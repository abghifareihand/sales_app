import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/models/add_outlet_model.dart';
import 'package:sales_app/core/models/api_model.dart';
import 'package:sales_app/features/base_view_model.dart';

class AddOutletViewModel extends BaseViewModel {
  AddOutletViewModel({required this.outletApi});
  final OutletApi outletApi;

  final TextEditingController idOutletController = TextEditingController();
  final TextEditingController nameOutletController = TextEditingController();
  final TextEditingController addressOutletController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController latLongController = TextEditingController();

  String idOutlet = '';
  String nameOutlet = '';
  String addressOutlet = '';
  String name = '';
  String phone = '';
  double? latitude;
  double? longitude;
  String? idOutletError;
  String? nameOutletError;
  String? addressOutletError;
  String? nameError;
  String? phoneError;

  bool isCurrentLocation = false;

  @override
  Future<void> initModel() async {
    setBusy(true);
    await fetchCurrentLocation();
    super.initModel();
    setBusy(false);
  }

  @override
  Future<void> disposeModel() async {
    idOutletController.dispose();
    nameOutletController.dispose();
    addressOutletController.dispose();
    nameController.dispose();
    phoneController.dispose();
    latLongController.dispose();
    super.disposeModel();
  }

  void updateIdOutlet(String value) {
    idOutlet = value;
    idOutletError = idOutlet.isEmpty ? 'ID Outlet tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateNameOutlet(String value) {
    nameOutlet = value;
    nameOutletError =
        nameOutlet.isEmpty ? 'Nama Outlet tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateAddressOutlet(String value) {
    addressOutlet = value;
    addressOutletError =
        addressOutlet.isEmpty ? 'Alamat Outlet tidak boleh kosong' : null;
    notifyListeners();
  }

  void updateName(String value) {
    name = value;
    nameError = name.isEmpty ? 'Nama Owner tidak boleh kosong' : null;
    notifyListeners();
  }

  void updatePhone(String value) {
    phone = value;
    phoneError = phone.isEmpty ? 'Nomor Telepon tidak boleh kosong' : null;
    notifyListeners();
  }

  bool get isFormValid =>
      idOutlet.isNotEmpty &&
      nameOutlet.isNotEmpty &&
      addressOutlet.isNotEmpty &&
      name.isNotEmpty &&
      phone.isNotEmpty;

  /// Fungsi untuk mendapatkan lokasi saat ini
  Future<void> fetchCurrentLocation() async {
    isCurrentLocation = true;
    notifyListeners();
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      latitude = position.latitude;
      longitude = position.longitude;
      latLongController.text = '$latitude, $longitude';
      notifyListeners();
    } catch (e) {
      setError('Gagal mendapatkan lokasi: $e');
    }

    isCurrentLocation = false;
    notifyListeners();
  }

  Future<void> addOutlet() async {
    if (latitude == null || longitude == null) {
      await fetchCurrentLocation();
    }
    setBusy(true);
    try {
      final HttpResponse<AddOutletResponse> response = await outletApi
          .addOutlet(
            request: AddOutletRequest(
              idOutlet: idOutlet,
              nameOutlet: nameOutlet,
              addressOutlet: addressOutlet,
              name: name,
              phone: phone,
              latitude: latitude!.toStringAsFixed(6),
              longitude: longitude!.toStringAsFixed(6),
            ),
          );
      if (response.response.statusCode == 200) {
        final addOutletResponse = response.data;
        setSuccess(addOutletResponse.message);
      }
      setBusy(false);
    } on DioException catch (e) {
      final apiResponse = ApiResponse.fromJson(e.response!.data);
      setError(apiResponse.message);
      setBusy(false);
    }
  }
}
