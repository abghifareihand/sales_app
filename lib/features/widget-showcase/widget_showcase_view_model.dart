

import 'package:sales_app/features/base_view_model.dart';

class WidgetShowcaseViewModel extends BaseViewModel {
  WidgetShowcaseViewModel();

  @override
  Future<void> initModel() async {
    setBusy(true);
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }
}