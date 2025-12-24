Patient Management SpringBoot

A Patient Management System built using a microservices architecture on Spring Boot, designed to manage patient data, authentication, billing, analytics, and API routing in a modular and scalable way.

🚀 Key Features
🧱 Microservices Architecture

The project is structured using multiple independent services that communicate with each other to form the full system:

API Gateway – Central entry point for routing requests to services.

Auth Service – Handles user authentication and authorization.

Patient Service – Manages patient data and patient-related APIs.

Billing Service – Manages billing and payment logic.

Analytics Service – Collects and processes usage or system analytics.

Integration Tests – End-to-end testing for inter-service communication.

Infrastructure – Shared configurations, Docker/Kubernetes manifests, environment settings, shared libraries, etc.

This design improves scalability, maintainability, and independent deployability of each component. 
GitHub

🔐 Authentication & Authorization

A dedicated Auth Service manages secure authentication (e.g., JWT or other token schemes), user accounts, roles, and session logic — allowing secure access to protected endpoints. 
GitHub

🏥 Patient Management

Core features include:

Creating, reading, updating, and deleting patient records

Handling patient profile and medical data through REST APIs

Flexible service design that allows easy enhancement of patient workflows 
GitHub

💳 Billing & Payments

The Billing Service encapsulates logic related to patient billing, invoices, and financial records — enabling extension into third-party payment systems in the future. 
GitHub

📊 Analytics

The Analytics Service can collect usage statistics or business metrics from the system for insights and reporting. 
GitHub

🧪 Integration Tests

Integration tests ensure different services work together correctly and validate cross-service API flows. 
GitHub

🛠 Technologies Used
Category	Technologies

Language	Java

Framework	Spring Boot

Architecture	Microservices

API Gateway	Spring Cloud Gateway (or similar)

Auth	JWT / Spring Security

Inter-Service Communication	REST APIs

Build Tool	Maven

Testing	JUnit, Spring Test

Containerization	Docker (Dockerfiles included)

Deployment	Flexible for Docker / Kubernetes

Version Control	Git / GitHub
