LOAD DATA LOCAL INFILE  
'/usr/local/airflow/include/shipments_deliveries.csv'
INTO TABLE user1234_staging.shipments_deliveries  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';