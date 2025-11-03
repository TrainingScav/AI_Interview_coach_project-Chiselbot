// import '../models/notice.dart';
// import 'i_notice_repository.dart';
//
// class DummyNoticeRepository implements INoticeRepository {
//   final List<Notice> _dummyNotices = [
//     Notice(
//       id: 1,
//       title: '서비스 점검 안내',
//       content: '''
// 안녕하세요, AI Interview Coach입니다.
//
// 서비스 품질 향상을 위한 정기 점검을 진행합니다.
//
// [점검 일정]
// - 2025년 11월 5일 02:00 ~ 06:00 (4시간)
//
// [점검 내용]
// - 서버 시스템 업그레이드
// - 데이터베이스 최적화
// - 보안 패치 적용
//
// 점검 시간 동안 서비스 이용이 제한될 수 있습니다.
// 양해 부탁드립니다.
//
// 감사합니다.
//       ''',
//       date: '2025-11-01',
//       isNew: true,
//     ),
//     Notice(
//       id: 2,
//       title: '새로운 기능 업데이트',
//       content: '''
// AI Interview Coach에 새로운 기능이 추가되었습니다!
//
// [업데이트 내용]
// 1. 면접 피드백 개선
//    - 더 상세한 답변 분석
//    - 개선 포인트 제시
//
// 2. 질문 카테고리 확장
//    - 새로운 기술 스택 추가
//    - 난이도별 질문 분류
//
// 3. UI/UX 개선
//    - 다크모드 지원
//    - 반응형 디자인 적용
//
// 앞으로도 더 나은 서비스를 제공하겠습니다.
//       ''',
//       date: '2025-10-28',
//       isNew: true,
//     ),
//     Notice(
//       id: 3,
//       title: '개인정보 처리방침 변경 안내',
//       content: '''
// 개인정보 처리방침이 일부 변경되었습니다.
//
// [주요 변경사항]
// - 개인정보 보유기간 명시
// - 제3자 제공 내역 추가
// - 정보주체의 권리 강화
//
// 변경된 처리방침은 2025년 11월 1일부터 적용됩니다.
//
// 자세한 내용은 설정 > 개인정보 처리방침에서 확인하실 수 있습니다.
//       ''',
//       date: '2025-10-20',
//       isNew: false,
//     ),
//   ];
//
//   @override
//   Future<List<Notice>> getNotices() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return _dummyNotices;
//   }
//
//   @override
//   Future<Notice> getNoticeById(int id) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//
//     try {
//       return _dummyNotices.firstWhere((notice) => notice.id == id);
//     } catch (e) {
//       throw Exception('공지사항을 찾을 수 없습니다. (ID: $id)');
//     }
//   }
// }
