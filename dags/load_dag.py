from airflow import DAG
from airflow.operators.mysql_operator import MySqlOperator

default_arg = {'owner': 'airflow', 'start_date': '2023-06-10'}

dag = DAG('load-data',
          default_args=default_arg,
          schedule_interval='@once',
          template_searchpath=['/usr/local/airflow/include/'])

create_table = MySqlOperator(dag=dag,
                           mysql_conn_id='mysql-connect', 
                           task_id='create_table',
                            sql='create_orders_table.sql')



load_orders = MySqlOperator(dag=dag,
                           mysql_conn_id='mysql-connect', 
                           task_id='load_orders',
                            sql='load_orders.sql')

create_reviews = MySqlOperator(dag=dag,
                           mysql_conn_id='mysql-connect', 
                           task_id='create_reviews',
                            sql='create_reviews_table.sql')

load_reviews = MySqlOperator(dag=dag,
                           mysql_conn_id='mysql-connect', 
                           task_id='load_reviews',
                            sql='load_reviews.sql')

create_shipment_deliveries = MySqlOperator(dag=dag,
                           mysql_conn_id='mysql-connect', 
                           task_id='create_shipment_deliveries',
                            sql='create_shipment_deliveries_table.sql')

load_shipment_deliveries = MySqlOperator(dag=dag,
                           mysql_conn_id='mysql-connect', 
                           task_id='load_shipment_deliveries',
                            sql='load_shipment_deliveries.sql')


create_table >> load_orders >> create_reviews >> load_reviews >> create_shipment_deliveries >> load_reviews