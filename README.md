# Flutter News App

This project is a Flutter-based mobile application that interacts with a News API to fetch and display articles based on user input. The app consists of two screens and follows **Clean Architecture** principles with **RiverPod** for state management.

## Features ✨

### 🌟 Screen 1: Search News
- **Input Field & Validation:**
    - Users can input a search term to query news articles.
    - Real-time validation ensures proper input and prevents invalid queries.

- **Search Functionality:**
    - When the button is clicked, the app triggers a network request to fetch data from the News API using the input keyword.
    - Handles **pagination** seamlessly for larger datasets.

- **Error Handling:**
    - Comprehensive error handling for various states like network issues, invalid input, or empty results.

---

### 🌟 Screen 2: Display News Results
- **Dynamic Display of Results:**
    - News articles are displayed in a scrollable list, complete with titles, descriptions, and images.
    - Articles without images are gracefully handled with placeholders.

- **Smooth Screen Transitions:**
    - Implements smooth and engaging animations while navigating between screens.

- **Local Caching:**
    - API responses are cached locally using **Shared Preferences**, reducing redundant network calls for the same query.

- **Search History:**
    - Users’ previous search queries are stored locally.

---

## Libraries & Tools Used 🛠

### 📦 Core Libraries:
- **Flutter SDK:** The framework used to build the app.
- **RiverPod:** For efficient and scalable state management.

### 🔗 Networking & API Integration:
- **Dio:** A powerful HTTP client for making network requests.
- **JSON Serialization:** Converts API responses into Dart objects.

### 🎨 UI & Animations:
- **Animated Navigation:** Custom page transitions for a seamless user experience.
- **Custom Widgets:** Reusable components for clean and consistent UI.

### ✅ Validation & Error Handling:
- **Input Validation:** Ensures only valid search terms are allowed.
- **Error Boundaries:** Handles scenarios like empty results, network failures, or API rate limits gracefully.

---

## Project Architecture 🏗

This app follows **Clean Architecture** to ensure scalability and maintainability:
1. **Presentation Layer:** Contains UI widgets and animations.
2. **Domain Layer:** Handles use cases and business logic,RiverPod providers.
3. **Data Layer:** Manages API interactions, caching, and local storage.

---
