SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';
SHOW VARIABLES LIKE 'slow_query_log_file';

SELECT * FROM performance_schema.events_statements_summary_by_digest
ORDER BY SUM_TIMER_WAIT DESC
LIMIT 10;


EXPLAIN SELECT * FROM personas WHERE identificacion = '1234567890';

EXPLAIN SELECT * FROM personas WHERE id = 2;

EXPLAIN SELECT * FROM reservas WHERE numero_habitacion = 102;

