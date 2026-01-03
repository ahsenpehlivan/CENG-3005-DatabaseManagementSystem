USE pipline_db;

DROP PROCEDURE IF EXISTS sp_operator_annual_summary;
DROP PROCEDURE IF EXISTS sp_state_annual_summary;

DELIMITER $$

-- Operator + year summary (IN + OUT + INOUT)
CREATE PROCEDURE sp_operator_annual_summary(
    IN p_operator_id INT,
    IN p_year INT,
    OUT p_accident_count INT,
    INOUT p_total_cost DECIMAL(14,2)
)
BEGIN
    DECLARE v_year_cost DECIMAL(14,2);

    -- OUT: accident count for operator/year
    SELECT COUNT(*)
      INTO p_accident_count
    FROM ACCIDENT_REPORT ar
    WHERE ar.PF_OP_OperatorID = p_operator_id
      AND YEAR(ar.AccidentDateTime) = p_year;

    -- Total cost for operator/year
    SELECT IFNULL(SUM(ac.Amount), 0)
      INTO v_year_cost
    FROM ACCIDENT_REPORT ar
    JOIN ACCIDENT_COSTS ac
      ON ar.AR_ResultID = ac.AR_ResultID
    WHERE ar.PF_OP_OperatorID = p_operator_id
      AND YEAR(ar.AccidentDateTime) = p_year;

    -- INOUT: running total update
    SET p_total_cost = IFNULL(p_total_cost, 0) + IFNULL(v_year_cost, 0);
END $$

DELIMITER ;