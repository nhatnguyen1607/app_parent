import '../../models/tuition_model.dart';

// Development-only mock data for Tuition
final devMockTuitionPaid = <TuitionRecord>[
  TuitionRecord(
    receiptNumber: '04/2024-HP-Agribank',
    amount: 8225700,
    receiver: 'Bank Agribank',
    date: '15/04/2024',
    details: '04/2024-HP-Agribank',
  ),
  TuitionRecord(
    receiptNumber: '09/2024-HP-Agribank',
    amount: 9000000,
    receiver: 'Bank Agribank',
    date: '03/09/2024',
    details: '09/2024-HP-Agribank',
  ),
  TuitionRecord(
    receiptNumber: '02/2025-HP-Agribank',
    amount: 8550000,
    receiver: 'Bank Agribank',
    date: '19/02/2025',
    details: '02/2025-HP-Agribank',
  ),
  TuitionRecord(
    receiptNumber: '10/2025-HP-Agribank',
    amount: 10403400,
    receiver: 'Bank Agribank',
    date: '19/10/2025',
    details: '10/2025-HP-Agribank',
  ),
];

final devMockTuitionRefunds = <TuitionRecord>[
  TuitionRecord(
    receiptNumber: 'RT/2024-HP-001',
    amount: 0,
    receiver: 'Bank Agribank',
    date: '10/06/2024',
    details: 'RT/2024-HP-001',
  ),
];

// Dev-only mock tuition charge items for the current semester
final devMockTuitionCharges = <TuitionCharge>[
  TuitionCharge(
    description: 'Chuyên đề 2 (IT) (5)_Khai phá dữ liệu Web',
    session: 1,
    credits: 2,
    amount: 990800,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'Đồ án chuyên ngành 1 (IT) (1)',
    session: 1,
    credits: 1,
    amount: 495400,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'GDTC 4 (Bóng chuyền) (3)',
    session: 1,
    credits: 1,
    amount: 495400,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'Hệ chuyên gia (1)',
    session: 1,
    credits: 2,
    amount: 990800,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'Học sâu (5)',
    session: 1,
    credits: 3,
    amount: 1486200,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'Học tăng cường_2 tín chỉ (1)',
    session: 1,
    credits: 2,
    amount: 990800,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'Kinh tế chính trị Mác - Lênin (9)',
    session: 1,
    credits: 2,
    amount: 990800,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'Tiếng Anh nâng cao 4 (1)',
    session: 1,
    credits: 2,
    amount: 990800,
    invoiceLabel: 'Học mới',
  ),
  TuitionCharge(
    description: 'Tư tưởng Hồ Chí Minh (5)',
    session: 1,
    credits: 2,
    amount: 990800,
    invoiceLabel: 'Học mới',
  ),
];

// Dev-only placeholder QR info (will be provided by API in real app)
final devMockQrInfo = QrInfo(
  amount: 8421800,
  content: 'HocPhi 23AI034',
  service: 'Thanh toan hoc phi',
  ref: 'v10007423AI034',
  bank: 'Agribank',
);
