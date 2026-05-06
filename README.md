<<<<<<< HEAD
# Restaurant Delivery System (PostgreSQL)

This project includes:
- `backend/` - Express API connected to PostgreSQL.
- `frontend/` - React app to browse menu, place order, and track order.

## 1) Setup PostgreSQL Database

Create a PostgreSQL database, for example:

```sql
CREATE DATABASE restaurant_delivery;
```

Run schema + sample data:

```bash
psql -U postgres -d restaurant_delivery -f backend/sql/init.sql
```

## 2) Run Backend

```bash
cd backend
npm install
copy .env.example .env
```

Update `backend/.env` if needed:

```env
PORT=5000
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/restaurant_delivery
```

Start backend:

```bash
npm run dev
```

Backend API runs at `http://localhost:5000`.

## 3) Run Frontend

```bash
cd frontend
npm install
npm run dev
```

Frontend runs at `http://localhost:5173`.

## API Endpoints

- `GET /api/health`
- `GET /api/restaurants`
- `GET /api/restaurants/:restaurantId/menu`
- `POST /api/orders`
- `GET /api/orders/:orderId/tracking`
=======
This is our dbms project
>>>>>>> 7d95112409a875560997ad4058c248a6d0e7a057
