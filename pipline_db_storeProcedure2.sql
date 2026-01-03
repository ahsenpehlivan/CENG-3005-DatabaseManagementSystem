USE pipline_db;

DROP PROCEDURE IF EXISTS sp_state_annual_summary;

DELIMITER $$

CREATE PROCEDURE sp_state_annual_summary(
    IN p_state VARCHAR(45),
    IN p_year INT,
    OUT p_accident_count INT,
    INOUT p_total_cost DECIMAL(14,2)
)
BEGIN
    DECLARE v_year_cost DECIMAL(14,2);

    -- OUT: Accident count for state/year
    SELECT COUNT(*)
      INTO p_accident_count
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
    WHERE s.AccidentState = p_state
      AND YEAR(ar.AccidentDateTime) = p_year;

    -- Total cost for state/year
    SELECT IFNULL(SUM(ac.Amount), 0)
      INTO v_year_cost
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
    WHERE s.AccidentState = p_state
      AND YEAR(ar.AccidentDateTime) = p_year;

    -- INOUT: running total update
    SET p_total_cost = IFNULL(p_total_cost, 0) + IFNULL(v_year_cost, 0);
END $$

DELIMITER ;