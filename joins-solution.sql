-- ## Tasks
-- 1. Get all customers and their addresses.
SELECT * FROM customers
JOIN addresses ON customers.id = addresses.customer_id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT * FROM orders
JOIN line_items ON orders.id = order_id
JOIN products ON products.id = line_items.product_id;

-- 3. Which warehouses have cheetos?
SELECT warehouse, products.description, warehouse_product.on_hand FROM warehouse
JOIN warehouse_product ON warehouse_id = warehouse.id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.id = 5;

-- 4. Which warehouses have diet pepsi?
SELECT warehouse, products.description, warehouse_product.on_hand FROM warehouse
JOIN warehouse_product ON warehouse_id = warehouse.id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi'; -- another way to get the item

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT customers.last_name, COUNT(*) FROM orders
JOIN addresses ON addresses.id = orders.address_id
JOIN customers ON customers.id = addresses.customer_id
GROUP BY customers.last_name;

-- 6. How many customers do we have?
SELECT COUNT(*) FROM customers;
SELECT 'Count', COUNT(*) FROM customers; -- just to add a column for fun

-- 7. How many products do we carry?
SELECT COUNT(*) FROM products;
SELECT 'Count', COUNT(*) FROM products;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT 'diet pepsi', SUM(warehouse_product.on_hand) FROM warehouse
JOIN warehouse_product ON warehouse_id = warehouse.id
JOIN products ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

-- ## Stretch
-- 9. How much was the total cost for each order?
SELECT orders.order_date, SUM(products.unit_price * line_items.quantity) FROM orders
JOIN line_items ON orders.id = order_id
JOIN products ON products.id = line_items.product_id
GROUP BY orders.id;

-- 10. How much has each customer spent in total?
SELECT customers.first_name, SUM(products.unit_price * quantity) FROM customers
JOIN addresses ON customers.id = addresses.customer_id
JOIN orders ON orders.address_id = addresses.id
JOIN line_items ON line_items.order_id = orders.id
JOIN products ON products.id = line_items.product_id
GROUP BY customers.id;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT customers.first_name, COALESCE(SUM(unit_price * quantity), 0) FROM customers
LEFT JOIN addresses ON customers.id = addresses.customer_id
LEFT JOIN orders ON orders.address_id = addresses.id
LEFT JOIN line_items ON line_items.order_id = orders.id
LEFT JOIN products ON products.id = line_items.product_id
GROUP BY customers.id;