fetch('http://localhost:5000/api/health')
  .then(res => res.json())
  .then(data => console.log('Health:', data))
  .catch(err => console.error('Error:', err));

fetch('http://localhost:5000/api/restaurants')
  .then(res => res.json())
  .then(data => console.log('Restaurants:', data))
  .catch(err => console.error('Error:', err));
