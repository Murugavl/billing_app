# Google Play Console — Data Safety Form Submission Guide

This document contains the exact answers required for the **Data Safety** questionnaire in Google Play Console for **Billwise**.

---

## Section 1: Overview Questions

1. **Does your app collect or share any of the required user data types?**
   - **Answer**: **Yes** (Email address for optional cloud backup authentication, business/financial records entered by user).

2. **Is all of the user data collected by your app encrypted in transit?**
   - **Answer**: **Yes** (All network communication with Google Sign-In and Google Drive API uses HTTPS / TLS 1.2+).

3. **Do you provide a way for users to request that their data be deleted?**
   - **Answer**: **Yes** (Users can delete local records in-app, clear app storage, or delete encrypted cloud backups directly from Google Drive).

---

## Section 2: Data Types & Usage Breakdown

### A. Personal Info → Email Address
- **Collected?**: Yes (Optional — collected only when user signs into Google Drive for backup).
- **Shared?**: No (Never shared with third parties).
- **Processed Ephemerally?**: No (Stored locally in app preferences to maintain backup state).
- **Required or Optional?**: **Optional** (User can choose to use app 100% offline without signing in).
- **Purposes**: **Account Management** & **App Functionality** (Identifying cloud backup owner).

### B. Financial Info → Financial & Invoice Records
- **Collected?**: Yes (Invoices, Estimates, Purchase Bills, Payments entered by the user).
- **Shared?**: No (Never shared with third parties).
- **Storage Location**: Stored 100% locally on device SQLite DB, and client-side AES-256 encrypted in user's private Google Drive `appDataFolder`.
- **Required or Optional?**: **Required for core functionality** (Invoicing app).
- **Purposes**: **App Functionality** (Creating invoices, calculating GST, tracking purchases).

### C. Contacts → Customer & Supplier Information
- **Collected?**: Yes (Names, phone numbers, addresses entered by the user).
- **Shared?**: No.
- **Purposes**: **App Functionality** (Managing customer & supplier directory).

---

## Section 3: Security Practices

- **Encryption in Transit**: Yes (HTTPS / TLS).
- **Encryption at Rest**: Yes (Client-side AES-256-CBC for cloud backups).
- **Data Deletion Mechanism**: Yes (Users can erase data in-app or delete backups via Google Account permissions).
