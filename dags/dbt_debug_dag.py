from airflow import DAG 
from airflow.operators.bash_operator import BashOperator 
from datetime import timedelta 

default_args = {
    'owner': 'airflow',
    'start_date': '2023-06-10'
}

with DAG(
    'dbt-debug',
    default_args=default_args,
    description='DAG to debug dbt project',
    schedule_interval=timedelta(days=1),
    tags=['dbt', 'debug'],
) as dag:
    dbt_debug = BashOperator(
        task_id="dbt_debug",
        bash_command='dbt debug',

    )