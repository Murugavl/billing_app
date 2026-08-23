# Privacy Policy for Billwise

**Last Updated: August 23, 2026**

**Billwise** ("we", "our", or "us") respects your privacy. This Privacy Policy explains how our application collects, uses, stores, and protects your information when you use the Billwise mobile application.

---

## 1. Information We Collect

### A. Personal Information via Google Sign-In
When you enable cloud backups, Billwise requests sign-in through Google Authentication. We collect and process:
- Your Google Account Email Address
- Display Name and Profile Picture URL

*We request ONLY the minimal scope (`https://www.googleapis.com/auth/drive.appdata`) needed to store encrypted database backups in your private Google Drive appData directory.*

### B. Business & Financial Data
To provide billing, invoicing, and inventory tracking, Billwise stores data entered directly by you:
- Business Profile (Business Name, Address, Phone, Email, GSTIN, Bank Details, Logo)
- Customer Directory & Supplier Directory (Names, Phones, Addresses, GSTINs)
- Catalogue Items & Services (Names, HSN/SAC codes, Prices, Tax rates)
- Documents & Financial Transactions (Invoices, Estimates, Purchase Bills, Payment Records)

---

## 2. How Data is Stored & Encrypted

### A. Local Storage (Device-First)
All your business profiles, customers, items, invoices, and purchase records are stored **locally on your device** inside a private SQLite database.

### B. Encrypted Cloud Backup (Google Drive)
If you turn on Google Drive Cloud Backup:
- Data is exported and encrypted **client-side** using **AES-256-CBC encryption**.
- The encrypted backup file (`billwise_backup.enc`) is uploaded strictly to your personal Google Drive **`appDataFolder`**.
- The `appDataFolder` is a hidden, app-private directory. **Neither Google, Billwise developers, nor any third party can access or read your unencrypted data.**

---

## 3. Data Sharing & Third-Party Services

- **Zero Data Selling or Monitization**: We do not sell, rent, or trade your personal or financial data to any advertisers, data brokers, or third parties.
- **Zero External Analytics or Tracking**: We do not include third-party advertising SDKs or tracking scripts.
- **Google Services**: Google Sign-In and Google Drive APIs are used solely for account authentication and encrypted cloud backups at your explicit request.

---

## 4. User Rights & Data Deletion

You retain 100% ownership and control over all your data:

1. **Delete Local App Data**: You can delete any customer, item, invoice, or supplier inside the app, or uninstall the app to erase local database files.
2. **Delete Cloud Backups**:
   - You can sign out of Google Drive inside the app settings at any time.
   - You can delete your backup from your Google Account by navigating to [Google Account Security → Third-party apps with account access](https://myaccount.google.com/permissions) and removing Billwise access.

---

## 5. Contact Us

If you have any questions regarding this Privacy Policy or your data privacy in Billwise, please contact us at:

**Ponsri Enterprises**  
Email: `support@ponsri.com`  
Website: `https://ponsri.com`
