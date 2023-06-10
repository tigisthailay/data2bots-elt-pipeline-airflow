create table if not exists orders
(
    order_id int not null primary key,
    customer_id int NOT null foreign key,
    order_date object NOT null,
    product_id int NOT null foreign key,
    unit_price int NOT null,
    quantity int NOT null,
    total_price int NOT null,
);
create table if not exists reviews
(
    review int NOT NULL,
    product_id int NOT null foreign key,
);

create table if not exists shipments_deliveries
(
    shipment_id int NOT NULL primary key,
    order_id int not null foreign key,
    shipment_date date NULL,
    delivery_date date Null,
);