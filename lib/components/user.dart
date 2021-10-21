class UserInf {
  final String status;
  final String currency;

  UserInf(this.status, this.currency);

  UserInf.fromJson(Map<String, Object> json)

      : status = json['status'],
        currency = json['currency'];
  Map toJson() {
    return {
      'status': status,
      'currency': currency,
    };
  }
  String toString() {
    return '$currency $status ';
    
  }
}