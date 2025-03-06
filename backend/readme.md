# Install dependencies

Make sure you have Node.js and npm installed on your system.

`npm install`

# Start mock-server

`npm start`

# Access mock api

`localhost:3001`

- **Login:**
  ```bash
  curl -X POST http://localhost:3001/login -H "Content-Type: application/json" -d '{"email": "any", "password": "any"}'
  ```
- **Profile:**
  ```bash
  curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" http://localhost:3001/user/profile
  ```
- **Refresh:**
  ```bash
  curl -X POST http://localhost:3001/refresh -H "Content-Type: application/json" -d '{"refresh_token": "THE_REFRESH_TOKEN_FROM_LOGIN"}'
  ```
- **Logout:**
  ```bash
  curl -X POST http://localhost:3001/logout
  ```
