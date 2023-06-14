#import important libraries
import boto3
from botocore import UNSIGNED
from botocore.client import Config

#creat S3 object
s3 = boto3.client('s3', config=Config(signature_version=UNSIGNED))
bucket_name = "d2b-internal-assessment-bucket"
response = s3.list_objects(Bucket=bucket_name, Prefix="orders_data")

# download orders.csv
s3.download_file(bucket_name, "orders_data/orders.csv", "../data/orders.csv")

#download reviews dataset
s3.download_file(bucket_name, "orders_data/reviews.csv", "../data/reviews.csv")

#download Shipment_deliveries
s3.download_file(bucket_name, "orders_data/shipment_deliveries.csv", "../data/shipment_deliveries.csv")