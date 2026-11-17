@echo off
echo ========================================================
echo  Department Attendance Management System - Pytest Suite
echo ========================================================
cd /d "%~dp0\department-attendance\backend"
python -m pytest tests -v
pause
