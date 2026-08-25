// Environment configuration and secrets manager
abstract final class EnvConfig {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Rasidhu',
  );

  static const String defaultBusinessName = String.fromEnvironment(
    'DEFAULT_BUSINESS_NAME',
    defaultValue: '',
  );

  static const String defaultPhone = String.fromEnvironment(
    'DEFAULT_PHONE',
    defaultValue: '9597794387',
  );

  static const String defaultEmail = String.fromEnvironment(
    'DEFAULT_EMAIL',
    defaultValue: '',
  );

  static const String defaultState = String.fromEnvironment(
    'DEFAULT_STATE',
    defaultValue: 'Tamil Nadu',
  );

  static const String dbSecretSalt = String.fromEnvironment(
    'DB_SECRET_SALT',
    defaultValue: 'RasidhuSecretKey2026',
  );
}
