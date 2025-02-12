class TransactionModel {
  final double amount;
  final String currency;
  final String transactionDate;
  final String senderId;
  final String recipientId;
  final String patientId;
  final String hospitalId;
  final String adherenceStatus;
  final String paymentMethod;
  final String transactionStatus;
  final String transactionType;
  String referenceNumber;
  final String? authorizationCode;
  final String fraudCheckIndicator;
  final double transactionFees;
  final double taxAmount;
  final double netAmount;
  final String platformChannel;
  final String ipAddress;
  final String deviceId;
  final String? description;
  final String? linkedTransactionId;
  final String? createdBy;
  final String? modifiedBy;
  final String? transactionId;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? conversionRate;

  TransactionModel({
    required this.amount,
    required this.currency,
    required this.transactionDate,
    required this.senderId,
    required this.recipientId,
    required this.patientId,
    required this.hospitalId,
    required this.adherenceStatus,
    required this.paymentMethod,
    required this.transactionStatus,
    required this.transactionType,
    required this.referenceNumber,
    this.authorizationCode,
    required this.fraudCheckIndicator,
    required this.transactionFees,
    required this.taxAmount,
    required this.netAmount,
    required this.platformChannel,
    required this.ipAddress,
    required this.deviceId,
    this.description,
    this.linkedTransactionId,
    this.createdBy,
    this.modifiedBy,
    this.transactionId,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.conversionRate,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      amount: (map['amount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? '',
      transactionDate: map['transaction_date'] ?? '',
      senderId: map['sender_id'] ?? '',
      recipientId: map['recipient_id'] ?? '',
      patientId: map['patient_id'] ?? '',
      hospitalId: map['hospital_id'] ?? '',
      adherenceStatus: map['adherence_status'] ?? '',
      paymentMethod: map['payment_method'] ?? '',
      transactionStatus: map['transaction_status'] ?? '',
      transactionType: map['transaction_type'] ?? '',
      referenceNumber: map['reference_number'] ?? '',
      authorizationCode: map['authorization_code'],
      fraudCheckIndicator: map['fraud_check_indicator'] ?? '',
      transactionFees: (map['transaction_fees'] ?? 0.0).toDouble(),
      taxAmount: (map['tax_amount'] ?? 0.0).toDouble(),
      netAmount: (map['net_amount'] ?? 0.0).toDouble(),
      platformChannel: map['platform_channel'] ?? '',
      ipAddress: map['ip_address'] ?? '',
      deviceId: map['device_id'] ?? '',
      description: map['description'],
      linkedTransactionId: map['linked_transaction_id'],
      createdBy: map['created_by'],
      modifiedBy: map['modified_by'],
      transactionId: map['transaction_id'],
      bankName: map['bank_name'],
      bankAccountName: map['bank_account_name'],
      bankAccountNumber: map['bank_account_number'],
      conversionRate: map['conversion_rate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      'transaction_date': transactionDate,
      'sender_id': senderId,
      'recipient_id': recipientId,
      'patient_id': patientId,
      'hospital_id': hospitalId,
      'adherence_status': adherenceStatus,
      'payment_method': paymentMethod,
      'transaction_status': transactionStatus,
      'transaction_type': transactionType,
      'reference_number': referenceNumber,
      'authorization_code': authorizationCode,
      'fraud_check_indicator': fraudCheckIndicator,
      'transaction_fees': transactionFees,
      'tax_amount': taxAmount,
      'net_amount': netAmount,
      'platform_channel': platformChannel,
      'ip_address': ipAddress,
      'device_id': deviceId,
      'description': description,
      'linked_transaction_id': linkedTransactionId,
      'created_by': createdBy,
      'modified_by': modifiedBy,
      'transaction_id': transactionId,
      'bank_name': bankName,
      'bank_account_name': bankAccountName,
      'bank_account_number': bankAccountNumber,
      'conversion_rate': conversionRate,
    };
  }
}
