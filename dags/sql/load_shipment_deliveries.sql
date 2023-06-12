LOAD DATA LOCAL INFILE  
'/usr/local/airflow/include/shipments_deliveries.csv'
INTO TABLE shipments_deliveries  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';