#  Complete Setup Guide - macOS

<div align="center">

**Install everything you need in one go.**

</div>

---

##  Option 1: Automated (Recommended)

Run the installer script from this folder:

```bash
chmod +x install_mac.sh
bash install_mac.sh
```

This installs **all 4 tools** automatically: PostgreSQL, pgAdmin 4, VS Code, and Git.

> Skip to [Step 5: Verify](#5%EF%B8%8F-verify-everything) after running the script.

---

##  Option 2: Manual Installation

### 1 Install Homebrew (if not installed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2 Install PostgreSQL

```bash
brew install postgresql
brew services start postgresql
```

Verify:

```bash
psql --version
```

### 3 Install pgAdmin 4

```bash
brew install --cask pgadmin4
```

Open **pgAdmin 4** -> Create Server:

| Field        | Value             |
| :----------- | :---------------- |
| **Name**     | PostgreSQL        |
| **Host**     | localhost         |
| **Port**     | 5432              |
| **Username** | postgres          |
| **Password** | _(your password)_ |

### 4 Install VS Code & Git

```bash
brew install --cask visual-studio-code
brew install git
```

Verify:

```bash
code --version
git --version
```

### 5 Verify Everything

Run these commands - all should return version numbers:

```bash
psql --version       # PostgreSQL
git --version        # Git
code --version       # VS Code
```

Open **pgAdmin 4** from Applications and confirm it connects to your PostgreSQL server.

---

##  Troubleshooting

| Problem                      | Solution                                                             |
| :--------------------------- | :------------------------------------------------------------------- |
| `brew: command not found`    | Install Homebrew (Step 1 above)                                      |
| `psql: command not found`    | Restart Terminal. If still missing, run: `brew link postgresql`      |
| PostgreSQL won't start       | `brew services restart postgresql`                                   |
| pgAdmin "Connection refused" | Ensure PostgreSQL is running: `brew services list`                   |
| `code: command not found`    | Open VS Code -> Cmd+Shift+P -> "Shell Command: Install 'code' command" |

>  **Tip:** Always restart Terminal after installation so PATH changes take effect.
