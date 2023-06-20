LOAD DATA LOCAL INFILE  
'../data/shipments_deliveries.csv'
INTO TABLE tegidege9284_staging.shipments_deliveries  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';