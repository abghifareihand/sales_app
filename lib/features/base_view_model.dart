import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  bool get isBusy => _isBusy;

  bool _hasSuccess = false;
  bool _hasError = false;
  String _message = '';

  bool get success => _hasSuccess;
  bool get error => _hasError;
  String get message => _message;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setSuccess(String message) {
    _hasSuccess = true;
    _hasError = false;
    _message = message;
    notifyListeners();
  }

  void setError(String message) {
    _hasError = true;
    _hasSuccess = false;
    _message = message;
    notifyListeners();
  }

  void initModel() {}

  void disposeModel() {}
}
