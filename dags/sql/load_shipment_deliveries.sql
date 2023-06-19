LOAD DATA LOCAL INFILE  
'../data/shipments_deliveries.csv'
INTO TABLE user1234_staging.shipments_deliveries  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';