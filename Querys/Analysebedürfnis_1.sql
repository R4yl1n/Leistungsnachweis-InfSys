    DECLARE @Betrachtungsjahr INT = 2013; 

SELECT  

    pr.ProductID,  

    pr.Name AS Produktname, 

    pr.ProductNumber AS Produktnummer, 

        -- Nettoerlös für das Jahr vor dem Betrachtungsjahr 

    SUM(CASE WHEN YEAR(sh.OrderDate) = @Betrachtungsjahr - 1 THEN sd.LineTotal ELSE 0 END) AS Umsatz_Vorjahr, 

        -- Nettoerlös für das Betrachtungsjahr 

    SUM(CASE WHEN YEAR(sh.OrderDate) = @Betrachtungsjahr THEN sd.LineTotal ELSE 0 END) AS Umsatz_Betrachtungsjahr, 

    -- Wachstum berechnen 

    CASE  

        WHEN SUM(CASE WHEN YEAR(sh.OrderDate) = @Betrachtungsjahr THEN sd.LineTotal ELSE 0 END) > 0 THEN  

            100 - ( 

                SUM(CASE WHEN YEAR(sh.OrderDate) = @Betrachtungsjahr - 1 THEN sd.LineTotal ELSE 0 END) * 100.0 / 

                SUM(CASE WHEN YEAR(sh.OrderDate) = @Betrachtungsjahr THEN sd.LineTotal ELSE 0 END) 

            ) 

        ELSE NULL -- Wachstum kann nicht berechnet werden, wenn der Umsatz im Betrachtungsjahr 0 ist 

    END AS Wachstum 

FROM  

    sales.SalesOrderHeader sh  

LEFT OUTER JOIN  

    sales.SalesOrderDetail sd ON sh.SalesOrderID = sd.SalesOrderID 

LEFT OUTER JOIN  

    production.Product pr ON sd.ProductID = pr.ProductID 

GROUP BY  

    pr.ProductID,  

    pr.Name,  

    pr.ProductNumber 

ORDER BY  

    pr.ProductID; 
