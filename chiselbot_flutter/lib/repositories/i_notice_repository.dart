import '../models/notice.dart';

abstract class INoticeRepository {
  Future<List<Notice>> getNotices();
  Future<Notice> getNoticeById(int id);
}
