# Data Collect Database

This repository contains the PostgreSQL setup for a time-partitioned telemetry/event database using [`pg_cron`](https://github.com/citusdata/pg_cron) for automated maintenance.

## 🧱 Features

- Partitioned table `data_collect` based on timestamp (`created_at`)
- Automatic daily partition creation via `pg_cron`
- Dockerized environment for easy setup
- Simple `Makefile` to manage common commands

## ⚙️ Requirements

- Docker
- Docker Compose
- Make (optional but recommended)

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/cassioeskelsen/data-collect.git
cd database
```

### 2. Recreate the database and configure scheduled jobs

```bash
make config
```

This command will:
- Recreate the database container and volume
- Wait for PostgreSQL to become healthy
- Apply `init.sql` and schedule the daily partition job using `pg_cron`

### 3. Check scheduled jobs

```bash
make check
```

## 📦 Other Useful Commands

| Command         | Description                              |
|----------------|------------------------------------------|
| `make up`       | Start the PostgreSQL container           |
| `make down`     | Stop and remove the container and volume |
| `make config`   | Recreate and initialize everything       |
| `make check`    | List current `pg_cron` jobs              |

## 🗂 Folder Structure

```
.
├── init/
│   ├── init.sql
│   └── pg_cron_job.sql
├── Dockerfile
├── docker-compose.yaml
├── recreate_db.sh
├── setup_pg_cron_job.sh
├── run.sh
├── Makefile
└── README.md
```

## 📌 Notes

- All SQL files in `init/` are automatically executed when the container starts for the first time.
- `pg_cron` is configured to run inside the `data_collect` database.
- Jobs are scheduled to run daily at midnight (`0 0 * * *`).

## Sample Data

To insert sample data into the database:

```bash
make insert_samples
```
