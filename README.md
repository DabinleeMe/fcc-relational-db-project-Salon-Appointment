# 💇‍♂️ Salon Appointment Scheduler

A relational database project developed as part of the **freeCodeCamp: Relational Database Certification**. This project demonstrates the integration of **Bash scripting** and **PostgreSQL** to build a functional appointment scheduling system.

## 🚀 Key Features
* **Dynamic Service Menu:** Retrieves available services directly from the PostgreSQL database.
* **Automated Customer Management:** Checks for existing customers by phone number and automatically registers new clients.
* **Appointment Booking:** Seamlessly links customers, services, and time slots in a relational schema.
* **Input Validation:** Uses Regular Expressions (Regex) and recursive functions to handle invalid user inputs gracefully.

## 🛠 Tech Stack
* **Language:** Bash Scripting (Shell)
* **Database:** PostgreSQL
* **Tools:** Git, Terminal

## 📊 Database Schema
The project utilizes three relational tables:
1.  `services`: Stores various salon treatments (cut, color, perm, etc.).
2.  `customers`: Manages client information (phone, name).
3.  `appointments`: Maps customers to services with specific time slots.

## 📖 Lessons Learned
* Handling PostgreSQL queries within a Shell environment using `psql`.
* Managing data integrity and foreign key relationships.
* Formatting raw SQL output using `sed` for clean user-facing messages.
* Implementing recursive logic in Bash for robust user interaction.

---
*Created as a learning milestone for Relational Databases.*
