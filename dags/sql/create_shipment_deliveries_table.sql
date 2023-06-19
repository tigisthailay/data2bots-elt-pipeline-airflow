create table if not exists user1234_staging.shipments_deliveries
(
    shipment_id int NOT NULL primary key,
    order_id int not null foreign key,
    shipment_date date NULL,
    delivery_date date Null,
);