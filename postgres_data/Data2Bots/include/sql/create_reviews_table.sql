create table if not exists reviews
(
    review int NOT NULL,
    product_id int NOT null foreign key,
);