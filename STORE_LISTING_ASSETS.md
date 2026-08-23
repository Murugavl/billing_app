# Google Play Store Listing Assets & Text Copy

This document contains the ready-to-use store metadata, text descriptions, and graphics specification checklist for **Billwise**.

---

## 1. Store Text Content

### App Name / Title (Max 30 characters)
`Billwise - Billing & Invoices`

### Short Description (Max 80 characters)
`Fast offline GST billing, invoice maker, purchase tracker & encrypted backup.`

### Full Description (Max 4,000 characters)
```text
Billwise is an offline-first, professional billing, GST invoicing, and purchase tracking app designed specifically for small businesses, wholesalers, retail shops, and freelancers.

Create professional tax invoices and estimates in seconds, share crisp PDFs over WhatsApp, manage customer and supplier ledgers, and track net profit margins — all without needing an active internet connection.

KEY FEATURES:

• Professional GST Invoices & Estimates
Generate polished Tax Invoices and Quotations with automatic GST calculations (CGST, SGST, IGST), custom terms, payment status, and bank transfer details.

• Instant WhatsApp & PDF Export
Preview and share clean, formatted PDF invoices directly via WhatsApp, Email, or Print. Supports custom business logos and authorized signatures.

• Complete Purchase Tracking & Net Margin Reports
Track incoming supplier bills alongside sales invoices. Automatically tally total purchases against sales to view your true Net Profit Margin and supplier balances.

• Customer & Supplier Directories
Maintain complete customer and supplier ledgers, phone contacts, addresses, and GSTINs. Search and filter instantly.

• End-to-End Encrypted Cloud Backup
Protect your business data with WhatsApp-style automatic Google Drive backups. All backups are encrypted client-side using AES-256 before upload into your private Google Drive appDataFolder — keeping your financial records 100% private to you.

• 100% Offline & Private
Your business records stay on your device. Billwise works flawlessly offline without registration delays or mandatory subscriptions.

Simplify your business billing today with Billwise!
```

---

## 2. Store Listing Graphics Checklist

| Asset Type | Specifications | Status / File Location |
| :--- | :--- | :--- |
| **App Icon** | 512 × 512 px, PNG (32-bit), Max 1024 KB | `assets/images/app_logo.png` (Regenerated for launcher) |
| **Feature Graphic** | 1024 × 500 px, PNG or JPEG, Max 15 MB | `assets/images/billwise_wordmark.png` |
| **Phone Screenshots** | Min 2 screenshots (Max 8), 16:9 or 9:16, 1080×1920 px | Generated during UI test runs |

---

## 3. Keystore & Production Build Metadata

- **Package Identifier**: `com.ponsri.billwise`
- **Version Code**: `1`
- **Version Name**: `1.0.0`
- **Signed AAB Output**: `build/app/outputs/bundle/release/app-release.aab`
- **Keystore Location**: `android/app/upload-keystore.jks`
- **Keystore Config**: `android/key.properties` *(Excluded from Git for safety)*
