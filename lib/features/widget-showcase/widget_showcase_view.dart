import 'package:flutter/material.dart';
import 'package:sales_app/features/base_view.dart';
import 'package:sales_app/features/widget-showcase/widget_showcase_view_model.dart';
import 'package:sales_app/ui/shared/custom_appbar.dart';
import 'package:sales_app/ui/theme/app_colors.dart';

class WidgetShowcaseView extends StatelessWidget {
  const WidgetShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<WidgetShowcaseViewModel>(
      model: WidgetShowcaseViewModel(),
      onModelReady: (WidgetShowcaseViewModel model) => model.initModel(),
      onModelDispose: (WidgetShowcaseViewModel model) => model.disposeModel(),
      builder: (BuildContext context, WidgetShowcaseViewModel model, _) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Title',),
          backgroundColor: AppColors.white,
          body: _buildBody(context, model),
        );
      },
    );
  }
}

Widget _buildBody(BuildContext context, WidgetShowcaseViewModel model) {
  if (model.isBusy) {
    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
  return ListView(children: []);
}
