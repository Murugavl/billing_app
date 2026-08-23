// Form field validators for the billing app
// All validators return null for valid input, error string for invalid.

abstract final class Validators {
  // ── Required ──────────────────────────────────────────────────────────────

  static String? required(String? v, {String label = 'This field'}) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  // ── Phone ─────────────────────────────────────────────────────────────────

  /// Accepts 10-digit Indian mobile numbers, optionally prefixed with +91.
  static String? phone(String? v, {bool required = true}) {
    if (v == null || v.trim().isEmpty) {
      return required ? 'Phone number is required' : null;
    }
    final digits = v.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    final core = digits.startsWith('91') && digits.length == 12
        ? digits.substring(2)
        : digits;
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(core)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  // ── Email ─────────────────────────────────────────────────────────────────

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // ── GST ───────────────────────────────────────────────────────────────────

  /// Indian GST number — 15 chars: 22AAAAA0000A1Z5
  static String? gst(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final clean = v.trim().toUpperCase();
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(clean)) {
      return 'Enter a valid 15-character GSTIN (e.g. 33AABCP1234A1Z5)';
    }
    return null;
  }

  // ── PAN ───────────────────────────────────────────────────────────────────

  /// Indian PAN — 10 chars: AAAAA0000A
  static String? pan(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final clean = v.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(clean)) {
      return 'Enter a valid 10-character PAN (e.g. AABCP1234A)';
    }
    return null;
  }

  // ── IFSC ──────────────────────────────────────────────────────────────────

  /// Indian bank IFSC — 11 chars: SBIN0001234
  static String? ifsc(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final clean = v.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(clean)) {
      return 'Enter a valid 11-character IFSC code (e.g. SBIN0001234)';
    }
    return null;
  }

  // ── Bank account ──────────────────────────────────────────────────────────

  static String? bankAccount(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final clean = v.trim().replaceAll(' ', '');
    if (!RegExp(r'^[0-9]{9,18}$').hasMatch(clean)) {
      return 'Enter a valid account number (9–18 digits)';
    }
    return null;
  }

  // ── Compose helpers ───────────────────────────────────────────────────────

  /// Chains multiple validators — returns the first error found.
  static String? Function(String?) chain(
      List<String? Function(String?)> validators) {
    return (v) {
      for (final fn in validators) {
        final err = fn(v);
        if (err != null) return err;
      }
      return null;
    };
  }
}
