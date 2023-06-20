#import packages
import psycopg2
#from config import config


def create_tables():
    """ create tables in the PostgreSQL database"""
    commands = (
        """
        create table if not exists tegidege9284_staging.orders(
        order_id int not null primary key,
        FOREIGN KEY (customer_id)
        REFERENCES if_common.dim_customers (customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
        order_date VARCHAR(255) NOT null,
        FOREIGN KEY (product_id) REFERENCES if_common.dim_products(product_id) ON UPDATE CASCADE ON DELETE CASCADE,
        unit_price int NOT null,
        quantity int NOT null,
        total_price int NOT null
        )
        """,
        """
        create table if not exists tegidege9284_staging.reviews(
        review int NOT NULL,
        FOREIGN KEY (product_id) REFERENCES if_common.dim_products(product_id) ON UPDATE CASCADE ON DELETE CASCADE
        )
        """,
        """
        create table if not exists tegidege9284_staging.shipments_deliveries(
        shipment_id int NOT NULL primary key,
        FOREIGN KEY (order_id) REFERENCES tegidege9284_staging.orders (order_id) ON UPDATE CASCADE ON DELETE CASCADE,
        shipment_date date NULL,
        delivery_date date Null
        """
        )
    conn = None
    try:
        #establish a connection with remote databases
        conn = psycopg2.connect(
        database="d2b_accessment",
        user="tegidege9284",
        password="KjJjxG99Hl",
        host="34.89.230.185",
        port= '5432'
)
        cur = conn.cursor()
        # create table one by one
        for command in commands:
            cur.execute(command)
        # close communication with the PostgreSQL database server
        cur.close()
        # commit the changes
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()


if __name__ == '__main__':
    create_tables()
