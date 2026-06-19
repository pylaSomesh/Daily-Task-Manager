# Daily Task Manager

## 📌 Overview

Daily Task Manager is a full-stack web application designed to help users efficiently manage and track their daily tasks. The application provides task creation, status tracking, completion monitoring, and an interactive analytics dashboard that offers insights into productivity trends and task performance.

The project follows the MVC architecture pattern and is built using Java, JSP, Servlets, JDBC, MySQL, AJAX, and Chart.js. It demonstrates full-stack development concepts including authentication, database integration, session management, asynchronous communication, and data visualization.

---

## ✨ Features

### 🔐 User Authentication

* User registration
* Secure user login
* Session management
* Logout functionality

### 📝 Task Management

* Create new tasks
* Update existing tasks
* Delete tasks
* Mark tasks as completed
* View task details
* Track task status

### 📊 Analytics Dashboard

* Total tasks overview
* Completed tasks tracking
* Pending tasks tracking
* Overdue tasks tracking
* Completion rate calculation
* Interactive task distribution chart
* Monthly productivity trend analysis
* Month-wise analytics filtering
* Dynamic dashboard updates using AJAX

### User Experience

* Modern responsive interface
* Interactive analytics dashboard
* Real-time task filtering
* Asynchronous updates without page refresh
* Optimized user workflow

---

## 🛠️ Technology Stack

### ⚙️ Backend

* Java
* JSP (Java Server Pages)
* Servlets
* JDBC

### 💻 Frontend

* HTML5
* CSS3
* JavaScript
* AJAX
* Chart.js

### 🗄️ Database

* MySQL

### 📦 Build and Dependency Management

* Maven

### 🌐 Application Server

* Apache Tomcat 10

---

## 🏗️ Architecture

The application follows the Model-View-Controller (MVC) architecture.

```text
Client Browser
       |
       v
JSP Views
       |
       v
Servlet Controllers
       |
       v
DAO Layer
       |
       v
MySQL Database
```

### Components

#### Model Layer

Responsible for representing application data.

Examples:

* User
* Task
* AnalyticsDTO

#### View Layer

Responsible for rendering user interfaces.

Examples:

* JSP Pages
* HTML
* CSS
* JavaScript

#### Controller Layer

Responsible for handling requests and coordinating application flow.

Examples:

* LoginServlet
* RegisterServlet
* AnalyticsServlet
* FilterTasksServlet

#### Data Access Layer

Responsible for database interaction.

Examples:

* UserDAO
* TaskDAO

---

## 📁 Project Structure

```text
DailyTaskManager
│
├── src
│   └── main
│       ├── java
│       │   └── com.taskmanager
│       │       ├── dao
│       │       ├── model
│       │       ├── servlet
│       │       └── util
│       │
│       ├── resources
│       │
│       └── webapp
│           ├── css
│           ├── js
│           ├── images
│           ├── WEB-INF
│           └── jsp
│
├── pom.xml
└── README.md
```

---

## 🗃️ Database Design

### 👤 Users Table

Stores registered user information.

Key Attributes:

* User ID
* Name
* Email
* Password

### 📋 Tasks Table

Stores task information associated with users.

Key Attributes:

* Task ID
* User ID
* Title
* Description
* Status
* Due Date
* Created Date
* Completed Date

---

## 📈 Analytics Capabilities

The analytics module provides meaningful insights into user productivity through:

* Task distribution analysis
* Completion rate calculation
* Monthly productivity tracking
* Status-based task filtering
* Interactive chart visualizations
* Dynamic dashboard metrics

---

## Key Learning Outcomes

This project helped strengthen understanding of:

* MVC Architecture
* Object-Oriented Programming
* JDBC Database Connectivity
* Session Management
* Authentication and Authorization
* Servlet-Based Request Handling
* AJAX Communication
* Data Visualization using Chart.js
* Maven Project Management
* Responsive Web Design
* Database Design and SQL Queries
* Full-Stack Application Development

---


---

## Running the Application

### Prerequisites

* Java JDK 17 or later
* Apache Tomcat 10
* MySQL Server
* Maven
* Eclipse IDE or IntelliJ IDEA

### Steps

1. Clone the repository.
2. Create the MySQL database.
3. Configure database credentials using environment variables.
4. Import the Maven project into the IDE.
5. Build the project using Maven.
6. Deploy the application to Apache Tomcat.
7. Start the server.
8. Access the application through the browser.

---

## Design Patterns and Concepts Used

* MVC Architecture
* DAO Design Pattern
* Session-Based Authentication
* Layered Application Design
* Dependency Management with Maven
* Asynchronous Communication using AJAX
* Data Visualization using Chart.js

---

## Future Enhancements

Potential improvements include:

* Email notifications
* Calendar-based task management
* PDF report generation
* Priority-based task analytics
* Category-based task organization
* User profile management
* Activity history tracking
* Export and reporting capabilities

---

## Author

Somesh Pyla

Bachelor of Technology in Computer Science and Engineering

Java Full Stack Developer

---

## Project Summary

Daily Task Manager is a comprehensive task management and productivity analytics application that demonstrates full-stack Java web development skills. The project integrates user authentication, task lifecycle management, database operations, asynchronous interactions, and analytical reporting into a single cohesive system while following industry-standard architectural practices.
