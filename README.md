# Department Attendance Management System (College ERP)

A production-grade, full-stack Attendance Management System engineered for college academic departments. Built with **React 18**, **Vite**, **Tailwind CSS**, **Python FastAPI**, **SQLAlchemy ORM**, **PostgreSQL**, **Alembic migrations**, and **WebSockets** for real-time dashboard updates.

---

## 🌟 Key Features

### 1. Three Dedicated Roles & Permissions
- **Administrator (HOD / Academic Dean)**:
  - Centralized department analytics, KPIs, and subject-wise attendance distribution charts.
  - Student and Faculty directory management (Add, edit, deactivate, assign sections).
  - Curriculum configuration (Academic years, semesters, sections, subjects, faculty mapping).
  - Configurable minimum attendance threshold (default: 75%) and dynamic QR code expiry.
  - Immutable audit logs capturing every attendance correction, login, and policy change.
- **Faculty**:
  - Assigned courses and section rosters.
  - Start attendance sessions with lecture topics, time slots, and period numbers.
  - One-click **"Mark All Present"** and individual **Present / Absent / On Duty** marking.
  - **Dynamic QR Code Generation** with real-time countdown timer (e.g., 180s) and live check-in counters.
  - Session history and authorized attendance corrections requiring a **mandatory justification reason**.
  - Defaulter tracking (<75%) showing exact classes needed for student recovery.
- **Student**:
  - Personal dashboard displaying overall percentage, subject-by-subject breakdown, and counts.
  - Shortage recovery predictor (**"You must attend next $X$ consecutive classes to reach 75%"**).
  - Low-attendance alert banners and notifications.
  - Interactive monthly attendance calendar.
  - Date-wise lecture history with filter by subject and date range.
  - Real-time QR check-in by submitting live session tokens.
  - Strict read-only integrity — students cannot modify attendance records.

### 2. Real-Time WebSockets
- WebSocket hub (`/ws`) authenticated with JWT tokens.
- Automatic dashboard refreshing when faculty submits attendance (no manual page reload required).
- Live session activity broadcasts and real-time student QR check-in stream.
- Automatic client reconnection with heartbeat ping/pong.

### 3. Reports & Analytics
- **Excel (.xlsx) Export**: Formatted spreadsheets built with Pandas & OpenPyXL containing student rosters, tallies, percentages, and defaulter flags.
- **PDF Attendance Transcripts**: Formal institutional transcripts compiled with ReportLab featuring college letterhead, subject summaries, and standing declaration.
- Real database records queried directly from PostgreSQL.

---

## 🛠️ Technology Stack

| Component | Technology |
|---|---|
| **Frontend Framework** | React 18, Vite |
| **Styling & Icons** | Tailwind CSS v4, Lucide React |
| **Routing & State** | React Router v6, React Context API |
| **Data Visualization** | Recharts (Bar Charts, Pie Charts) |
| **HTTP Client** | Axios (JWT Interceptor, 401 Redirects) |
| **Backend API** | Python 3.10+ / FastAPI |
| **ORM & Database** | SQLAlchemy 2.0, PostgreSQL (SQLite local auto-fallback) |
| **Database Migrations**| Alembic |
| **Real-Time Protocol** | Native WebSockets |
| **Security & Auth** | JWT (PyJWT), bcrypt password hashing, SlowAPI rate limiting |
| **Document Generation**| Pandas, OpenPyXL (Excel), ReportLab (PDF), QRCode (PIL) |
| **Test Automation** | Pytest, FastAPI TestClient |

---

## 🚀 Quick Start Guide

### Prerequisites
- Python 3.10 or higher
- Node.js 18+ and npm
- PostgreSQL (Optional: if PostgreSQL is not running locally, the system automatically uses the bundled local SQLite database so you can test immediately!)

---

### Step 1: Clone and Setup Backend

```bash
# Navigate to backend directory
cd department-attendance/backend

# Create and activate virtual environment (optional but recommended)
python -m venv venv
# On Windows:
venv\Scripts\activate
# On Linux/macOS:
source venv/bin/activate

# Install backend dependencies
pip install -r requirements.txt

# Copy environment file
cp .env.example .env
```

#### Database Configuration
In `.env`:
```ini
DATABASE_URL=postgresql+psycopg2://postgres:postgres@localhost:5432/attendance_db
ENABLE_SQLITE_FALLBACK=True
```
*Note: If PostgreSQL is unreachable, the system will seamlessly log a warning and fall back to `attendance.db`.*

#### Run Database Migrations & Seed Baseline Data
```bash
# Apply Alembic migrations
python -m alembic upgrade head

# Seed realistic college ERP cohort (Admin, Faculty, Students, Subjects, Sessions)
python seeds/seed_data.py
```

#### Start FastAPI Backend Server
```bash
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```
API Documentation will be live at: **http://127.0.0.1:8000/api/v1/docs**

---

### Step 2: Setup and Start Frontend

In a separate terminal window:
```bash
# Navigate to frontend directory
cd department-attendance/frontend

# Install frontend dependencies
npm install

# Start Vite development server
npm run dev
```
The React ERP Portal will be live at: **http://localhost:5173**

---

## 🔑 Pre-Seeded Demo Accounts

The database comes pre-populated with active accounts for testing all three roles:

| Role | Username / Identifier | Password | Name / Description |
|---|---|---|---|
| **Administrator** | `admin` | `Admin@123` | Dr. Sarah Jenkins (HOD & Admin) |
| **Faculty** | `faculty` | `Faculty@123` | Prof. Rajesh Sharma (Associate Professor) |
| **Faculty (2)** | `prof.anita` | `Faculty@123` | Dr. Anita Verma (Assistant Professor) |
| **Student** | `student` | `Student@123` | Aarav Patel (Roll: 23CSE001) |
| **Student (Defaulter)**| `23cse005` | `Student@123` | Vikram Singh (Roll: 23CSE005, 60% Attendance) |

*The login page includes convenient **One-Click Demo Login** buttons to switch between Admin, Faculty, and Student instantly.*

---

## 🧪 Running Automated Tests

Run the complete test suite verifying authentication, session creation, duplicate prevention, attendance formulas, report generation, and RBAC:

```bash
cd department-attendance/backend
python -m pytest tests -v
```

Test coverage includes:
- `test_auth.py`: Authentication, JWT generation, invalid credentials, RBAC enforcement.
- `test_attendance.py`: Session start, roster loading, batch attendance submission, duplicate record prevention, dynamic QR generation, authorized corrections with audit reason.
- `test_calculations.py`: Percentage calculation formula, approved On-Duty treatment, zero-conducted div-by-zero protection, shortage recovery classes needed formula.
- `test_reports.py`: Excel spreadsheet export generation (`.xlsx`), student transcript PDF generation, defaulter list filtering.

---

## 📂 Project Structure

```
department-attendance/
├── backend/
│   ├── app/
│   │   ├── api/v1/             # REST Endpoints (auth, admin, faculty, student, attendance, reports)
│   │   ├── core/               # App configuration, security (bcrypt, JWT), dependencies
│   │   ├── database/           # SQLAlchemy Base and SessionLocal engine
│   │   ├── models/             # 15 Normalized SQLAlchemy models (User, Student, Faculty, Sessions, etc.)
│   │   ├── schemas/            # Pydantic v2 schemas and validation models
│   │   ├── services/           # Business logic: attendance calculations, shortage predictor, reports
│   │   ├── utils/              # Dynamic QR generator (PIL), token helpers
│   │   ├── websocket/          # ConnectionManager and real-time WebSocket endpoints
│   │   └── main.py             # FastAPI entry point, CORS, RateLimiter, Lifespan
│   ├── migrations/             # Alembic migration scripts
│   ├── seeds/                  # Baseline seed script with realistic college cohort
│   ├── tests/                  # Pytest automated test suite
│   ├── alembic.ini             # Alembic configuration
│   └── requirements.txt        # Backend dependencies
├── frontend/
│   ├── src/
│   │   ├── components/         # StatCard, Badge, Modal, Navbar, Sidebar
│   │   ├── context/            # AuthContext, ThemeContext (Dark/Light), WebSocketContext
│   │   ├── layouts/            # DashboardLayout with real-time toast alerts
│   │   ├── pages/
│   │   │   ├── admin/          # AdminDashboard, StudentsManagement, FacultyManagement, AcademicConfig, AuditLogs, SettingsPage
│   │   │   ├── faculty/        # FacultyDashboard, TakeAttendance, SessionHistory, DefaultersView
│   │   │   ├── student/        # StudentDashboard, StudentCalendar, StudentHistory, StudentQRScanner
│   │   │   ├── Login.jsx       # Login portal with one-click demo credentials
│   │   │   └── ReportsPage.jsx # Excel & PDF report generation interface
│   │   ├── services/           # Axios API client with auth interceptors
│   │   └── App.jsx             # React Router v6 protected role routes
│   ├── package.json
│   ├── tailwind.config.js
│   └── vite.config.js
├── docs/
│   ├── ARCHITECTURE.md         # System design, relational schema, calculation formulas
│   └── API_DOCUMENTATION.md    # Complete REST and WebSocket endpoint reference
├── .env.example                # Example environment variables
└── README.md                   # Project documentation
```

---

## 🛡️ Production Deployment Guide

### 1. PostgreSQL Production Database Setup
```sql
CREATE DATABASE attendance_db;
CREATE USER college_admin WITH ENCRYPTED PASSWORD 'StrongProductionPassword';
GRANT ALL PRIVILEGES ON DATABASE attendance_db TO college_admin;
```

Update `.env`:
```ini
DATABASE_URL=postgresql+psycopg2://college_admin:StrongProductionPassword@localhost:5432/attendance_db
ENABLE_SQLITE_FALLBACK=False
SECRET_KEY=<generate_with_openssl_rand_hex_32>
```

### 2. Run Migrations
```bash
python -m alembic upgrade head
```

### 3. Production Service Execution
- **Backend**: Run using Gunicorn with Uvicorn worker:
  ```bash
  gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:8000
  ```
- **Frontend**: Build optimized static assets and serve via Nginx:
  ```bash
  cd frontend && npm run build
  ```

---

## 👨‍💻 Author & Developer
Developed with excellence by **SSS** (Shivatej S Sankapal).

---

## 📄 License
This Department Attendance Management System is licensed under the MIT License.
