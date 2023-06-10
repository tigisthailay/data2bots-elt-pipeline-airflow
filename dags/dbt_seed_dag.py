from airflow import DAG 
from airflow.operators.bash_operator import BashOperator 
from datetime import timedelta

default_args = {
    'owner': 'airflow',
    'start_date': '2023-06-10'
}

with DAG(
    'dbt-seed',
    default_args=default_args,
    description='DAG to run dbt seed',
    schedule_interval=timedelta(days=1),
    tags=['dbt', 'seed'],
) as dag:
    dbt_seed = BashOperator(
        task_id="dbt_seed",
        bash_command='dbt seed',
    )