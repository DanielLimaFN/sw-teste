import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw_test/core/network/http_helper.dart';
import 'package:sw_test/core/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final httpHelper = context.read<HttpHelper>();
    final tokenStored = await httpHelper.hasStoredToken();
    if (!tokenStored) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }
    final valid = await httpHelper.verifyStoredTokenIsValid();
    if (!mounted) return;
    if (valid) {
      Navigator.pushReplacementNamed(context, AppRoutes.orderList);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
