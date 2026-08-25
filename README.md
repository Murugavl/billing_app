# Rasidhu — Offline-First Billing & Invoicing App

An offline-first, professional billing and invoicing Flutter application designed for small businesses, water treatment suppliers, and utility service providers.

---

## 🔐 Developer Setup — Required Secret Files

This project uses several secret files that are **NOT included in version control**. You must obtain or create each one before the project will build.

### 1. `.env`
Copy `.env.example` to `.env` and fill in your values:
```bash
cp .env.example .env
```
| Variable | Description |
|---|---|
| `APP_NAME` | Display name of the app (default: `Rasidhu`) |
| `DB_SECRET_SALT` | Random secret string for database encryption |
| `DEFAULT_BUSINESS_NAME` | Pre-filled business name in profile setup |

### 2. `android/key.properties` (Release Signing)
Copy `android/key.properties.example` to `android/key.properties` and fill in your keystore details:
```bash
cp android/key.properties.example android/key.properties
```
You also need the **keystore file** itself (`android/app/upload-keystore.jks`). This must be obtained from the project owner or generated fresh if starting from scratch.

### 3. `android/app/google-services.json` (Firebase / Google Sign-In)
Obtain this file from your **Firebase Console** → Project Settings → Android app (`com.ponsri.rasidhu`). Place it at `android/app/google-services.json`.

A template showing the expected structure is at `android/app/google-services.json.example`.

> ⚠️ **Git Security**: All three files above are listed in `.gitignore`. Running `git status` should never show them as untracked. If they appear, do NOT stage or commit them.

---

## 🌟 Key Features

1. **Business Profile Management**:
   - Singleton business profile storing Company Name, Address, Phone, Email, PAN, GSTIN, Logo, Signature image, and Bank Details for advance transfers.
2. **Customer & Item Master Catalog**:
   - Searchable customer directory with GSTIN support and document history.
   - Item/Product catalog with HSN/SAC codes, default units (`Pcs`, `Nos`, `Kg`, `Ltr`, `Hrs`, `Box`), price, and tax rates.
   - Delete safety checks preventing deletion of customers/items referenced by existing documents.
3. **Tax Invoice Creation & Edit Flow**:
   - Sequential document auto-numbering (`INV-0001`, `INV-0002`).
   - Inline customer picker with instant `+ New Customer` quick-add.
   - Line items editor supporting catalog picking or custom entry.
   - **Discount Toggle**: Switch between Percentage (`%`) and Flat Amount (`₹`) discount calculation modes.
   - Live auto-updating totals, "You Saved ₹X" savings callout, and **Indian Currency Number-to-Words** converter.
   - Partial & full payment recording with auto-calculated Balance Due and dynamic status updates.
4. **Estimate & Quotation Flow**:
   - Sequential quotation auto-numbering (`EST-0001`).
   - **One-Click "Convert to Invoice"**: Automatically carries over customer details and all line items.
5. **Pixel-Perfect PDF Generation, Printing & Sharing**:
   - Configurable PDF templates with logo, company header, colored table headers, totals, bank details, signature.
   - **Native Sharing**: One-tap share via `share_plus` to WhatsApp, Email, or Drive.
   - **Local PDF Save & Native Printing**: Integrated with iOS/Android print frameworks.
6. **Dashboard Analytics**:
   - Summary cards displaying **Total Outstanding Balance**, **This Month Sales**, and **Draft Estimates Count**.
   - Recent Documents activity list with tap navigation.
7. **Reports & Accountant CSV Export**:
   - Date range filters (`Today`, `This Week`, `This Month`, `Custom Range`).
   - Sales Summary, Outstanding Payments, and Top Customers reports.
   - One-tap **CSV Export** for accountant tax filing.
8. **Global Search Engine**:
   - Search across Customers, Invoices, and Estimates by name, phone, or document number.
9. **Data Safety, Local Backup & Restore**:
   - One-click JSON database export and atomic import restoration.
   - Auto-backup date tracking and AES-256 encrypted Google Drive cloud backup.

---

## 🛠️ Architecture & Tech Stack

- **UI Framework**: Flutter (Material 3 with professional Navy `#1E3A5F` and Slate Dark palette).
- **Architecture**: Clean Architecture (`lib/core`, `lib/db`, `lib/models`, `lib/providers`, `lib/screens`, `lib/services`, `lib/utils`, `lib/widgets`).
- **Database**: Drift / SQLite3 (`drift` & `drift_flutter`) for type-safe offline-first relational storage.
- **State Management**: Riverpod (`flutter_riverpod`).
- **Navigation**: `go_router`.
- **PDF & Printing**: `pdf`, `printing`, `path_provider`, `share_plus`.

---

## 🔄 How to Rebuild the Local Database Schema

If you modify or add database tables/columns in `lib/db/tables/` or DAOs in `lib/db/daos/`:

1. **Update Table Definition**: Edit or add columns in `lib/db/tables/`.
2. **Increment Schema Version**: In `lib/db/app_database.dart`, increment `schemaVersion`.
3. **Run Code Generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Add Schema Migration** (if required):
   In `lib/db/app_database.dart`, update `migration` strategy inside `AppDatabase`.

---

## 🚀 Building & Testing

### 1. Run Static Analysis
```bash
flutter analyze
```

### 2. Build Release Android App Bundle / APK
```bash
flutter build appbundle --release
# or
flutter build apk --release
```

---

## 📐 Layout Guidelines & Text Overflow Rules

1. **Flex Child Protection**: Any `Text` widget placed inside a `Row`, `Flex`, `ListTile`, or horizontal card header **MUST** be wrapped in an `Expanded` or `Flexible` widget.
2. **Explicit Overflow Handling**: Specify `overflow: TextOverflow.ellipsis` and an explicit `maxLines` count for dynamic text fields.
3. **Numeric & Currency Displays**: Currency totals inside tight horizontal spaces should use `FittedBox(fit: BoxFit.scaleDown)` or `Flexible` with ellipsis.
