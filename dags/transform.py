from datetime import timedelta

from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import datetime
from airflow.utils.dates import timedelta
from airflow.utils.dates import days_ago

default_args = {
    "owner": "tegisty",
    "email": ["tigisthay13@gmail.com"],
    "email_on_failaure": false,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

dag_exec = DAG(
    dag_id="dbt_exec",
    default_args=default_args,
    schedule_interval="@daily",
    start_date=days_ago(1),
    dagrun_timeout=timedelta(minutes=60),
    description="executing dag codes",
)


dbt_run = BashOperator(task_id="dbt_run", bash_command="dbt run", dag=dag_exec)

dbt_test = BashOperator(
    task_id="dbt_test", bash_command="dbt test", dag=dag_exec
)

dbt_run >> dbt_test