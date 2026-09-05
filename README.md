# 🛍️ Bazar

**Bazar** is a modern full-stack e-commerce application built with **Flutter, Dart, Node.js, Express, and MongoDB**, designed to provide users with a smooth and intuitive online shopping experience.

The application focuses on clean UI, reusable components, scalable architecture, secure authentication, and a seamless shopping flow from browsing products to completing orders and payments.

## ✨ Features

* 🏠 Modern Home Screen
* 🔎 Product Search
* 🗂️ Product Categories
* 📦 Product Details
* 🛒 Shopping Cart
* ❤️ Favorites
* 💳 Checkout Flow
* 💰 Online Payments
* 📋 Order Management
* 🔔 Notifications
* 👤 User Profile
* 📱 Responsive UI
* 🔐 User Authentication
* 📦 Product & Variant Management
* ⭐ Ratings & Reviews
* 📊 Inventory & Stock Management

## 🛠️ Technologies

### 📱 Frontend

* **Flutter**
* **Dart**
* **BLoC / Cubit**
* **Clean Architecture**
* **REST APIs**
* **Dio**
* **Firebase**
* **Local Storage**
* **Responsive & Adaptive UI**

### ⚙️ Backend

* **Node.js**
* **Express.js**
* **MongoDB**
* **Mongoose**
* **JWT**
* **Zod**
* **Firebase**
* **Paymob**
* **RESTful APIs**

## 🏗️ Architecture

The project follows a structured and scalable architecture that separates application responsibilities into different layers.

### 📱 Flutter Architecture

```text
lib/
├── core/
│   ├── services/
│   ├── utils/
│   ├── widgets/
│   └── ...
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── product/
│   ├── cart/
│   ├── order/
│   ├── notification/
│   └── profile/
│
└── main.dart
```

This structure helps keep the application **maintainable, testable, and easy to extend**.

### ⚙️ Backend Architecture

```text
backend/
├── controllers/
├── routes/
├── models/
├── middlewares/
├── services/
├── validators/
├── utils/
├── config/
└── server.js
```

The backend follows a modular architecture that separates routing, business logic, database models, validation, authentication, and other application responsibilities.

## 🚀 Getting Started

### Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Node.js
* MongoDB
* Android Studio or VS Code
* Git

### 📱 Frontend Installation

Clone the repository:

```bash
git clone https://github.com/Dany126/Bazar.git
```

Navigate to the project:

```bash
cd Bazar
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

### ⚙️ Backend Installation

Navigate to the backend directory:

```bash
cd server
```

Install dependencies:

```bash
npm install
```

Create a `.env` file and configure the required environment variables.

Start the development server:

```bash
npm run dev
```

## 📸 Design

The application design was created using Figma.

```text
https://www.figma.com/design/UHVWaI7SURpJlL7wx7rdOi/Ecommerce-Mobile-App--Community-?node-id=11-1088&t=3b8IypM18jXCYRZ4-1
```

```text
Home        Products       Details       Cart
🏠             🛍️             📦           🛒
```

## 🎯 Project Goals

The main goals of Bazar are:

* Build a complete Flutter e-commerce application.
* Build a scalable and secure backend API.
* Practice scalable Flutter architecture.
* Implement state management using BLoC/Cubit.
* Implement secure authentication using JWT.
* Integrate RESTful APIs between the mobile application and backend.
* Integrate online payments using Paymob.
* Create reusable and maintainable components.
* Provide a smooth and intuitive shopping experience.
* Apply responsive and adaptive design principles.

## 📚 What I Learned

While developing Bazar, I improved my experience with:

### 📱 Frontend

* Flutter application architecture.
* State management using BLoC/Cubit.
* API integration and asynchronous operations.
* Building reusable custom widgets.
* E-commerce workflows and application logic.
* Responsive and adaptive UI development.
* Managing complex application states.

### ⚙️ Backend

* Building RESTful APIs using Node.js and Express.
* Designing MongoDB databases using Mongoose.
* Implementing JWT authentication and authorization.
* Working with access and refresh tokens.
* API validation and middleware.
* E-commerce business logic.
* Product and inventory management.
* Cart and order management.
* Payment integration and webhooks.
* Firebase integration.

## 👨‍💻 Developers

**Dany Ashraf**

Flutter Developer passionate about building modern, scalable, and user-friendly applications.

**Mohamed Adel**

Backend Developer passionate about building secure, scalable, and reliable RESTful APIs and server-side applications.

## 🔗 Repository

[GitHub Repository](https://github.com/Dany126/Bazar)

---

⭐ If you find this project useful, feel free to star the repository.
