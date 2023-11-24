import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

final TextTemplate defaultText = TextTemplate(
  text: '테스트',
  link: Link(
    webUrl: Uri.parse('https://www.uspray.kr/'),
    mobileWebUrl: Uri.parse('https://www.uspray.kr/'),
  ),
);

void sendLink() async {
  // 카카오톡 실행 가능 여부 확인
  bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

  if (isKakaoTalkSharingAvailable) {
    try {
      Uri uri = await ShareClient.instance.shareDefault(template: defaultText);
      await ShareClient.instance.launchKakaoTalk(uri);
      print('카카오톡 공유 완료');
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  } else {
    try {
      Uri shareUrl = await WebSharerClient.instance
          .makeDefaultUrl(template: defaultText);
      await launchBrowserTab(shareUrl, popupOpen: true);
    } catch (error) {
      print('카카오톡 공유 실패 $error');
    }
  }
}

