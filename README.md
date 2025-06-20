# WTMS Flutter App

A Worker Task Management System (WTMS) mobile app built with Flutter.

## Features

- **Task List:** View assigned tasks and submit work.
- **Submission History:** See your previous submissions and edit them.
- **Profile:** View and update your worker profile (except username).
- **Modern Navigation:** BottomNavigationBar and Drawer for easy access to all pages.

---

## Related Repositories

- **Backend (PHP API):** [wtms_phpBackend](https://github.com/wanjinnnn/wtms_phpBackend.git)
- **Database (MySQL):** [wtms_mysql](https://github.com/wanjinnnn/wtms_mysql.git)

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [PHP Backend for WTMS](https://github.com/wanjinnnn/wtms_phpBackend.git)
- [MySQL Database](https://github.com/wanjinnnn/wtms_mysql.git)

### Installation

1. **Clone this repository:**
    ```sh
    git clone https://github.com/wanjinnnn/wtms_flutterApp.git
    cd wtms_flutterApp/wtms
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Configure backend API endpoints:**
    - Update the API URLs in the Dart files (e.g. `http://<your-server-ip>/wtms/`) to match your backend server address.

4. **Run the app:**
    ```sh
    flutter run
    ```

### Backend & Database Setup

- **Backend:**  
  See [wtms_phpBackend](https://github.com/wanjinnnn/wtms_phpBackend.git) for PHP API setup instructions.
- **Database:**  
  See [wtms_mysql](https://github.com/wanjinnnn/wtms_mysql.git) for MySQL scripts and setup.

---

## Usage

- **Login** with your worker credentials.
- **Navigate** using the bottom bar or drawer to Tasks, History, or Profile.
- **Submit work** for tasks, view and edit your submission history, and update your profile as needed.

---

## License

This project is for academic purposes.  
Feel free to use and modify for learning or demonstration.

---
