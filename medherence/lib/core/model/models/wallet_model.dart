class WalletModel {
  final String firstName;
  final String lastName;
  final String title, dateTime;
  final double price;
  final String src;
  final bool debit;

  WalletModel({
    required this.firstName,
    required this.lastName,
    required this.src,
    required this.title,
    required this.dateTime,
    required this.price,
    required this.debit,
  });
}
