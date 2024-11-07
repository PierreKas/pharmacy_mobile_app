class SellingPoint {
  int? id;
  String? name;

  SellingPoint({
    this.id,
    required this.name,
  });

  factory SellingPoint.fromJson(Map<String, dynamic> json) {
    return SellingPoint(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
