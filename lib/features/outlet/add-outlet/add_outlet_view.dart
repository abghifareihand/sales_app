import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/outlet/add-outlet/add_outlet_view_model.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/shared/custom_button.dart';
import 'package:sales_app/ui/shared/custom_snackbar.dart';
import 'package:sales_app/ui/shared/custom_text_field.dart';
import 'package:sales_app/ui/theme/app_colors.dart';
import 'package:sales_app/ui/theme/app_fonts.dart';

class AddOutletView extends StatelessWidget {
  const AddOutletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<AddOutletViewModel>(
      model: AddOutletViewModel(outletApi: Provider.of<OutletApi>(context)),
      onModelReady: (AddOutletViewModel model) => model.initModel(),
      onModelDispose: (AddOutletViewModel model) => model.disposeModel(),
      builder: (BuildContext context, AddOutletViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Tambah Outlet'),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, AddOutletViewModel model) {
  if (model.isCurrentLocation) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Mendapatkan lokasi...',
            style: AppFonts.medium.copyWith(
              color: AppColors.primary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  return ListView(
    padding: EdgeInsets.all(24),
    children: [
      CustomTextField(
        controller: model.latLongController,
        label: 'Lokasi Outlet',
        readOnly: true,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.idOutletController,
        textCapitalization: TextCapitalization.characters,
        label: 'ID Outlet',
        hintText: 'Masukkan ID Outlet',
        onChanged: model.updateIdOutlet,
        errorText: model.idOutletError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.nameOutletController,
        textCapitalization: TextCapitalization.words,
        label: 'Nama Outlet',
        hintText: 'Masukkan Nama Outlet',
        onChanged: model.updateNameOutlet,
        errorText: model.nameOutletError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.addressOutletController,
        label: 'Alamat Outlet',
        hintText: 'Masukkan Alamat Outlet',
        maxLines: 3,
        onChanged: model.updateAddressOutlet,
        errorText: model.addressOutletError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.nameController,
        textCapitalization: TextCapitalization.words,
        label: 'Nama Owner',
        hintText: 'Masukkan Nama Owner',
        onChanged: model.updateName,
        errorText: model.nameError,
      ),
      const SizedBox(height: 16.0),
      CustomTextField(
        controller: model.phoneController,
        label: 'Nomor Telepon',
        hintText: 'Masukkan Nomor Telepon',
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        onChanged: model.updatePhone,
        errorText: model.phoneError,
      ),

      const SizedBox(height: 24.0),
      Button.filled(
        onPressed:
            model.isFormValid
                ? () async {
                  await model.addOutlet();
                  if (context.mounted) {
                    if (model.error) {
                      CustomSnackbar.showError(context, model.message);
                    }
                    if (model.success) {
                      Navigator.of(context).pop(true);
                    }
                  }
                }
                : null,
        label: 'Simpan',
        isLoading: model.isBusy,
      ),
    ],
  );
}
