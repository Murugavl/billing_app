# Billwise — Offline-First Billing & Invoicing App

An offline-first, professional billing and invoicing Flutter application designed for small businesses, water treatment suppliers, and utility service providers (Billwise).

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
   - Live auto-updating totals, "You Saved ₹X" savings callout, and **Indian Currency Number-to-Words** converter (e.g. `"Eight Thousand Rupees and Three Paise Only"`).
   - Partial & full payment recording with auto-calculated Balance Due and dynamic status updates (`draft`, `sent`, `partially_paid`, `paid`, `overdue`).
4. **Estimate & Quotation Flow**:
   - Sequential quotation auto-numbering (`EST-0001`).
   - Quotation layout highlighting **Taxable Amount** column and Bank Details block for advance payments.
   - **One-Click "Convert to Invoice"**: Automatically carries over customer details and all line items into a pre-filled new invoice form.
5. **Pixel-Perfect PDF Generation, Printing & Sharing**:
   - Configurable PDF templates matching sample invoice/estimate designs (logo, company header, colored table headers, totals, bank details, signature).
   - **Native Sharing**: One-tap share via `share_plus` (`Share.shareXFiles`) to WhatsApp, Email, or Drive.
   - **Local PDF Save & Native Printing**: Integrated with iOS/Android print frameworks.
6. **Dashboard Analytics**:
   - Summary cards displaying **Total Outstanding Balance**, **This Month Sales**, and **Draft Estimates Count**.
   - Recent Documents activity list with tap navigation.
7. **Reports & Accountant CSV Export**:
   - Date range filters (`Today`, `This Week`, `This Month`, `Custom Range`).
   - Sales Summary report, Outstanding Payments report (sorted highest balance due first), and Top Customers report.
   - One-tap **CSV Export** for accountant tax filing.
8. **Global Search Engine**:
   - Search across Customers, Invoices, and Estimates by name, phone, or document number.
9. **Data Safety, Local Backup & Restore**:
   - One-click JSON database export and atomic import restoration (preserves all customers, items, invoices, estimates, and payment history).
   - Auto-backup date tracking and scaffolded Cloud Sync toggle.

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

1. **Update Table Definition**: Edit or add columns in `lib/db/tables/` (e.g. `documents_table.dart`, `customers_table.dart`).
2. **Increment Schema Version**: In `lib/db/app_database.dart`, increment `schemaVersion`:
   ```dart
   @override
   int get schemaVersion => 2; // increment version number
   ```
3. **Run Code Generation**:
   Execute build runner to regenerate `.g.dart` files:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Add Schema Migration** (if required):
   In `lib/db/app_database.dart`, update `migration` strategy inside `AppDatabase`:
   ```dart
   @override
   MigrationStrategy get migration {
     return MigrationStrategy(
       onUpgrade: (m, from, to) async {
         if (from < 2) {
           // Add new columns or tables
           // await m.addColumn(documents, documents.newColumn);
         }
       },
     );
   }
   ```

---

## 🚀 Building & Testing

### 1. Run Static Analysis
```bash
flutter analyze
```

### 2. Run Full Unit Test Suite (33 Tests)
```bash
flutter test
```

### 3. Build Release Android App Bundle / APK
```bash
flutter build appbundle --release
# or
flutter build apk --release
```
