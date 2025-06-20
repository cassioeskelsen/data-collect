CREATE EXTENSION IF NOT EXISTS pg_cron;

CREATE OR REPLACE FUNCTION create_next_daily_partition()
RETURNS void AS $$
DECLARE
    next_day_start TIMESTAMPTZ;
    next_next_day_start TIMESTAMPTZ;
    partition_name TEXT;
    sql_command TEXT;
BEGIN
    next_day_start := (NOW() + INTERVAL '1 day')::DATE::TIMESTAMPTZ;
    next_next_day_start := (NOW() + INTERVAL '2 days')::DATE::TIMESTAMPTZ;

    partition_name := 'data_collect_y' || TO_CHAR(next_day_start, 'YYYY_MM_DD');

    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = partition_name) THEN
        sql_command := FORMAT(
            'CREATE TABLE %I PARTITION OF public.data_collect FOR VALUES FROM (%L) TO (%L);',
            partition_name,
            next_day_start,
            next_next_day_start
        );
        EXECUTE sql_command;
        RAISE NOTICE 'Partition % created successfully.', partition_name;
    ELSE
        RAISE NOTICE 'Partition % already exists. No action taken.', partition_name;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT cron.unschedule('create_next_daily_partition_job');

SELECT cron.schedule(
    'create_next_daily_partition_job',
    '0 0 * * *',
    'SELECT create_next_daily_partition();'
);
