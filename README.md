# 👁️ eyeseeyou

A lightweight bash-based reconnaissance tool for ethical hacking, penetration testing, and bug bounty hunting. It automates basic recon tasks like DNS lookup, WHOIS, and can be extended with tools like `waybackurls`.

---

## ✨ Features

- 🔎 DNS and WHOIS information gathering
- 📁 Automatic directory and log creation per target
- 📜 Real-time terminal output and saved logs
- 📥 Easily extendable with tools like `waybackurls`, `httpx`, etc.

---

## 🧰 Requirements

Before running `eyeseeyou`, ensure the following are installed:

- `bash`
- `nslookup`
- `whois`
- `tee`

### 🔧 Optional Tools (recommended for extended recon)

Install [Go](https://golang.org/doc/install) to use the following Go-based tools:

#### 📦 waybackurls (for historical URL discovery)
```bash
go install github.com/tomnomnom/waybackurls@latest
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
