import { useEffect, useMemo, useState } from "react";
import "./styles.css";

const API_BASE = "http://localhost:5000/api";

export default function App() {
  const [restaurants, setRestaurants] = useState([]);
  const [restaurantId, setRestaurantId] = useState("");
  const [menu, setMenu] = useState([]);
  const [selectedItems, setSelectedItems] = useState({});
  const [orderResponse, setOrderResponse] = useState(null);
  const [trackingOrderId, setTrackingOrderId] = useState("");
  const [trackingData, setTrackingData] = useState(null);
  const [error, setError] = useState("");

  useEffect(() => {
    fetch(`${API_BASE}/restaurants`)
      .then((res) => res.json())
      .then((data) => {
        setRestaurants(data);
        if (data.length > 0) setRestaurantId(String(data[0].restaurant_id));
      })
      .catch((err) => setError(err.message));
  }, []);

  useEffect(() => {
    if (!restaurantId) return;
    fetch(`${API_BASE}/restaurants/${restaurantId}/menu`)
      .then((res) => res.json())
      .then((data) => {
        setMenu(data);
        setSelectedItems({});
      })
      .catch((err) => setError(err.message));
  }, [restaurantId]);

  const total = useMemo(() => {
    return Object.values(selectedItems).reduce((sum, item) => sum + item.subtotal, 0);
  }, [selectedItems]);

  const toggleItem = (menuItem) => {
    setSelectedItems((prev) => {
      const existing = prev[menuItem.item_code];
      if (existing) {
        const next = { ...prev };
        delete next[menuItem.item_code];
        return next;
      }
      return {
        ...prev,
        [menuItem.item_code]: {
          item_code: menuItem.item_code,
          item_name: menuItem.item_name,
          quantity: 1,
          subtotal: Number(menuItem.price),
          unitPrice: Number(menuItem.price),
        },
      };
    });
  };

  const updateQuantity = (itemCode, quantity) => {
    const numericQty = Math.max(1, Number(quantity || 1));
    setSelectedItems((prev) => ({
      ...prev,
      [itemCode]: {
        ...prev[itemCode],
        quantity: numericQty,
        subtotal: Number((prev[itemCode].unitPrice * numericQty).toFixed(2)),
      },
    }));
  };

  const placeOrder = async () => {
    try {
      setError("");
      const payload = {
        customer_id: 1, // Static for demo
        restaurant_id: Number(restaurantId),
        delivery_address_id: 1,
        payment_mode: "upi",
        items: Object.values(selectedItems).map(({ item_code, quantity }) => ({
          item_code,
          quantity,
        })),
      };

      const res = await fetch(`${API_BASE}/orders`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.message || "Failed to create order");
      setOrderResponse(data);
      setTrackingOrderId(String(data.order_id));
      setSelectedItems({});
    } catch (err) {
      setError(err.message);
    }
  };

  const fetchTracking = async () => {
    if (!trackingOrderId) return;
    try {
      const res = await fetch(`${API_BASE}/orders/${trackingOrderId}/tracking`);
      const data = await res.json();
      if (!res.ok) throw new Error(data.message || "Tracking lookup failed");
      setTrackingData(data);
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="container">
      <header>
        <h1>FoodieHub</h1>
        <p>Premium food delivery at your fingertips.</p>
      </header>

      {error && <div className="error card" style={{padding: '1rem', marginBottom: '2rem'}}>{error}</div>}

      <div className="restaurant-selector">
        <select value={restaurantId} onChange={(e) => setRestaurantId(e.target.value)}>
          {restaurants.map((r) => (
            <option key={r.restaurant_id} value={r.restaurant_id}>
              📍 {r.name}
            </option>
          ))}
        </select>
      </div>

      <div className="menu-grid">
        {menu.map((item) => (
          <div key={item.item_code} className="menu-card">
            <img 
              src={item.image_url || "https://images.unsplash.com/photo-1546069901-ba9599a7e63c"} 
              alt={item.item_name} 
              className="menu-image"
            />
            <div className="menu-content">
              <h3>{item.item_name}</h3>
              <p className="menu-description">{item.description}</p>
              <div className="menu-footer">
                <span className="price">Rs {item.price}</span>
                <div className="cart-controls">
                  {selectedItems[item.item_code] ? (
                    <input
                      type="number"
                      className="qty-input"
                      min="1"
                      value={selectedItems[item.item_code].quantity}
                      onChange={(e) => updateQuantity(item.item_code, e.target.value)}
                    />
                  ) : (
                    <button className="btn-add" onClick={() => toggleItem(item)}>Add to Cart</button>
                  )}
                  {selectedItems[item.item_code] && (
                    <button className="btn-add" style={{background: '#ff4757'}} onClick={() => toggleItem(item)}>×</button>
                  )}
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="checkout-section">
        <div>
          <h2 style={{margin: 0}}>Total: <span className="price">Rs {total.toFixed(2)}</span></h2>
          <p style={{margin: 0, color: 'var(--text-muted)'}}>{Object.keys(selectedItems).length} items in cart</p>
        </div>
        <button
          className="checkout-btn"
          onClick={placeOrder}
          disabled={Object.keys(selectedItems).length === 0}
        >
          Proceed to Checkout
        </button>
      </div>

      {orderResponse && (
        <div className="success card" style={{padding: '1.5rem', marginTop: '2rem', textAlign: 'center'}}>
           🎉 Order placed successfully! <strong>Order ID: #{orderResponse.order_id}</strong>
        </div>
      )}

      <section className="tracking-section">
        <h2>📦 Track Your Order</h2>
        <div className="tracking-form">
          <input
            type="number"
            className="input-field"
            placeholder="Enter Order ID (e.g. 1)"
            value={trackingOrderId}
            onChange={(e) => setTrackingOrderId(e.target.value)}
          />
          <button className="btn-add" style={{padding: '0 2rem'}} onClick={fetchTracking}>Track</button>
        </div>
        {trackingData && (
          <div className="card" style={{padding: '1.5rem'}}>
            <div style={{display: 'flex', justifyContent: 'space-between', marginBottom: '1rem'}}>
              <span className="status-badge">{trackingData.order_status}</span>
              <span className="price">Order #{trackingData.order_id}</span>
            </div>
            <p><strong>Driver:</strong> {trackingData.driver_name || "Assigning..."}</p>
            <p><strong>Phone:</strong> {trackingData.driver_phone || "N/A"}</p>
            <p><strong>Delivery Status:</strong> {trackingData.delivery_status || "Processing"}</p>
          </div>
        )}
      </section>
    </div>
  );
}
