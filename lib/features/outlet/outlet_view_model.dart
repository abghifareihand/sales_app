import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/core/models/outlet_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class OutletViewModel extends BaseViewModel {
  OutletViewModel({required this.outletApi});
  final OutletApi outletApi;

  final TextEditingController searchController = TextEditingController();
  List<Outlet> outlets = [];
  Timer? _debounce;

  @override
  Future<void> initModel() async {
    setBusy(true);
    super.initModel();
    await fetchOutlets(); // load awal tanpa search
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    _debounce?.cancel();
    super.disposeModel();
  }

  Future<void> fetchOutlets({String? search}) async {
    setBusy(true);
    try {
      final HttpResponse<OutletResponse> response = await outletApi.outlets(search);
      if (response.response.statusCode == 200) {
        outlets = response.data.outlets;
      }
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
    }
    setBusy(false);
  }

  /// Fungsi versi debounced
  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchOutlets(search: query.isEmpty ? null : query);
    });
  }
}
