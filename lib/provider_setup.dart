import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sales_app/core/api/auth_api.dart';
import 'package:sales_app/core/api/history_api.dart';
import 'package:sales_app/core/api/outlet_api.dart';
import 'package:sales_app/core/api/product_api.dart';
import 'package:sales_app/core/api/transaction_api.dart';
import 'package:sales_app/core/services/dio_service.dart';
import 'package:sales_app/core/services/pref_service.dart';
import 'package:sales_app/features/cart/cart_view_model.dart';

List<SingleChildWidget> independentServices = <SingleChildWidget>[
  Provider<DioService>(create: (_) => DioService(PrefService())),
];

List<SingleChildWidget> globalServices = <SingleChildWidget>[
  ChangeNotifierProvider(create: (_) => CartViewModel()),
];

List<SingleChildWidget> apiServices = <SingleChildWidget>[
  ProxyProvider<DioService, AuthApi>(
    update: (_, dioService, __) => AuthApi(dioService.dio),
  ),
  ProxyProvider<DioService, ProductApi>(
    update: (_, dioService, __) => ProductApi(dioService.dio),
  ),
  ProxyProvider<DioService, OutletApi>(
    update: (_, dioService, __) => OutletApi(dioService.dio),
  ),
  ProxyProvider<DioService, TransactionApi>(
    update: (_, dioService, __) => TransactionApi(dioService.dio),
  ),
  ProxyProvider<DioService, HistoryApi>(
    update: (_, dioService, __) => HistoryApi(dioService.dio),
  ),
];

List<SingleChildWidget> appProviders = [
  ...independentServices,
  ...globalServices,
  ...apiServices,
];
