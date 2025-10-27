enum InquiryStatus { WAITING, ANSWERED, CLOSED }

InquiryStatus statusFromString(String s) {
  switch (s) {
    case 'WAITING':
      return InquiryStatus.WAITING;
    case 'ANSWERED':
      return InquiryStatus.ANSWERED;
    case 'CLOSED':
      return InquiryStatus.CLOSED;
    default:
      return InquiryStatus.WAITING;
  }
}

String statusToString(InquiryStatus st) {
  switch (st) {
    case InquiryStatus.WAITING:
      return 'WAITING';
    case InquiryStatus.ANSWERED:
      return 'ANSWERED';
    case InquiryStatus.CLOSED:
      return 'CLOSED';
  }
}

class Inquiry {
  final int inquiryId;
  final int userId;
  final int? adminId;
  final String title;
  final String content;
  final String? answerContent;
  final InquiryStatus status;
  final DateTime createdAt;
  final DateTime? answeredAt;
  final DateTime? updatedAt;

  Inquiry({
    required this.inquiryId,
    required this.userId,
    this.adminId,
    required this.title,
    required this.content,
    this.answerContent,
    required this.status,
    required this.createdAt,
    this.answeredAt,
    this.updatedAt,
  });

  factory Inquiry.fromJson(Map<String, dynamic> j) => Inquiry(
        inquiryId: j['inquiryId'],
        userId: j['userId'],
        adminId: j['adminId'],
        title: j['title'],
        content: j['content'],
        answerContent: j['answerContent'],
        status: statusFromString(j['status']),
        createdAt: DateTime.parse(j['createdAt']),
        answeredAt:
            j['answeredAt'] != null ? DateTime.parse(j['answeredAt']) : null,
        updatedAt:
            j['updatedAt'] != null ? DateTime.parse(j['updatedAt']) : null,
      );
}
