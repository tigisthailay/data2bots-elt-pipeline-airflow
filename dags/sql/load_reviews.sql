LOAD DATA LOCAL INFILE  
'/usr/local/airflow/include/reviews.csv'
INTO TABLE reviews  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';