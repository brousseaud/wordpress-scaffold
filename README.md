# 📝 WordPress Scaffold Installer

This project provides a clean, automated way to install WordPress via SSH using WP-CLI — with plugin configurations pulled from a YAML file in your private GitHub repo.

---

## 📦 What It Does

✅ Downloads WordPress core into the **parent directory of this scaffold**  
✅ Creates the `wp-config.php` file with your database info  
✅ Installs WordPress with the site details you enter  
✅ Installs and activates plugins listed in your `configs/site-plugins.yaml` file  
✅ Leaves your scaffold directory clean for configs and scripts only  
✅ Uses the default WordPress theme  

---

## 📂 Directory Structure

/your-webspace/
├── wordpress-scaffold/
│ ├── configs/
│ │ └── site-plugins.yaml
│ └── install-wordpress.sh
├── wp-content/
├── wp-config.php
├── wp-admin/
├── ...

---

## 📋 Prerequisites

- **SSH access** to your hosting or server  
- **A MySQL database created and ready** (note down DB name, user, and password)  
- **PHP CLI installed** (commonly available on most hosting environments)  
- **Git installed**  
- **WP-CLI** will be downloaded automatically by the install script  

---

## 🚀 How to Use

### 1️⃣ SSH into Your Hosting or Server

```bash
ssh your-username@your-hostname
```

### 2️⃣ Clone Your Scaffold Repository

```bash
git clone https://github.com/yourusername/yourrepo.git
cd yourrepo
```

3️⃣ Make the Script Executable

```bash
chmod +x install-wordpress.sh
```

4️⃣ Run the Installer

```bash
./install-wordpress.sh
```

5️⃣ Follow the Prompts

It will then install WordPress and your plugins.

