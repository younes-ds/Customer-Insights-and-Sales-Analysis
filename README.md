# Customer Analytics Database

This SQL project sets up a simple customer analytics database to track customer orders, products, and sales.

## Structure

The database includes four tables:
- **Customers**: Stores customer info (ID, name, email, join date).
- **Products**: Stores product details (ID, name, category, price).
- **Orders**: Tracks orders (ID, customer ID, order date, status).
- **Order_Details**: Links products to orders (order ID, product ID, quantity).

## Features

1. **Database Setup**: Creates the `CustomerAnalyticsDB` database and tables.
2. **Sample Data**: Inserts sample data for customers, products, orders, and order details.
3. **Analytics Queries**: Includes queries like:
   - Top customers by total spending
   - Most popular products
   - Monthly sales totals
   - Average order value

## Usage

1. Clone the repo.
2. Run the SQL script in your MySQL or PostgreSQL client.
3. Use the queries to analyze sales and customer data.

## Requirements

- MySQL or PostgreSQL database
- SQL client (e.g., MySQL Workbench, pgAdmin)

## License

MIT License - see [LICENSE](LICENSE) for details.
