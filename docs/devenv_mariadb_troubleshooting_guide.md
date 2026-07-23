# DEVENV MARIADB INITIALIZATION & TROUBLESHOOTING GUIDE

## 1. OVERVIEW & CAUSE

When setting up MariaDB and initial databases/users in `devenv.nix`, several issues
can prevent database initialization or cause crash loops:

- Existing Database State: `devenv` skips running `initialDatabases` and
  `ensureUsers` if `.devenv/state/mysql` already exists.
- Unbound Variable Error: Running `ensureUsers` in strict bash mode (`set -u`)
  without explicit `password` entries (e.g. for `root`) causes script crashes
  (`line 34: password: unbound variable`).
- Port Collisions & Lock Files: Lingering `mariadbd` processes keep port 3306 or
  socket files occupied, causing MariaDB to fall back to port 3307 and crash
  with `ERROR 1006 (HY000)` / `errno: 2 "No such file or directory"`.

## 2. KEY TERMINOLOGY DEFINITIONS

- Post-Ready Task (`devenv:mysql:configure`): A downstream hook executed by
  `devenv` after the MariaDB daemon passes its socket/port health probe.
- Unbound Variable Error: A bash execution failure (`set -u`) triggered when a
  variable is referenced without being explicitly assigned or defined.
- `ERROR 1006 (HY000)` / `errno: 2`: A MariaDB engine error indicating that the
  server cannot locate or write to the expected data directory structure on
  disk, often due to an aborted process or socket disconnect mid-query.
- Restart Rate Limit: A process manager protection mechanism that halts repeated
  service restarts after a threshold of rapid failures.


## 3. STEP-BY-STEP FIX

### Step 1: Fix `devenv.nix` Configuration

Ensure `ensureUsers` explicitly defines the `password` attribute for all users
(or remove `root` if relying on default passwordless root access):

```nix
  services.mysql = {
    enable = true;
    package = pkgs.mariadb_114;

    initialDatabases = [
      {
        name = "car_service_db";
        schema = ./apps/app1/db/scheme.sql;
      }
    ];

    ensureUsers = [
      {
        name = "root";
        password = "";  # Prevents 'password: unbound variable' error
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "app_user";
        password = "app_password";
        ensurePermissions = {
          "car_service_db.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };
```

### Step 2: Terminate Active Processes

Press `Ctrl + C` in the running terminal tab to stop `devenv up`.

### Step 3: Kill Lingering MariaDB Daemons

Force kill any orphan `mariadbd` processes occupying port 3306 or holding locks:

```term
  pkill -9 -f mariadbd
```

### Step 4: Wipe Corrupted State Directory

Remove the local state folder to force a clean first-boot initialization:

```term
  rm -rf .devenv
```

### Step 5: Re-launch devenv with All Tasks

Start `devenv` with the `--mode all` flag to ensure all post-ready setup tasks run:

```term
  devenv up --mode all
```

