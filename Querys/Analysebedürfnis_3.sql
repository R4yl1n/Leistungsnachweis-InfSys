USE ERP; 

DECLARE @ProductName  NVARCHAR(MAX) = 'ML Road Tire' ; 

 

WITH SalesTrends AS ( 

    SELECT 

        P.ProductID, 

        P.Name AS ProductName, 

        MONTH(SOH.OrderDate) AS SalesOrderMonth, 

        YEAR(SOH.OrderDate) AS SalesOrderYear, 

        SUM(SOD.OrderQty) AS SoldQtyPerMonth 

    FROM 

        Sales.SalesOrderDetail SOD 

    JOIN 

        Sales.SalesOrderHeader SOH ON SOD.SalesOrderID = SOH.SalesOrderID 

    JOIN 

        Production.Product P ON SOD.ProductID = P.ProductID 

    GROUP BY 

        P.ProductID,  

        P.Name, 

        MONTH(SOH.OrderDate), 

        YEAR(SOH.OrderDate) 

), 

StockLevels AS ( 

    SELECT 

        PI.ProductID, 

        SUM(PI.Quantity) AS TotalStock 

    FROM 

        Production.ProductInventory PI 

    GROUP BY 

        PI.ProductID 

) 

SELECT 

    --ST.ProductID, 

    ST.ProductName, 

    SL.TotalStock, 

    ST.SoldQtyPerMonth, 

    ST.SalesOrderYear as YEAR, 

    ST.SalesOrderMonth as Month, 

 

     

    CASE 

        WHEN ST.SoldQtyPerMonth > 0 THEN ROUND(SL.TotalStock / ST.SoldQtyPerMonth, 2) 

        ELSE NULL 

    END AS MonthsOfStockRemaining 

FROM 

    SalesTrends ST 

JOIN 

    StockLevels SL ON ST.ProductID = SL.ProductID 

WHERE  ST.ProductName = @ProductName --coment this line to gett all the Data 

ORDER BY ProductName--MonthsOfStockRemaining  

 
