create table if not exists tegidege9284_staging.shipments_deliveries(
    shipment_id int NOT NULL primary key,
    FOREIGN KEY (order_id) REFERENCES tegidege9284_staging.orders (order_id) ON UPDATE CASCADE ON DELETE CASCADE,
    shipment_date date NULL,
    delivery_date date Null
);