config:
	./recreate_db.sh
	sleep 5
	./setup_pg_cron_job.sh

up:
	docker compose up -d --build

down:
	docker compose down -v

check:
	PGPASSWORD=data_collect psql -h localhost -p 5432 -U data_collect -d data_collect -c "SELECT jobid, jobname, schedule, command, active FROM cron.job;"

insert_samples:
	PGPASSWORD=data_collect psql -h localhost -p 5432 -U data_collect -d data_collect -f init/sample_data.sql