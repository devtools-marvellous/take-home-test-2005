# Marvelous Babysitting - Login Refactor Test

## Overview

This code test is designed to evaluate your approach to refactoring an existing login system. The current app contains a working but simplified login system that includes:

1. A login page with email and password fields
2. A success page that shows user information after login
3. Logout functionality

## Your Task

Your task is to refactor the login process based on the existing codebase structure and best practices. You should:

1. Review the current implementation
2. Identify areas for improvement
3. Refactor the code to make it more maintainable, testable, and efficient
4. Ensure the basic functionality (login, logout) still works after your changes

## Key Areas to Consider

- Code organization and architecture
- State management
- Error handling
- Code reusability
- UI/UX improvements
- Potential security improvements

## The Codebase

The project uses:
- Flutter Bloc for state management
- SharedPreferences for local storage
- A mock authentication system with:
  - ApiService for network requests
  - TokenService for token management
  - AuthRepository for authentication logic

## Areas to Consider for Refactoring

The codebase has several areas that could be improved:

1. **Token Management**: The TokenService class handles tokens but has potential issues with how token expiration is managed
2. **Validation Logic**: The AuthRepository contains validation logic that should be extracted to a separate service
3. **Error Handling**: The current error handling is inconsistent and lacks proper categorization
4. **API Layer**: The ApiService has tight coupling with the TokenService
5. **State Management**: The current BLoC pattern implementation could be improved

## Getting Started

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to see the current implementation
4. Make your changes
5. Document your changes and reasoning in the comments or in a separate document

## Submission

When you're finished, please:

1. Create a zip file of your solution
2. Include a brief document explaining your approach and any design decisions you made
3. Send the zip file to the email address provided in the test instructions

## Evaluation Criteria

Your solution will be evaluated based on:

- Code quality and organization
- The effectiveness of your refactoring
- Your ability to identify and solve issues
- Adherence to Flutter best practices
- Maintainability and scalability of your solution

Good luck!
