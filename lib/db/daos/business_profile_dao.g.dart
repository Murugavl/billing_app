// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_dao.dart';

// ignore_for_file: type=lint
mixin _$BusinessProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $BusinessProfileTable get businessProfile => attachedDatabase.businessProfile;
  BusinessProfileDaoManager get managers => BusinessProfileDaoManager(this);
}

class BusinessProfileDaoManager {
  final _$BusinessProfileDaoMixin _db;
  BusinessProfileDaoManager(this._db);
  $$BusinessProfileTableTableManager get businessProfile =>
      $$BusinessProfileTableTableManager(
          _db.attachedDatabase, _db.businessProfile);
}
