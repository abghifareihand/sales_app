import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/outlet_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class OutletViewModel extends BaseViewModel {
  OutletViewModel({required this.outletApi});

  final OutletApi outletApi;
  List<Outlet> outlets = [];

  @override
  Future<void> initModel() async {
    setBusy(true);
    super.initModel();
    await fetchOutlets();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchOutlets() async {
    setBusy(true);
    try {
      final HttpResponse<OutletResponse> response = await outletApi.outlets();
      if (response.response.statusCode == 200) {
        outlets = response.data.outlets;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}
