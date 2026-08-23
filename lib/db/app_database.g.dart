// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusinessProfileTable extends BusinessProfile
    with TableInfo<$BusinessProfileTable, BusinessProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _businessNameMeta =
      const VerificationMeta('businessName');
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
      'business_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _addressLineMeta =
      const VerificationMeta('addressLine');
  @override
  late final GeneratedColumn<String> addressLine = GeneratedColumn<String>(
      'address_line', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _panNumberMeta =
      const VerificationMeta('panNumber');
  @override
  late final GeneratedColumn<String> panNumber = GeneratedColumn<String>(
      'pan_number', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _gstNumberMeta =
      const VerificationMeta('gstNumber');
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
      'gst_number', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _logoPathMeta =
      const VerificationMeta('logoPath');
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
      'logo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _signaturePathMeta =
      const VerificationMeta('signaturePath');
  @override
  late final GeneratedColumn<String> signaturePath = GeneratedColumn<String>(
      'signature_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bankNameMeta =
      const VerificationMeta('bankName');
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
      'bank_name', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bankAccountNoMeta =
      const VerificationMeta('bankAccountNo');
  @override
  late final GeneratedColumn<String> bankAccountNo = GeneratedColumn<String>(
      'bank_account_no', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bankIfscMeta =
      const VerificationMeta('bankIfsc');
  @override
  late final GeneratedColumn<String> bankIfsc = GeneratedColumn<String>(
      'bank_ifsc', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 11),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _bankBranchAddressMeta =
      const VerificationMeta('bankBranchAddress');
  @override
  late final GeneratedColumn<String> bankBranchAddress =
      GeneratedColumn<String>('bank_branch_address', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessName,
        addressLine,
        phone,
        email,
        panNumber,
        gstNumber,
        logoPath,
        signaturePath,
        bankName,
        bankAccountNo,
        bankIfsc,
        bankBranchAddress,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profile';
  @override
  VerificationContext validateIntegrity(
      Insertable<BusinessProfileData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
          _businessNameMeta,
          businessName.isAcceptableOrUnknown(
              data['business_name']!, _businessNameMeta));
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('address_line')) {
      context.handle(
          _addressLineMeta,
          addressLine.isAcceptableOrUnknown(
              data['address_line']!, _addressLineMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('pan_number')) {
      context.handle(_panNumberMeta,
          panNumber.isAcceptableOrUnknown(data['pan_number']!, _panNumberMeta));
    }
    if (data.containsKey('gst_number')) {
      context.handle(_gstNumberMeta,
          gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta));
    }
    if (data.containsKey('logo_path')) {
      context.handle(_logoPathMeta,
          logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta));
    }
    if (data.containsKey('signature_path')) {
      context.handle(
          _signaturePathMeta,
          signaturePath.isAcceptableOrUnknown(
              data['signature_path']!, _signaturePathMeta));
    }
    if (data.containsKey('bank_name')) {
      context.handle(_bankNameMeta,
          bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta));
    }
    if (data.containsKey('bank_account_no')) {
      context.handle(
          _bankAccountNoMeta,
          bankAccountNo.isAcceptableOrUnknown(
              data['bank_account_no']!, _bankAccountNoMeta));
    }
    if (data.containsKey('bank_ifsc')) {
      context.handle(_bankIfscMeta,
          bankIfsc.isAcceptableOrUnknown(data['bank_ifsc']!, _bankIfscMeta));
    }
    if (data.containsKey('bank_branch_address')) {
      context.handle(
          _bankBranchAddressMeta,
          bankBranchAddress.isAcceptableOrUnknown(
              data['bank_branch_address']!, _bankBranchAddressMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfileData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      businessName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_name'])!,
      addressLine: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address_line']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      panNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pan_number']),
      gstNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gst_number']),
      logoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_path']),
      signaturePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}signature_path']),
      bankName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_name']),
      bankAccountNo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_account_no']),
      bankIfsc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_ifsc']),
      bankBranchAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}bank_branch_address']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BusinessProfileTable createAlias(String alias) {
    return $BusinessProfileTable(attachedDatabase, alias);
  }
}

class BusinessProfileData extends DataClass
    implements Insertable<BusinessProfileData> {
  final int id;
  final String businessName;
  final String? addressLine;
  final String? phone;
  final String? email;
  final String? panNumber;
  final String? gstNumber;
  final String? logoPath;
  final String? signaturePath;
  final String? bankName;
  final String? bankAccountNo;
  final String? bankIfsc;
  final String? bankBranchAddress;
  final DateTime updatedAt;
  const BusinessProfileData(
      {required this.id,
      required this.businessName,
      this.addressLine,
      this.phone,
      this.email,
      this.panNumber,
      this.gstNumber,
      this.logoPath,
      this.signaturePath,
      this.bankName,
      this.bankAccountNo,
      this.bankIfsc,
      this.bankBranchAddress,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_name'] = Variable<String>(businessName);
    if (!nullToAbsent || addressLine != null) {
      map['address_line'] = Variable<String>(addressLine);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || panNumber != null) {
      map['pan_number'] = Variable<String>(panNumber);
    }
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || signaturePath != null) {
      map['signature_path'] = Variable<String>(signaturePath);
    }
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || bankAccountNo != null) {
      map['bank_account_no'] = Variable<String>(bankAccountNo);
    }
    if (!nullToAbsent || bankIfsc != null) {
      map['bank_ifsc'] = Variable<String>(bankIfsc);
    }
    if (!nullToAbsent || bankBranchAddress != null) {
      map['bank_branch_address'] = Variable<String>(bankBranchAddress);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BusinessProfileCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfileCompanion(
      id: Value(id),
      businessName: Value(businessName),
      addressLine: addressLine == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      panNumber: panNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(panNumber),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      signaturePath: signaturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(signaturePath),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      bankAccountNo: bankAccountNo == null && nullToAbsent
          ? const Value.absent()
          : Value(bankAccountNo),
      bankIfsc: bankIfsc == null && nullToAbsent
          ? const Value.absent()
          : Value(bankIfsc),
      bankBranchAddress: bankBranchAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(bankBranchAddress),
      updatedAt: Value(updatedAt),
    );
  }

  factory BusinessProfileData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfileData(
      id: serializer.fromJson<int>(json['id']),
      businessName: serializer.fromJson<String>(json['businessName']),
      addressLine: serializer.fromJson<String?>(json['addressLine']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      panNumber: serializer.fromJson<String?>(json['panNumber']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      signaturePath: serializer.fromJson<String?>(json['signaturePath']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      bankAccountNo: serializer.fromJson<String?>(json['bankAccountNo']),
      bankIfsc: serializer.fromJson<String?>(json['bankIfsc']),
      bankBranchAddress:
          serializer.fromJson<String?>(json['bankBranchAddress']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessName': serializer.toJson<String>(businessName),
      'addressLine': serializer.toJson<String?>(addressLine),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'panNumber': serializer.toJson<String?>(panNumber),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'logoPath': serializer.toJson<String?>(logoPath),
      'signaturePath': serializer.toJson<String?>(signaturePath),
      'bankName': serializer.toJson<String?>(bankName),
      'bankAccountNo': serializer.toJson<String?>(bankAccountNo),
      'bankIfsc': serializer.toJson<String?>(bankIfsc),
      'bankBranchAddress': serializer.toJson<String?>(bankBranchAddress),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BusinessProfileData copyWith(
          {int? id,
          String? businessName,
          Value<String?> addressLine = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> panNumber = const Value.absent(),
          Value<String?> gstNumber = const Value.absent(),
          Value<String?> logoPath = const Value.absent(),
          Value<String?> signaturePath = const Value.absent(),
          Value<String?> bankName = const Value.absent(),
          Value<String?> bankAccountNo = const Value.absent(),
          Value<String?> bankIfsc = const Value.absent(),
          Value<String?> bankBranchAddress = const Value.absent(),
          DateTime? updatedAt}) =>
      BusinessProfileData(
        id: id ?? this.id,
        businessName: businessName ?? this.businessName,
        addressLine: addressLine.present ? addressLine.value : this.addressLine,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        panNumber: panNumber.present ? panNumber.value : this.panNumber,
        gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
        logoPath: logoPath.present ? logoPath.value : this.logoPath,
        signaturePath:
            signaturePath.present ? signaturePath.value : this.signaturePath,
        bankName: bankName.present ? bankName.value : this.bankName,
        bankAccountNo:
            bankAccountNo.present ? bankAccountNo.value : this.bankAccountNo,
        bankIfsc: bankIfsc.present ? bankIfsc.value : this.bankIfsc,
        bankBranchAddress: bankBranchAddress.present
            ? bankBranchAddress.value
            : this.bankBranchAddress,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BusinessProfileData copyWithCompanion(BusinessProfileCompanion data) {
    return BusinessProfileData(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      addressLine:
          data.addressLine.present ? data.addressLine.value : this.addressLine,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      panNumber: data.panNumber.present ? data.panNumber.value : this.panNumber,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      signaturePath: data.signaturePath.present
          ? data.signaturePath.value
          : this.signaturePath,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      bankAccountNo: data.bankAccountNo.present
          ? data.bankAccountNo.value
          : this.bankAccountNo,
      bankIfsc: data.bankIfsc.present ? data.bankIfsc.value : this.bankIfsc,
      bankBranchAddress: data.bankBranchAddress.present
          ? data.bankBranchAddress.value
          : this.bankBranchAddress,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileData(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('addressLine: $addressLine, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('panNumber: $panNumber, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('logoPath: $logoPath, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountNo: $bankAccountNo, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('bankBranchAddress: $bankBranchAddress, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessName,
      addressLine,
      phone,
      email,
      panNumber,
      gstNumber,
      logoPath,
      signaturePath,
      bankName,
      bankAccountNo,
      bankIfsc,
      bankBranchAddress,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfileData &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.addressLine == this.addressLine &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.panNumber == this.panNumber &&
          other.gstNumber == this.gstNumber &&
          other.logoPath == this.logoPath &&
          other.signaturePath == this.signaturePath &&
          other.bankName == this.bankName &&
          other.bankAccountNo == this.bankAccountNo &&
          other.bankIfsc == this.bankIfsc &&
          other.bankBranchAddress == this.bankBranchAddress &&
          other.updatedAt == this.updatedAt);
}

class BusinessProfileCompanion extends UpdateCompanion<BusinessProfileData> {
  final Value<int> id;
  final Value<String> businessName;
  final Value<String?> addressLine;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> panNumber;
  final Value<String?> gstNumber;
  final Value<String?> logoPath;
  final Value<String?> signaturePath;
  final Value<String?> bankName;
  final Value<String?> bankAccountNo;
  final Value<String?> bankIfsc;
  final Value<String?> bankBranchAddress;
  final Value<DateTime> updatedAt;
  const BusinessProfileCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.addressLine = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccountNo = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.bankBranchAddress = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BusinessProfileCompanion.insert({
    this.id = const Value.absent(),
    required String businessName,
    this.addressLine = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.panNumber = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.signaturePath = const Value.absent(),
    this.bankName = const Value.absent(),
    this.bankAccountNo = const Value.absent(),
    this.bankIfsc = const Value.absent(),
    this.bankBranchAddress = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : businessName = Value(businessName);
  static Insertable<BusinessProfileData> custom({
    Expression<int>? id,
    Expression<String>? businessName,
    Expression<String>? addressLine,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? panNumber,
    Expression<String>? gstNumber,
    Expression<String>? logoPath,
    Expression<String>? signaturePath,
    Expression<String>? bankName,
    Expression<String>? bankAccountNo,
    Expression<String>? bankIfsc,
    Expression<String>? bankBranchAddress,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (addressLine != null) 'address_line': addressLine,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (panNumber != null) 'pan_number': panNumber,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (logoPath != null) 'logo_path': logoPath,
      if (signaturePath != null) 'signature_path': signaturePath,
      if (bankName != null) 'bank_name': bankName,
      if (bankAccountNo != null) 'bank_account_no': bankAccountNo,
      if (bankIfsc != null) 'bank_ifsc': bankIfsc,
      if (bankBranchAddress != null) 'bank_branch_address': bankBranchAddress,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BusinessProfileCompanion copyWith(
      {Value<int>? id,
      Value<String>? businessName,
      Value<String?>? addressLine,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? panNumber,
      Value<String?>? gstNumber,
      Value<String?>? logoPath,
      Value<String?>? signaturePath,
      Value<String?>? bankName,
      Value<String?>? bankAccountNo,
      Value<String?>? bankIfsc,
      Value<String?>? bankBranchAddress,
      Value<DateTime>? updatedAt}) {
    return BusinessProfileCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      addressLine: addressLine ?? this.addressLine,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      panNumber: panNumber ?? this.panNumber,
      gstNumber: gstNumber ?? this.gstNumber,
      logoPath: logoPath ?? this.logoPath,
      signaturePath: signaturePath ?? this.signaturePath,
      bankName: bankName ?? this.bankName,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      bankIfsc: bankIfsc ?? this.bankIfsc,
      bankBranchAddress: bankBranchAddress ?? this.bankBranchAddress,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (addressLine.present) {
      map['address_line'] = Variable<String>(addressLine.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (panNumber.present) {
      map['pan_number'] = Variable<String>(panNumber.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (signaturePath.present) {
      map['signature_path'] = Variable<String>(signaturePath.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (bankAccountNo.present) {
      map['bank_account_no'] = Variable<String>(bankAccountNo.value);
    }
    if (bankIfsc.present) {
      map['bank_ifsc'] = Variable<String>(bankIfsc.value);
    }
    if (bankBranchAddress.present) {
      map['bank_branch_address'] = Variable<String>(bankBranchAddress.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfileCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('addressLine: $addressLine, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('panNumber: $panNumber, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('logoPath: $logoPath, ')
          ..write('signaturePath: $signaturePath, ')
          ..write('bankName: $bankName, ')
          ..write('bankAccountNo: $bankAccountNo, ')
          ..write('bankIfsc: $bankIfsc, ')
          ..write('bankBranchAddress: $bankBranchAddress, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gstNumberMeta =
      const VerificationMeta('gstNumber');
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
      'gst_number', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, phone, email, address, gstNumber, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('gst_number')) {
      context.handle(_gstNumberMeta,
          gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      gstNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gst_number']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? gstNumber;
  final DateTime createdAt;
  const Customer(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.gstNumber,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> gstNumber = const Value.absent(),
          DateTime? createdAt}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
        createdAt: createdAt ?? this.createdAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, email, address, gstNumber, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.gstNumber == this.gstNumber &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> gstNumber;
  final Value<DateTime> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? gstNumber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? gstNumber,
      Value<DateTime>? createdAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _hsnSacCodeMeta =
      const VerificationMeta('hsnSacCode');
  @override
  late final GeneratedColumn<String> hsnSacCode = GeneratedColumn<String>(
      'hsn_sac_code', aliasedName, true,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _defaultUnitMeta =
      const VerificationMeta('defaultUnit');
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
      'default_unit', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Pcs'));
  static const VerificationMeta _defaultPriceMeta =
      const VerificationMeta('defaultPrice');
  @override
  late final GeneratedColumn<double> defaultPrice = GeneratedColumn<double>(
      'default_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _defaultTaxPercentMeta =
      const VerificationMeta('defaultTaxPercent');
  @override
  late final GeneratedColumn<double> defaultTaxPercent =
      GeneratedColumn<double>('default_tax_percent', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        hsnSacCode,
        defaultUnit,
        defaultPrice,
        defaultTaxPercent,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('hsn_sac_code')) {
      context.handle(
          _hsnSacCodeMeta,
          hsnSacCode.isAcceptableOrUnknown(
              data['hsn_sac_code']!, _hsnSacCodeMeta));
    }
    if (data.containsKey('default_unit')) {
      context.handle(
          _defaultUnitMeta,
          defaultUnit.isAcceptableOrUnknown(
              data['default_unit']!, _defaultUnitMeta));
    }
    if (data.containsKey('default_price')) {
      context.handle(
          _defaultPriceMeta,
          defaultPrice.isAcceptableOrUnknown(
              data['default_price']!, _defaultPriceMeta));
    }
    if (data.containsKey('default_tax_percent')) {
      context.handle(
          _defaultTaxPercentMeta,
          defaultTaxPercent.isAcceptableOrUnknown(
              data['default_tax_percent']!, _defaultTaxPercentMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      hsnSacCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsn_sac_code']),
      defaultUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_unit'])!,
      defaultPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}default_price'])!,
      defaultTaxPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}default_tax_percent']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }
}

class Item extends DataClass implements Insertable<Item> {
  final int id;
  final String name;
  final String? hsnSacCode;

  /// Default unit label, e.g. "Pcs", "Nos", "Kg", "Hrs", "Ltr"
  final String defaultUnit;

  /// Default selling price (INR)
  final double defaultPrice;

  /// Default tax rate — GST % (e.g. 0, 5, 12, 18, 28). Nullable = exempt/zero.
  final double? defaultTaxPercent;
  final DateTime createdAt;
  const Item(
      {required this.id,
      required this.name,
      this.hsnSacCode,
      required this.defaultUnit,
      required this.defaultPrice,
      this.defaultTaxPercent,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || hsnSacCode != null) {
      map['hsn_sac_code'] = Variable<String>(hsnSacCode);
    }
    map['default_unit'] = Variable<String>(defaultUnit);
    map['default_price'] = Variable<double>(defaultPrice);
    if (!nullToAbsent || defaultTaxPercent != null) {
      map['default_tax_percent'] = Variable<double>(defaultTaxPercent);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      name: Value(name),
      hsnSacCode: hsnSacCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnSacCode),
      defaultUnit: Value(defaultUnit),
      defaultPrice: Value(defaultPrice),
      defaultTaxPercent: defaultTaxPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultTaxPercent),
      createdAt: Value(createdAt),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hsnSacCode: serializer.fromJson<String?>(json['hsnSacCode']),
      defaultUnit: serializer.fromJson<String>(json['defaultUnit']),
      defaultPrice: serializer.fromJson<double>(json['defaultPrice']),
      defaultTaxPercent:
          serializer.fromJson<double?>(json['defaultTaxPercent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'hsnSacCode': serializer.toJson<String?>(hsnSacCode),
      'defaultUnit': serializer.toJson<String>(defaultUnit),
      'defaultPrice': serializer.toJson<double>(defaultPrice),
      'defaultTaxPercent': serializer.toJson<double?>(defaultTaxPercent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Item copyWith(
          {int? id,
          String? name,
          Value<String?> hsnSacCode = const Value.absent(),
          String? defaultUnit,
          double? defaultPrice,
          Value<double?> defaultTaxPercent = const Value.absent(),
          DateTime? createdAt}) =>
      Item(
        id: id ?? this.id,
        name: name ?? this.name,
        hsnSacCode: hsnSacCode.present ? hsnSacCode.value : this.hsnSacCode,
        defaultUnit: defaultUnit ?? this.defaultUnit,
        defaultPrice: defaultPrice ?? this.defaultPrice,
        defaultTaxPercent: defaultTaxPercent.present
            ? defaultTaxPercent.value
            : this.defaultTaxPercent,
        createdAt: createdAt ?? this.createdAt,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hsnSacCode:
          data.hsnSacCode.present ? data.hsnSacCode.value : this.hsnSacCode,
      defaultUnit:
          data.defaultUnit.present ? data.defaultUnit.value : this.defaultUnit,
      defaultPrice: data.defaultPrice.present
          ? data.defaultPrice.value
          : this.defaultPrice,
      defaultTaxPercent: data.defaultTaxPercent.present
          ? data.defaultTaxPercent.value
          : this.defaultTaxPercent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hsnSacCode: $hsnSacCode, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('defaultPrice: $defaultPrice, ')
          ..write('defaultTaxPercent: $defaultTaxPercent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, hsnSacCode, defaultUnit,
      defaultPrice, defaultTaxPercent, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.name == this.name &&
          other.hsnSacCode == this.hsnSacCode &&
          other.defaultUnit == this.defaultUnit &&
          other.defaultPrice == this.defaultPrice &&
          other.defaultTaxPercent == this.defaultTaxPercent &&
          other.createdAt == this.createdAt);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> hsnSacCode;
  final Value<String> defaultUnit;
  final Value<double> defaultPrice;
  final Value<double?> defaultTaxPercent;
  final Value<DateTime> createdAt;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hsnSacCode = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.defaultPrice = const Value.absent(),
    this.defaultTaxPercent = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.hsnSacCode = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.defaultPrice = const Value.absent(),
    this.defaultTaxPercent = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Item> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? hsnSacCode,
    Expression<String>? defaultUnit,
    Expression<double>? defaultPrice,
    Expression<double>? defaultTaxPercent,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hsnSacCode != null) 'hsn_sac_code': hsnSacCode,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (defaultPrice != null) 'default_price': defaultPrice,
      if (defaultTaxPercent != null) 'default_tax_percent': defaultTaxPercent,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? hsnSacCode,
      Value<String>? defaultUnit,
      Value<double>? defaultPrice,
      Value<double?>? defaultTaxPercent,
      Value<DateTime>? createdAt}) {
    return ItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hsnSacCode: hsnSacCode ?? this.hsnSacCode,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      defaultTaxPercent: defaultTaxPercent ?? this.defaultTaxPercent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (hsnSacCode.present) {
      map['hsn_sac_code'] = Variable<String>(hsnSacCode.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (defaultPrice.present) {
      map['default_price'] = Variable<double>(defaultPrice.value);
    }
    if (defaultTaxPercent.present) {
      map['default_tax_percent'] = Variable<double>(defaultTaxPercent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hsnSacCode: $hsnSacCode, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('defaultPrice: $defaultPrice, ')
          ..write('defaultTaxPercent: $defaultTaxPercent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _documentNumberMeta =
      const VerificationMeta('documentNumber');
  @override
  late final GeneratedColumn<String> documentNumber = GeneratedColumn<String>(
      'document_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerAddressMeta =
      const VerificationMeta('customerAddress');
  @override
  late final GeneratedColumn<String> customerAddress = GeneratedColumn<String>(
      'customer_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerGstNumberMeta =
      const VerificationMeta('customerGstNumber');
  @override
  late final GeneratedColumn<String> customerGstNumber =
      GeneratedColumn<String>('customer_gst_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _placeOfSupplyMeta =
      const VerificationMeta('placeOfSupply');
  @override
  late final GeneratedColumn<String> placeOfSupply = GeneratedColumn<String>(
      'place_of_supply', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalDiscountMeta =
      const VerificationMeta('totalDiscount');
  @override
  late final GeneratedColumn<double> totalDiscount = GeneratedColumn<double>(
      'total_discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalTaxMeta =
      const VerificationMeta('totalTax');
  @override
  late final GeneratedColumn<double> totalTax = GeneratedColumn<double>(
      'total_tax', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _grandTotalMeta =
      const VerificationMeta('grandTotal');
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
      'grand_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _amountReceivedMeta =
      const VerificationMeta('amountReceived');
  @override
  late final GeneratedColumn<double> amountReceived = GeneratedColumn<double>(
      'amount_received', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _balanceDueMeta =
      const VerificationMeta('balanceDue');
  @override
  late final GeneratedColumn<double> balanceDue = GeneratedColumn<double>(
      'balance_due', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _amountInWordsMeta =
      const VerificationMeta('amountInWords');
  @override
  late final GeneratedColumn<String> amountInWords = GeneratedColumn<String>(
      'amount_in_words', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        documentNumber,
        type,
        customerId,
        customerName,
        customerPhone,
        customerAddress,
        customerGstNumber,
        date,
        dueDate,
        placeOfSupply,
        subtotal,
        totalDiscount,
        totalTax,
        grandTotal,
        amountReceived,
        balanceDue,
        amountInWords,
        status,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_number')) {
      context.handle(
          _documentNumberMeta,
          documentNumber.isAcceptableOrUnknown(
              data['document_number']!, _documentNumberMeta));
    } else if (isInserting) {
      context.missing(_documentNumberMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('customer_address')) {
      context.handle(
          _customerAddressMeta,
          customerAddress.isAcceptableOrUnknown(
              data['customer_address']!, _customerAddressMeta));
    }
    if (data.containsKey('customer_gst_number')) {
      context.handle(
          _customerGstNumberMeta,
          customerGstNumber.isAcceptableOrUnknown(
              data['customer_gst_number']!, _customerGstNumberMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('place_of_supply')) {
      context.handle(
          _placeOfSupplyMeta,
          placeOfSupply.isAcceptableOrUnknown(
              data['place_of_supply']!, _placeOfSupplyMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('total_discount')) {
      context.handle(
          _totalDiscountMeta,
          totalDiscount.isAcceptableOrUnknown(
              data['total_discount']!, _totalDiscountMeta));
    }
    if (data.containsKey('total_tax')) {
      context.handle(_totalTaxMeta,
          totalTax.isAcceptableOrUnknown(data['total_tax']!, _totalTaxMeta));
    }
    if (data.containsKey('grand_total')) {
      context.handle(
          _grandTotalMeta,
          grandTotal.isAcceptableOrUnknown(
              data['grand_total']!, _grandTotalMeta));
    }
    if (data.containsKey('amount_received')) {
      context.handle(
          _amountReceivedMeta,
          amountReceived.isAcceptableOrUnknown(
              data['amount_received']!, _amountReceivedMeta));
    }
    if (data.containsKey('balance_due')) {
      context.handle(
          _balanceDueMeta,
          balanceDue.isAcceptableOrUnknown(
              data['balance_due']!, _balanceDueMeta));
    }
    if (data.containsKey('amount_in_words')) {
      context.handle(
          _amountInWordsMeta,
          amountInWords.isAcceptableOrUnknown(
              data['amount_in_words']!, _amountInWordsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      documentNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}document_number'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name'])!,
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone']),
      customerAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}customer_address']),
      customerGstNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}customer_gst_number']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date']),
      placeOfSupply: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place_of_supply']),
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      totalDiscount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_discount'])!,
      totalTax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_tax'])!,
      grandTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grand_total'])!,
      amountReceived: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_received']),
      balanceDue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance_due']),
      amountInWords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount_in_words']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;

  /// Human-readable number, e.g. "INV-0001" or "EST-0001".
  /// Managed by the DAO (per-type sequence counter).
  final String documentNumber;

  /// 'invoice' | 'estimate'
  final String type;

  /// FK → customers.id — nullable (walk-in / ad-hoc customer)
  final int? customerId;

  /// Denormalised snapshot at creation time (preserved if customer is edited)
  final String customerName;
  final String? customerPhone;
  final String? customerAddress;
  final String? customerGstNumber;
  final DateTime date;
  final DateTime? dueDate;
  final String? placeOfSupply;
  final double subtotal;
  final double totalDiscount;
  final double totalTax;
  final double grandTotal;

  /// Applicable to invoices only; null for estimates.
  final double? amountReceived;
  final double? balanceDue;

  /// Pre-computed "Rupees eight thousand only" — stored for PDF rendering.
  final String? amountInWords;

  /// See status values above. Default 'draft' for both types.
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Document(
      {required this.id,
      required this.documentNumber,
      required this.type,
      this.customerId,
      required this.customerName,
      this.customerPhone,
      this.customerAddress,
      this.customerGstNumber,
      required this.date,
      this.dueDate,
      this.placeOfSupply,
      required this.subtotal,
      required this.totalDiscount,
      required this.totalTax,
      required this.grandTotal,
      this.amountReceived,
      this.balanceDue,
      this.amountInWords,
      required this.status,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_number'] = Variable<String>(documentNumber);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    if (!nullToAbsent || customerAddress != null) {
      map['customer_address'] = Variable<String>(customerAddress);
    }
    if (!nullToAbsent || customerGstNumber != null) {
      map['customer_gst_number'] = Variable<String>(customerGstNumber);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || placeOfSupply != null) {
      map['place_of_supply'] = Variable<String>(placeOfSupply);
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['total_discount'] = Variable<double>(totalDiscount);
    map['total_tax'] = Variable<double>(totalTax);
    map['grand_total'] = Variable<double>(grandTotal);
    if (!nullToAbsent || amountReceived != null) {
      map['amount_received'] = Variable<double>(amountReceived);
    }
    if (!nullToAbsent || balanceDue != null) {
      map['balance_due'] = Variable<double>(balanceDue);
    }
    if (!nullToAbsent || amountInWords != null) {
      map['amount_in_words'] = Variable<String>(amountInWords);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      documentNumber: Value(documentNumber),
      type: Value(type),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      customerAddress: customerAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(customerAddress),
      customerGstNumber: customerGstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(customerGstNumber),
      date: Value(date),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      placeOfSupply: placeOfSupply == null && nullToAbsent
          ? const Value.absent()
          : Value(placeOfSupply),
      subtotal: Value(subtotal),
      totalDiscount: Value(totalDiscount),
      totalTax: Value(totalTax),
      grandTotal: Value(grandTotal),
      amountReceived: amountReceived == null && nullToAbsent
          ? const Value.absent()
          : Value(amountReceived),
      balanceDue: balanceDue == null && nullToAbsent
          ? const Value.absent()
          : Value(balanceDue),
      amountInWords: amountInWords == null && nullToAbsent
          ? const Value.absent()
          : Value(amountInWords),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      documentNumber: serializer.fromJson<String>(json['documentNumber']),
      type: serializer.fromJson<String>(json['type']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      customerAddress: serializer.fromJson<String?>(json['customerAddress']),
      customerGstNumber:
          serializer.fromJson<String?>(json['customerGstNumber']),
      date: serializer.fromJson<DateTime>(json['date']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      placeOfSupply: serializer.fromJson<String?>(json['placeOfSupply']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      totalDiscount: serializer.fromJson<double>(json['totalDiscount']),
      totalTax: serializer.fromJson<double>(json['totalTax']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      amountReceived: serializer.fromJson<double?>(json['amountReceived']),
      balanceDue: serializer.fromJson<double?>(json['balanceDue']),
      amountInWords: serializer.fromJson<String?>(json['amountInWords']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentNumber': serializer.toJson<String>(documentNumber),
      'type': serializer.toJson<String>(type),
      'customerId': serializer.toJson<int?>(customerId),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'customerAddress': serializer.toJson<String?>(customerAddress),
      'customerGstNumber': serializer.toJson<String?>(customerGstNumber),
      'date': serializer.toJson<DateTime>(date),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'placeOfSupply': serializer.toJson<String?>(placeOfSupply),
      'subtotal': serializer.toJson<double>(subtotal),
      'totalDiscount': serializer.toJson<double>(totalDiscount),
      'totalTax': serializer.toJson<double>(totalTax),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'amountReceived': serializer.toJson<double?>(amountReceived),
      'balanceDue': serializer.toJson<double?>(balanceDue),
      'amountInWords': serializer.toJson<String?>(amountInWords),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Document copyWith(
          {int? id,
          String? documentNumber,
          String? type,
          Value<int?> customerId = const Value.absent(),
          String? customerName,
          Value<String?> customerPhone = const Value.absent(),
          Value<String?> customerAddress = const Value.absent(),
          Value<String?> customerGstNumber = const Value.absent(),
          DateTime? date,
          Value<DateTime?> dueDate = const Value.absent(),
          Value<String?> placeOfSupply = const Value.absent(),
          double? subtotal,
          double? totalDiscount,
          double? totalTax,
          double? grandTotal,
          Value<double?> amountReceived = const Value.absent(),
          Value<double?> balanceDue = const Value.absent(),
          Value<String?> amountInWords = const Value.absent(),
          String? status,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Document(
        id: id ?? this.id,
        documentNumber: documentNumber ?? this.documentNumber,
        type: type ?? this.type,
        customerId: customerId.present ? customerId.value : this.customerId,
        customerName: customerName ?? this.customerName,
        customerPhone:
            customerPhone.present ? customerPhone.value : this.customerPhone,
        customerAddress: customerAddress.present
            ? customerAddress.value
            : this.customerAddress,
        customerGstNumber: customerGstNumber.present
            ? customerGstNumber.value
            : this.customerGstNumber,
        date: date ?? this.date,
        dueDate: dueDate.present ? dueDate.value : this.dueDate,
        placeOfSupply:
            placeOfSupply.present ? placeOfSupply.value : this.placeOfSupply,
        subtotal: subtotal ?? this.subtotal,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        totalTax: totalTax ?? this.totalTax,
        grandTotal: grandTotal ?? this.grandTotal,
        amountReceived:
            amountReceived.present ? amountReceived.value : this.amountReceived,
        balanceDue: balanceDue.present ? balanceDue.value : this.balanceDue,
        amountInWords:
            amountInWords.present ? amountInWords.value : this.amountInWords,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      documentNumber: data.documentNumber.present
          ? data.documentNumber.value
          : this.documentNumber,
      type: data.type.present ? data.type.value : this.type,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      customerAddress: data.customerAddress.present
          ? data.customerAddress.value
          : this.customerAddress,
      customerGstNumber: data.customerGstNumber.present
          ? data.customerGstNumber.value
          : this.customerGstNumber,
      date: data.date.present ? data.date.value : this.date,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      placeOfSupply: data.placeOfSupply.present
          ? data.placeOfSupply.value
          : this.placeOfSupply,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      totalDiscount: data.totalDiscount.present
          ? data.totalDiscount.value
          : this.totalDiscount,
      totalTax: data.totalTax.present ? data.totalTax.value : this.totalTax,
      grandTotal:
          data.grandTotal.present ? data.grandTotal.value : this.grandTotal,
      amountReceived: data.amountReceived.present
          ? data.amountReceived.value
          : this.amountReceived,
      balanceDue:
          data.balanceDue.present ? data.balanceDue.value : this.balanceDue,
      amountInWords: data.amountInWords.present
          ? data.amountInWords.value
          : this.amountInWords,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('documentNumber: $documentNumber, ')
          ..write('type: $type, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('customerGstNumber: $customerGstNumber, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('placeOfSupply: $placeOfSupply, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalDiscount: $totalDiscount, ')
          ..write('totalTax: $totalTax, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('balanceDue: $balanceDue, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        documentNumber,
        type,
        customerId,
        customerName,
        customerPhone,
        customerAddress,
        customerGstNumber,
        date,
        dueDate,
        placeOfSupply,
        subtotal,
        totalDiscount,
        totalTax,
        grandTotal,
        amountReceived,
        balanceDue,
        amountInWords,
        status,
        notes,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.documentNumber == this.documentNumber &&
          other.type == this.type &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.customerAddress == this.customerAddress &&
          other.customerGstNumber == this.customerGstNumber &&
          other.date == this.date &&
          other.dueDate == this.dueDate &&
          other.placeOfSupply == this.placeOfSupply &&
          other.subtotal == this.subtotal &&
          other.totalDiscount == this.totalDiscount &&
          other.totalTax == this.totalTax &&
          other.grandTotal == this.grandTotal &&
          other.amountReceived == this.amountReceived &&
          other.balanceDue == this.balanceDue &&
          other.amountInWords == this.amountInWords &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<String> documentNumber;
  final Value<String> type;
  final Value<int?> customerId;
  final Value<String> customerName;
  final Value<String?> customerPhone;
  final Value<String?> customerAddress;
  final Value<String?> customerGstNumber;
  final Value<DateTime> date;
  final Value<DateTime?> dueDate;
  final Value<String?> placeOfSupply;
  final Value<double> subtotal;
  final Value<double> totalDiscount;
  final Value<double> totalTax;
  final Value<double> grandTotal;
  final Value<double?> amountReceived;
  final Value<double?> balanceDue;
  final Value<String?> amountInWords;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.documentNumber = const Value.absent(),
    this.type = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.customerGstNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.placeOfSupply = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalDiscount = const Value.absent(),
    this.totalTax = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.balanceDue = const Value.absent(),
    this.amountInWords = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    required String documentNumber,
    required String type,
    this.customerId = const Value.absent(),
    required String customerName,
    this.customerPhone = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.customerGstNumber = const Value.absent(),
    required DateTime date,
    this.dueDate = const Value.absent(),
    this.placeOfSupply = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalDiscount = const Value.absent(),
    this.totalTax = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.balanceDue = const Value.absent(),
    this.amountInWords = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : documentNumber = Value(documentNumber),
        type = Value(type),
        customerName = Value(customerName),
        date = Value(date);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<String>? documentNumber,
    Expression<String>? type,
    Expression<int>? customerId,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? customerAddress,
    Expression<String>? customerGstNumber,
    Expression<DateTime>? date,
    Expression<DateTime>? dueDate,
    Expression<String>? placeOfSupply,
    Expression<double>? subtotal,
    Expression<double>? totalDiscount,
    Expression<double>? totalTax,
    Expression<double>? grandTotal,
    Expression<double>? amountReceived,
    Expression<double>? balanceDue,
    Expression<String>? amountInWords,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentNumber != null) 'document_number': documentNumber,
      if (type != null) 'type': type,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerAddress != null) 'customer_address': customerAddress,
      if (customerGstNumber != null) 'customer_gst_number': customerGstNumber,
      if (date != null) 'date': date,
      if (dueDate != null) 'due_date': dueDate,
      if (placeOfSupply != null) 'place_of_supply': placeOfSupply,
      if (subtotal != null) 'subtotal': subtotal,
      if (totalDiscount != null) 'total_discount': totalDiscount,
      if (totalTax != null) 'total_tax': totalTax,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (amountReceived != null) 'amount_received': amountReceived,
      if (balanceDue != null) 'balance_due': balanceDue,
      if (amountInWords != null) 'amount_in_words': amountInWords,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DocumentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? documentNumber,
      Value<String>? type,
      Value<int?>? customerId,
      Value<String>? customerName,
      Value<String?>? customerPhone,
      Value<String?>? customerAddress,
      Value<String?>? customerGstNumber,
      Value<DateTime>? date,
      Value<DateTime?>? dueDate,
      Value<String?>? placeOfSupply,
      Value<double>? subtotal,
      Value<double>? totalDiscount,
      Value<double>? totalTax,
      Value<double>? grandTotal,
      Value<double?>? amountReceived,
      Value<double?>? balanceDue,
      Value<String?>? amountInWords,
      Value<String>? status,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      documentNumber: documentNumber ?? this.documentNumber,
      type: type ?? this.type,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      customerGstNumber: customerGstNumber ?? this.customerGstNumber,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      placeOfSupply: placeOfSupply ?? this.placeOfSupply,
      subtotal: subtotal ?? this.subtotal,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      totalTax: totalTax ?? this.totalTax,
      grandTotal: grandTotal ?? this.grandTotal,
      amountReceived: amountReceived ?? this.amountReceived,
      balanceDue: balanceDue ?? this.balanceDue,
      amountInWords: amountInWords ?? this.amountInWords,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentNumber.present) {
      map['document_number'] = Variable<String>(documentNumber.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (customerAddress.present) {
      map['customer_address'] = Variable<String>(customerAddress.value);
    }
    if (customerGstNumber.present) {
      map['customer_gst_number'] = Variable<String>(customerGstNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (placeOfSupply.present) {
      map['place_of_supply'] = Variable<String>(placeOfSupply.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (totalDiscount.present) {
      map['total_discount'] = Variable<double>(totalDiscount.value);
    }
    if (totalTax.present) {
      map['total_tax'] = Variable<double>(totalTax.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (amountReceived.present) {
      map['amount_received'] = Variable<double>(amountReceived.value);
    }
    if (balanceDue.present) {
      map['balance_due'] = Variable<double>(balanceDue.value);
    }
    if (amountInWords.present) {
      map['amount_in_words'] = Variable<String>(amountInWords.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('documentNumber: $documentNumber, ')
          ..write('type: $type, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('customerGstNumber: $customerGstNumber, ')
          ..write('date: $date, ')
          ..write('dueDate: $dueDate, ')
          ..write('placeOfSupply: $placeOfSupply, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalDiscount: $totalDiscount, ')
          ..write('totalTax: $totalTax, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('balanceDue: $balanceDue, ')
          ..write('amountInWords: $amountInWords, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentLineItemsTable extends DocumentLineItems
    with TableInfo<$DocumentLineItemsTable, DocumentLineItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentLineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
      'document_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hsnSacCodeMeta =
      const VerificationMeta('hsnSacCode');
  @override
  late final GeneratedColumn<String> hsnSacCode = GeneratedColumn<String>(
      'hsn_sac_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Pcs'));
  static const VerificationMeta _pricePerUnitMeta =
      const VerificationMeta('pricePerUnit');
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
      'price_per_unit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountPercentMeta =
      const VerificationMeta('discountPercent');
  @override
  late final GeneratedColumn<double> discountPercent = GeneratedColumn<double>(
      'discount_percent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxableAmountMeta =
      const VerificationMeta('taxableAmount');
  @override
  late final GeneratedColumn<double> taxableAmount = GeneratedColumn<double>(
      'taxable_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxPercentMeta =
      const VerificationMeta('taxPercent');
  @override
  late final GeneratedColumn<double> taxPercent = GeneratedColumn<double>(
      'tax_percent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        documentId,
        itemId,
        itemName,
        hsnSacCode,
        quantity,
        unit,
        pricePerUnit,
        discountPercent,
        discountAmount,
        taxableAmount,
        taxPercent,
        taxAmount,
        lineTotal,
        sortOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_line_items';
  @override
  VerificationContext validateIntegrity(Insertable<DocumentLineItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('hsn_sac_code')) {
      context.handle(
          _hsnSacCodeMeta,
          hsnSacCode.isAcceptableOrUnknown(
              data['hsn_sac_code']!, _hsnSacCodeMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
          _pricePerUnitMeta,
          pricePerUnit.isAcceptableOrUnknown(
              data['price_per_unit']!, _pricePerUnitMeta));
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
          _discountPercentMeta,
          discountPercent.isAcceptableOrUnknown(
              data['discount_percent']!, _discountPercentMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('taxable_amount')) {
      context.handle(
          _taxableAmountMeta,
          taxableAmount.isAcceptableOrUnknown(
              data['taxable_amount']!, _taxableAmountMeta));
    }
    if (data.containsKey('tax_percent')) {
      context.handle(
          _taxPercentMeta,
          taxPercent.isAcceptableOrUnknown(
              data['tax_percent']!, _taxPercentMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentLineItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentLineItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}document_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id']),
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      hsnSacCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsn_sac_code']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      pricePerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_unit'])!,
      discountPercent: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_percent'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      taxableAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}taxable_amount'])!,
      taxPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_percent'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $DocumentLineItemsTable createAlias(String alias) {
    return $DocumentLineItemsTable(attachedDatabase, alias);
  }
}

class DocumentLineItem extends DataClass
    implements Insertable<DocumentLineItem> {
  final int id;

  /// FK → documents.id
  final int documentId;

  /// FK → items.id — nullable when the line is an ad-hoc / custom entry.
  final int? itemId;
  final String itemName;
  final String? hsnSacCode;
  final double quantity;
  final String unit;
  final double pricePerUnit;

  /// Discount applied to this line (%)
  final double discountPercent;

  /// Computed: quantity * pricePerUnit * (discountPercent / 100)
  final double discountAmount;

  /// Computed: (quantity * pricePerUnit) - discountAmount
  final double taxableAmount;

  /// GST % applied on taxableAmount
  final double taxPercent;

  /// Computed: taxableAmount * (taxPercent / 100)
  final double taxAmount;

  /// taxableAmount + taxAmount
  final double lineTotal;

  /// For maintaining display order
  final int sortOrder;
  const DocumentLineItem(
      {required this.id,
      required this.documentId,
      this.itemId,
      required this.itemName,
      this.hsnSacCode,
      required this.quantity,
      required this.unit,
      required this.pricePerUnit,
      required this.discountPercent,
      required this.discountAmount,
      required this.taxableAmount,
      required this.taxPercent,
      required this.taxAmount,
      required this.lineTotal,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_id'] = Variable<int>(documentId);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || hsnSacCode != null) {
      map['hsn_sac_code'] = Variable<String>(hsnSacCode);
    }
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['price_per_unit'] = Variable<double>(pricePerUnit);
    map['discount_percent'] = Variable<double>(discountPercent);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['taxable_amount'] = Variable<double>(taxableAmount);
    map['tax_percent'] = Variable<double>(taxPercent);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['line_total'] = Variable<double>(lineTotal);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DocumentLineItemsCompanion toCompanion(bool nullToAbsent) {
    return DocumentLineItemsCompanion(
      id: Value(id),
      documentId: Value(documentId),
      itemId:
          itemId == null && nullToAbsent ? const Value.absent() : Value(itemId),
      itemName: Value(itemName),
      hsnSacCode: hsnSacCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnSacCode),
      quantity: Value(quantity),
      unit: Value(unit),
      pricePerUnit: Value(pricePerUnit),
      discountPercent: Value(discountPercent),
      discountAmount: Value(discountAmount),
      taxableAmount: Value(taxableAmount),
      taxPercent: Value(taxPercent),
      taxAmount: Value(taxAmount),
      lineTotal: Value(lineTotal),
      sortOrder: Value(sortOrder),
    );
  }

  factory DocumentLineItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentLineItem(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<int>(json['documentId']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      hsnSacCode: serializer.fromJson<String?>(json['hsnSacCode']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      pricePerUnit: serializer.fromJson<double>(json['pricePerUnit']),
      discountPercent: serializer.fromJson<double>(json['discountPercent']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      taxableAmount: serializer.fromJson<double>(json['taxableAmount']),
      taxPercent: serializer.fromJson<double>(json['taxPercent']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<int>(documentId),
      'itemId': serializer.toJson<int?>(itemId),
      'itemName': serializer.toJson<String>(itemName),
      'hsnSacCode': serializer.toJson<String?>(hsnSacCode),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'pricePerUnit': serializer.toJson<double>(pricePerUnit),
      'discountPercent': serializer.toJson<double>(discountPercent),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'taxableAmount': serializer.toJson<double>(taxableAmount),
      'taxPercent': serializer.toJson<double>(taxPercent),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DocumentLineItem copyWith(
          {int? id,
          int? documentId,
          Value<int?> itemId = const Value.absent(),
          String? itemName,
          Value<String?> hsnSacCode = const Value.absent(),
          double? quantity,
          String? unit,
          double? pricePerUnit,
          double? discountPercent,
          double? discountAmount,
          double? taxableAmount,
          double? taxPercent,
          double? taxAmount,
          double? lineTotal,
          int? sortOrder}) =>
      DocumentLineItem(
        id: id ?? this.id,
        documentId: documentId ?? this.documentId,
        itemId: itemId.present ? itemId.value : this.itemId,
        itemName: itemName ?? this.itemName,
        hsnSacCode: hsnSacCode.present ? hsnSacCode.value : this.hsnSacCode,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        pricePerUnit: pricePerUnit ?? this.pricePerUnit,
        discountPercent: discountPercent ?? this.discountPercent,
        discountAmount: discountAmount ?? this.discountAmount,
        taxableAmount: taxableAmount ?? this.taxableAmount,
        taxPercent: taxPercent ?? this.taxPercent,
        taxAmount: taxAmount ?? this.taxAmount,
        lineTotal: lineTotal ?? this.lineTotal,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  DocumentLineItem copyWithCompanion(DocumentLineItemsCompanion data) {
    return DocumentLineItem(
      id: data.id.present ? data.id.value : this.id,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      hsnSacCode:
          data.hsnSacCode.present ? data.hsnSacCode.value : this.hsnSacCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      taxableAmount: data.taxableAmount.present
          ? data.taxableAmount.value
          : this.taxableAmount,
      taxPercent:
          data.taxPercent.present ? data.taxPercent.value : this.taxPercent,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentLineItem(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('hsnSacCode: $hsnSacCode, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('taxPercent: $taxPercent, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      documentId,
      itemId,
      itemName,
      hsnSacCode,
      quantity,
      unit,
      pricePerUnit,
      discountPercent,
      discountAmount,
      taxableAmount,
      taxPercent,
      taxAmount,
      lineTotal,
      sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentLineItem &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.itemId == this.itemId &&
          other.itemName == this.itemName &&
          other.hsnSacCode == this.hsnSacCode &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.pricePerUnit == this.pricePerUnit &&
          other.discountPercent == this.discountPercent &&
          other.discountAmount == this.discountAmount &&
          other.taxableAmount == this.taxableAmount &&
          other.taxPercent == this.taxPercent &&
          other.taxAmount == this.taxAmount &&
          other.lineTotal == this.lineTotal &&
          other.sortOrder == this.sortOrder);
}

class DocumentLineItemsCompanion extends UpdateCompanion<DocumentLineItem> {
  final Value<int> id;
  final Value<int> documentId;
  final Value<int?> itemId;
  final Value<String> itemName;
  final Value<String?> hsnSacCode;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double> pricePerUnit;
  final Value<double> discountPercent;
  final Value<double> discountAmount;
  final Value<double> taxableAmount;
  final Value<double> taxPercent;
  final Value<double> taxAmount;
  final Value<double> lineTotal;
  final Value<int> sortOrder;
  const DocumentLineItemsCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.hsnSacCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.taxPercent = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  DocumentLineItemsCompanion.insert({
    this.id = const Value.absent(),
    required int documentId,
    this.itemId = const Value.absent(),
    required String itemName,
    this.hsnSacCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxableAmount = const Value.absent(),
    this.taxPercent = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.sortOrder = const Value.absent(),
  })  : documentId = Value(documentId),
        itemName = Value(itemName);
  static Insertable<DocumentLineItem> custom({
    Expression<int>? id,
    Expression<int>? documentId,
    Expression<int>? itemId,
    Expression<String>? itemName,
    Expression<String>? hsnSacCode,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? pricePerUnit,
    Expression<double>? discountPercent,
    Expression<double>? discountAmount,
    Expression<double>? taxableAmount,
    Expression<double>? taxPercent,
    Expression<double>? taxAmount,
    Expression<double>? lineTotal,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (hsnSacCode != null) 'hsn_sac_code': hsnSacCode,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (taxableAmount != null) 'taxable_amount': taxableAmount,
      if (taxPercent != null) 'tax_percent': taxPercent,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (lineTotal != null) 'line_total': lineTotal,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  DocumentLineItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? documentId,
      Value<int?>? itemId,
      Value<String>? itemName,
      Value<String?>? hsnSacCode,
      Value<double>? quantity,
      Value<String>? unit,
      Value<double>? pricePerUnit,
      Value<double>? discountPercent,
      Value<double>? discountAmount,
      Value<double>? taxableAmount,
      Value<double>? taxPercent,
      Value<double>? taxAmount,
      Value<double>? lineTotal,
      Value<int>? sortOrder}) {
    return DocumentLineItemsCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      hsnSacCode: hsnSacCode ?? this.hsnSacCode,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      taxPercent: taxPercent ?? this.taxPercent,
      taxAmount: taxAmount ?? this.taxAmount,
      lineTotal: lineTotal ?? this.lineTotal,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (hsnSacCode.present) {
      map['hsn_sac_code'] = Variable<String>(hsnSacCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<double>(discountPercent.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (taxableAmount.present) {
      map['taxable_amount'] = Variable<double>(taxableAmount.value);
    }
    if (taxPercent.present) {
      map['tax_percent'] = Variable<double>(taxPercent.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentLineItemsCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('hsnSacCode: $hsnSacCode, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxableAmount: $taxableAmount, ')
          ..write('taxPercent: $taxPercent, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
      'document_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, documentId, amount, date, method, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}document_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;

  /// FK → documents.id (invoice type only)
  final int documentId;
  final double amount;
  final DateTime date;

  /// 'cash' | 'upi' | 'bank_transfer' | 'cheque' | 'other'
  final String method;
  final String? notes;
  final DateTime createdAt;
  const Payment(
      {required this.id,
      required this.documentId,
      required this.amount,
      required this.date,
      required this.method,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_id'] = Variable<int>(documentId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      documentId: Value(documentId),
      amount: Value(amount),
      date: Value(date),
      method: Value(method),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<int>(json['documentId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      method: serializer.fromJson<String>(json['method']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<int>(documentId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'method': serializer.toJson<String>(method),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Payment copyWith(
          {int? id,
          int? documentId,
          double? amount,
          DateTime? date,
          String? method,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      Payment(
        id: id ?? this.id,
        documentId: documentId ?? this.documentId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        method: method ?? this.method,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      method: data.method.present ? data.method.value : this.method,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, documentId, amount, date, method, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.method == this.method &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> documentId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> method;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int documentId,
    this.amount = const Value.absent(),
    required DateTime date,
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : documentId = Value(documentId),
        date = Value(date);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? documentId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? method,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (method != null) 'method': method,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? documentId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? method,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      method: method ?? this.method,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gstNumberMeta =
      const VerificationMeta('gstNumber');
  @override
  late final GeneratedColumn<String> gstNumber = GeneratedColumn<String>(
      'gst_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, phone, address, gstNumber, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('gst_number')) {
      context.handle(_gstNumberMeta,
          gstNumber.isAcceptableOrUnknown(data['gst_number']!, _gstNumberMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      gstNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gst_number']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String phone;
  final String? address;
  final String? gstNumber;
  final DateTime createdAt;
  const Supplier(
      {required this.id,
      required this.name,
      required this.phone,
      this.address,
      this.gstNumber,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || gstNumber != null) {
      map['gst_number'] = Variable<String>(gstNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      gstNumber: gstNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(gstNumber),
      createdAt: Value(createdAt),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      gstNumber: serializer.fromJson<String?>(json['gstNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String?>(address),
      'gstNumber': serializer.toJson<String?>(gstNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Supplier copyWith(
          {int? id,
          String? name,
          String? phone,
          Value<String?> address = const Value.absent(),
          Value<String?> gstNumber = const Value.absent(),
          DateTime? createdAt}) =>
      Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        address: address.present ? address.value : this.address,
        gstNumber: gstNumber.present ? gstNumber.value : this.gstNumber,
        createdAt: createdAt ?? this.createdAt,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      gstNumber: data.gstNumber.present ? data.gstNumber.value : this.gstNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, address, gstNumber, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.gstNumber == this.gstNumber &&
          other.createdAt == this.createdAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> address;
  final Value<String?> gstNumber;
  final Value<DateTime> createdAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    this.address = const Value.absent(),
    this.gstNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        phone = Value(phone);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? gstNumber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (gstNumber != null) 'gst_number': gstNumber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SuppliersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? phone,
      Value<String?>? address,
      Value<String?>? gstNumber,
      Value<DateTime>? createdAt}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gstNumber.present) {
      map['gst_number'] = Variable<String>(gstNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gstNumber: $gstNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseBillsTable extends PurchaseBills
    with TableInfo<$PurchaseBillsTable, PurchaseBill> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseBillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _billNumberMeta =
      const VerificationMeta('billNumber');
  @override
  late final GeneratedColumn<String> billNumber = GeneratedColumn<String>(
      'bill_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalTaxMeta =
      const VerificationMeta('totalTax');
  @override
  late final GeneratedColumn<double> totalTax = GeneratedColumn<double>(
      'total_tax', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _grandTotalMeta =
      const VerificationMeta('grandTotal');
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
      'grand_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountPaidMeta =
      const VerificationMeta('amountPaid');
  @override
  late final GeneratedColumn<double> amountPaid = GeneratedColumn<double>(
      'amount_paid', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _balanceDueMeta =
      const VerificationMeta('balanceDue');
  @override
  late final GeneratedColumn<double> balanceDue = GeneratedColumn<double>(
      'balance_due', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unpaid'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        billNumber,
        supplierId,
        date,
        subtotal,
        totalTax,
        grandTotal,
        amountPaid,
        balanceDue,
        status,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_bills';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseBill> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bill_number')) {
      context.handle(
          _billNumberMeta,
          billNumber.isAcceptableOrUnknown(
              data['bill_number']!, _billNumberMeta));
    } else if (isInserting) {
      context.missing(_billNumberMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('total_tax')) {
      context.handle(_totalTaxMeta,
          totalTax.isAcceptableOrUnknown(data['total_tax']!, _totalTaxMeta));
    } else if (isInserting) {
      context.missing(_totalTaxMeta);
    }
    if (data.containsKey('grand_total')) {
      context.handle(
          _grandTotalMeta,
          grandTotal.isAcceptableOrUnknown(
              data['grand_total']!, _grandTotalMeta));
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
          _amountPaidMeta,
          amountPaid.isAcceptableOrUnknown(
              data['amount_paid']!, _amountPaidMeta));
    }
    if (data.containsKey('balance_due')) {
      context.handle(
          _balanceDueMeta,
          balanceDue.isAcceptableOrUnknown(
              data['balance_due']!, _balanceDueMeta));
    } else if (isInserting) {
      context.missing(_balanceDueMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseBill map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseBill(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      billNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bill_number'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      totalTax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_tax'])!,
      grandTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}grand_total'])!,
      amountPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount_paid'])!,
      balanceDue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance_due'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PurchaseBillsTable createAlias(String alias) {
    return $PurchaseBillsTable(attachedDatabase, alias);
  }
}

class PurchaseBill extends DataClass implements Insertable<PurchaseBill> {
  final int id;
  final String billNumber;
  final int supplierId;
  final DateTime date;
  final double subtotal;
  final double totalTax;
  final double grandTotal;
  final double amountPaid;
  final double balanceDue;
  final String status;
  final String? notes;
  final DateTime createdAt;
  const PurchaseBill(
      {required this.id,
      required this.billNumber,
      required this.supplierId,
      required this.date,
      required this.subtotal,
      required this.totalTax,
      required this.grandTotal,
      required this.amountPaid,
      required this.balanceDue,
      required this.status,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bill_number'] = Variable<String>(billNumber);
    map['supplier_id'] = Variable<int>(supplierId);
    map['date'] = Variable<DateTime>(date);
    map['subtotal'] = Variable<double>(subtotal);
    map['total_tax'] = Variable<double>(totalTax);
    map['grand_total'] = Variable<double>(grandTotal);
    map['amount_paid'] = Variable<double>(amountPaid);
    map['balance_due'] = Variable<double>(balanceDue);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchaseBillsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseBillsCompanion(
      id: Value(id),
      billNumber: Value(billNumber),
      supplierId: Value(supplierId),
      date: Value(date),
      subtotal: Value(subtotal),
      totalTax: Value(totalTax),
      grandTotal: Value(grandTotal),
      amountPaid: Value(amountPaid),
      balanceDue: Value(balanceDue),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory PurchaseBill.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseBill(
      id: serializer.fromJson<int>(json['id']),
      billNumber: serializer.fromJson<String>(json['billNumber']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      date: serializer.fromJson<DateTime>(json['date']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      totalTax: serializer.fromJson<double>(json['totalTax']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      amountPaid: serializer.fromJson<double>(json['amountPaid']),
      balanceDue: serializer.fromJson<double>(json['balanceDue']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'billNumber': serializer.toJson<String>(billNumber),
      'supplierId': serializer.toJson<int>(supplierId),
      'date': serializer.toJson<DateTime>(date),
      'subtotal': serializer.toJson<double>(subtotal),
      'totalTax': serializer.toJson<double>(totalTax),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'amountPaid': serializer.toJson<double>(amountPaid),
      'balanceDue': serializer.toJson<double>(balanceDue),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchaseBill copyWith(
          {int? id,
          String? billNumber,
          int? supplierId,
          DateTime? date,
          double? subtotal,
          double? totalTax,
          double? grandTotal,
          double? amountPaid,
          double? balanceDue,
          String? status,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      PurchaseBill(
        id: id ?? this.id,
        billNumber: billNumber ?? this.billNumber,
        supplierId: supplierId ?? this.supplierId,
        date: date ?? this.date,
        subtotal: subtotal ?? this.subtotal,
        totalTax: totalTax ?? this.totalTax,
        grandTotal: grandTotal ?? this.grandTotal,
        amountPaid: amountPaid ?? this.amountPaid,
        balanceDue: balanceDue ?? this.balanceDue,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  PurchaseBill copyWithCompanion(PurchaseBillsCompanion data) {
    return PurchaseBill(
      id: data.id.present ? data.id.value : this.id,
      billNumber:
          data.billNumber.present ? data.billNumber.value : this.billNumber,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      date: data.date.present ? data.date.value : this.date,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      totalTax: data.totalTax.present ? data.totalTax.value : this.totalTax,
      grandTotal:
          data.grandTotal.present ? data.grandTotal.value : this.grandTotal,
      amountPaid:
          data.amountPaid.present ? data.amountPaid.value : this.amountPaid,
      balanceDue:
          data.balanceDue.present ? data.balanceDue.value : this.balanceDue,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseBill(')
          ..write('id: $id, ')
          ..write('billNumber: $billNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalTax: $totalTax, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('balanceDue: $balanceDue, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, billNumber, supplierId, date, subtotal,
      totalTax, grandTotal, amountPaid, balanceDue, status, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseBill &&
          other.id == this.id &&
          other.billNumber == this.billNumber &&
          other.supplierId == this.supplierId &&
          other.date == this.date &&
          other.subtotal == this.subtotal &&
          other.totalTax == this.totalTax &&
          other.grandTotal == this.grandTotal &&
          other.amountPaid == this.amountPaid &&
          other.balanceDue == this.balanceDue &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class PurchaseBillsCompanion extends UpdateCompanion<PurchaseBill> {
  final Value<int> id;
  final Value<String> billNumber;
  final Value<int> supplierId;
  final Value<DateTime> date;
  final Value<double> subtotal;
  final Value<double> totalTax;
  final Value<double> grandTotal;
  final Value<double> amountPaid;
  final Value<double> balanceDue;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const PurchaseBillsCompanion({
    this.id = const Value.absent(),
    this.billNumber = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.date = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalTax = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.balanceDue = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PurchaseBillsCompanion.insert({
    this.id = const Value.absent(),
    required String billNumber,
    required int supplierId,
    required DateTime date,
    required double subtotal,
    required double totalTax,
    required double grandTotal,
    this.amountPaid = const Value.absent(),
    required double balanceDue,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : billNumber = Value(billNumber),
        supplierId = Value(supplierId),
        date = Value(date),
        subtotal = Value(subtotal),
        totalTax = Value(totalTax),
        grandTotal = Value(grandTotal),
        balanceDue = Value(balanceDue);
  static Insertable<PurchaseBill> custom({
    Expression<int>? id,
    Expression<String>? billNumber,
    Expression<int>? supplierId,
    Expression<DateTime>? date,
    Expression<double>? subtotal,
    Expression<double>? totalTax,
    Expression<double>? grandTotal,
    Expression<double>? amountPaid,
    Expression<double>? balanceDue,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (billNumber != null) 'bill_number': billNumber,
      if (supplierId != null) 'supplier_id': supplierId,
      if (date != null) 'date': date,
      if (subtotal != null) 'subtotal': subtotal,
      if (totalTax != null) 'total_tax': totalTax,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (balanceDue != null) 'balance_due': balanceDue,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PurchaseBillsCompanion copyWith(
      {Value<int>? id,
      Value<String>? billNumber,
      Value<int>? supplierId,
      Value<DateTime>? date,
      Value<double>? subtotal,
      Value<double>? totalTax,
      Value<double>? grandTotal,
      Value<double>? amountPaid,
      Value<double>? balanceDue,
      Value<String>? status,
      Value<String?>? notes,
      Value<DateTime>? createdAt}) {
    return PurchaseBillsCompanion(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      supplierId: supplierId ?? this.supplierId,
      date: date ?? this.date,
      subtotal: subtotal ?? this.subtotal,
      totalTax: totalTax ?? this.totalTax,
      grandTotal: grandTotal ?? this.grandTotal,
      amountPaid: amountPaid ?? this.amountPaid,
      balanceDue: balanceDue ?? this.balanceDue,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (billNumber.present) {
      map['bill_number'] = Variable<String>(billNumber.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (totalTax.present) {
      map['total_tax'] = Variable<double>(totalTax.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<double>(amountPaid.value);
    }
    if (balanceDue.present) {
      map['balance_due'] = Variable<double>(balanceDue.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseBillsCompanion(')
          ..write('id: $id, ')
          ..write('billNumber: $billNumber, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalTax: $totalTax, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('balanceDue: $balanceDue, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PurchaseLineItemsTable extends PurchaseLineItems
    with TableInfo<$PurchaseLineItemsTable, PurchaseLineItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseLineItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _purchaseBillIdMeta =
      const VerificationMeta('purchaseBillId');
  @override
  late final GeneratedColumn<int> purchaseBillId = GeneratedColumn<int>(
      'purchase_bill_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES purchase_bills (id) ON DELETE CASCADE'));
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
      'item_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES items (id)'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _hsnSacCodeMeta =
      const VerificationMeta('hsnSacCode');
  @override
  late final GeneratedColumn<String> hsnSacCode = GeneratedColumn<String>(
      'hsn_sac_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Pcs'));
  static const VerificationMeta _pricePerUnitMeta =
      const VerificationMeta('pricePerUnit');
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
      'price_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        purchaseBillId,
        itemId,
        itemName,
        hsnSacCode,
        quantity,
        unit,
        pricePerUnit,
        taxAmount,
        lineTotal
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_line_items';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseLineItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_bill_id')) {
      context.handle(
          _purchaseBillIdMeta,
          purchaseBillId.isAcceptableOrUnknown(
              data['purchase_bill_id']!, _purchaseBillIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseBillIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('hsn_sac_code')) {
      context.handle(
          _hsnSacCodeMeta,
          hsnSacCode.isAcceptableOrUnknown(
              data['hsn_sac_code']!, _hsnSacCodeMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
          _pricePerUnitMeta,
          pricePerUnit.isAcceptableOrUnknown(
              data['price_per_unit']!, _pricePerUnitMeta));
    } else if (isInserting) {
      context.missing(_pricePerUnitMeta);
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseLineItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseLineItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      purchaseBillId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_bill_id'])!,
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_id']),
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      hsnSacCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hsn_sac_code']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      pricePerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_per_unit'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
    );
  }

  @override
  $PurchaseLineItemsTable createAlias(String alias) {
    return $PurchaseLineItemsTable(attachedDatabase, alias);
  }
}

class PurchaseLineItem extends DataClass
    implements Insertable<PurchaseLineItem> {
  final int id;
  final int purchaseBillId;
  final int? itemId;
  final String itemName;
  final String? hsnSacCode;
  final double quantity;
  final String unit;
  final double pricePerUnit;
  final double taxAmount;
  final double lineTotal;
  const PurchaseLineItem(
      {required this.id,
      required this.purchaseBillId,
      this.itemId,
      required this.itemName,
      this.hsnSacCode,
      required this.quantity,
      required this.unit,
      required this.pricePerUnit,
      required this.taxAmount,
      required this.lineTotal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_bill_id'] = Variable<int>(purchaseBillId);
    if (!nullToAbsent || itemId != null) {
      map['item_id'] = Variable<int>(itemId);
    }
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || hsnSacCode != null) {
      map['hsn_sac_code'] = Variable<String>(hsnSacCode);
    }
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['price_per_unit'] = Variable<double>(pricePerUnit);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['line_total'] = Variable<double>(lineTotal);
    return map;
  }

  PurchaseLineItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseLineItemsCompanion(
      id: Value(id),
      purchaseBillId: Value(purchaseBillId),
      itemId:
          itemId == null && nullToAbsent ? const Value.absent() : Value(itemId),
      itemName: Value(itemName),
      hsnSacCode: hsnSacCode == null && nullToAbsent
          ? const Value.absent()
          : Value(hsnSacCode),
      quantity: Value(quantity),
      unit: Value(unit),
      pricePerUnit: Value(pricePerUnit),
      taxAmount: Value(taxAmount),
      lineTotal: Value(lineTotal),
    );
  }

  factory PurchaseLineItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseLineItem(
      id: serializer.fromJson<int>(json['id']),
      purchaseBillId: serializer.fromJson<int>(json['purchaseBillId']),
      itemId: serializer.fromJson<int?>(json['itemId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      hsnSacCode: serializer.fromJson<String?>(json['hsnSacCode']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      pricePerUnit: serializer.fromJson<double>(json['pricePerUnit']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseBillId': serializer.toJson<int>(purchaseBillId),
      'itemId': serializer.toJson<int?>(itemId),
      'itemName': serializer.toJson<String>(itemName),
      'hsnSacCode': serializer.toJson<String?>(hsnSacCode),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'pricePerUnit': serializer.toJson<double>(pricePerUnit),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'lineTotal': serializer.toJson<double>(lineTotal),
    };
  }

  PurchaseLineItem copyWith(
          {int? id,
          int? purchaseBillId,
          Value<int?> itemId = const Value.absent(),
          String? itemName,
          Value<String?> hsnSacCode = const Value.absent(),
          double? quantity,
          String? unit,
          double? pricePerUnit,
          double? taxAmount,
          double? lineTotal}) =>
      PurchaseLineItem(
        id: id ?? this.id,
        purchaseBillId: purchaseBillId ?? this.purchaseBillId,
        itemId: itemId.present ? itemId.value : this.itemId,
        itemName: itemName ?? this.itemName,
        hsnSacCode: hsnSacCode.present ? hsnSacCode.value : this.hsnSacCode,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        pricePerUnit: pricePerUnit ?? this.pricePerUnit,
        taxAmount: taxAmount ?? this.taxAmount,
        lineTotal: lineTotal ?? this.lineTotal,
      );
  PurchaseLineItem copyWithCompanion(PurchaseLineItemsCompanion data) {
    return PurchaseLineItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseBillId: data.purchaseBillId.present
          ? data.purchaseBillId.value
          : this.purchaseBillId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      hsnSacCode:
          data.hsnSacCode.present ? data.hsnSacCode.value : this.hsnSacCode,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseLineItem(')
          ..write('id: $id, ')
          ..write('purchaseBillId: $purchaseBillId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('hsnSacCode: $hsnSacCode, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseBillId, itemId, itemName,
      hsnSacCode, quantity, unit, pricePerUnit, taxAmount, lineTotal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseLineItem &&
          other.id == this.id &&
          other.purchaseBillId == this.purchaseBillId &&
          other.itemId == this.itemId &&
          other.itemName == this.itemName &&
          other.hsnSacCode == this.hsnSacCode &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.pricePerUnit == this.pricePerUnit &&
          other.taxAmount == this.taxAmount &&
          other.lineTotal == this.lineTotal);
}

class PurchaseLineItemsCompanion extends UpdateCompanion<PurchaseLineItem> {
  final Value<int> id;
  final Value<int> purchaseBillId;
  final Value<int?> itemId;
  final Value<String> itemName;
  final Value<String?> hsnSacCode;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double> pricePerUnit;
  final Value<double> taxAmount;
  final Value<double> lineTotal;
  const PurchaseLineItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseBillId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.hsnSacCode = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.lineTotal = const Value.absent(),
  });
  PurchaseLineItemsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseBillId,
    this.itemId = const Value.absent(),
    required String itemName,
    this.hsnSacCode = const Value.absent(),
    required double quantity,
    this.unit = const Value.absent(),
    required double pricePerUnit,
    this.taxAmount = const Value.absent(),
    required double lineTotal,
  })  : purchaseBillId = Value(purchaseBillId),
        itemName = Value(itemName),
        quantity = Value(quantity),
        pricePerUnit = Value(pricePerUnit),
        lineTotal = Value(lineTotal);
  static Insertable<PurchaseLineItem> custom({
    Expression<int>? id,
    Expression<int>? purchaseBillId,
    Expression<int>? itemId,
    Expression<String>? itemName,
    Expression<String>? hsnSacCode,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? pricePerUnit,
    Expression<double>? taxAmount,
    Expression<double>? lineTotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseBillId != null) 'purchase_bill_id': purchaseBillId,
      if (itemId != null) 'item_id': itemId,
      if (itemName != null) 'item_name': itemName,
      if (hsnSacCode != null) 'hsn_sac_code': hsnSacCode,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (lineTotal != null) 'line_total': lineTotal,
    });
  }

  PurchaseLineItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? purchaseBillId,
      Value<int?>? itemId,
      Value<String>? itemName,
      Value<String?>? hsnSacCode,
      Value<double>? quantity,
      Value<String>? unit,
      Value<double>? pricePerUnit,
      Value<double>? taxAmount,
      Value<double>? lineTotal}) {
    return PurchaseLineItemsCompanion(
      id: id ?? this.id,
      purchaseBillId: purchaseBillId ?? this.purchaseBillId,
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      hsnSacCode: hsnSacCode ?? this.hsnSacCode,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      taxAmount: taxAmount ?? this.taxAmount,
      lineTotal: lineTotal ?? this.lineTotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseBillId.present) {
      map['purchase_bill_id'] = Variable<int>(purchaseBillId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (hsnSacCode.present) {
      map['hsn_sac_code'] = Variable<String>(hsnSacCode.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseLineItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseBillId: $purchaseBillId, ')
          ..write('itemId: $itemId, ')
          ..write('itemName: $itemName, ')
          ..write('hsnSacCode: $hsnSacCode, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('pricePerUnit: $pricePerUnit, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('lineTotal: $lineTotal')
          ..write(')'))
        .toString();
  }
}

class $PurchasePaymentsTable extends PurchasePayments
    with TableInfo<$PurchasePaymentsTable, PurchasePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _purchaseBillIdMeta =
      const VerificationMeta('purchaseBillId');
  @override
  late final GeneratedColumn<int> purchaseBillId = GeneratedColumn<int>(
      'purchase_bill_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES purchase_bills (id) ON DELETE CASCADE'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchaseBillId, amount, date, method, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_payments';
  @override
  VerificationContext validateIntegrity(Insertable<PurchasePayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('purchase_bill_id')) {
      context.handle(
          _purchaseBillIdMeta,
          purchaseBillId.isAcceptableOrUnknown(
              data['purchase_bill_id']!, _purchaseBillIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseBillIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchasePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchasePayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      purchaseBillId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_bill_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $PurchasePaymentsTable createAlias(String alias) {
    return $PurchasePaymentsTable(attachedDatabase, alias);
  }
}

class PurchasePayment extends DataClass implements Insertable<PurchasePayment> {
  final int id;
  final int purchaseBillId;
  final double amount;
  final DateTime date;
  final String method;
  final String? notes;
  const PurchasePayment(
      {required this.id,
      required this.purchaseBillId,
      required this.amount,
      required this.date,
      required this.method,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['purchase_bill_id'] = Variable<int>(purchaseBillId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PurchasePaymentsCompanion toCompanion(bool nullToAbsent) {
    return PurchasePaymentsCompanion(
      id: Value(id),
      purchaseBillId: Value(purchaseBillId),
      amount: Value(amount),
      date: Value(date),
      method: Value(method),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory PurchasePayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchasePayment(
      id: serializer.fromJson<int>(json['id']),
      purchaseBillId: serializer.fromJson<int>(json['purchaseBillId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      method: serializer.fromJson<String>(json['method']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'purchaseBillId': serializer.toJson<int>(purchaseBillId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'method': serializer.toJson<String>(method),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PurchasePayment copyWith(
          {int? id,
          int? purchaseBillId,
          double? amount,
          DateTime? date,
          String? method,
          Value<String?> notes = const Value.absent()}) =>
      PurchasePayment(
        id: id ?? this.id,
        purchaseBillId: purchaseBillId ?? this.purchaseBillId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        method: method ?? this.method,
        notes: notes.present ? notes.value : this.notes,
      );
  PurchasePayment copyWithCompanion(PurchasePaymentsCompanion data) {
    return PurchasePayment(
      id: data.id.present ? data.id.value : this.id,
      purchaseBillId: data.purchaseBillId.present
          ? data.purchaseBillId.value
          : this.purchaseBillId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      method: data.method.present ? data.method.value : this.method,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchasePayment(')
          ..write('id: $id, ')
          ..write('purchaseBillId: $purchaseBillId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseBillId, amount, date, method, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchasePayment &&
          other.id == this.id &&
          other.purchaseBillId == this.purchaseBillId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.method == this.method &&
          other.notes == this.notes);
}

class PurchasePaymentsCompanion extends UpdateCompanion<PurchasePayment> {
  final Value<int> id;
  final Value<int> purchaseBillId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> method;
  final Value<String?> notes;
  const PurchasePaymentsCompanion({
    this.id = const Value.absent(),
    this.purchaseBillId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PurchasePaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int purchaseBillId,
    required double amount,
    required DateTime date,
    required String method,
    this.notes = const Value.absent(),
  })  : purchaseBillId = Value(purchaseBillId),
        amount = Value(amount),
        date = Value(date),
        method = Value(method);
  static Insertable<PurchasePayment> custom({
    Expression<int>? id,
    Expression<int>? purchaseBillId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? method,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseBillId != null) 'purchase_bill_id': purchaseBillId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (method != null) 'method': method,
      if (notes != null) 'notes': notes,
    });
  }

  PurchasePaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? purchaseBillId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? method,
      Value<String?>? notes}) {
    return PurchasePaymentsCompanion(
      id: id ?? this.id,
      purchaseBillId: purchaseBillId ?? this.purchaseBillId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      method: method ?? this.method,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (purchaseBillId.present) {
      map['purchase_bill_id'] = Variable<int>(purchaseBillId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasePaymentsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseBillId: $purchaseBillId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BusinessProfileTable businessProfile =
      $BusinessProfileTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $DocumentLineItemsTable documentLineItems =
      $DocumentLineItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $PurchaseBillsTable purchaseBills = $PurchaseBillsTable(this);
  late final $PurchaseLineItemsTable purchaseLineItems =
      $PurchaseLineItemsTable(this);
  late final $PurchasePaymentsTable purchasePayments =
      $PurchasePaymentsTable(this);
  late final BusinessProfileDao businessProfileDao =
      BusinessProfileDao(this as AppDatabase);
  late final CustomersDao customersDao = CustomersDao(this as AppDatabase);
  late final ItemsDao itemsDao = ItemsDao(this as AppDatabase);
  late final DocumentsDao documentsDao = DocumentsDao(this as AppDatabase);
  late final PaymentsDao paymentsDao = PaymentsDao(this as AppDatabase);
  late final SuppliersDao suppliersDao = SuppliersDao(this as AppDatabase);
  late final PurchaseBillsDao purchaseBillsDao =
      PurchaseBillsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        businessProfile,
        customers,
        items,
        documents,
        documentLineItems,
        payments,
        suppliers,
        purchaseBills,
        purchaseLineItems,
        purchasePayments
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('purchase_bills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('purchase_line_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('purchase_bills',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('purchase_payments', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$BusinessProfileTableCreateCompanionBuilder = BusinessProfileCompanion
    Function({
  Value<int> id,
  required String businessName,
  Value<String?> addressLine,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> panNumber,
  Value<String?> gstNumber,
  Value<String?> logoPath,
  Value<String?> signaturePath,
  Value<String?> bankName,
  Value<String?> bankAccountNo,
  Value<String?> bankIfsc,
  Value<String?> bankBranchAddress,
  Value<DateTime> updatedAt,
});
typedef $$BusinessProfileTableUpdateCompanionBuilder = BusinessProfileCompanion
    Function({
  Value<int> id,
  Value<String> businessName,
  Value<String?> addressLine,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> panNumber,
  Value<String?> gstNumber,
  Value<String?> logoPath,
  Value<String?> signaturePath,
  Value<String?> bankName,
  Value<String?> bankAccountNo,
  Value<String?> bankIfsc,
  Value<String?> bankBranchAddress,
  Value<DateTime> updatedAt,
});

class $$BusinessProfileTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get addressLine => $composableBuilder(
      column: $table.addressLine, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get panNumber => $composableBuilder(
      column: $table.panNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstNumber => $composableBuilder(
      column: $table.gstNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get signaturePath => $composableBuilder(
      column: $table.signaturePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankAccountNo => $composableBuilder(
      column: $table.bankAccountNo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankIfsc => $composableBuilder(
      column: $table.bankIfsc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bankBranchAddress => $composableBuilder(
      column: $table.bankBranchAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BusinessProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessName => $composableBuilder(
      column: $table.businessName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get addressLine => $composableBuilder(
      column: $table.addressLine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get panNumber => $composableBuilder(
      column: $table.panNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstNumber => $composableBuilder(
      column: $table.gstNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoPath => $composableBuilder(
      column: $table.logoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get signaturePath => $composableBuilder(
      column: $table.signaturePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankName => $composableBuilder(
      column: $table.bankName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankAccountNo => $composableBuilder(
      column: $table.bankAccountNo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankIfsc => $composableBuilder(
      column: $table.bankIfsc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankBranchAddress => $composableBuilder(
      column: $table.bankBranchAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BusinessProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessProfileTable> {
  $$BusinessProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
      column: $table.businessName, builder: (column) => column);

  GeneratedColumn<String> get addressLine => $composableBuilder(
      column: $table.addressLine, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get panNumber =>
      $composableBuilder(column: $table.panNumber, builder: (column) => column);

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get signaturePath => $composableBuilder(
      column: $table.signaturePath, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get bankAccountNo => $composableBuilder(
      column: $table.bankAccountNo, builder: (column) => column);

  GeneratedColumn<String> get bankIfsc =>
      $composableBuilder(column: $table.bankIfsc, builder: (column) => column);

  GeneratedColumn<String> get bankBranchAddress => $composableBuilder(
      column: $table.bankBranchAddress, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BusinessProfileTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BusinessProfileTable,
    BusinessProfileData,
    $$BusinessProfileTableFilterComposer,
    $$BusinessProfileTableOrderingComposer,
    $$BusinessProfileTableAnnotationComposer,
    $$BusinessProfileTableCreateCompanionBuilder,
    $$BusinessProfileTableUpdateCompanionBuilder,
    (
      BusinessProfileData,
      BaseReferences<_$AppDatabase, $BusinessProfileTable, BusinessProfileData>
    ),
    BusinessProfileData,
    PrefetchHooks Function()> {
  $$BusinessProfileTableTableManager(
      _$AppDatabase db, $BusinessProfileTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> businessName = const Value.absent(),
            Value<String?> addressLine = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> panNumber = const Value.absent(),
            Value<String?> gstNumber = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> signaturePath = const Value.absent(),
            Value<String?> bankName = const Value.absent(),
            Value<String?> bankAccountNo = const Value.absent(),
            Value<String?> bankIfsc = const Value.absent(),
            Value<String?> bankBranchAddress = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              BusinessProfileCompanion(
            id: id,
            businessName: businessName,
            addressLine: addressLine,
            phone: phone,
            email: email,
            panNumber: panNumber,
            gstNumber: gstNumber,
            logoPath: logoPath,
            signaturePath: signaturePath,
            bankName: bankName,
            bankAccountNo: bankAccountNo,
            bankIfsc: bankIfsc,
            bankBranchAddress: bankBranchAddress,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String businessName,
            Value<String?> addressLine = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> panNumber = const Value.absent(),
            Value<String?> gstNumber = const Value.absent(),
            Value<String?> logoPath = const Value.absent(),
            Value<String?> signaturePath = const Value.absent(),
            Value<String?> bankName = const Value.absent(),
            Value<String?> bankAccountNo = const Value.absent(),
            Value<String?> bankIfsc = const Value.absent(),
            Value<String?> bankBranchAddress = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              BusinessProfileCompanion.insert(
            id: id,
            businessName: businessName,
            addressLine: addressLine,
            phone: phone,
            email: email,
            panNumber: panNumber,
            gstNumber: gstNumber,
            logoPath: logoPath,
            signaturePath: signaturePath,
            bankName: bankName,
            bankAccountNo: bankAccountNo,
            bankIfsc: bankIfsc,
            bankBranchAddress: bankBranchAddress,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BusinessProfileTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BusinessProfileTable,
    BusinessProfileData,
    $$BusinessProfileTableFilterComposer,
    $$BusinessProfileTableOrderingComposer,
    $$BusinessProfileTableAnnotationComposer,
    $$BusinessProfileTableCreateCompanionBuilder,
    $$BusinessProfileTableUpdateCompanionBuilder,
    (
      BusinessProfileData,
      BaseReferences<_$AppDatabase, $BusinessProfileTable, BusinessProfileData>
    ),
    BusinessProfileData,
    PrefetchHooks Function()>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> gstNumber,
  Value<DateTime> createdAt,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> gstNumber,
  Value<DateTime> createdAt,
});

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstNumber => $composableBuilder(
      column: $table.gstNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstNumber => $composableBuilder(
      column: $table.gstNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> gstNumber = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            gstNumber: gstNumber,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> gstNumber = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            gstNumber: gstNumber,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, BaseReferences<_$AppDatabase, $CustomersTable, Customer>),
    Customer,
    PrefetchHooks Function()>;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> hsnSacCode,
  Value<String> defaultUnit,
  Value<double> defaultPrice,
  Value<double?> defaultTaxPercent,
  Value<DateTime> createdAt,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> hsnSacCode,
  Value<String> defaultUnit,
  Value<double> defaultPrice,
  Value<double?> defaultTaxPercent,
  Value<DateTime> createdAt,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchaseLineItemsTable, List<PurchaseLineItem>>
      _purchaseLineItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseLineItems,
              aliasName: $_aliasNameGenerator(
                  db.items.id, db.purchaseLineItems.itemId));

  $$PurchaseLineItemsTableProcessedTableManager get purchaseLineItemsRefs {
    final manager =
        $$PurchaseLineItemsTableTableManager($_db, $_db.purchaseLineItems)
            .filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_purchaseLineItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultPrice => $composableBuilder(
      column: $table.defaultPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get defaultTaxPercent => $composableBuilder(
      column: $table.defaultTaxPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> purchaseLineItemsRefs(
      Expression<bool> Function($$PurchaseLineItemsTableFilterComposer f) f) {
    final $$PurchaseLineItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseLineItems,
        getReferencedColumn: (t) => t.itemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseLineItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseLineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultPrice => $composableBuilder(
      column: $table.defaultPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get defaultTaxPercent => $composableBuilder(
      column: $table.defaultTaxPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
      column: $table.defaultUnit, builder: (column) => column);

  GeneratedColumn<double> get defaultPrice => $composableBuilder(
      column: $table.defaultPrice, builder: (column) => column);

  GeneratedColumn<double> get defaultTaxPercent => $composableBuilder(
      column: $table.defaultTaxPercent, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> purchaseLineItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseLineItemsTableAnnotationComposer a) f) {
    final $$PurchaseLineItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.purchaseLineItems,
            getReferencedColumn: (t) => t.itemId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PurchaseLineItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.purchaseLineItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function({bool purchaseLineItemsRefs})> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> hsnSacCode = const Value.absent(),
            Value<String> defaultUnit = const Value.absent(),
            Value<double> defaultPrice = const Value.absent(),
            Value<double?> defaultTaxPercent = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            name: name,
            hsnSacCode: hsnSacCode,
            defaultUnit: defaultUnit,
            defaultPrice: defaultPrice,
            defaultTaxPercent: defaultTaxPercent,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> hsnSacCode = const Value.absent(),
            Value<String> defaultUnit = const Value.absent(),
            Value<double> defaultPrice = const Value.absent(),
            Value<double?> defaultTaxPercent = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            name: name,
            hsnSacCode: hsnSacCode,
            defaultUnit: defaultUnit,
            defaultPrice: defaultPrice,
            defaultTaxPercent: defaultTaxPercent,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ItemsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({purchaseLineItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseLineItemsRefs) db.purchaseLineItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseLineItemsRefs)
                    await $_getPrefetchedData<Item, $ItemsTable,
                            PurchaseLineItem>(
                        currentTable: table,
                        referencedTable: $$ItemsTableReferences
                            ._purchaseLineItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemsTableReferences(db, table, p0)
                                .purchaseLineItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.itemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function({bool purchaseLineItemsRefs})>;
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  required String documentNumber,
  required String type,
  Value<int?> customerId,
  required String customerName,
  Value<String?> customerPhone,
  Value<String?> customerAddress,
  Value<String?> customerGstNumber,
  required DateTime date,
  Value<DateTime?> dueDate,
  Value<String?> placeOfSupply,
  Value<double> subtotal,
  Value<double> totalDiscount,
  Value<double> totalTax,
  Value<double> grandTotal,
  Value<double?> amountReceived,
  Value<double?> balanceDue,
  Value<String?> amountInWords,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<String> documentNumber,
  Value<String> type,
  Value<int?> customerId,
  Value<String> customerName,
  Value<String?> customerPhone,
  Value<String?> customerAddress,
  Value<String?> customerGstNumber,
  Value<DateTime> date,
  Value<DateTime?> dueDate,
  Value<String?> placeOfSupply,
  Value<double> subtotal,
  Value<double> totalDiscount,
  Value<double> totalTax,
  Value<double> grandTotal,
  Value<double?> amountReceived,
  Value<double?> balanceDue,
  Value<String?> amountInWords,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerGstNumber => $composableBuilder(
      column: $table.customerGstNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get placeOfSupply => $composableBuilder(
      column: $table.placeOfSupply, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalDiscount => $composableBuilder(
      column: $table.totalDiscount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalTax => $composableBuilder(
      column: $table.totalTax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balanceDue => $composableBuilder(
      column: $table.balanceDue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amountInWords => $composableBuilder(
      column: $table.amountInWords, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerGstNumber => $composableBuilder(
      column: $table.customerGstNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
      column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get placeOfSupply => $composableBuilder(
      column: $table.placeOfSupply,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalDiscount => $composableBuilder(
      column: $table.totalDiscount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalTax => $composableBuilder(
      column: $table.totalTax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balanceDue => $composableBuilder(
      column: $table.balanceDue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amountInWords => $composableBuilder(
      column: $table.amountInWords,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress, builder: (column) => column);

  GeneratedColumn<String> get customerGstNumber => $composableBuilder(
      column: $table.customerGstNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get placeOfSupply => $composableBuilder(
      column: $table.placeOfSupply, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get totalDiscount => $composableBuilder(
      column: $table.totalDiscount, builder: (column) => column);

  GeneratedColumn<double> get totalTax =>
      $composableBuilder(column: $table.totalTax, builder: (column) => column);

  GeneratedColumn<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => column);

  GeneratedColumn<double> get amountReceived => $composableBuilder(
      column: $table.amountReceived, builder: (column) => column);

  GeneratedColumn<double> get balanceDue => $composableBuilder(
      column: $table.balanceDue, builder: (column) => column);

  GeneratedColumn<String> get amountInWords => $composableBuilder(
      column: $table.amountInWords, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()> {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> documentNumber = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<String> customerName = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> customerAddress = const Value.absent(),
            Value<String?> customerGstNumber = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> placeOfSupply = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> totalDiscount = const Value.absent(),
            Value<double> totalTax = const Value.absent(),
            Value<double> grandTotal = const Value.absent(),
            Value<double?> amountReceived = const Value.absent(),
            Value<double?> balanceDue = const Value.absent(),
            Value<String?> amountInWords = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DocumentsCompanion(
            id: id,
            documentNumber: documentNumber,
            type: type,
            customerId: customerId,
            customerName: customerName,
            customerPhone: customerPhone,
            customerAddress: customerAddress,
            customerGstNumber: customerGstNumber,
            date: date,
            dueDate: dueDate,
            placeOfSupply: placeOfSupply,
            subtotal: subtotal,
            totalDiscount: totalDiscount,
            totalTax: totalTax,
            grandTotal: grandTotal,
            amountReceived: amountReceived,
            balanceDue: balanceDue,
            amountInWords: amountInWords,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String documentNumber,
            required String type,
            Value<int?> customerId = const Value.absent(),
            required String customerName,
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> customerAddress = const Value.absent(),
            Value<String?> customerGstNumber = const Value.absent(),
            required DateTime date,
            Value<DateTime?> dueDate = const Value.absent(),
            Value<String?> placeOfSupply = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> totalDiscount = const Value.absent(),
            Value<double> totalTax = const Value.absent(),
            Value<double> grandTotal = const Value.absent(),
            Value<double?> amountReceived = const Value.absent(),
            Value<double?> balanceDue = const Value.absent(),
            Value<String?> amountInWords = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DocumentsCompanion.insert(
            id: id,
            documentNumber: documentNumber,
            type: type,
            customerId: customerId,
            customerName: customerName,
            customerPhone: customerPhone,
            customerAddress: customerAddress,
            customerGstNumber: customerGstNumber,
            date: date,
            dueDate: dueDate,
            placeOfSupply: placeOfSupply,
            subtotal: subtotal,
            totalDiscount: totalDiscount,
            totalTax: totalTax,
            grandTotal: grandTotal,
            amountReceived: amountReceived,
            balanceDue: balanceDue,
            amountInWords: amountInWords,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, BaseReferences<_$AppDatabase, $DocumentsTable, Document>),
    Document,
    PrefetchHooks Function()>;
typedef $$DocumentLineItemsTableCreateCompanionBuilder
    = DocumentLineItemsCompanion Function({
  Value<int> id,
  required int documentId,
  Value<int?> itemId,
  required String itemName,
  Value<String?> hsnSacCode,
  Value<double> quantity,
  Value<String> unit,
  Value<double> pricePerUnit,
  Value<double> discountPercent,
  Value<double> discountAmount,
  Value<double> taxableAmount,
  Value<double> taxPercent,
  Value<double> taxAmount,
  Value<double> lineTotal,
  Value<int> sortOrder,
});
typedef $$DocumentLineItemsTableUpdateCompanionBuilder
    = DocumentLineItemsCompanion Function({
  Value<int> id,
  Value<int> documentId,
  Value<int?> itemId,
  Value<String> itemName,
  Value<String?> hsnSacCode,
  Value<double> quantity,
  Value<String> unit,
  Value<double> pricePerUnit,
  Value<double> discountPercent,
  Value<double> discountAmount,
  Value<double> taxableAmount,
  Value<double> taxPercent,
  Value<double> taxAmount,
  Value<double> lineTotal,
  Value<int> sortOrder,
});

class $$DocumentLineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentLineItemsTable> {
  $$DocumentLineItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountPercent => $composableBuilder(
      column: $table.discountPercent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxableAmount => $composableBuilder(
      column: $table.taxableAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxPercent => $composableBuilder(
      column: $table.taxPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$DocumentLineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentLineItemsTable> {
  $$DocumentLineItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get itemId => $composableBuilder(
      column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountPercent => $composableBuilder(
      column: $table.discountPercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxableAmount => $composableBuilder(
      column: $table.taxableAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxPercent => $composableBuilder(
      column: $table.taxPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$DocumentLineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentLineItemsTable> {
  $$DocumentLineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => column);

  GeneratedColumn<double> get discountPercent => $composableBuilder(
      column: $table.discountPercent, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<double> get taxableAmount => $composableBuilder(
      column: $table.taxableAmount, builder: (column) => column);

  GeneratedColumn<double> get taxPercent => $composableBuilder(
      column: $table.taxPercent, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DocumentLineItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentLineItemsTable,
    DocumentLineItem,
    $$DocumentLineItemsTableFilterComposer,
    $$DocumentLineItemsTableOrderingComposer,
    $$DocumentLineItemsTableAnnotationComposer,
    $$DocumentLineItemsTableCreateCompanionBuilder,
    $$DocumentLineItemsTableUpdateCompanionBuilder,
    (
      DocumentLineItem,
      BaseReferences<_$AppDatabase, $DocumentLineItemsTable, DocumentLineItem>
    ),
    DocumentLineItem,
    PrefetchHooks Function()> {
  $$DocumentLineItemsTableTableManager(
      _$AppDatabase db, $DocumentLineItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentLineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentLineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentLineItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> documentId = const Value.absent(),
            Value<int?> itemId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<String?> hsnSacCode = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> pricePerUnit = const Value.absent(),
            Value<double> discountPercent = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxableAmount = const Value.absent(),
            Value<double> taxPercent = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              DocumentLineItemsCompanion(
            id: id,
            documentId: documentId,
            itemId: itemId,
            itemName: itemName,
            hsnSacCode: hsnSacCode,
            quantity: quantity,
            unit: unit,
            pricePerUnit: pricePerUnit,
            discountPercent: discountPercent,
            discountAmount: discountAmount,
            taxableAmount: taxableAmount,
            taxPercent: taxPercent,
            taxAmount: taxAmount,
            lineTotal: lineTotal,
            sortOrder: sortOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int documentId,
            Value<int?> itemId = const Value.absent(),
            required String itemName,
            Value<String?> hsnSacCode = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> pricePerUnit = const Value.absent(),
            Value<double> discountPercent = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxableAmount = const Value.absent(),
            Value<double> taxPercent = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
          }) =>
              DocumentLineItemsCompanion.insert(
            id: id,
            documentId: documentId,
            itemId: itemId,
            itemName: itemName,
            hsnSacCode: hsnSacCode,
            quantity: quantity,
            unit: unit,
            pricePerUnit: pricePerUnit,
            discountPercent: discountPercent,
            discountAmount: discountAmount,
            taxableAmount: taxableAmount,
            taxPercent: taxPercent,
            taxAmount: taxAmount,
            lineTotal: lineTotal,
            sortOrder: sortOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentLineItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentLineItemsTable,
    DocumentLineItem,
    $$DocumentLineItemsTableFilterComposer,
    $$DocumentLineItemsTableOrderingComposer,
    $$DocumentLineItemsTableAnnotationComposer,
    $$DocumentLineItemsTableCreateCompanionBuilder,
    $$DocumentLineItemsTableUpdateCompanionBuilder,
    (
      DocumentLineItem,
      BaseReferences<_$AppDatabase, $DocumentLineItemsTable, DocumentLineItem>
    ),
    DocumentLineItem,
    PrefetchHooks Function()>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required int documentId,
  Value<double> amount,
  required DateTime date,
  Value<String> method,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int> documentId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> method,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> documentId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            documentId: documentId,
            amount: amount,
            date: date,
            method: method,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int documentId,
            Value<double> amount = const Value.absent(),
            required DateTime date,
            Value<String> method = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            documentId: documentId,
            amount: amount,
            date: date,
            method: method,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  required String name,
  required String phone,
  Value<String?> address,
  Value<String?> gstNumber,
  Value<DateTime> createdAt,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> phone,
  Value<String?> address,
  Value<String?> gstNumber,
  Value<DateTime> createdAt,
});

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PurchaseBillsTable, List<PurchaseBill>>
      _purchaseBillsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseBills,
              aliasName: $_aliasNameGenerator(
                  db.suppliers.id, db.purchaseBills.supplierId));

  $$PurchaseBillsTableProcessedTableManager get purchaseBillsRefs {
    final manager = $$PurchaseBillsTableTableManager($_db, $_db.purchaseBills)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseBillsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gstNumber => $composableBuilder(
      column: $table.gstNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> purchaseBillsRefs(
      Expression<bool> Function($$PurchaseBillsTableFilterComposer f) f) {
    final $$PurchaseBillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gstNumber => $composableBuilder(
      column: $table.gstNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get gstNumber =>
      $composableBuilder(column: $table.gstNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> purchaseBillsRefs<T extends Object>(
      Expression<T> Function($$PurchaseBillsTableAnnotationComposer a) f) {
    final $$PurchaseBillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool purchaseBillsRefs})> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> gstNumber = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            phone: phone,
            address: address,
            gstNumber: gstNumber,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String phone,
            Value<String?> address = const Value.absent(),
            Value<String?> gstNumber = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            address: address,
            gstNumber: gstNumber,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SuppliersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({purchaseBillsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseBillsRefs) db.purchaseBills
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseBillsRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            PurchaseBill>(
                        currentTable: table,
                        referencedTable: $$SuppliersTableReferences
                            ._purchaseBillsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .purchaseBillsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function({bool purchaseBillsRefs})>;
typedef $$PurchaseBillsTableCreateCompanionBuilder = PurchaseBillsCompanion
    Function({
  Value<int> id,
  required String billNumber,
  required int supplierId,
  required DateTime date,
  required double subtotal,
  required double totalTax,
  required double grandTotal,
  Value<double> amountPaid,
  required double balanceDue,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
});
typedef $$PurchaseBillsTableUpdateCompanionBuilder = PurchaseBillsCompanion
    Function({
  Value<int> id,
  Value<String> billNumber,
  Value<int> supplierId,
  Value<DateTime> date,
  Value<double> subtotal,
  Value<double> totalTax,
  Value<double> grandTotal,
  Value<double> amountPaid,
  Value<double> balanceDue,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
});

final class $$PurchaseBillsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseBillsTable, PurchaseBill> {
  $$PurchaseBillsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias(
          $_aliasNameGenerator(db.purchaseBills.supplierId, db.suppliers.id));

  $$SuppliersTableProcessedTableManager get supplierId {
    final $_column = $_itemColumn<int>('supplier_id')!;

    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PurchaseLineItemsTable, List<PurchaseLineItem>>
      _purchaseLineItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseLineItems,
              aliasName: $_aliasNameGenerator(
                  db.purchaseBills.id, db.purchaseLineItems.purchaseBillId));

  $$PurchaseLineItemsTableProcessedTableManager get purchaseLineItemsRefs {
    final manager = $$PurchaseLineItemsTableTableManager(
            $_db, $_db.purchaseLineItems)
        .filter((f) => f.purchaseBillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_purchaseLineItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchasePaymentsTable, List<PurchasePayment>>
      _purchasePaymentsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchasePayments,
              aliasName: $_aliasNameGenerator(
                  db.purchaseBills.id, db.purchasePayments.purchaseBillId));

  $$PurchasePaymentsTableProcessedTableManager get purchasePaymentsRefs {
    final manager = $$PurchasePaymentsTableTableManager(
            $_db, $_db.purchasePayments)
        .filter((f) => f.purchaseBillId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_purchasePaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PurchaseBillsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseBillsTable> {
  $$PurchaseBillsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalTax => $composableBuilder(
      column: $table.totalTax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balanceDue => $composableBuilder(
      column: $table.balanceDue, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> purchaseLineItemsRefs(
      Expression<bool> Function($$PurchaseLineItemsTableFilterComposer f) f) {
    final $$PurchaseLineItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseLineItems,
        getReferencedColumn: (t) => t.purchaseBillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseLineItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseLineItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchasePaymentsRefs(
      Expression<bool> Function($$PurchasePaymentsTableFilterComposer f) f) {
    final $$PurchasePaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchasePayments,
        getReferencedColumn: (t) => t.purchaseBillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasePaymentsTableFilterComposer(
              $db: $db,
              $table: $db.purchasePayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchaseBillsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseBillsTable> {
  $$PurchaseBillsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalTax => $composableBuilder(
      column: $table.totalTax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balanceDue => $composableBuilder(
      column: $table.balanceDue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseBillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseBillsTable> {
  $$PurchaseBillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get billNumber => $composableBuilder(
      column: $table.billNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get totalTax =>
      $composableBuilder(column: $table.totalTax, builder: (column) => column);

  GeneratedColumn<double> get grandTotal => $composableBuilder(
      column: $table.grandTotal, builder: (column) => column);

  GeneratedColumn<double> get amountPaid => $composableBuilder(
      column: $table.amountPaid, builder: (column) => column);

  GeneratedColumn<double> get balanceDue => $composableBuilder(
      column: $table.balanceDue, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> purchaseLineItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseLineItemsTableAnnotationComposer a) f) {
    final $$PurchaseLineItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.purchaseLineItems,
            getReferencedColumn: (t) => t.purchaseBillId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PurchaseLineItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.purchaseLineItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> purchasePaymentsRefs<T extends Object>(
      Expression<T> Function($$PurchasePaymentsTableAnnotationComposer a) f) {
    final $$PurchasePaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchasePayments,
        getReferencedColumn: (t) => t.purchaseBillId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasePaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchasePayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchaseBillsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseBillsTable,
    PurchaseBill,
    $$PurchaseBillsTableFilterComposer,
    $$PurchaseBillsTableOrderingComposer,
    $$PurchaseBillsTableAnnotationComposer,
    $$PurchaseBillsTableCreateCompanionBuilder,
    $$PurchaseBillsTableUpdateCompanionBuilder,
    (PurchaseBill, $$PurchaseBillsTableReferences),
    PurchaseBill,
    PrefetchHooks Function(
        {bool supplierId,
        bool purchaseLineItemsRefs,
        bool purchasePaymentsRefs})> {
  $$PurchaseBillsTableTableManager(_$AppDatabase db, $PurchaseBillsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseBillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseBillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseBillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> billNumber = const Value.absent(),
            Value<int> supplierId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> totalTax = const Value.absent(),
            Value<double> grandTotal = const Value.absent(),
            Value<double> amountPaid = const Value.absent(),
            Value<double> balanceDue = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchaseBillsCompanion(
            id: id,
            billNumber: billNumber,
            supplierId: supplierId,
            date: date,
            subtotal: subtotal,
            totalTax: totalTax,
            grandTotal: grandTotal,
            amountPaid: amountPaid,
            balanceDue: balanceDue,
            status: status,
            notes: notes,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String billNumber,
            required int supplierId,
            required DateTime date,
            required double subtotal,
            required double totalTax,
            required double grandTotal,
            Value<double> amountPaid = const Value.absent(),
            required double balanceDue,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PurchaseBillsCompanion.insert(
            id: id,
            billNumber: billNumber,
            supplierId: supplierId,
            date: date,
            subtotal: subtotal,
            totalTax: totalTax,
            grandTotal: grandTotal,
            amountPaid: amountPaid,
            balanceDue: balanceDue,
            status: status,
            notes: notes,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchaseBillsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {supplierId = false,
              purchaseLineItemsRefs = false,
              purchasePaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseLineItemsRefs) db.purchaseLineItems,
                if (purchasePaymentsRefs) db.purchasePayments
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$PurchaseBillsTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$PurchaseBillsTableReferences._supplierIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseLineItemsRefs)
                    await $_getPrefetchedData<PurchaseBill, $PurchaseBillsTable,
                            PurchaseLineItem>(
                        currentTable: table,
                        referencedTable: $$PurchaseBillsTableReferences
                            ._purchaseLineItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PurchaseBillsTableReferences(db, table, p0)
                                .purchaseLineItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.purchaseBillId == item.id),
                        typedResults: items),
                  if (purchasePaymentsRefs)
                    await $_getPrefetchedData<PurchaseBill, $PurchaseBillsTable,
                            PurchasePayment>(
                        currentTable: table,
                        referencedTable: $$PurchaseBillsTableReferences
                            ._purchasePaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PurchaseBillsTableReferences(db, table, p0)
                                .purchasePaymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.purchaseBillId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PurchaseBillsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseBillsTable,
    PurchaseBill,
    $$PurchaseBillsTableFilterComposer,
    $$PurchaseBillsTableOrderingComposer,
    $$PurchaseBillsTableAnnotationComposer,
    $$PurchaseBillsTableCreateCompanionBuilder,
    $$PurchaseBillsTableUpdateCompanionBuilder,
    (PurchaseBill, $$PurchaseBillsTableReferences),
    PurchaseBill,
    PrefetchHooks Function(
        {bool supplierId,
        bool purchaseLineItemsRefs,
        bool purchasePaymentsRefs})>;
typedef $$PurchaseLineItemsTableCreateCompanionBuilder
    = PurchaseLineItemsCompanion Function({
  Value<int> id,
  required int purchaseBillId,
  Value<int?> itemId,
  required String itemName,
  Value<String?> hsnSacCode,
  required double quantity,
  Value<String> unit,
  required double pricePerUnit,
  Value<double> taxAmount,
  required double lineTotal,
});
typedef $$PurchaseLineItemsTableUpdateCompanionBuilder
    = PurchaseLineItemsCompanion Function({
  Value<int> id,
  Value<int> purchaseBillId,
  Value<int?> itemId,
  Value<String> itemName,
  Value<String?> hsnSacCode,
  Value<double> quantity,
  Value<String> unit,
  Value<double> pricePerUnit,
  Value<double> taxAmount,
  Value<double> lineTotal,
});

final class $$PurchaseLineItemsTableReferences extends BaseReferences<
    _$AppDatabase, $PurchaseLineItemsTable, PurchaseLineItem> {
  $$PurchaseLineItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PurchaseBillsTable _purchaseBillIdTable(_$AppDatabase db) =>
      db.purchaseBills.createAlias($_aliasNameGenerator(
          db.purchaseLineItems.purchaseBillId, db.purchaseBills.id));

  $$PurchaseBillsTableProcessedTableManager get purchaseBillId {
    final $_column = $_itemColumn<int>('purchase_bill_id')!;

    final manager = $$PurchaseBillsTableTableManager($_db, $_db.purchaseBills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseBillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemsTable _itemIdTable(_$AppDatabase db) => db.items.createAlias(
      $_aliasNameGenerator(db.purchaseLineItems.itemId, db.items.id));

  $$ItemsTableProcessedTableManager? get itemId {
    final $_column = $_itemColumn<int>('item_id');
    if ($_column == null) return null;
    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PurchaseLineItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseLineItemsTable> {
  $$PurchaseLineItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  $$PurchaseBillsTableFilterComposer get purchaseBillId {
    final $$PurchaseBillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseBillId,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseLineItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseLineItemsTable> {
  $$PurchaseLineItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  $$PurchaseBillsTableOrderingComposer get purchaseBillId {
    final $$PurchaseBillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseBillId,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableOrderingComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableOrderingComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseLineItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseLineItemsTable> {
  $$PurchaseLineItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get hsnSacCode => $composableBuilder(
      column: $table.hsnSacCode, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
      column: $table.pricePerUnit, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  $$PurchaseBillsTableAnnotationComposer get purchaseBillId {
    final $$PurchaseBillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseBillId,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemId,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseLineItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseLineItemsTable,
    PurchaseLineItem,
    $$PurchaseLineItemsTableFilterComposer,
    $$PurchaseLineItemsTableOrderingComposer,
    $$PurchaseLineItemsTableAnnotationComposer,
    $$PurchaseLineItemsTableCreateCompanionBuilder,
    $$PurchaseLineItemsTableUpdateCompanionBuilder,
    (PurchaseLineItem, $$PurchaseLineItemsTableReferences),
    PurchaseLineItem,
    PrefetchHooks Function({bool purchaseBillId, bool itemId})> {
  $$PurchaseLineItemsTableTableManager(
      _$AppDatabase db, $PurchaseLineItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseLineItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseLineItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseLineItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> purchaseBillId = const Value.absent(),
            Value<int?> itemId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<String?> hsnSacCode = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> pricePerUnit = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
          }) =>
              PurchaseLineItemsCompanion(
            id: id,
            purchaseBillId: purchaseBillId,
            itemId: itemId,
            itemName: itemName,
            hsnSacCode: hsnSacCode,
            quantity: quantity,
            unit: unit,
            pricePerUnit: pricePerUnit,
            taxAmount: taxAmount,
            lineTotal: lineTotal,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int purchaseBillId,
            Value<int?> itemId = const Value.absent(),
            required String itemName,
            Value<String?> hsnSacCode = const Value.absent(),
            required double quantity,
            Value<String> unit = const Value.absent(),
            required double pricePerUnit,
            Value<double> taxAmount = const Value.absent(),
            required double lineTotal,
          }) =>
              PurchaseLineItemsCompanion.insert(
            id: id,
            purchaseBillId: purchaseBillId,
            itemId: itemId,
            itemName: itemName,
            hsnSacCode: hsnSacCode,
            quantity: quantity,
            unit: unit,
            pricePerUnit: pricePerUnit,
            taxAmount: taxAmount,
            lineTotal: lineTotal,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchaseLineItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({purchaseBillId = false, itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (purchaseBillId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.purchaseBillId,
                    referencedTable: $$PurchaseLineItemsTableReferences
                        ._purchaseBillIdTable(db),
                    referencedColumn: $$PurchaseLineItemsTableReferences
                        ._purchaseBillIdTable(db)
                        .id,
                  ) as T;
                }
                if (itemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemId,
                    referencedTable:
                        $$PurchaseLineItemsTableReferences._itemIdTable(db),
                    referencedColumn:
                        $$PurchaseLineItemsTableReferences._itemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PurchaseLineItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseLineItemsTable,
    PurchaseLineItem,
    $$PurchaseLineItemsTableFilterComposer,
    $$PurchaseLineItemsTableOrderingComposer,
    $$PurchaseLineItemsTableAnnotationComposer,
    $$PurchaseLineItemsTableCreateCompanionBuilder,
    $$PurchaseLineItemsTableUpdateCompanionBuilder,
    (PurchaseLineItem, $$PurchaseLineItemsTableReferences),
    PurchaseLineItem,
    PrefetchHooks Function({bool purchaseBillId, bool itemId})>;
typedef $$PurchasePaymentsTableCreateCompanionBuilder
    = PurchasePaymentsCompanion Function({
  Value<int> id,
  required int purchaseBillId,
  required double amount,
  required DateTime date,
  required String method,
  Value<String?> notes,
});
typedef $$PurchasePaymentsTableUpdateCompanionBuilder
    = PurchasePaymentsCompanion Function({
  Value<int> id,
  Value<int> purchaseBillId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> method,
  Value<String?> notes,
});

final class $$PurchasePaymentsTableReferences extends BaseReferences<
    _$AppDatabase, $PurchasePaymentsTable, PurchasePayment> {
  $$PurchasePaymentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PurchaseBillsTable _purchaseBillIdTable(_$AppDatabase db) =>
      db.purchaseBills.createAlias($_aliasNameGenerator(
          db.purchasePayments.purchaseBillId, db.purchaseBills.id));

  $$PurchaseBillsTableProcessedTableManager get purchaseBillId {
    final $_column = $_itemColumn<int>('purchase_bill_id')!;

    final manager = $$PurchaseBillsTableTableManager($_db, $_db.purchaseBills)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseBillIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PurchasePaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasePaymentsTable> {
  $$PurchasePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$PurchaseBillsTableFilterComposer get purchaseBillId {
    final $$PurchaseBillsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseBillId,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasePaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasePaymentsTable> {
  $$PurchasePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$PurchaseBillsTableOrderingComposer get purchaseBillId {
    final $$PurchaseBillsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseBillId,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableOrderingComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasePaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasePaymentsTable> {
  $$PurchasePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PurchaseBillsTableAnnotationComposer get purchaseBillId {
    final $$PurchaseBillsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseBillId,
        referencedTable: $db.purchaseBills,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseBillsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseBills,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasePaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasePaymentsTable,
    PurchasePayment,
    $$PurchasePaymentsTableFilterComposer,
    $$PurchasePaymentsTableOrderingComposer,
    $$PurchasePaymentsTableAnnotationComposer,
    $$PurchasePaymentsTableCreateCompanionBuilder,
    $$PurchasePaymentsTableUpdateCompanionBuilder,
    (PurchasePayment, $$PurchasePaymentsTableReferences),
    PurchasePayment,
    PrefetchHooks Function({bool purchaseBillId})> {
  $$PurchasePaymentsTableTableManager(
      _$AppDatabase db, $PurchasePaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasePaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasePaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasePaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> purchaseBillId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              PurchasePaymentsCompanion(
            id: id,
            purchaseBillId: purchaseBillId,
            amount: amount,
            date: date,
            method: method,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int purchaseBillId,
            required double amount,
            required DateTime date,
            required String method,
            Value<String?> notes = const Value.absent(),
          }) =>
              PurchasePaymentsCompanion.insert(
            id: id,
            purchaseBillId: purchaseBillId,
            amount: amount,
            date: date,
            method: method,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchasePaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({purchaseBillId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (purchaseBillId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.purchaseBillId,
                    referencedTable: $$PurchasePaymentsTableReferences
                        ._purchaseBillIdTable(db),
                    referencedColumn: $$PurchasePaymentsTableReferences
                        ._purchaseBillIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PurchasePaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchasePaymentsTable,
    PurchasePayment,
    $$PurchasePaymentsTableFilterComposer,
    $$PurchasePaymentsTableOrderingComposer,
    $$PurchasePaymentsTableAnnotationComposer,
    $$PurchasePaymentsTableCreateCompanionBuilder,
    $$PurchasePaymentsTableUpdateCompanionBuilder,
    (PurchasePayment, $$PurchasePaymentsTableReferences),
    PurchasePayment,
    PrefetchHooks Function({bool purchaseBillId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BusinessProfileTableTableManager get businessProfile =>
      $$BusinessProfileTableTableManager(_db, _db.businessProfile);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$DocumentLineItemsTableTableManager get documentLineItems =>
      $$DocumentLineItemsTableTableManager(_db, _db.documentLineItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$PurchaseBillsTableTableManager get purchaseBills =>
      $$PurchaseBillsTableTableManager(_db, _db.purchaseBills);
  $$PurchaseLineItemsTableTableManager get purchaseLineItems =>
      $$PurchaseLineItemsTableTableManager(_db, _db.purchaseLineItems);
  $$PurchasePaymentsTableTableManager get purchasePayments =>
      $$PurchasePaymentsTableTableManager(_db, _db.purchasePayments);
}
