create table if not exists tegidege9284_staging.orders
(
    order_id int not null primary key,
    FOREIGN KEY (customer_id)
    REFERENCES if_common.dim_customers (customer_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    order_date VARCHAR(255) NOT null,
    FOREIGN KEY (product_id) REFERENCES if_common.dim_products(product_id) ON UPDATE CASCADE ON DELETE CASCADE,
    unit_price int NOT null,
    quantity int NOT null,
    total_price int NOT null
    );
