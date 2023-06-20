create table if not exists tegidege9284_staging.reviews(
    review int NOT NULL,
    FOREIGN KEY (product_id) REFERENCES if_common.dim_products(product_id) ON UPDATE CASCADE ON DELETE CASCADE
    );