# ☕ Java Code Review & Quality Analyzer

A professional fullstack Java application for automated **Code Review, Static AST Linting, Cyclomatic Complexity Calculation, and OWASP Security Vulnerability Inspection**.

Built with:
1. **Frontend**: Pure HTML5, Modern CSS (Glassmorphism, Dark Mode, SVG Circular Gauges), Vanilla JavaScript (Zero npm build step needed).
2. **Backend**: Java 21, Spring Boot 3, JavaParser AST engine, Spring Data JPA, HikariCP.
3. **Database**: XAMPP MySQL with phpMyAdmin integration (`code_analyzer_db`).

---

## 🌟 Key Features

- **⚡ AST-Powered Static Analysis Engine**:
  - **OWASP Security Vulnerabilities**: Detects SQL Injection (dynamic concatenation), Hardcoded Credentials / Secrets, Command Injection (`Runtime.exec`), Insecure Randomness (`java.util.Random`), Weak Hashing algorithms (`MD5`, `SHA-1`), and Path Traversal risks.
  - **Code Smells & Anti-patterns**: God Classes (>350 LOC), Long Methods (>35 LOC), Excessive Method Parameters (>4), Empty `catch` blocks (swallowed exceptions), and Generic Exception usage.
  - **Bug & Memory Risks**: `String` equality comparison with `==` instead of `.equals()`, AutoCloseable resource leaks without `try-with-resources`, and `equals()` overridden without `hashCode()`.
  - **Performance & Best Practices**: String concatenation in tight loops, legacy synchronized collections (`Vector`, `Hashtable`), and direct `System.out` / `printStackTrace()` calls in production.

- **📊 Interactive Quality Dashboard**:
  - Animated Circular SVG Score Gauge (0 - 100) with Letter Grade (A+, A, B, C, D, F) and Verdict status.
  - Live KPI cards: Total Lines of Code (LOC), Comment Ratio, McCabe Cyclomatic Complexity, SEI Maintainability Index, and Remediation Technical Debt estimation.
  - Filterable issues explorer with categorized pills (Security, Bugs, Code Smells, Performance, Best Practices).

- **🛠️ Automated Quick-Fix**:
  - Generates refactored Java code with one click (e.g. converting `==` to `.equals()`, upgrading insecure random, wrapping resources, fixing empty catch blocks).

- **🗄️ XAMPP / phpMyAdmin MySQL Persistence**:
  - Automatically records full audit reports, code snippets, metrics, and detected issues in MySQL database `code_analyzer_db`.
  - Built-in Audit History browser: Search past reviews by file name, inspect previous scores, or delete entries.
  - Resilient backend: starts smoothly even if XAMPP MySQL hasn't been booted up yet, with live status detection.

---

## 🚀 Quick Start Guide

### 1. Prerequisites
- **XAMPP**: Start **Apache** and **MySQL** from the XAMPP Control Panel.
- **Java 21 & Maven 3.9+** (pre-configured in this environment).

### 2. Start MySQL in XAMPP
1. Open **XAMPP Control Panel**.
2. Click **Start** next to **MySQL** (and **Apache**).
3. Access phpMyAdmin at: [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
4. *(Optional)* Import `database_setup.sql` in phpMyAdmin, or let the Spring Boot application create tables automatically!

### 3. Open & Run in IntelliJ IDEA (Community or Ultimate)
1. Launch **IntelliJ IDEA**.
2. Click **File -> Open...** and select this project folder:
   `C:\Users\Sakthi\OneDrive\Documents\java fullstack project`
3. IntelliJ will automatically detect the **Maven** project and import all dependencies using the included Maven Wrapper (`mvnw`).
4. **Run the Application**:
   - **Option A (Top Toolbar)**: Click the pre-configured **"Run Code Analyzer"** or **"CodeAnalyzerApplication"** in the top-right toolbar and click the green Play ▶️ button.
   - **Option B (Direct Main class)**: Navigate to `src/main/java/com/codeanalyzer/CodeAnalyzerApplication.java` in the project tree and click the green ▶️ icon next to line `public static void main(String[] args)`.
5. Open your browser at **http://localhost:8080**.

### 4. Alternative: Command Line or Batch Scripts
Double-click `run.bat` or run via PowerShell:

```powershell
.\run.ps1
```

Or using the Maven wrapper:
```powershell
.\mvnw.cmd spring-boot:run
```

### 5. Open in Browser
- **Application UI**: [http://localhost:8080](http://localhost:8080)
- **phpMyAdmin**: [http://localhost/phpmyadmin](http://localhost/phpmyadmin)
- **System Health & DB Status**: [http://localhost:8080/api/system/status](http://localhost:8080/api/system/status)
- **Active Rules Catalog API**: [http://localhost:8080/api/system/rules](http://localhost:8080/api/system/rules)

---

## 📁 Project Structure

```
├── pom.xml                               # Maven project configuration
├── run.bat                               # Windows Command Prompt launcher
├── run.ps1                               # Windows PowerShell launcher
├── database_setup.sql                    # phpMyAdmin database schema & seed data
├── README.md                             # Documentation
└── src/
    └── main/
        ├── java/com/codeanalyzer/
        │   ├── CodeAnalyzerApplication.java   # Spring Boot Main Application
        │   ├── config/                        # CORS & Web configs
        │   ├── controller/                    # REST Controllers (Analysis, History, System)
        │   ├── model/                         # DTOs, QualityGrade, Metrics & JPA Entities
        │   ├── repository/                    # Spring Data JPA Repositories
        │   ├── service/                       # AST Engine, Security & Code Smell Analyzers
        │   └── util/                          # Database connection health check
        └── resources/
            ├── application.properties         # Spring Boot & MySQL configuration
            └── static/                        # Frontend UI (HTML, CSS, JS)
                ├── index.html                 # Single page application
                ├── css/
                │   ├── style.css              # Core layout, tokens & typography
                │   ├── theme.css              # Glassmorphism, buttons & badges
                │   └── components.css         # Code editor, circular gauge & tables
                └── js/
                    ├── app.js                 # App coordinator & MySQL ping
                    ├── editor.js              # Code editor with line numbers & cursor tracking
                    ├── analyzer.js            # API caller & animated report dashboard
                    ├── history.js             # Stored MySQL reviews manager
                    └── samples.js             # Realistic test Java code snippets
```

---

## 📡 REST API Reference

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/analyze` | Analyzes Java code AST, returns metrics, issues, grade, and refactored fix |
| `POST` | `/api/analyze/upload` | Uploads a `.java` source file for review |
| `POST` | `/api/analyze/quick-fix` | Generates refactored Java code with fixes applied |
| `GET` | `/api/history` | Fetches all stored review reports from MySQL |
| `GET` | `/api/history/{id}` | Fetches detailed review report with all detected issues |
| `DELETE`| `/api/history/{id}` | Deletes review record from MySQL |
| `GET` | `/api/history/stats` | Aggregate review metrics (total reviews, avg score, total issues) |
| `GET` | `/api/system/status` | Checks XAMPP MySQL connectivity on port 3306 & DB status |
| `GET` | `/api/system/rules` | Retrieves active AST inspection rules catalog |
