-- Restaurant Delivery System Database Schema - PostgreSQL
-- Created: 2026-05-01

DROP TABLE IF EXISTS DRIVER_LOCATION CASCADE;
DROP TABLE IF EXISTS DELIVERY_STATUS CASCADE;
DROP TABLE IF EXISTS PAYMENT_DETAILS CASCADE;
DROP TABLE IF EXISTS ORDERS CASCADE;
DROP TABLE IF EXISTS PLACES CASCADE;
DROP TABLE IF EXISTS ORDER_DETAILS CASCADE;
DROP TABLE IF EXISTS MENU_ITEM CASCADE;
DROP TABLE IF EXISTS CATEGORY CASCADE;
DROP TABLE IF EXISTS RATING CASCADE;
DROP TABLE IF EXISTS CUSTOMER_ADDRESS CASCADE;
DROP TABLE IF EXISTS RESTAURANT_LOCATION CASCADE;
DROP TABLE IF EXISTS DRIVER CASCADE;
DROP TABLE IF EXISTS RESTAURANT CASCADE;
DROP TABLE IF EXISTS ADMIN CASCADE;
DROP TABLE IF EXISTS CUSTOMER CASCADE;

DROP TYPE IF EXISTS driver_status_type CASCADE;
DROP TYPE IF EXISTS address_type CASCADE;
DROP TYPE IF EXISTS order_status_type CASCADE;
DROP TYPE IF EXISTS delivery_status_type CASCADE;
DROP TYPE IF EXISTS payment_mode_type CASCADE;
DROP TYPE IF EXISTS payment_status_type CASCADE;

CREATE TYPE driver_status_type AS ENUM ('available', 'busy', 'offline');
CREATE TYPE address_type AS ENUM ('Home', 'Work', 'Other');
CREATE TYPE order_status_type AS ENUM ('pending', 'confirmed', 'preparing', 'ready', 'out_for_delivery', 'delivered', 'cancelled');
CREATE TYPE delivery_status_type AS ENUM ('assigned', 'picked_up', 'in_transit', 'delivered', 'failed');
CREATE TYPE payment_mode_type AS ENUM ('cash', 'card', 'upi', 'wallet');
CREATE TYPE payment_status_type AS ENUM ('pending', 'completed', 'failed', 'refunded');

CREATE TABLE CUSTOMER (
    customer_id SERIAL PRIMARY KEY,
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Address TEXT,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_no VARCHAR(15),
    Password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ADMIN (
    Admin_id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE RESTAURANT (
    restaurant_id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address TEXT NOT NULL,
    phone_no VARCHAR(15),
    Password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE DRIVER (
    driver_id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    phone_no VARCHAR(15) NOT NULL,
    status driver_status_type DEFAULT 'offline',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE RESTAURANT_LOCATION (
    location_id SERIAL PRIMARY KEY,
    restaurant_id INTEGER NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    full_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id) ON DELETE CASCADE
);

CREATE TABLE CUSTOMER_ADDRESS (
    address_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    full_address TEXT NOT NULL,
    address_type address_type DEFAULT 'Home',
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE
);

CREATE TABLE RATING (
    rating_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    admin_id INTEGER,
    rating_value INTEGER CHECK (rating_value BETWEEN 1 AND 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES ADMIN(Admin_id) ON DELETE SET NULL
);

CREATE TABLE CATEGORY (
    Category_id SERIAL PRIMARY KEY,
    restaurant_id INTEGER NOT NULL,
    Name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id) ON DELETE CASCADE
);

CREATE TABLE MENU_ITEM (
    item_code SERIAL PRIMARY KEY,
    Category_id INTEGER NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Category_id) REFERENCES CATEGORY(Category_id) ON DELETE CASCADE
);

CREATE TABLE ORDER_DETAILS (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    restaurant_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status order_status_type DEFAULT 'pending',
    delivery_address_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES RESTAURANT(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_address_id) REFERENCES CUSTOMER_ADDRESS(address_id) ON DELETE SET NULL
);

CREATE TABLE PLACES (
    customer_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (customer_id, order_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES ORDER_DETAILS(order_id) ON DELETE CASCADE
);

CREATE TABLE ORDERS (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    item_code INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    item_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES ORDER_DETAILS(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_code) REFERENCES MENU_ITEM(item_code) ON DELETE CASCADE
);

CREATE TABLE DELIVERY_STATUS (
    Delivery_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    driver_id INTEGER,
    delivery_address TEXT NOT NULL,
    status delivery_status_type DEFAULT 'assigned',
    estimated_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES ORDER_DETAILS(order_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES DRIVER(driver_id) ON DELETE SET NULL
);

CREATE TABLE DRIVER_LOCATION (
    location_id SERIAL PRIMARY KEY,
    driver_id INTEGER NOT NULL,
    delivery_id INTEGER,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES DRIVER(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_id) REFERENCES DELIVERY_STATUS(Delivery_id) ON DELETE SET NULL
);

CREATE TABLE PAYMENT_DETAILS (
    payment_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    Category_id INTEGER,
    amount DECIMAL(10, 2) NOT NULL,
    time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    mode payment_mode_type NOT NULL,
    transaction_id VARCHAR(100),
    status payment_status_type DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES ORDER_DETAILS(order_id) ON DELETE CASCADE,
    FOREIGN KEY (Category_id) REFERENCES CATEGORY(Category_id) ON DELETE SET NULL
);

CREATE INDEX idx_customer_email ON CUSTOMER(email);
CREATE INDEX idx_restaurant_name ON RESTAURANT(Name);
CREATE INDEX idx_order_status ON ORDER_DETAILS(status);
CREATE INDEX idx_driver_status ON DRIVER(status);
CREATE INDEX idx_delivery_status ON DELIVERY_STATUS(status);
CREATE INDEX idx_menu_item_category ON MENU_ITEM(Category_id);
CREATE INDEX idx_rating_restaurant ON RATING(restaurant_id);
CREATE INDEX idx_driver_timestamp ON DRIVER_LOCATION(driver_id, timestamp);
CREATE INDEX idx_delivery_timestamp ON DRIVER_LOCATION(delivery_id, timestamp);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_customer_updated_at BEFORE UPDATE ON CUSTOMER
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_restaurant_updated_at BEFORE UPDATE ON RESTAURANT
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_driver_updated_at BEFORE UPDATE ON DRIVER
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customer_address_updated_at BEFORE UPDATE ON CUSTOMER_ADDRESS
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_item_updated_at BEFORE UPDATE ON MENU_ITEM
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_delivery_status_updated_at BEFORE UPDATE ON DELIVERY_STATUS
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO ADMIN (Name, Password) VALUES
('System Admin', '$2y$10$samplehashedpassword123');

INSERT INTO CUSTOMER (Firstname, Lastname, Name, Address, email, phone_no, Password) VALUES
('John', 'Doe', 'John Doe', '123 Main St, City', 'john.doe@example.com', '9876543210', '$2y$10$samplehash1'),
('Jane', 'Smith', 'Jane Smith', '456 Park Ave, City', 'jane.smith@example.com', '9876543211', '$2y$10$samplehash2');

INSERT INTO RESTAURANT (Name, Address, phone_no, Password) VALUES
('Tasty Bites', '789 Food Street, Downtown', '9876543220', '$2y$10$samplehash3'),
('Quick Meals', '321 Fast Lane, Uptown', '9876543221', '$2y$10$samplehash4');

INSERT INTO RESTAURANT_LOCATION (restaurant_id, latitude, longitude, full_address) VALUES
(1, 30.358560, 76.365330, '789 Food Street, Downtown, Patiala'),
(2, 30.340560, 76.385330, '321 Fast Lane, Uptown, Patiala');

INSERT INTO CUSTOMER_ADDRESS (customer_id, latitude, longitude, full_address, address_type, is_default) VALUES
(1, 30.350000, 76.370000, '123 Main St, City, Patiala', 'Home', TRUE),
(1, 30.355000, 76.375000, 'Office Complex, Business District, Patiala', 'Work', FALSE),
(2, 30.360000, 76.368000, '456 Park Ave, City, Patiala', 'Home', TRUE);

INSERT INTO DRIVER (Name, phone_no, status) VALUES
('Rajesh Kumar', '9876543230', 'available'),
('Amit Singh', '9876543231', 'available'),
('Priya Sharma', '9876543232', 'busy');

INSERT INTO CATEGORY (restaurant_id, Name) VALUES
(1, 'North Indian'),
(1, 'Chinese'),
(1, 'Beverages'),
(2, 'Fast Food'),
(2, 'Desserts');

INSERT INTO MENU_ITEM (Category_id, item_name, price, description) VALUES
(1, 'Butter Chicken', 320.00, 'Creamy tomato-based curry with tender chicken'),
(1, 'Paneer Tikka', 280.00, 'Grilled cottage cheese with spices'),
(2, 'Hakka Noodles', 180.00, 'Stir-fried noodles with vegetables'),
(3, 'Mango Lassi', 80.00, 'Sweet yogurt drink with mango'),
(4, 'Burger Combo', 150.00, 'Burger with fries and drink'),
(5, 'Chocolate Brownie', 120.00, 'Warm brownie with ice cream');

INSERT INTO ORDER_DETAILS (customer_id, restaurant_id, amount, status, delivery_address_id) VALUES
(1, 1, 680.00, 'out_for_delivery', 1);

INSERT INTO PLACES (customer_id, order_id) VALUES
(1, 1);

INSERT INTO ORDERS (order_id, item_code, quantity, item_price, subtotal) VALUES
(1, 1, 1, 320.00, 320.00),
(1, 2, 1, 280.00, 280.00),
(1, 4, 1, 80.00, 80.00);

INSERT INTO DELIVERY_STATUS (order_id, driver_id, delivery_address, status, estimated_time) VALUES
(1, 3, '123 Main St, City, Patiala', 'in_transit', CURRENT_TIMESTAMP + INTERVAL '25 minutes');

INSERT INTO DRIVER_LOCATION (driver_id, delivery_id, latitude, longitude) VALUES
(3, 1, 30.355000, 76.372000),
(3, 1, 30.354500, 76.371500),
(3, 1, 30.354000, 76.371000);

INSERT INTO PAYMENT_DETAILS (order_id, amount, mode, status, transaction_id) VALUES
(1, 680.00, 'upi', 'completed', 'TXN123456789');

INSERT INTO RATING (customer_id, restaurant_id, admin_id, rating_value, review_text) VALUES
(2, 1, 1, 5, 'Excellent food and quick delivery!');

COMMENT ON TABLE DRIVER_LOCATION IS 'Stores driver location updates every 5-7 seconds for real-time tracking';

CREATE OR REPLACE VIEW v_delivery_tracking AS
SELECT
    od.order_id,
    c.Name as customer_name,
    c.phone_no as customer_phone,
    ca.latitude as customer_lat,
    ca.longitude as customer_lng,
    ca.full_address as customer_address,
    r.Name as restaurant_name,
    rl.latitude as restaurant_lat,
    rl.longitude as restaurant_lng,
    rl.full_address as restaurant_address,
    d.Name as driver_name,
    d.phone_no as driver_phone,
    ds.status as delivery_status,
    ds.estimated_time,
    od.status as order_status,
    od.amount
FROM ORDER_DETAILS od
JOIN CUSTOMER c ON od.customer_id = c.customer_id
JOIN CUSTOMER_ADDRESS ca ON od.delivery_address_id = ca.address_id
JOIN RESTAURANT r ON od.restaurant_id = r.restaurant_id
JOIN RESTAURANT_LOCATION rl ON r.restaurant_id = rl.restaurant_id
LEFT JOIN DELIVERY_STATUS ds ON od.order_id = ds.order_id
LEFT JOIN DRIVER d ON ds.driver_id = d.driver_id
WHERE od.status IN ('confirmed', 'preparing', 'ready', 'out_for_delivery');

CREATE OR REPLACE FUNCTION get_latest_driver_location(p_delivery_id INTEGER)
RETURNS TABLE (
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    last_updated TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT dl.latitude, dl.longitude, dl.timestamp
    FROM DRIVER_LOCATION dl
    WHERE dl.delivery_id = p_delivery_id
    ORDER BY dl.timestamp DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMENT ON TABLE CUSTOMER IS 'Stores customer information and authentication details';
COMMENT ON TABLE RESTAURANT IS 'Stores restaurant information';
COMMENT ON TABLE DRIVER IS 'Stores driver information - no vehicle details, only location tracking';
COMMENT ON TABLE DRIVER_LOCATION IS 'Real-time driver location tracking - updates every 5-7 seconds';
COMMENT ON TABLE RESTAURANT_LOCATION IS 'Fixed location coordinates for restaurants';
COMMENT ON TABLE CUSTOMER_ADDRESS IS 'Customer delivery addresses with coordinates for mapping';
COMMENT ON TABLE ORDER_DETAILS IS 'Main order information';
COMMENT ON TABLE DELIVERY_STATUS IS 'Tracks delivery progress and driver assignment';
