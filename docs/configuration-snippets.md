# Configuration Snippets

## 1) Nginx Load Balancer (`infra/nginx/nginx.conf`)
```nginx
upstream api_nodes {
  least_conn;
  server api-node-1:3000 max_fails=3 fail_timeout=10s;
  server api-node-2:3000 max_fails=3 fail_timeout=10s;
}
```

## 2) Master MySQL Setup (`docker-compose.yml` + SQL init)
```yaml
mysql-master:
  image: mysql:8.0
  command: --server-id=1 --log-bin=mysql-bin --binlog-format=ROW
```

```sql
CREATE USER IF NOT EXISTS 'repl_user'@'%' IDENTIFIED BY 'repl_pass';
GRANT REPLICATION SLAVE ON *.* TO 'repl_user'@'%';
```

## 3) Slave MySQL Setup (`docker-compose.yml` + replication script)
```yaml
mysql-slave:
  image: mysql:8.0
  command: --server-id=2 --relay-log=relay-bin --read-only=1 --super-read-only=1
```

```sql
CHANGE REPLICATION SOURCE TO
  SOURCE_HOST='mysql-master',
  SOURCE_USER='repl_user',
  SOURCE_PASSWORD='repl_pass';
START REPLICA;
```

## 4) API Read/Write Splitting (`api/src/server.js`)
```js
app.post("/products", async (req, res) => {
  const [result] = await writePool.execute(
    "INSERT INTO products (name, price) VALUES (?, ?)",
    [name.trim(), price]
  );
});

app.get("/products", async (_req, res) => {
  const [rows] = await readPool.execute(
    "SELECT id, name, price, created_at FROM products ORDER BY id ASC"
  );
});
```
