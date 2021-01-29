import 'package:flutter/material.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';

class PageModel extends ChangeNotifier {
  final _log = getLogger('PageModel');
  String _currentPage;
  int _activePartition = 0;

  PageModel(String homePage) {
    _currentPage = homePage;
  }
  get currentPage => _currentPage;

  set currentPage(String page) {
    _log.i('currentPage() | $_currentPage => $page');
    _currentPage = page;
    notifyListeners();
  }

  get activePartition => _activePartition;

  set activePartition(int partitionId) {
    _log.i('activePartition() | $_activePartition => $partitionId');
    _activePartition = partitionId;
    notifyListeners();
  }
}
