import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';

abstract class QChangeNotifier extends ChangeNotifier {
  final _log = getLogger('QChangeNotifier');
  StreamController<String> _errorStreamController =
      StreamController<String>.broadcast();
  IQCloudRepository _repo;
  QChangeNotifier(this._repo);
  @override
  dispose() {
    _errorStreamController?.close();
    super.dispose();
  }

  Stream<String> get errorStream => _errorStreamController.stream;

  @protected
  Future<dynamic> sendRequest(Function requestFunc,
      [void Function(bool val) deviceLoading]) async {
    String requestStatus;
    var result;
    if (deviceLoading != null) deviceLoading(true);
    try {
      result = await requestFunc();
      requestStatus = requestSuccess;
    } on DioError catch (e) {
      _log.e(e.toString());
      if (e.response?.statusCode == 403) {
        _repo.account.logout();
      } else if (e.type == DioErrorType.RESPONSE) {
        final data = e.response.data;
        if (data != null && data['error'] != null)
          requestStatus = data['error']['message'];
        else
          requestStatus = 'ERROR';
      } else
        requestStatus = 'REQUEST TIMEOUT';
    } on TypeError catch (e) {
      _log.e(e.toString());
      requestStatus = 'RESPONSE ERROR';
    } finally {
      if (deviceLoading != null) deviceLoading(false);
      //We only need to handle errors when the user can see a loading indicator
      if (requestStatus != requestSuccess && deviceLoading != null)
        _errorStreamController?.add(requestStatus ?? 'UNKNOWN ERROR');
      notifyListeners();
    }
    return result;
  }
}
