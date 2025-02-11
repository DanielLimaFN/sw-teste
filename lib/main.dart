import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw_test/core/routes/app_routes.dart';
import 'package:sw_test/core/theme/app_theme.dart';
import 'package:sw_test/repositories/order_repository.dart';
import 'package:sw_test/viewmodels/order_view_model.dart';
import 'package:sw_test/views/login_view.dart';
import 'package:sw_test/views/order_add_view.dart';
import 'package:sw_test/views/order_list_view.dart';
import 'package:sw_test/views/splash_view.dart';

import 'core/network/http_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HttpHelper>(create: (_) => HttpHelper()),
        ProxyProvider<HttpHelper, OrderRepository>(
          update: (context, httpHelper, previous) => OrderRepository(httpHelper),
        ),
        ChangeNotifierProxyProvider<OrderRepository, OrderViewModel>(
          create: (_) => OrderViewModel(null),
          update: (context, repository, previous) => OrderViewModel(repository),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Tech Test',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashView(),
          AppRoutes.login: (context) => const LoginView(),
          AppRoutes.orderList: (context) => const OrderListView(),
          AppRoutes.orderAdd: (context) => const OrderAddView(),
        },
      ),
    );
  }
}