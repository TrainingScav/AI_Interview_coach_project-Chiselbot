import '../models/notice.dart';
import '../services/notice_api_service.dart';
import 'i_notice_repository.dart';

class ServerNoticeRepository implements INoticeRepository {
  final NoticeApiService _apiService;

  ServerNoticeRepository(this._apiService);

  @override
  Future<List<Notice>> getNotices() async {
    return await _apiService.getNotices();
  }

  @override
  Future<Notice> getNoticeById(int id) async {
    return await _apiService.getNoticeById(id);
  }
}
