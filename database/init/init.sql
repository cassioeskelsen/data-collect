ALTER SYSTEM SET cron.database_name = 'data_collect';

CREATE TABLE public.data_collect (
  id UUID DEFAULT gen_random_uuid(),
  aggregatetype VARCHAR(100),
  aggregateid VARCHAR(50),
  payload JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);
 