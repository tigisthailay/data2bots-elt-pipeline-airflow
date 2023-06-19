create table if not exists user1234_staging.orders
(
    order_id int not null primary key,
    customer_id int NOT null foreign key,
    order_date object NOT null,
    product_id int NOT null foreign key,
    unit_price int NOT null,
    quantity int NOT null,
    total_price int NOT null,
);
