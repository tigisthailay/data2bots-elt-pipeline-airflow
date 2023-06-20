
LOAD DATA LOCAL INFILE  
'../data/orders.csv'
INTO TABLE tegidege9284_staging.orders  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';