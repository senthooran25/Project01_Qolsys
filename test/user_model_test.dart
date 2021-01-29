import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/providers/user_model.dart';
import 'package:qolsys_app/repos/iqcloud_client.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';

class MockDio extends Mock implements Dio {}

class MockAccountModel extends Mock implements AccountModel {}

final successLogin = {
  "access_token": "dummy access token",
  "refresh_token": "dummy refresh token",
  "expires_in": 1296000,
  "refresh_expires_in": 1382400,
  "token_type": "bearer"
};

main() {
  Dio client;
  AccountModel accountModel;
  UserModel userModel;

  setUp(() {
    client = MockDio();
    accountModel = MockAccountModel();
    userModel = UserModel(
      IQCloudRepository(
        client: IQCloudClient(client),
        account: accountModel,
      ),
    );
  });

  tearDown(() {
    client = null;
    accountModel = null;
    userModel = null;
  });

  test('login success', () async {
    when(client.request(
      any,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
      data: anyNamed('data'),
    )).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(data: successLogin));

    await userModel.login('username', 'password');

    verify(accountModel.setAuthToken(any)).called(1);
  });

  test('login error', () async {
    when(client.request(
      any,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
      data: anyNamed('data'),
    )).thenAnswer((_) async {
      throw DioError(
        error: 'error',
        type: DioErrorType.DEFAULT,
      );
    });

    await userModel.login('username', 'password');

    verifyNever(accountModel.setAuthToken(any));
  });
}
