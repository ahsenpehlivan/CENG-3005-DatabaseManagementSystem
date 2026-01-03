USE pipline_db;

-- 1) State summary view
DROP VIEW IF EXISTS v_state_accident_summary;

CREATE OR REPLACE VIEW v_state_accident_summary AS
SELECT
    s.AccidentState AS AccidentState,
    COUNT(DISTINCT ar.ReportNumber) AS AccidentCount,

    -- Spill totals (classification by name patterns)
    SUM(CASE WHEN st.SpillTypeName LIKE '%Unintentional%' THEN asv.Barrel ELSE 0 END) AS TotalUnintentionalRelease_Barrels,
    SUM(CASE WHEN st.SpillTypeName LIKE '%Intentional%' THEN asv.Barrel ELSE 0 END) AS TotalIntentionalRelease_Barrels,
    SUM(CASE WHEN st.SpillTypeName LIKE '%Recovery%' OR st.SpillTypeName LIKE '%Recovered%' THEN asv.Barrel ELSE 0 END) AS TotalRecovered_Barrels,

    -- Net loss = (unintentional + intentional) - recovered
    (
      SUM(CASE WHEN st.SpillTypeName LIKE '%Unintentional%' THEN asv.Barrel ELSE 0 END)
      + SUM(CASE WHEN st.SpillTypeName LIKE '%Intentional%' THEN asv.Barrel ELSE 0 END)
      - SUM(CASE WHEN st.SpillTypeName LIKE '%Recovery%' OR st.SpillTypeName LIKE '%Recovered%' THEN asv.Barrel ELSE 0 END)
    ) AS TotalNetLoss_Barrels,

    -- Total cost for accidents in that state
    IFNULL(SUM(ac.Amount), 0) AS TotalCost_USD

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

LEFT JOIN ACCIDENT_SPILL_VOLUME asv
  ON ar.AR_ResultID = asv.AR_ResultID
LEFT JOIN SPILL_TYPE st
  ON asv.ST_SpillTypeID = st.SpillTypeID
LEFT JOIN ACCIDENT_COSTS ac
  ON ar.AR_ResultID = ac.AR_ResultID

GROUP BY s.AccidentState;


-- 2) Operator net loss + total cost summary view
DROP VIEW IF EXISTS v_operator_netloss_cost_summary;

CREATE OR REPLACE VIEW v_operator_netloss_cost_summary AS
SELECT 
    o.OperatorID,
    o.OperatorName,

    (
      SUM(CASE WHEN st.SpillTypeName LIKE '%Unintentional%' THEN asv.Barrel ELSE 0 END)
      + SUM(CASE WHEN st.SpillTypeName LIKE '%Intentional%' THEN asv.Barrel ELSE 0 END)
      - SUM(CASE WHEN st.SpillTypeName LIKE '%Recovery%' OR st.SpillTypeName LIKE '%Recovered%' THEN asv.Barrel ELSE 0 END)
    ) AS TotalNetLoss_Barrels,

    IFNULL(SUM(ac.Amount), 0) AS TotalCost_USD

FROM ACCIDENT_REPORT ar
JOIN OPERATOR o
  ON ar.PF_OP_OperatorID = o.OperatorID
LEFT JOIN ACCIDENT_SPILL_VOLUME asv
  ON ar.AR_ResultID = asv.AR_ResultID
LEFT JOIN SPILL_TYPE st
  ON asv.ST_SpillTypeID = st.SpillTypeID
LEFT JOIN ACCIDENT_COSTS ac
  ON ar.AR_ResultID = ac.AR_ResultID

GROUP BY o.OperatorID, o.OperatorName;


-- 3) Cause category accident count view
DROP VIEW IF EXISTS v_causecategory_accident_count;

CREATE OR REPLACE VIEW v_causecategory_accident_count AS
SELECT
    cc.CauseCategoryID,
    cc.CauseCategoryName AS CauseCategory,
    COUNT(*) AS AccidentCount
FROM ACCIDENT_REPORT ar
JOIN CAUSE_SUBCATEGORY cs
  ON ar.CS_CauseSubcategoryID = cs.CauseSubcategoryID
JOIN CAUSE_CATEGORY cc
  ON cs.CC_CauseCategoryID = cc.CauseCategoryID
GROUP BY cc.CauseCategoryID, cc.CauseCategoryName;
