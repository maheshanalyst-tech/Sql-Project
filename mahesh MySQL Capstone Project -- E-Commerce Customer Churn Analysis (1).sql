## ECOMM PROJECT MYSQL--
USE ecomm;
SELECT* FROM customer_churn;
SELECT ROUND(AVG(WarehouseToHome)) FROM customer_churn;
SET SQL_SAFE_UPDATES = 0;
##Data Cleaning:
UPDATE customer_churn
SET WarehouseToHome = (
    SELECT ROUND(AVG(WarehouseToHome)) 
    FROM (SELECT * FROM customer_churn WHERE WarehouseToHome IS NOT NULL) AS subquery
)
WHERE WarehouseToHome IS NULL;

UPDATE customer_churn
SET HourSpendOnApp = (
    SELECT ROUND(AVG(HourSpendOnApp)) 
    FROM (SELECT * FROM customer_churn WHERE HourSpendOnApp IS NOT NULL) AS subquery
)
WHERE HourSpendOnApp IS NULL;

UPDATE customer_churn
SET OrderAmountHikeFromlastYear = (
    SELECT ROUND(AVG(OrderAmountHikeFromlastYear)) 
    FROM (SELECT * FROM customer_churn WHERE OrderAmountHikeFromlastYear IS NOT NULL) AS subquery
)
WHERE OrderAmountHikeFromlastYear IS NULL;

UPDATE customer_churn
SET DaySinceLastOrder = (
    SELECT ROUND(AVG(DaySinceLastOrder)) 
    FROM (SELECT * FROM customer_churn WHERE DaySinceLastOrder IS NOT NULL) AS subquery
)
WHERE DaySinceLastOrder IS NULL;

SELECT* FROM customer_churn;

UPDATE customer_churn
SET Tenure = (
    SELECT Tenure FROM (
    SELECT Tenure FROM customer_churn
    WHERE Tenure IS NOT NULL 
    GROUP BY Tenure 
    ORDER BY COUNT(*) DESC 
    LIMIT 1) AS t
)
WHERE Tenure IS NULL;

UPDATE customer_churn
SET CouponUsed = (
    SELECT CouponUsed FROM (
    SELECT CouponUsed FROM customer_churn 
    WHERE CouponUsed IS NOT NULL 
    GROUP BY CouponUsed 
    ORDER BY COUNT(*) DESC 
    LIMIT 1) AS c
)
WHERE CouponUsed IS NULL;

UPDATE customer_churn
SET OrderCount = (
    SELECT OrderCount FROM (
    SELECT OrderCount FROM customer_churn 
    WHERE OrderCount IS NOT NULL 
    GROUP BY OrderCount 
    ORDER BY COUNT(*) DESC 
    LIMIT 1) AS oc
)
WHERE OrderCount IS NULL;

DELETE FROM customer_churn WHERE WarehouseToHome > 100;

SELECT* FROM customer_churn;

##Dealing with Inconsistencies:
UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

##Data Transformation:
##Column Renaming:

ALTER TABLE customer_churn CHANGE PreferedOrderCat PreferredOrderCat VARCHAR(255);

ALTER TABLE customer_churn CHANGE HourSpendOnApp HoursSpentOnApp INT;

##Creating New Columns:
ALTER TABLE customer_churn ADD COLUMN ComplaintReceived’ VARCHAR(3);

UPDATE customer_churn SET ComplaintReceived’ = IF(Complain = 1, 'Yes', 'No');

select* from customer_churn;

ALTER TABLE customer_churn ADD COLUMN ChurnStatus VARCHAR(10);

UPDATE customer_churn SET ChurnStatus = IF(Churn = 1, 'Churned', 'Active');
 
 ## Column Dropping:
ALTER TABLE customer_churn DROP COLUMN Churn;

ALTER TABLE customer_churn DROP COLUMN Complain;

##Data Exploration and Analysis:
SELECT ChurnStatus, COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY ChurnStatus;

SELECT * FROM customer_churn;

SELECT AVG(Tenure) AS AvgTenure, SUM(CashbackAmount) AS TotalCashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';


SELECT 
    (COUNT(*) / (SELECT COUNT(*) FROM customer_churn WHERE ChurnStatus = 'Churned') * 100) AS ComplaintPercentage
FROM customer_churn
WHERE ChurnStatus = 'Churned' AND ComplaintReceived’ = 'Yes';


SELECT Gender, COUNT(*) AS Count
FROM customer_churn
WHERE ComplaintReceived’ = 'Yes'
GROUP BY Gender;


SELECT CityTier, COUNT(*) AS ChurnedCount
FROM customer_churn
WHERE ChurnStatus = 'Churned' AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY ChurnedCount DESC
LIMIT 1;


SELECT PreferredPaymentMode, COUNT(*) AS Count
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY Count DESC
LIMIT 1;


SELECT SUM(OrderAmountHikeFromlastYear) AS TotalHike,MaritalStatus,PreferredOrderCat
FROM customer_churn
WHERE MaritalStatus = 'Single' AND PreferredOrderCat = 'Mobile Phone';

SELECT AVG(NumberOfDeviceRegistered) AS AvgDevices,PreferredPaymentMode
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

SELECT CityTier, COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY CityTier
ORDER BY CustomerCount DESC
LIMIT 1;

SELECT Gender,CouponUsed
FROM customer_churn
ORDER BY CouponUsed DESC
LIMIT 1;


SELECT PreferredOrderCat, COUNT(*) AS CustomerCount, MAX(HoursSpentOnApp) AS MaxHours
FROM customer_churn
GROUP BY PreferredOrderCat;

SELECT SUM(OrderCount) AS TotalOrders
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);

SELECT COUNT(*) AS CustomerCount
FROM customer_churn
WHERE HoursSpentOnApp = 1 AND DaySinceLastOrder > 5;

SELECT AVG(SatisfactionScore) AS AvgSatisfaction
FROM customer_churn
WHERE ComplaintReceived’ = 'Yes';

SELECT PreferredOrderCat, COUNT(*) AS Count
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat
ORDER BY Count DESC
LIMIT 1;

SELECT PreferredOrderCat, AVG(CashbackAmount) AS AvgCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AvgCashback DESC
LIMIT 3;

SELECT PreferredPaymentMode, COUNT(*) AS Count
FROM customer_churn	
WHERE Tenure = 10
AND OrderCount > 500
GROUP BY PreferredPaymentMode;


SELECT 
    CASE 
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS Count
FROM customer_churn
GROUP BY DistanceCategory, ChurnStatus;


SELECT *
FROM customer_churn
WHERE CustomerID IN (
    SELECT CustomerID
    FROM customer_churn
    WHERE MaritalStatus = 'Married' AND CityTier = 1
    AND OrderCount > (SELECT AVG(OrderCount) FROM customer_churn)
);

CREATE TABLE IF NOT EXISTS customer_returns (
    ReturnID INT PRIMARY KEY,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount DECIMAL(10,2)
);

INSERT INTO customer_returns (ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

SELECT * FROM customer_returns;

SELECT cr.CustomerID,cr.ReturnID,cr.RefundAmount,cr.ReturnDate,cc.ComplaintReceived’,cc.ChurnStatus FROM customer_returns AS cr
JOIN customer_churn AS cc
ON cc.CustomerID = cr.CustomerID
WHERE ChurnStatus = "Churned" AND ComplaintReceived’ = "yes";


