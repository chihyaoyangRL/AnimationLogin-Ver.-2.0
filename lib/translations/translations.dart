import 'en_us.dart';
import 'package:get/get.dart';
import 'package:animationlogin2/translations/pt_br.dart';
import 'package:animationlogin2/translations/zh_tw.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'pt_BR': ptBR, 'zh_TW': zhTW};
}