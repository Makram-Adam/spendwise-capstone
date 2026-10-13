# SpendWise Capstone — Requirements

## 1. Project Overview
SpendWise is a multi-user expense and budget tracking application.
It helps users record expenses, organize spending by category, and
monitor monthly budgets.

## 2. Main Requirements
- Users have private accounts and authenticated access.
- Users can create, view, update, and delete their own expenses.
- Each expense has an amount, description, date, and category.
- The application provides shared default categories.
- Users can create and manage their own custom categories.
- Users can create an overall monthly budget.
- Users can create category-specific monthly budgets.
- Users can view spending summaries and compare expenses with budgets.
- Important data changes are recorded in an audit log.
- Users must not access another user's private expenses or budgets.

## 3. Database Requirements
- PostgreSQL is the authoritative relational database.
- Flyway will manage versioned schema migrations.
- Redis is a proposed caching component for suitable summaries.
- The backend framework will be selected before implementation.
- Indexes and EXPLAIN ANALYZE will be used to investigate query performance.
- Backups must be created and a restore must be tested.

## 4. Security Requirements
- Store password hashes, never plaintext passwords.
- Apply least-privilege database roles.
- Use PostgreSQL Row-Level Security (RLS) for private user data.
- Validate category ownership when expenses and budgets are created or changed.
- Protect default categories from unauthorized changes.
- Protect audit records from unauthorized modification.
- Use parameterized queries to reduce SQL injection risk.
- Isolate cached data by user and avoid caching sensitive information unnecessarily.

## 5. Main Entities
- USERS: account and profile information.
- CATEGORIES: shared default categories and user-created categories.
- EXPENSES: expenses recorded by users.
- BUDGETS: overall or category-specific monthly spending limits.
- AUDIT_LOG: records of important data changes.

## 6. Acceptance Tests
- User A cannot read, modify, or delete User B's expenses or budgets.
- Users cannot assign expenses to another user's private categories.
- Users cannot modify or delete shared default categories.
- Each user can have one overall budget per month.
- Each user can have one budget per category per month.
- Database access controls are tested using the application database role.
- Migrations run successfully from an empty database.
- Query performance evidence, a backup, and a tested restore are documented.

## 7. Deliverables
- Requirements summary and ER diagram.
- Versioned database migrations.
- Justified NoSQL integration, if appropriate.
- Before-and-after query performance evidence.
- Backup and security artifacts.
- Final project walkthrough presentation.
