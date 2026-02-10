# personal_finance_tracker
## Personal Finance Tracker

This project is a **responsive personal finance tracker** built with Flutter. It allows you to record income and expenses, inspect each transaction, and view simple statistics (totals and category breakdowns) to better understand your spending habits.

### Deployed application

- **URL**: `https://alex20m.github.io/flutter_course/`

Open the link in any modern browser (Chrome, Edge, Safari, Firefox). The app runs fully in the browser as a Flutter web application.

### Idea and purpose

- **Idea**: A small “quantified money” app where you can quickly log incomes and expenses, then see an overview of how much you earn, how much you spend, and where the money goes.
- **Purpose**: Practice building a multi-screen, responsive Flutter app that:
  - Accepts user input via forms.
  - Persists data locally between restarts.
  - Shows derived statistics based on the entered data.

### How to use the application

- **Overview screen (`/`)**
  - Shows total **income**, **expenses**, and **net balance**.
  - Lists your **most recent transactions**.
  - Use the “View all” button to go to the full transactions list.

- **Transactions list (`/transactions`)**
  - See all saved transactions, most recent first.
  - **Filter** by category using the dropdown at the top.
  - Click **“Add transaction”** to create a new income or expense.
  - Tap/click any transaction row to open its **detail view**.

- **Add / Edit transaction (`/transactions/new` and `/transactions/:id` via Edit)**
  - Fill in:
    - **Description** (e.g. “Groceries”, “Salary August”)
    - **Amount** (positive number)
    - **Category** (select from predefined categories)
    - **Date** (pick using the date picker)
    - Toggle **“This is income”** on/off
  - Press **Save**:
    - A new transaction is created, or the existing one is updated.
    - You are navigated to the corresponding **transaction detail** screen.

- **Transaction detail (`/transactions/:id`)**
  - Shows all information for a single transaction.
  - Use **Edit** to change it, or **Delete** to remove it.
  - After deleting, you are taken back to the transaction list.

- **Statistics screen (`/stats`)**
  - Shows:
    - Total **income**
    - Total **expenses**
    - **Net balance**
  - Displays breakdowns **“Income by category”** and **“Expenses by category”** using progress bars to visualise relative shares.

### Responsiveness and layout

- The app uses a shared `ResponsiveScaffold`:
  - On **narrow screens** (mobile): top app bar + bottom navigation bar.
  - On **wider screens** (tablet/desktop): a **navigation rail** on the left and content on the right.
- The main content area is constrained to a **maximum width** to keep the layout readable on very wide displays.

### Data persistence

- The app uses **GetX** and **Hive** (`hive_ce_flutter`) for local persistence:
  - A `FinanceController` manages a list of transactions.
  - Data is stored in a local Hive box named `"storage"` under the key `"transactions"`.
  - When you refresh or reopen the app in the same browser profile, previously entered transactions are loaded back from Hive.

### Project structure for submission

- The root of the zip contains:
  - This `README.md` file.
  - A folder called `src` that holds the application sources.
- Inside `src`:
  - `main.dart` is the **entry point** of the application.
  - The Flutter project lives under `lib/`, `pubspec.yaml`, `web/`, `test/`, etc.
  - To run locally:
    - `cd src`
    - `flutter pub get`
    - `flutter run -d chrome`
