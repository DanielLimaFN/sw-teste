import 'package:flutter/foundation.dart';
import 'package:sw_test/models/order.dart';
import 'package:sw_test/repositories/order_repository.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository? repository;
  List<Order> orders = [];
  bool loading = false;

  OrderViewModel(this.repository);

  Future<void> fetchOrders() async {
    if (repository == null) return;
    loading = true;
    notifyListeners();
    orders = await repository!.getOrders(includeFinished: true);
    loading = false;
    notifyListeners();
  }

  Future<void> addOrder(String description, String customerName) async {
    if (repository == null) return;
    loading = true;
    notifyListeners();
    final newOrder = await repository!.createOrder(description, customerName);
    orders.add(newOrder);
    loading = false;
    notifyListeners();
  }

  Future<void> finishOrder(String id, String description, String customerName) async {
    if (repository == null) return;
    loading = true;
    notifyListeners();
    final updatedOrder = await repository!.finishOrder(id, description, customerName);
    final index = orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      orders[index] = updatedOrder;
    }
    loading = false;
    notifyListeners();
  }
}
