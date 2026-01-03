UNLOCK TABLES;

-- Calculate the total net loss (in barrels) for each operator to see which company lost the most oil.
SELECT 
    o.OperatorID,
    o.OperatorName,
    SUM(
        CASE WHEN st.SpillTypeName IN ('Unintentional Release', 'Unintentional_Release', 'Unintentional Release (Barrels)')
             THEN asv.Barrel ELSE 0 END
      + CASE WHEN st.SpillTypeName IN ('Intentional Release', 'Intentional_Release', 'Intentional Release (Barrels)')
             THEN asv.Barrel ELSE 0 END
      - CASE WHEN st.SpillTypeName IN ('Liquid Recovery', 'Liquid_Recovery', 'Recovered', 'Liquid Recovery (Barrels)')
             THEN asv.Barrel ELSE 0 END
    ) AS TotalNetLoss_Barrels
FROM ACCIDENT_REPORT ar
JOIN OPERATOR o
  ON ar.PF_OP_OperatorID = o.OperatorID
JOIN ACCIDENT_SPILL_VOLUME asv
  ON ar.AR_ResultID = asv.AR_ResultID
JOIN SPILL_TYPE st
  ON asv.ST_SpillTypeID = st.SpillTypeID
GROUP BY o.OperatorID, o.OperatorName
ORDER BY TotalNetLoss_Barrels DESC;



-- Count the number of accidents for each cause category to find out the most common reason for pipeline failures.
SELECT
    cc.CauseCategoryName AS CauseCategory,
    COUNT(*) AS AccidentCount
FROM ACCIDENT_REPORT ar
JOIN CAUSE_SUBCATEGORY cs
  ON ar.CS_CauseSubcategoryID = cs.CauseSubcategoryID
JOIN CAUSE_CATEGORY cc
  ON cs.CC_CauseCategoryID = cc.CauseCategoryID
GROUP BY cc.CauseCategoryName
ORDER BY AccidentCount DESC;



-- What is the average environmental remediation cost for accidents, grouped by the liquid type?
SELECT
    lc.LiquidType,
    AVG(ac.Amount) AS AvgEnvironmentalRemediationCost
FROM ACCIDENT_REPORT ar
JOIN LIQUID_NAME ln
  ON ar.LN_LiquidID = ln.LiquidID
JOIN LIQUID_CLASS lc
  ON ln.LC_LiquidSubtypeID = lc.LiquidSubtypeID
JOIN ACCIDENT_COSTS ac
  ON ar.AR_ResultID = ac.AR_ResultID
JOIN COST_TYPE ct
  ON ac.CT_CostTypeID = ct.CostTypeID
WHERE ct.CostTypeName IN ('Environmental Remediation Costs', 'Environmental Remediation', 'Env Remediation')
GROUP BY lc.LiquidType
ORDER BY AvgEnvironmentalRemediationCost DESC;

    
    
-- Count the total number of accidents that happened in each year.
SELECT
    YEAR(ar.AccidentDateTime) AS AccidentYear,
    COUNT(*) AS AccidentCount
FROM ACCIDENT_REPORT ar
GROUP BY YEAR(ar.AccidentDateTime)
ORDER BY AccidentYear;



-- Calculate the total property damage costs for each city in Texas (TX).
SELECT
    ctc.AccidentCity,
    SUM(ac.Amount) AS TotalPropertyDamageCosts
FROM ACCIDENT_REPORT ar
JOIN ACCIDENT_LOCATION al
  ON ar.AL_AccidentLatitude  = al.AccidentLatitude
 AND ar.AL_AccidentLongitude = al.AccidentLongitude
JOIN CITY_TO_COUNTY ctc
  ON al.CTCO_CityID = ctc.CityID
JOIN COUNTY_TO_STATE cts
  ON ctc.COTS_CountyID = cts.CountyID
JOIN STATE s
  ON cts.ST_StateID = s.StateID
JOIN ACCIDENT_COSTS ac
  ON ar.AR_ResultID = ac.AR_ResultID
JOIN COST_TYPE ct
  ON ac.CT_CostTypeID = ct.CostTypeID
WHERE s.AccidentState = 'TX'
  AND ct.CostTypeName IN ('Property Damage Costs', 'Property Damage', 'Property_Damage_Costs')
GROUP BY ctc.AccidentCity
ORDER BY TotalPropertyDamageCosts DESC;
