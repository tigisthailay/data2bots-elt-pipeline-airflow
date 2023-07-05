import psycopg2 as ps
import pandas as pd

#establish a connection with remote databases
conn = ps.connect(
      database="d2b_accessment",
      user="tegidege9284",
      password="KjJjxG99Hl",
      host="34.89.230.185",
      port= '5432')

cur = conn.cursor()

with open('/home/tegisty/Downloads/reviews.csv', 'r') as f:
     
# Skip the header row.
    next(f)
    cur.copy_from(f, 'reviews', sep=',')

conn.commit()
