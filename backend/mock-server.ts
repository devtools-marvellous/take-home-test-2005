import express, { Request, Response, Router } from 'express';
import { v4 as uuidv4 } from 'uuid';

const app = express();
const port = 3001;

app.use(express.json());

interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  address: string;
  address2: string;
  emailVerified: boolean;
}

interface LoginResponse {
  success: boolean;
  errors?: string[];
  user: User;
  token: Token;
}

interface Token {
  access_token: string;
  refresh_token: string; // can be the same one, or a new one
  expires_in: number;
  expiration_timestamp: number; // Timestamp when the access token expires
}

// Mock user data (for demonstration purposes)
const mockUser: User = {
  id: uuidv4(),
  email: 'test@example.com',
  firstName: 'Test',
  lastName: 'User',
  address: '123 Main St',
  address2: 'Apt 4B',
  emailVerified: true,
};

// const expiresIn = 3600; // 1 hour (in seconds)
const expiresIn = 60; // 1 min (in seconds)

// Store tokens and their expiration times (in-memory for mock)
const accessTokens: { [token: string]: number } = {};
// Store refresh tokens and associated user IDs (in-memory for mock)
const refreshTokens: { [token: string]: string } = {};

// *** ROUTES ***

// / (root)
app.get('/', (req, res) => {
  res.send('Mock Express + TypeScript Server');
});

// /login
app.post('/login', (req: Request, res: Response) => {
  // In a real application, you'd verify the email and password from the request body here.
  // For this mock, we'll just assume the login is always successful.

  const accessToken = uuidv4();
  const refreshToken = uuidv4();

  // Calculate the expiration timestamp (current time + expiresIn in seconds)
  const expirationTimestamp = Date.now() + expiresIn * 1000; // Convert seconds to milliseconds

  accessTokens[accessToken] = expirationTimestamp;  //Store it in the in-memory storage
  refreshTokens[refreshToken] = mockUser.id; // Associate refresh token with the user ID

  const loginResponse: LoginResponse = {
    success: true,
    user: mockUser,
    token: {
      access_token: accessToken,
      refresh_token: refreshToken,
      expires_in: expiresIn,
      expiration_timestamp: expirationTimestamp,
    },
  };

  res.json(loginResponse);
});

// /logout
app.post('/logout', (req: Request, res: Response) => {
  const authHeader = req.headers.authorization;
  if (authHeader && authHeader.startsWith('Bearer ')) {
    const accessToken = authHeader.split(' ')[1];
    delete accessTokens[accessToken]; // Remove the token on logout
    console.log(`Token ${accessToken} invalidated on logout.`);
  }
  res.json({ message: 'Logout successful' });
});

// /refresh
app.post('/refresh', (req: Request, res: Response) => {
  const refreshToken = req.body.refresh_token;
  console.log(`RefreshToken recived: ${refreshToken}`);

  if (!refreshToken || !refreshTokens[refreshToken]) {
    res.status(400).json({ message: 'Invalid refresh token' });
    return;
  }

  // Invalidate the old refresh token
  delete refreshTokens[refreshToken];

  // Generate a new access token and refresh token
  const newAccessToken = uuidv4();
  const newRefreshToken = uuidv4(); // You can generate a new one or reuse the old one

  const expirationTimestamp = Date.now() + expiresIn * 1000;

  // Store the new access token
  accessTokens[newAccessToken] = expirationTimestamp;

  // Store the new refresh token (if you generated a new one)
  refreshTokens[newRefreshToken] = refreshTokens[refreshToken]; // Keep the same user association
  delete refreshTokens[refreshToken]; //Remove the old refresh token

  const refreshResponse: Token = {
    access_token: newAccessToken,
    refresh_token: newRefreshToken,
    expires_in: expiresIn,
    expiration_timestamp: expirationTimestamp
  };

  res.json(refreshResponse);
});

// /user/profile
app.get('/user/profile', (req: Request, res: Response) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    res.status(401).json({ message: 'Unauthorized: Missing or invalid Authorization header' });
    return;
  }

  const accessToken = authHeader.split(' ')[1];

  // Check if the token exists and is not expired
  if (!accessTokens[accessToken] || accessTokens[accessToken] <= Date.now()) {
    res.status(401).json({ message: 'Unauthorized: Token expired or invalid' });
    return;
  }

  console.log(`Access Token from header: ${accessToken}`);

  res.json(mockUser);
});

// Start the server
app.listen(port, () => {
  console.log(`Mock server listening at http://localhost:${port}`);
});