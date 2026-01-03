USE pipline_db;

-- Confirm database
SELECT DATABASE() AS CurrentDatabase;

-- List all views
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Show view definitions (optional)
SHOW CREATE VIEW v_state_accident_summary;
SHOW CREATE VIEW v_operator_netloss_cost_summary;
SHOW CREATE VIEW v_causecategory_accident_count;

-- Run views (sample outputs)
SELECT *
FROM v_state_accident_summary
ORDER BY AccidentCount DESC;

SELECT *
FROM v_operator_netloss_cost_summary
ORDER BY TotalNetLoss_Barrels DESC;

SELECT *
FROM v_causecategory_accident_count
ORDER BY AccidentCount DESC;

-- List stored procedures
SHOW PROCEDURE STATUS WHERE Db = DATABASE();

-- 5) Show procedure definitions (optional)
SHOW CREATE PROCEDURE sp_operator_annual_summary;
SHOW CREATE PROCEDURE sp_state_annual_summary;

-- Run procedure demo #1 (Operator + Year)
SET @acc_count = 0;
SET @running_total = 0.00;

CALL sp_operator_annual_summary(11169, 2010, @acc_count, @running_total);

SELECT
  @acc_count AS OperatorYear_AccidentCount,
  @running_total AS OperatorYear_RunningTotalCost;

-- Run procedure demo #2 (State + Year)
SET @acc_count2 = 0;
SET @running_total2 = 0.00;

CALL sp_state_annual_summary('TX', 2010, @acc_count2, @running_total2);

SELECT
  @acc_count2 AS StateYear_AccidentCount,
  @running_total2 AS StateYear_RunningTotalCost;
