SELECT DISTINCT 

    sap.TerritoryID, 

    st.Name AS Territory, 

    sap.BusinessEntityID AS SalesPersonBusinessEntitiyID, 

    sap.SalesYTD, 

    sap.SalesLastYear, 

    st.SalesYTD AS TerritorySalesYTD, 

    st.SalesLastYear AS TerritorySalesLastYear 

FROM staging.SalesPerson AS sap 

LEFT OUTER JOIN staging.SalesTerritory AS st 

    ON st.TerritoryID = sap.TerritoryID 

WHERE sap.TerritoryID IS NOT NULL 

  AND st.TerritoryID IS NOT NULL; 
