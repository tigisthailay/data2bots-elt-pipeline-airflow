from sqlalchemy import create_engine
import pandas as pd
import os
from datetime import timedelta,datetime
import airflow
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator


default_args = {
    'owner':'tegisty',
    'retries':4,
    'retry_delay':timedelta(minutes=2)
}

def load_raw_data(path, table_name):
    print("WRITING DATA")
    engine = create_engine("postgresql+postgresql://postgres:nvskFr7xOO8bndqdqh9W@containers-us-west-30.trafic.app:7828/traffic")
    df = pd.read_csv(path, sep="[,;:]", index_col=False)

    df.to_sql(table_name, con=engine, if_exists='replace',index_label='id')
    print("DATA SAVED")


with DAG(
    dag_id='save_to_db',
    default_args=default_args,
    description='this dag loads raw data to ware house',
    start_date=airflow.utils.dates.days_ago(1),
    schedule_interval='@once'
)as dag:
    task1 = PythonOperator(
        task_id='load_orders_data',
        python_callable=load_raw_data,
        op_kwargs={
            "path": "./data/orders.csv",
            "table_name":"orders"
        }
    )
    task2 = PythonOperator(
        task_id='load_reviews_data',
        python_callable=load_raw_data,
        op_kwargs={
            "path": "./data/reviews.csv",
            "table_name":"reviews"
        }
    )
    task3 = PythonOperator(
        task_id='load_Shipments_deliveries_data',
        python_callable=load_raw_data,
        op_kwargs={
            "path": "./data/shipments_deliveries.csv",
            "table_name":"shipments_deliveries"
        }
    )
    task1 >> task2 >> task3