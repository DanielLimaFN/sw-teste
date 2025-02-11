import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw_test/core/routes/app_routes.dart';
import 'package:sw_test/viewmodels/order_view_model.dart';


class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: viewModel.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: viewModel.orders.length,
        itemBuilder: (context, index) {
          final order = viewModel.orders[index];
          return ListTile(
            title: Text(order.description),
            subtitle: Text(order.finished ? 'Finished' : 'Pending'),
            trailing: order.finished
                ? null
                : IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                viewModel.finishOrder(
                  order.id,
                  order.description,
                  order.customerName,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.orderAdd);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
