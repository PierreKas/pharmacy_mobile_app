class Client {
  String fullName;
  String phoneNumber;
  String password;
  int? clientId;
  String? address;

  Client(
      {required this.fullName,
      required this.phoneNumber,
      required this.password,
      this.clientId,
      this.address});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        fullName: json['Full_name'],
        phoneNumber: json['phone_number'],
        password: json['pwd'],
        clientId: json['client_id'],
        address: json['address']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Full_name': fullName,
      'phone_number': phoneNumber,
      'pwd': password,
      'client_id': clientId,
      'addres': address
    };
  }
}
