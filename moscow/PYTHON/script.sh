# _file=`date +"%Y%m%d_%H%M%S"`
dict_cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
dict_cur.execute("INSERT INTO test (num, data) VALUES(%s, %s)", (100, "abc'def"))
dict_cur.execute("SELECT * FROM test")
rec = dict_cur.fetchone()
rec['id']

>>> SQL = "INSERT INTO authors (name) VALUES (%s);" # Note: no quotes
>>> data = ("O'Reilly", )
>>> cur.execute(SQL, data) # Note: no % operator

Many ways. DONT use the most obvious one (%s with %) in real code, it's open to attacks.
Here copy-paste'd from pydoc of sqlite3:
# Never do this -- insecure!
symbol = 'RHAT'
c.execute("SELECT * FROM stocks WHERE symbol = '%s'" % symbol)
# Do this instead
t = ('RHAT',)
c.execute('SELECT * FROM stocks WHERE symbol=?', t)
print c.fetchone()
# Larger example that inserts many records at a time
purchases = [('2006-03-28', 'BUY', 'IBM', 1000, 45.00),('2006-04-05', 'BUY', 'MSFT', 1000, 72.00),('2006-04-06', 'SELL', 'IBM', 500, 53.00),
            ]
c.executemany('INSERT INTO stocks VALUES (?,?,?,?,?)', purchases)

More examples if you need:
# Multiple values single statement/execution
c.execute('SELECT * FROM stocks WHERE symbol=? OR symbol=?', ('RHAT', 'MSO'))
print c.fetchall()
c.execute('SELECT * FROM stocks WHERE symbol IN (?, ?)', ('RHAT', 'MSO'))
print c.fetchall()
# This also works, though ones above are better as a habit as it's inline with syntax of executemany().. but your choice.
c.execute('SELECT * FROM stocks WHERE symbol=? OR symbol=?', 'RHAT', 'MSO')
print c.fetchall()
[[# Insert a single item
c.execute('INSERT INTO stocks VALUES (?,?,?,?,?)', ('2006-03-28', 'BUY', 'IBM', 1000, 45.00))