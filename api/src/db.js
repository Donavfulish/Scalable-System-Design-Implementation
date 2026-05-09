const mysql = require("mysql2/promise");

function createPool(prefix) {
  return mysql.createPool({
    host: process.env[`${prefix}_HOST`],
    port: Number(process.env[`${prefix}_PORT`] || 3306),
    user: process.env[`${prefix}_USER`],
    password: process.env[`${prefix}_PASSWORD`],
    database: process.env[`${prefix}_DATABASE`],
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
  });
}

const writePool = createPool("DB_WRITE");
const readPool = createPool("DB_READ");

module.exports = {
  writePool,
  readPool,
};
