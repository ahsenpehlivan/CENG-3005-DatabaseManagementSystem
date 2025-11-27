-- Calculate the total net loss (in barrels) for each operator to see which company lost the most oil.
SELECT 
    o.OperatorID,
    o.OperatorName,
    SUM(
        ar.Unintentional_Release_Barrels
        + ar.Intentional_Release_Barrels
        - ar.Liquid_Recovery_Barrels
    ) AS TotalNetLoss_Barrels
FROM ACCIDENT_REPORT AS ar
JOIN PIPELINE_FACILITY AS pf
      ON ar.PF_PipelineFacilityName = pf.PipelineFacilityName
     AND ar.PF_OP_OperatorID       = pf.OP_OperatorID
JOIN OPERATOR AS o
      ON pf.OP_OperatorID = o.OperatorID
GROUP BY 
    o.OperatorID,
    o.OperatorName
ORDER BY 
    TotalNetLoss_Barrels DESC;


-- Count the number of accidents for each cause category to find out the most common reason for pipeline failures.
SELECT
    c.CauseCategory,
    COUNT(*) AS AccidentCount
FROM ACCIDENT_REPORT AS ar
JOIN CAUSE AS c
      ON ar.C_CauseSubcategory = c.CauseSubcategory
GROUP BY
    c.CauseCategory
ORDER BY
    AccidentCount DESC;


-- What is the average environmental remediation cost for accidents, grouped by the liquid type?
SELECT
    lc.LiquidType,
    AVG(ar.Environmental_Remediation_Costs) AS AvgEnvironmentalRemediationCost
FROM ACCIDENT_REPORT AS ar
JOIN LIQUID_NAME AS ln
      ON ar.LN_LiquidName = ln.LiquidName
JOIN LIQUID_CLASS AS lc
      ON ln.LC_LiquidSubtype = lc.LiquidSubtype
GROUP BY
    lc.LiquidType
ORDER BY
    AvgEnvironmentalRemediationCost DESC;
    
    
-- Count the total number of accidents that happened in each year.
SELECT
    YEAR(ar.AccidentDateTime) AS AccidentYear,
    COUNT(*) AS AccidentCount
FROM ACCIDENT_REPORT AS ar
GROUP BY
    YEAR(ar.AccidentDateTime)
ORDER BY
    AccidentYear;


-- Calculate the total property damage costs for each city in Texas (TX).
SELECT
    al.AccidentCity,
    SUM(ar.Property_Damage_Costs) AS TotalPropertyDamageCosts
FROM ACCIDENT_REPORT AS ar
JOIN ACCIDENT_LOCATION AS al
      ON ar.AL_AccidentLatitude  = al.AccidentLatitude
     AND ar.AL_AccidentLongitude = al.AccidentLongitude
WHERE
    al.AccidentState = 'TX'
GROUP BY
    al.AccidentCity
ORDER BY
    TotalPropertyDamageCosts DESC;