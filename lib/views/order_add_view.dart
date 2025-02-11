import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/order_view_model.dart';

class OrderAddView extends StatefulWidget {
  const OrderAddView({super.key});

  @override
  State<OrderAddView> createState() => _OrderAddViewState();
}

class _OrderAddViewState extends State<OrderAddView> {
  final _descriptionController = TextEditingController();
  final _customerNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(hintText: 'Customer Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_descriptionController.text.isNotEmpty &&
                    _customerNameController.text.isNotEmpty) {
                  await viewModel.addOrder(
                    _descriptionController.text,
                    _customerNameController.text,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                }
              },
              child: viewModel.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
