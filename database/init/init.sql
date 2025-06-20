ALTER SYSTEM SET cron.database_name = 'data_collect';

CREATE TABLE public.data_collect (
  id UUID DEFAULT gen_random_uuid(),
  aggregatetype VARCHAR(100),
  aggregateid VARCHAR(50),
  payload JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (id, created_at)
) PARTITION BY RANGE (created_at);

CREATE TABLE data_collect_y2025 PARTITION OF public.data_collect
    FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2026-01-01 00:00:00');

CREATE TABLE data_collect_y2024 PARTITION OF public.data_collect
    FOR VALUES FROM ('2024-01-01 00:00:00') TO ('2025-01-01 00:00:00');

INSERT INTO public.data_collect (aggregatetype, aggregateid, payload) VALUES
('UserActivity', 'user123', '{"action": "login", "timestamp": "2025-06-20T10:00:00Z"}'),
('ProductEvent', 'prod456', '{"event": "view", "productId": "ABC", "user": "user123"}');