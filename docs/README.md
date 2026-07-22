# XAWAD: Simple XAMPP alternative Web Apps Development Environment Using PHP and MariaDB

Welcome to the *Web Apps Development Environment Using PHP and MariaDB* project! This project is designed to help you learn the fundamentals of web programming (PHP), HTML forms, and database management (MariaDB / SQL).

## Why This Project Setup?

In standard Malaysian SPM / Computer Science curricula, students are typically introduced to web and database development using **XAMPP on Windows**. 

While XAMPP is commonly used on Windows in schools, this project uses **NixOS / Linux** with **`nix` + `devenv`** to deliver a more modern, flexible setup. This provides several key advantages:

* **No Manual Software Installers:** Everything needed (PHP, MariaDB, phpMyAdmin) is defined cleanly in code and kept isolated inside this project directory.
* **No Hidden Background Services:** Stopping the server commands cleanly shuts down MariaDB without leaving behind permanent system background processes.
* **Reproducible Setup:** Anyone cloning this repository gets the exact same versions of PHP and MariaDB, avoiding any *"it works on my machine"* troubleshooting.

## Key Definitions

Before you begin, here are definitions for terms you will see throughout this guide:

- **Repository (Repo)**: A folder where all source code and files for a project are stored and tracked using Git.

- **Clone**: Creating a local copy of a remote Git repository on your own computer.

- **Localhost**: A standard hostname that means "this computer." It allows your computer to run web servers locally without sending requests over the Internet.

- **Port**: An internal software endpoint (like a door number on a building) that directs web traffic to a specific server program (e.g., port 8000 for your web app, port 8001 for phpMyAdmin).

- **Database (DB)**: An organized collection of structured data (like tables with rows and columns) stored electronically.

- **Prepared Statements**: A secure method of executing SQL queries that prevents malicious users from manipulating database commands (preventing SQL Injection).

## Prerequisites

To run this project, your system only needs:

- *Nix Package Manager* (or *NixOS* operating system).
- `direnv` shell extension (with `nix-direnv` integration enabled).
- `git` version control tool.

> **Note:** You do **not** need to install PHP, MariaDB, or `devenv` globally. `direnv` and `nix` will automatically fetch and manage everything within this project folder!

## Getting Started

Follow these steps in order to set up your environment for the first time.

### Step 1: Clone the Repository

Open your terminal and clone the project into your local source directory:

```Bash
mkdir -p ~/src
cd ~/src
git clone https://github.com/mnajib/xawad.git
cd xawad
```

### Step 2: Enable the Environment

When you enter the project directory for the first time, `direnv` will ask for permission to load the Nix development environment.

Run:
```Bash
direnv allow
```

> **Note**: The first time you run this, Nix will download PHP, MariaDB, and other required packages. This may take a few minutes.

### Step 3: Download & Set Up phpMyAdmin (One-Time Setup)

To visually manage your database in a browser, download and extract phpMyAdmin directly into your project root directory.

#### Option A: Direct Download via Web Browser

- Go to the official download page: **[phpmyadmin.net/downloads/](https://www.phpmyadmin.net/downloads/)**

- Download the latest **`phpMyAdmin-x.x.x-all-languages.zip`** package and save it into your `tmp/` folder (or project root).

OR

#### Option B: Download phpMyAdmin zip to `tmp/`

```Bash
cd ~/src/xawad
mkdir -p tmp
curl -o tmp/phpmyadmin.zip https://files.phpmyadmin.net/phpMyAdmin/5.2.3/phpMyAdmin-5.2.3-all-languages.zip
```

### Step 4: Extract the `.zip` file into a folder named `phpmyadmin` in your project root:

Create target directory

```Bash
cd ~/src/xawad
mkdir -p phpmyadmin
```

Extract and strip the top-level directory structure

```Bash
cd ~/src/xawad
unzip -j tmp/phpmyadmin.zip -d phpmyadmin/
```

Next, enable passwordless login for local testing by creating `phpmyadmin/config.inc.php`:

```PHP
<?php
$i = 0;
$i++;

$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = '127.0.0.1';
$cfg['Servers'][$i]['AllowNoPassword'] = true;
```

### Step 5: Import Initial Database Schema for Example App (Car Service Booking System)

#### 5.1 Open Terminal 1 and start MariaDB:

```Bash
devenv up
```

#### 5.2 Open Terminal 2 and start phpMyAdmin:

```Bash
php -S 127.0.0.1:8000 -t phpmyadmin
```

#### 5.3 Open `http://localhost:8000` in your web browser.

Log in with:

```
    Username: root
    Password: (Leave completely blank)
```

Select `car_service_db` on the left sidebar.

Click the SQL tab at the top.

Open `schema.sql` from the app1 root folder `./apps/app1/db/schema.sql`, copy its content, paste it into the SQL text box, and click Go.

## Daily Development Workflow

When you start working on the project, you will use three terminal windows or tabs:

### 1. Start MariaDB (Terminal 1)

```Bash
cd ~/src/xawad
devenv up
```

### 2. Start phpMyAdmin (Terminal 2)

```Bash
cd ~/src/xawad
php -S 127.0.0.1:8000 -t phpmyadmin
```

Access the database interface at: `http://localhost:8000`

### 3. Start App Server (Terminal 3)

```Bash
cd ~/src/xawad
php -S 127.0.0.1:8001 -t apps/app1/public
```

Access the web application at: `http://localhost:8001`

### 4. Start Another App Server (Terminal 4)

Similarly, to start another web apps, for example: apps2

```Bash
cd ~/src/xawad
php -S 127.0.0.1:8002 -t apps/app2/public
```

Access the web application at: `http://localhost:8002`

## Project Directory Overview

```
xawad/
├── apps/
│   ├── app1/
│   │   ├── db/
│   │   │   ├── db/schema.sql       # Initial database table structure & sample data
│   │   │   └── db/db.php           # Database connection helper script
│   │   └── public/                 # Files accessible to web browsers
│   │       ├── index.php           # App dashboard (lists appointments)
│   │       ├── book.php            # HTML booking form
│   │       └── process-book.php    # Form handling and SQL insertion logic
│   └── app2/
│       ├── db/
│       │   ├── db/schema.sql
│       │   └── db/db.php
│       └── public/
│           └── index.php
├── phpmyadmin/                     # Web interface for MariaDB management
│   └── config.inc.php              #
├── devenv.nix                      # Environment definition (Nix configuration)
└── .devenv/                        # Local runtime data & database state (Git ignored)
```

## Stopping the Servers

When you finish working, stop each service by pressing `Ctrl + C` in its respective terminal window.
