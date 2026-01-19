class TuitionRecord {
  final String receiptNumber;
  final int amount; // in VND
  final String receiver;
  final String date; // simple string for mock
  final String details;

  TuitionRecord({
    required this.receiptNumber,
    required this.amount,
    required this.receiver,
    required this.date,
    required this.details,
  });
}

// Represents a planned tuition charge (per course or fee item)
class TuitionCharge {
  final String description;
  final int session; // 'Lần học'
  final int credits;
  final int amount; // in VND
  final String invoiceLabel; // e.g. 'Học mới'

  TuitionCharge({
    required this.description,
    required this.session,
    required this.credits,
    required this.amount,
    required this.invoiceLabel,
  });
}

// Simple model for QR payment payload (dev/mock)
class QrInfo {
  final int amount; // VND
  final String content; // payment content / invoice reference
  final String service; // e.g., Thanh toán hoc phi
  final String ref; // reference/order id
  final String bank; // bank name

  QrInfo({
    required this.amount,
    required this.content,
    required this.service,
    required this.ref,
    required this.bank,
  });
}