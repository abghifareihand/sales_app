import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/api/history_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/history_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class HistoryViewModel extends BaseViewModel {
  HistoryViewModel({required this.historyApi});
  final HistoryApi historyApi;
  List<History> history = [];

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchHistory();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    super.disposeModel();
  }

  Future<void> fetchHistory() async {
    setBusy(true);
    try {
      final HttpResponse<HistoryResponse> response = await historyApi.history();
      if (response.response.statusCode == 200) {
        history = response.data.data;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }
}
