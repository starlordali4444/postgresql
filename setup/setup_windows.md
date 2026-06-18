#  Complete Setup Guide - Windows

<div align="center">

**Install everything you need in one go.**

</div>

---

## 1 Install PostgreSQL & pgAdmin 4

### Download

 Visit: [EnterpriseDB - PostgreSQL Downloads](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)

Download the **latest version** for Windows (64-bit).

### Install

Select **all** components during installation:

-  PostgreSQL Server
-  pgAdmin 4
-  Command Line Tools

Keep the defaults:

| Setting      | Value                    |
| :----------- | :----------------------- |
| **Port**     | `5432`                   |
| **Username** | `postgres`               |
| **Password** | _(choose and remember!)_ |

### Verify

Open **Command Prompt** and type:

```bash
psql -U postgres
```

If you see `postgres=#` you're connected . Type `\q` to exit.

>  If `psql is not recognized`, add PostgreSQL to your PATH:
> `C:\Program Files\PostgreSQL\<version>\bin` -> add to System Environment Variables -> PATH

---

## 2 Install VS Code

### Download

 Visit: [code.visualstudio.com](https://code.visualstudio.com/)

Download the **latest version** for Windows.

### Install

-  Check **"Add to PATH"** during installation
-  Check **"Register Code as editor for supported file types"**

### Verify

Open Command Prompt:

```bash
code --version
```

### Recommended Extensions

Open VS Code -> Extensions (Ctrl+Shift+X) -> Install:

- **SQLTools** - SQL query runner
- **SQLTools PostgreSQL** - PostgreSQL driver

---

## 3 Install Git Bash

### Download

 Visit: [git-scm.com/download/win](https://git-scm.com/download/win)

Download the **latest version**.

### Install

Keep all defaults. Important options:

-  **Use Git from the Windows Command Prompt** (adds to PATH)
-  **Use VS Code as Git's default editor**

### Verify

Open Command Prompt:

```bash
git --version
```

---

## 4 Verify Everything

Open **Command Prompt** and run all three:

```bash
psql --version       # PostgreSQL
code --version       # VS Code
git --version        # Git
```

All should return version numbers. Open **pgAdmin 4** from Start Menu and verify it connects.

---

##  Troubleshooting

| Problem                    | Solution                                                                                         |
| :------------------------- | :----------------------------------------------------------------------------------------------- |
| `psql is not recognized`   | Add `C:\Program Files\PostgreSQL\<version>\bin` to PATH, or reinstall with "Add to PATH" checked |
| Forgot postgres password   | Open pgAdmin 4 -> right-click Server -> Properties -> change password                               |
| PostgreSQL service stopped | Open **Services.msc** -> find _postgresql_ -> right-click -> **Start**                              |
| `code is not recognized`   | Reinstall VS Code with "Add to PATH" checked                                                     |
| `git is not recognized`    | Reinstall Git with "Use Git from Windows Command Prompt" checked                                 |
| pgAdmin connection error   | Ensure PostgreSQL service is running. Use `localhost` and port `5432`                            |

>  **Tip:** Reboot your PC after installation if any command isn't recognized.
