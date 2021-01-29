import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qolsys_app/models/auth_token.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/utils/local_storage.dart';

class MockStorage extends Mock implements LocalStorage {}

AuthToken invalidToken = AuthToken(
  accessToken: '1234',
  refreshToken: '1234',
  expiresIn: 1234,
  refreshExpiresIn: 1234,
  tokenType: '1234',
);

Map<String, dynamic> eternalUserData = {
  "exp": 9999999999,
  "iat": 1608323155,
  "jti": "dummy jti",
  "iss":
      "https://dev-auth.qolsys.com/auth/realms/qolsys-security-external-apps",
  "aud": "account",
  "sub": "dummy sub",
  "typ": "Bearer",
  "azp": "qolsys-security-external-apps",
  "session_state": "dummy state",
  "acr": "1",
  "realm_access": {
    "roles": ["offline_access", "uma_authorization"]
  },
  "resource_access": {
    "qolsys-security-external-apps": {
      "roles": ["user"]
    },
    "account": {
      "roles": ["manage-account", "manage-account-links", "view-profile"]
    }
  },
  "scope": "openid email profile",
  "account_number": "1234",
  "email_verified": false,
  "name": "dummy name",
  "groups": ["dealer0"],
  "preferred_dealerid": "dealer0",
  "preferred_username": "dummyusername",
  "given_name": "firstname",
  "family_name": "lastname",
  "email": "dummy@qolsys.com"
};

Map<String, dynamic> expiredUserData = Map.from(eternalUserData)..['exp'] = 1;

main() {
  test('constructing account model without cache', () {
    final accountModel = AccountModel();
    expect(accountModel.accessToken, isNull);
  });
  test('constructing account model from invalid token', () {
    final mockStorage = MockStorage();
    when(mockStorage.loadToken()).thenReturn(invalidToken);
    final accountModel = AccountModel(cache: mockStorage);
    expect(accountModel.accessToken, isNull);
  });
  test('account without accessToken not logged in', () {
    final accountModel = AccountModel();
    expect(accountModel.isLoggedIn(), false);
  });

  test('get accountNumber', () {
    final accountModel = AccountModel();
    accountModel.authToken = invalidToken;
    accountModel.setUserData(eternalUserData);
    expect(accountModel.isLoggedIn(), true);
  });

  test('get valid user name', () {
    final accountModel = AccountModel();
    accountModel.authToken = invalidToken;
    accountModel.setUserData(eternalUserData);
    expect(accountModel.userName, 'dummy name');
  });

  test('get null user name', () {
    final accountModel = AccountModel();
    expect(accountModel.userName, isNull);
  });

  test('get valid accountNumber', () {
    final accountModel = AccountModel();
    accountModel.authToken = invalidToken;
    accountModel.setUserData(eternalUserData);
    expect(accountModel.accountNumber, '1234');
  });

  test('get null accountNumber', () {
    final accountModel = AccountModel();
    expect(accountModel.accountNumber, isNull);
  });

  test('account with logged in userdata and token is logged in', () {
    final accountModel = AccountModel();
    accountModel.authToken = invalidToken;
    accountModel.setUserData(eternalUserData);
    expect(accountModel.isLoggedIn(), true);
  });

  test('account with expired userdata and token is logged in', () {
    final accountModel = AccountModel();
    accountModel.authToken = invalidToken;
    accountModel.setUserData(expiredUserData);
    expect(accountModel.isLoggedIn(), false);
  });

  test('account with expired userdata and token is logged in', () {
    final accountModel = AccountModel();
    accountModel.authToken = invalidToken;
    accountModel.setUserData(expiredUserData);
    expect(accountModel.isLoggedIn(), false);
  });
}
