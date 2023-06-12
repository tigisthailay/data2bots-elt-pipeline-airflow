#Importing modules

from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
#from airflow.utils.dates import 

#Define default and DAG-specific arguments

default_args = {
    "owner": "tegisty",
    "email": ["tigisthay13@gmail.com"],
    "email_on_failaure": True,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# Instantiate a DAG
# Give the DAG name, configure the schedule, and set the DAG settings
dag_exec = DAG(
    dag_id="data2bots_demo",
    default_args=default_args,
    schedule_interval="@daily",
    start_date=days_ago(1),
    dagrun_timeout=timedelta(minutes=60),
    description="use case of psql operator in airflow",
)

# Set the Tasks

db = MySqlOperator(
    sql="sql/create_database.sql",
    task_id="createdb_task",
    postgres_conssn_id="d2b",
    dag=dag_exec,
)

create = PostgresOperator(
    sql="sql/create__orders_table.sql",
    task_id="create_orders_table_task",
    postgres_conssn_id="d2b",
    dag=dag_exec,
)

load = PostgresOperator(
    sql="sql/load_orders.sql",
    task_id="insertdata_task",
    postgres_conn_id="d2b",
    dag=dag_exec,
)
# Setting up Dependencies
db >> create >> load

if __name__ == "__main__":
    dag_exec.cli()