const express = require("express");
const { writePool, readPool } = require("./db");

const app = express();
app.use(express.json());

const PORT = Number(process.env.PORT || 3000);
const SERVER_ID = process.env.SERVER_ID || "Node_Unknown";

function validateProductPayload(body) {
  if (!body || typeof body !== "object") {
    return "Payload must be a JSON object";
  }
  const { name, price } = body;
  if (typeof name !== "string" || name.trim().length === 0) {
    return "name is required and must be a non-empty string";
  }
  if (typeof price !== "number" || Number.isNaN(price) || price < 0) {
    return "price is required and must be a non-negative number";
  }
  return null;
}

app.get("/health", async (_req, res) => {
  try {
    await writePool.query("SELECT 1");
    await readPool.query("SELECT 1");
    return res.status(200).json({
      status: "ok",
      processed_by: SERVER_ID,
      db_write: "connected",
      db_read: "connected",
    });
  } catch (error) {
    return res.status(503).json({
      status: "degraded",
      processed_by: SERVER_ID,
      error: error.message,
    });
  }
});

app.post("/products", async (req, res) => {
  const validationError = validateProductPayload(req.body);
  if (validationError) {
    return res.status(400).json({
      message: "Validation failed",
      error: validationError,
      processed_by: SERVER_ID,
    });
  }

  const { name, price } = req.body;
  try {
    const [result] = await writePool.execute(
      "INSERT INTO products (name, price) VALUES (?, ?)",
      [name.trim(), price]
    );
    return res.status(201).json({
      message: "Product created successfully",
      processed_by: SERVER_ID,
      data: {
        id: result.insertId,
        name: name.trim(),
        price,
      },
    });
  } catch (error) {
    return res.status(500).json({
      message: "Failed to create product",
      processed_by: SERVER_ID,
      error: error.message,
    });
  }
});

app.get("/products", async (_req, res) => {
  try {
    const [rows] = await readPool.execute(
      "SELECT id, name, price, created_at FROM products ORDER BY id ASC"
    );
    return res.status(200).json({
      message: "Products fetched successfully",
      processed_by: SERVER_ID,
      count: rows.length,
      data: rows,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Failed to fetch products",
      processed_by: SERVER_ID,
      error: error.message,
    });
  }
});

app.listen(PORT, () => {
  console.log(`API server running on port ${PORT} (${SERVER_ID})`);
});
