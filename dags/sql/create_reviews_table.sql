create table if not exists user1234_staging.reviews
(
    review int NOT NULL,
    product_id int NOT null foreign key,
);