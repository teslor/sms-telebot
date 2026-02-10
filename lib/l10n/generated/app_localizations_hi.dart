// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => 'SMS फ़ॉरवर्डिंग शुरू करने के लिए\nस्टार्ट दबाएँ';

  @override
  String get sms_empty => 'वर्तमान सत्र में\nकोई SMS नहीं';

  @override
  String get sms_hello => 'SMS Telebot से नमस्ते! =^•⩊•^=';

  @override
  String get sms_from => 'SMS प्रेषक';

  @override
  String get sms_received => 'प्राप्त';

  @override
  String get sms_sent => 'फ़ॉरवर्ड किया गया';

  @override
  String get sms_start => 'स्टार्ट';

  @override
  String get sms_stop => 'स्टॉप';

  @override
  String get filters => 'फ़िल्टर';

  @override
  String get filters_off => 'बंद';

  @override
  String get filters_whitelist => 'व्हाइटलिस्ट';

  @override
  String get filters_blacklist => 'ब्लैकलिस्ट';

  @override
  String get filters_sender => 'प्रेषक';

  @override
  String get filters_senderInfo => 'नंबर या नाम के लिए फ़िल्टर जोड़ें';

  @override
  String get filters_text => 'संदेश';

  @override
  String get filters_textInfo => 'SMS टेक्स्ट के लिए फ़िल्टर जोड़ें';

  @override
  String get filters_test => 'टेस्ट करें';

  @override
  String get filters_save => 'सहेजें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get settings_token => 'बॉट टोकन';

  @override
  String get settings_tokenInfo => '@BotFather से प्राप्त टोकन';

  @override
  String get settings_chatId => 'चैट ID';

  @override
  String get settings_chatIdInfo => 'आपके बॉट के साथ चैट की ID (वैकल्पिक)';

  @override
  String get settings_deviceLabel => 'डिवाइस लेबल';

  @override
  String get settings_deviceLabelInfo => 'कस्टम लेबल (वैकल्पिक)';

  @override
  String get settings_test => 'टेस्ट और सहेजें';

  @override
  String get help_about => 'ऐप के बारे में';

  @override
  String get help_appInfo =>
      'आने वाले SMS संदेशों को स्वचालित रूप से Telegram बॉट को भेजने के लिए ऐप';

  @override
  String get help_howToUse => 'उपयोग कैसे करें';

  @override
  String get help_howToUse_01 =>
      'यदि आपके पास अभी तक Telegram बॉट नहीं है, तो @BotFather का उपयोग करके एक बनाएं और इसका टोकन प्राप्त करें। यह आसान और मुफ़्त है।';

  @override
  String get help_howToUse_02 =>
      'Telegram में अपने बॉट के साथ चैट खोलें, बातचीत शुरू करें या कोई संदेश भेजें। यह अगले चरण के लिए चैट ID स्वचालित रूप से प्राप्त करने के लिए आवश्यक है।';

  @override
  String get help_howToUse_03 =>
      'ऐप खोलें, बॉट सेटिंग्स में टोकन दर्ज करें और सेटिंग्स का परीक्षण करें (यदि आप जानते हैं तो चैट ID भी सेट कर सकते हैं)। यदि परीक्षण सफल होता है, तो सेटिंग्स सहेज ली जाती हैं और Telegram चैट में एक स्वागत संदेश भेजा जाता है।';

  @override
  String get help_howToUse_04 =>
      'बस! अब ऐप आपके बॉट को आने वाले SMS आगे भेजने के लिए तैयार है। SMS फ़ॉरवर्डिंग सक्षम करने के लिए स्टार्ट दबाएँ, या उसे बंद करने के लिए स्टॉप दबाएँ।';

  @override
  String get help_howToUse_04l =>
      'कई डिवाइस से SMS भेजते समय, रिसीविंग फ़ोन की पहचान के लिए सेटिंग्स में डिवाइस लेबल सेट कर सकते हैं।';

  @override
  String get help_howToUse_05 =>
      'कुछ फ़ोन बैटरी बचाने के लिए बैकग्राउंड गतिविधि को सीमित कर सकते हैं। यदि आपको डिलीवरी में लंबे विलंब दिखाई दें, तो इस ऐप के लिए बैटरी ऑप्टिमाइज़ेशन बंद कर दें।';

  @override
  String get help_howToUse_06 =>
      'सुनिश्चित करें कि ऐप काम करने के लिए इंटरनेट कनेक्शन सक्षम रखें।';

  @override
  String get help_filters => 'फ़िल्टर';

  @override
  String get help_filters_01 =>
      'आप आने वाले SMS संदेशों के प्रेषक या टेक्स्ट के लिए फ़िल्टर सेट कर सकते हैं। यदि प्रेषक का नंबर/नाम या टेक्स्ट निर्दिष्ट वर्णों को शामिल करता है तो फ़िल्टर ट्रिगर होता है।';

  @override
  String get help_filters_02 =>
      'दो मोड हैं: व्हाइटलिस्ट (यदि कम से कम एक फ़िल्टर मेल खाता है तो SMS भेजा जाता है) और ब्लैकलिस्ट (यदि कोई फ़िल्टर मेल खाता है तो SMS नहीं भेजा जाता है)। व्हाइटलिस्ट मोड में, यदि कोई फ़िल्टर सेट नहीं है, तो कोई भी SMS बॉट को नहीं भेजा जाएगा।';

  @override
  String get help_filters_03 =>
      'regex के लिए दो स्लैश का उपयोग करें। उदाहरण के लिए, फ़िल्टर /^\\d*555\$/ सभी नंबरों से मेल खाता है जो 555 पर समाप्त होते हैं';

  @override
  String get help_filters_04 =>
      'यह जांचने के लिए कि वर्तमान फ़िल्टर के आधार पर कोई विशिष्ट SMS भेजा जाएगा या नहीं, इनपुट फ़ील्ड में आवश्यक प्रेषक और/या संदेश दर्ज करें और सत्यापित करने के लिए बटन पर क्लिक करें।';
}
