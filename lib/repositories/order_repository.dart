import 'package:sw_test/core/constants/app_constants.dart';
import 'package:sw_test/core/network/http_helper.dart';
import 'package:sw_test/models/order.dart';

class OrderRepository {
  final HttpHelper httpHelper;
  OrderRepository(this.httpHelper);

  Future<List<Order>> getOrders({bool includeFinished = true}) async {
    final response = await httpHelper.getRequest(
      AppConstants.ordersEndpoint,
      queryParams: {'includeFinished': includeFinished},
    );
    final data = response.data as List;
    return data.map((e) => Order.fromJson(e)).toList();
  }

  Future<Order> createOrder(String description, String customerName) async {
    final response = await httpHelper.postRequest(
      AppConstants.ordersEndpoint,
      {
        'description': description,
        'customerName': customerName
      },
    );
    return Order.fromJson(response.data);
  }

  Future<Order> finishOrder(String id, String description, String customerName) async {
    final response = await httpHelper.putRequest(
      '${AppConstants.ordersEndpoint}/$id/finish',
      {
        'description': description,
        'customerName': customerName
      },
    );
    return Order.fromJson(response.data);
  }
}
