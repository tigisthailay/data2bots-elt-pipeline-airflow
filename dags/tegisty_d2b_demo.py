import airflow
import os
from datetime import timedelta
from airflow import DAG
from airflow.operators.postgres_operator import PostgresOperator
from airflow.utils.dates import days_ago

args={'owner': 'tegisty'}

default_args = {
    'owner': 'tegisty',    
    #'start_date': airflow.utils.dates.days_ago(2),
    # 'end_date': datetime(),
    # 'depends_on_past': False,
    #'email': ['airflow@example.com'],
    #'email_on_failure': False,
    # 'email_on_retry': False,
    # If a task fails, retry it once after waiting
    # at least 5 minutes
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag_d2b = DAG(
    dag_id = "data2bots_demo",
    default_args=args,
    # schedule_interval='0 0 * * *',
    schedule_interval='@once',	
    dagrun_timeout=timedelta(minutes=60),
    description='use case of psql operator in airflow',
    start_date = airflow.utils.dates.days_ago(1)
)

create_orders_table = PostgresOperator(
    sql = 'sql/create_orders_table.sql',
    task_id = "create_Orders_table",
    postgres_conn_id = "d2b",
    dag = dag_d2b
    )

load_orders = PostgresOperator(
    sql = 'sql/load_orders.sql',
    task_id = "load_Orders_data",
    postgres_conn_id = "d2b",
    dag = dag_d2b
    )
create_reviews_table = PostgresOperator(
    sql = 'sql/create_reviews_table.sql',
    task_id = "create_reviews_table",
    postgres_conn_id = "d2b",
    dag = dag_d2b
    )

load_reviews = PostgresOperator(
    sql = 'sql/load_reviews.sql',
    task_id = "load_reviews_data",
    postgres_conn_id = "d2b",
    dag = dag_d2b
    )
create_shipment_table = PostgresOperator(
    sql = 'sql/create_shipment_deliveries_table.sql',
    task_id = "create_shipment_deliveries_table",
    postgres_conn_id = "d2b",
    dag = dag_d2b
    )

load_shipments = PostgresOperator(
    sql = 'sql/load_shipment_deliveries.sql',
    task_id = "load_shipments_deliveries_data",
    postgres_conn_id = "d2b",
    dag = dag_d2b
    )

create_orders_table >> load_orders >> create_reviews_table >> load_reviews >> create_shipment_table >> load_shipments

if __name__ == "__main__":
    dag_d2b.cli()