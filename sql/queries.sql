SELECT 
    Region,
    ROUND(SUM(Sales), 0) as Total_Revenue,
    ROUND(SUM(Profit), 0) as Total_Profit,
    ROUND(AVG(Profit_Margin_Pct), 1) as Avg_Margin_Pct,
    COUNT(*) as Order_Count
FROM orders
GROUP BY Region
ORDER BY Total_Revenue DESC;
SELECT 
    Category,
    Sub_Category,
    COUNT(*) as Loss_Orders,
    ROUND(SUM(Profit), 0) as Total_Loss,
    ROUND(AVG(Discount), 2) as Avg_Discount
FROM orders
WHERE Is_Loss = 1
GROUP BY Category, Sub_Category
ORDER BY Total_Loss ASC;
SELECT 
    Order_Year,
    Order_Month,
    Order_Month_Name,
    ROUND(SUM(Sales), 0) as Monthly_Revenue,
    ROUND(SUM(Profit), 0) as Monthly_Profit,
    COUNT(*) as Orders
FROM orders
GROUP BY Order_Year, Order_Month, Order_Month_Name
ORDER BY Order_Year, Order_Month;
SELECT 
    Segment,
    ROUND(SUM(Sales), 0) as Revenue,
    ROUND(SUM(Profit), 0) as Profit,
    ROUND(AVG(Profit_Margin_Pct), 1) as Avg_Margin,
    COUNT(DISTINCT Customer_ID) as Unique_Customers,
    ROUND(SUM(Sales)/COUNT(DISTINCT Customer_ID), 0) as Revenue_Per_Customer
FROM orders
GROUP BY Segment
ORDER BY Revenue DESC;
CREATE VIEW IF NOT EXISTS business_insights AS
SELECT 
    Region,
    Category,
    ROUND(SUM(Sales), 0) as Revenue,
    ROUND(SUM(Profit), 0) as Profit,
    ROUND(AVG(Profit_Margin_Pct), 1) as Margin_Pct,
    ROUND(AVG(Discount)*100, 1) as Avg_Discount_Pct,
    SUM(Is_Loss) as Loss_Orders,
    CASE 
        WHEN AVG(Profit_Margin_Pct) < 0 
            THEN 'CRITICAL: Negative margin — review pricing immediately'
        WHEN AVG(Profit_Margin_Pct) < 5 
            THEN 'WARNING: Margin below 5% — discount strategy review needed'
        WHEN AVG(Discount) > 0.3 
            THEN 'WARNING: High discount rate eroding profit'
        ELSE 
            'HEALTHY: Performance within acceptable range'
    END as Business_Signal
FROM orders
GROUP BY Region, Category
ORDER BY Margin_Pct ASC;
SELECT * FROM business_insights;