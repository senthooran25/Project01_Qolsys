class EnvironmentConfig {
  static const BASE_URL = String.fromEnvironment(
      'IQCONTROL_BASE_URL',
      defaultValue: 'https://api-qis.qolsys.com/apps/v1/');
  static const ENVIRONMENT_CONFIG  = String.fromEnvironment(
      'ENVIRONMENT_CONFIG',
      defaultValue: 'PROD');
}