// Service for picking a contact from the device's native contact picker.
//
// Keeps all flutter_contacts / permission_handler logic out of the UI layer.
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

/// Lightweight result returned after the user selects a contact.
class PickedContact {
  const PickedContact({
    required this.name,
    required this.phones,
  });

  /// Display name of the selected contact.
  final String name;

  /// All phone numbers attached to the contact (normalised, non-empty).
  final List<String> phones;
}

/// Wraps [FlutterContacts] + [permission_handler] so the UI only deals with
/// [PickedContact].
class ContactPickerService {
  /// Returns `true` if [READ_CONTACTS] is already granted — **without**
  /// triggering the OS permission dialog.
  ///
  /// Used by the UI to decide whether to skip the rationale dialog (already
  /// have permission → go straight to picker) or to show it first.
  Future<bool> hasPermission() async {
    final status = await Permission.contacts.status;
    return status.isGranted;
  }

  /// Opens the Android permission dialog for [READ_CONTACTS].
  ///
  /// Returns `true` if the user grants the permission.
  Future<bool> requestPermission() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }

  /// Opens the native contact picker and returns the selected contact,
  /// or `null` if the user cancelled or reading failed.
  ///
  /// Requires [READ_CONTACTS] to already be granted before calling.
  Future<PickedContact?> pickContact() async {
    // openExternalPick launches the device's own Contacts picker UI.
    // The user picks a contact; we receive a Contact with an id, then
    // fetch full details (phones) separately.
    final contact = await FlutterContacts.openExternalPick();
    if (contact == null) return null;

    final full = await FlutterContacts.getContact(
      contact.id,
      withProperties: true,
    );
    if (full == null) return null;

    final name = full.displayName.trim();
    final phones = full.phones
        .map((p) => p.number.trim())
        .where((n) => n.isNotEmpty)
        .toList();

    return PickedContact(name: name, phones: phones);
  }
}
