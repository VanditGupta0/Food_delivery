-- Additional Seed Data for Restaurant Delivery System
-- This script adds professional, realistic data for a better UI experience.

-- OPTIONAL: Add image_url to MENU_ITEM if not already there
ALTER TABLE MENU_ITEM ADD COLUMN IF NOT EXISTS image_url TEXT;

-- 1. CLEAR EXISTING DATA (Resetting sequences so IDs start at 1)
TRUNCATE TABLE RATING, ORDERS, PLACES, ORDER_DETAILS, MENU_ITEM, CATEGORY, RESTAURANT_LOCATION, RESTAURANT, CUSTOMER_ADDRESS, CUSTOMER, DRIVER, DRIVER_LOCATION RESTART IDENTITY CASCADE;

-- 2. PROFESSIONAL RESTAURANTS
INSERT INTO RESTAURANT (Name, Address, phone_no, Password) VALUES
('Bella Italia', '14 Roma Square, Little Italy', '9876543001', '$2y$10$samplehash'),
('Sushi Zen', '88 Sakura Way, Midtown', '9876543002', '$2y$10$samplehash'),
('The Green Bowl', '22 Wellness Ave, Green Park', '9876543003', '$2y$10$samplehash'),
('Retro Burger', '55 Neon Blvd, Downtown', '9876543004', '$2y$10$samplehash'),
('Spice Route', '101 Curry Lane, Old City', '9876543005', '$2y$10$samplehash');

-- 3. CATEGORIES FOR EACH RESTAURANT
INSERT INTO CATEGORY (restaurant_id, Name) VALUES
(1, 'Hand-Tossed Pizza'), (1, 'Artisan Pasta'), (1, 'Italian Desserts'),
(2, 'Premium Sushi'), (2, 'Ramen & Bowls'), (2, 'Appetizers'),
(3, 'Superfood Salads'), (3, 'Fresh Juices'), (3, 'Vegan Wraps'),
(4, 'Gourmet Burgers'), (4, 'Sides & Fries'), (4, 'Milkshakes'),
(5, 'Tandoori Specials'), (5, 'Biryani & Rice'), (5, 'Breads');

-- 4. HIGH-QUALITY MENU ITEMS
INSERT INTO MENU_ITEM (Category_id, item_name, price, description, image_url) VALUES
-- Bella Italia
(1, 'Truffle Mushroom Pizza', 450.00, 'Wild forest mushrooms, mozzarella, and aromatic truffle oil on a sourdough base.', 'https://images.unsplash.com/photo-1513104890138-7c749659a591'),
(1, 'Classic Margherita', 350.00, 'San Marzano tomatoes, fresh buffalo mozzarella, and organic basil.', 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca'),
(2, 'Wild Mushroom Risotto', 380.00, 'Creamy Arborio rice with porcini mushrooms and aged parmesan.', 'https://images.unsplash.com/photo-1476124369491-e7addf5db371'),
(3, 'Tiramisu della Casa', 220.00, 'Classic Italian pick-me-up with espresso-soaked ladyfingers and mascarpone.', 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9'),

-- Sushi Zen
(4, 'Dragon Roll', 550.00, 'Tempura prawn, cucumber, topped with avocado, unagi sauce, and spicy mayo.', 'https://images.unsplash.com/photo-1553621042-f6e147245754'),
(4, 'Salmon Sashimi (5pc)', 420.00, 'Premium fresh Atlantic salmon served with wasabi and pickled ginger.', 'https://images.unsplash.com/photo-1534482421-045b4c2935e6'),
(5, 'Tonkotsu Ramen', 480.00, 'Rich 12-hour pork broth, chashu pork, soft-boiled egg, and nori.', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624'),

-- The Green Bowl
(7, 'Harvest Quinoa Bowl', 320.00, 'Roasted sweet potato, kale, quinoa, avocado, and tahini dressing.', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd'),
(8, 'Cold-Pressed Green Glow', 180.00, 'Spinach, green apple, cucumber, lemon, and ginger.', 'https://images.unsplash.com/photo-1615485290382-441e4d019cb5'),

-- Retro Burger
(10, 'The Signature Beast', 390.00, 'Double wagyu beef patty, smoked bacon, cheddar, and caramelized onions.', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd'),
(11, 'Truffle Parmesan Fries', 150.00, 'Golden crispy fries tossed in truffle oil and freshly grated parmesan.', 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877'),
(12, 'Salted Caramel Shake', 200.00, 'Hand-spun vanilla bean ice cream with sea salt and buttery caramel.', 'https://images.unsplash.com/photo-1572490122747-3968b75cc699'),

-- Spice Route
(13, 'Lamb Rogan Josh', 460.00, 'Slow-cooked Kashmiri lamb in a rich tomato and ginger gravy.', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe'),
(14, 'Hyderabadi Chicken Biryani', 420.00, 'Fragrant long-grain basmati rice layered with spiced chicken and saffron.', 'https://images.unsplash.com/photo-1563379091339-03b21bc4a4f8'),
(15, 'Garlic Butter Naan', 60.00, 'Soft, clay-oven baked bread brushed with fresh garlic and butter.', 'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7');

-- 5. REALISTIC DRIVERS
INSERT INTO DRIVER (Name, phone_no, status) VALUES
('Arjun Khanna', '9988776655', 'available'),
('Sarah Williams', '9988776654', 'busy'),
('David Miller', '9988776653', 'available'),
('Maria Rodriguez', '9988776652', 'offline'),
('Kenji Tanaka', '9988776651', 'available');

-- 6. CUSTOMERS & ADDRESSES
INSERT INTO CUSTOMER (Firstname, Lastname, Name, email, phone_no, Password) VALUES
('Vandit', 'Gupta', 'Vandit Gupta', 'vandit@example.com', '9000000001', '$2y$10$samplehash'),
('Alice', 'Walker', 'Alice Walker', 'alice@example.com', '9000000002', '$2y$10$samplehash'),
('Bob', 'Sanders', 'Bob Sanders', 'bob@example.com', '9000000003', '$2y$10$samplehash'),
('Charlie', 'Puth', 'Charlie Puth', 'charlie@example.com', '9000000004', '$2y$10$samplehash');

INSERT INTO CUSTOMER_ADDRESS (customer_id, full_address, latitude, longitude, address_type, is_default) VALUES
(1, 'Apartment 402, Skyline Towers, Patiala', 30.3585, 76.3653, 'Home', TRUE),
(1, 'Tech Park Phase 1, Office 12B, Patiala', 30.3400, 76.3800, 'Work', FALSE),
(2, 'Green Valley Villas, Sector 7, Patiala', 30.3600, 76.3700, 'Home', TRUE);

-- 7. RECENT ORDER HISTORY
INSERT INTO ORDER_DETAILS (customer_id, restaurant_id, amount, status, delivery_address_id) VALUES
(1, 1, 1050.00, 'delivered', 1),
(2, 2, 970.00, 'out_for_delivery', 3),
(3, 4, 540.00, 'preparing', NULL),
(1, 5, 940.00, 'pending', 1);

INSERT INTO ORDERS (order_id, item_code, quantity, item_price, subtotal) VALUES
(1, 1, 2, 450.00, 900.00), (1, 11, 1, 150.00, 150.00),
(2, 5, 1, 550.00, 550.00), (2, 6, 1, 420.00, 420.00);

-- 8. GENUINE REVIEWS
INSERT INTO RATING (customer_id, restaurant_id, rating_value, review_text) VALUES
(1, 1, 5, 'Best Truffle Pizza in town! The crust is so airy and fresh.'),
(2, 2, 4, 'Sushi was fresh, but the delivery took slightly longer than expected.'),
(3, 3, 5, 'Perfect for a healthy lunch. The Quinoa bowl is filling and tasty.'),
(1, 4, 3, 'Burger was good, but fries were a bit cold on arrival.'),
(2, 5, 5, 'Authentic spices. The Biryani reminds me of home!');
