import 'package:flutter/material.dart';
import '../models/inquiry.dart';

// QNA 위젯
class InquiryItem extends StatelessWidget {
  final Inquiry inquiry;
  final VoidCallback? onTap;
  const InquiryItem({super.key, required this.inquiry, this.onTap});

  Color _chipColor(BuildContext ctx) {
    switch (inquiry.status) {
      case InquiryStatus.WAITING:
        return Colors.amber.shade700;
      case InquiryStatus.ANSWERED:
        return Colors.green.shade600;
      case InquiryStatus.CLOSED:
        return Colors.grey;
    }
  }

  String _statusLabel() {
    switch (inquiry.status) {
      case InquiryStatus.WAITING:
        return '대기';
      case InquiryStatus.ANSWERED:
        return '답변완료';
      case InquiryStatus.CLOSED:
        return '종료';
    }
  }

  @override
  Widget build(BuildContext context) {
    final created = inquiry.createdAt;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          inquiry.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${created.year}-${created.month.toString().padLeft(2, '0')}-${created.day.toString().padLeft(2, '0')} • 문의 ID #${inquiry.inquiryId}',
        ),
        trailing: Chip(
          backgroundColor: _chipColor(context),
          label: Text(
            _statusLabel(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
