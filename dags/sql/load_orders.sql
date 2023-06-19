
LOAD DATA LOCAL INFILE  
'/usr/local/airflow/include/orders.csv'
INTO TABLE user1234_staging.orders  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';