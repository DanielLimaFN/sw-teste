class Order {
  final String id;
  final String description;
  final String customerName;
  final bool finished;

  Order({
    required this.id,
    required this.description,
    required this.customerName,
    required this.finished,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      customerName: json['customerName'] ?? '',
      finished: json['finished'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'customerName': customerName,
      'finished': finished,
    };
  }
}
