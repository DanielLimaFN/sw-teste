import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/network/http_helper.dart';
import '../core/routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;

  Future<void> _login() async {
    final httpHelper = context.read<HttpHelper>();
    if (_userController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() {
      loading = true;
    });
    try {
      await httpHelper.login(_userController.text, _passwordController.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.orderList);
    } catch (_) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(hintText: 'User'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _login,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
