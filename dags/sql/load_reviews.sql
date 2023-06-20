LOAD DATA LOCAL INFILE  
'../data/reviews.csv'
INTO TABLE tegidege9284_staging.reviews  
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';