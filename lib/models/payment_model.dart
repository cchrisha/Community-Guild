class TransactionDetails {
  final String sender;
  final String recipient;
  final String amount;
  final String hash;
  final DateTime date;
  final bool isSent;

  TransactionDetails({
    required this.sender,
    required this.recipient,
    required this.amount,
    required this.hash,
    required this.date,
    required this.isSent,
  });
}
