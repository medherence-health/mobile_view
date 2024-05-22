class WalletModel {
  final String title, dateTime;
  final double price;
  final String src;
  final bool debit;

  WalletModel({
    required this.src,
    required this.title,
    required this.dateTime,
    required this.price,
    required this.debit,
  });
}
