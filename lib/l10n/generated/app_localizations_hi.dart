// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get action_cancel => 'रद्द करें';

  @override
  String get action_delete => 'हटाएं';

  @override
  String get action_duplicate => 'डुप्लिकेट';

  @override
  String get action_save => 'सहेजें';

  @override
  String get action_test => 'टेस्ट करें';

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => 'SMS फ़ॉरवर्डिंग शुरू करने के लिए\nस्टार्ट दबाएँ';

  @override
  String get sms_empty => 'पिछले 24 घंटों में\nकोई इनकमिंग SMS नहीं';

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
  String get rule => 'नियम';

  @override
  String get rule_add => 'फ़ॉरवर्डिंग नियम जोड़ें';

  @override
  String get rule_copySuffix => 'कॉपी';

  @override
  String get rule_deleteHeader => 'नियम हटाएं?';

  @override
  String get rule_deleteText => 'इस कार्रवाई को वापस नहीं लिया जा सकता।';

  @override
  String get rule_noParams =>
      'इस नियम को सक्रिय करने से पहले कृपया इसे कॉन्फ़िगर करें।';

  @override
  String get rules => 'नियम';

  @override
  String get rules_empty => 'अभी तक कोई नियम नहीं है।\nपहला जोड़ें!';

  @override
  String get connection => 'कनेक्शन';

  @override
  String get tbot => 'Telegram बॉट';

  @override
  String get tbot_token => 'बॉट टोकन';

  @override
  String get tbot_tokenInfo => '@BotFather से प्राप्त टोकन';

  @override
  String get tbot_chatId => 'चैट ID';

  @override
  String get tbot_chatIdInfo => 'आपके बॉट के साथ चैट की ID (वैकल्पिक)';

  @override
  String get smtp => 'SMTP सर्वर';

  @override
  String get smtp_host => 'SMTP होस्ट';

  @override
  String get smtp_protocol => 'प्रोटोकॉल';

  @override
  String get smtp_protocolEmpty => 'कोई नहीं';

  @override
  String get smtp_port => 'पोर्ट';

  @override
  String get smtp_login => 'लॉगिन';

  @override
  String get smtp_loginInfo => 'आमतौर पर पूरा ईमेल पता';

  @override
  String get smtp_password => 'पासवर्ड';

  @override
  String get smtp_passwordInfo => 'आमतौर पर बाहरी ऐप्स के लिए पासवर्ड';

  @override
  String get smtp_fromEmail => 'प्रेषक ईमेल';

  @override
  String get smtp_fromEmailInfo => 'वैकल्पिक - खाली होने पर लॉगिन';

  @override
  String get smtp_toEmail => 'प्राप्तकर्ता ईमेल';

  @override
  String get smtp_toEmailInfo => 'प्राप्तकर्ता का ईमेल पता';

  @override
  String get smtp_subject => 'विषय';

  @override
  String get smtp_subjectInfo => 'ईमेल विषय (वैकल्पिक)';

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
  String get settings => 'सेटिंग्स';

  @override
  String get settings_deviceLabel => 'डिवाइस लेबल';

  @override
  String get settings_deviceLabelInfo => 'कस्टम लेबल (वैकल्पिक)';

  @override
  String get help_about => 'ऐप के बारे में';

  @override
  String get help_appInfo =>
      'आने वाले SMS संदेशों को स्वचालित रूप से Telegram बॉट को भेजने के लिए ऐप';

  @override
  String get help_info => 'त्वरित अवलोकन';

  @override
  String get help_info_01 =>
      'यह ऐप आने वाले SMS को Telegram बॉट या ईमेल पर फॉरवर्ड करता है। इसके लिए आपको अपने बॉट या SMTP एक्सेस वाले ईमेल की आवश्यकता होगी।';

  @override
  String get help_info_02 =>
      'प्रत्येक कनेक्शन के पैरामीटर \'फॉरवर्डिंग नियमों\' में सेट किए जाते हैं, जिससे आप चुन सकते हैं कि कौन सा SMS कहाँ भेजना है। आप नियमों को कॉपी कर सकते हैं और जब चाहें चालू या बंद कर सकते हैं।';

  @override
  String get help_info_03 =>
      'SMS आने पर, ऐप सभी सक्रिय नियमों की जाँच करता है और उसे भेजने का प्रयास करता है। यदि तकनीकी कारणों से (जैसे इंटरनेट न होना) विफल रहता है, तो स्वतः पुनः प्रयास किया जाएगा।';

  @override
  String get help_info_04 =>
      'कई डिवाइस से SMS भेजते समय, रिसीविंग फ़ोन की पहचान के लिए सेटिंग्स में डिवाइस लेबल सेट कर सकते हैं।';

  @override
  String get help_info_05 =>
      'ऐप के लिए बैटरी ऑप्टिमाइज़ेशन बंद करने की सलाह दी जाती है, क्योंकि सिस्टम बैटरी बचाने के लिए बैकग्राउंड में ऐप्स की गतिविधि को सीमित कर सकता है।';

  @override
  String get help_info_06 =>
      'सुनिश्चित करें कि ऐप काम करने के लिए इंटरनेट कनेक्शन सक्षम रखें।';

  @override
  String get help_tbot => 'Telegram बॉट कनेक्ट करना';

  @override
  String get help_tbot_01 =>
      'यदि आपके पास अभी तक Telegram बॉट नहीं है, तो @BotFather का उपयोग करके एक बनाएं और इसका टोकन प्राप्त करें। यह आसान और मुफ़्त है।';

  @override
  String get help_tbot_02 =>
      'Telegram में अपने बॉट के साथ चैट खोलें, बातचीत शुरू करें या कोई संदेश भेजें। यह अगले चरण के लिए चैट ID स्वचालित रूप से प्राप्त करने के लिए आवश्यक है।';

  @override
  String get help_tbot_03 =>
      'ऐप में Telegram बॉट के लिए एक नियम बनाएँ और टोकन दर्ज करें (यदि पता हो तो चैट आईडी भी सेट कर सकते हैं)। सेटिंग्स का परीक्षण करें और फिर सेव करें। सफल होने पर एक स्वागत संदेश आएगा।';

  @override
  String get help_tbot_04 =>
      'हो गया! अब आपका बॉट SMS प्राप्त करने के लिए तैयार है। नियम चालू करें और शुरू करने के लिए \'Start\' दबाएँ।';

  @override
  String get help_smtp => 'SMTP सर्वर कनेक्ट करना';

  @override
  String get help_smtp_01 =>
      'फॉरवर्डिंग के लिए एक अलग ईमेल (alias नहीं) रखने की सलाह दी जाती है — यही आपका लॉगिन होगा। विशेष रूप से Gmail जैसी सेवाओं के लिए।';

  @override
  String get help_smtp_02 =>
      'एक नियम बनाएँ और कनेक्शन विवरण भरें। आमतौर पर \'ऐप पासवर्ड\' की आवश्यकता होती है (जो ईमेल सुरक्षा सेटिंग्स में जनरेट होता है)।';

  @override
  String get help_smtp_03 =>
      'सेटिंग्स टेस्ट करें और सेव करें, नियम चालू करें और \'Start\' दबाएँ।';

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

  @override
  String get error_badRequest =>
      'अनुरोध अस्वीकार कर दिया गया। दर्ज किए गए कनेक्शन पैरामीटर जांचें।';

  @override
  String get error_invalidParams =>
      'कनेक्शन पैरामीटर अमान्य हैं। उन्हें ठीक करें और फिर से प्रयास करें।';

  @override
  String get error_networkError =>
      'अपना इंटरनेट कनेक्शन जांचें और फिर से प्रयास करें।';

  @override
  String get error_networkTimeout =>
      'समय सीमा समाप्त हो गई। इंटरनेट जांचें और सुनिश्चित करें कि दर्ज किए गए कनेक्शन पैरामीटर सही हैं।';

  @override
  String get error_rateLimited =>
      'आप बहुत तेज़ी से अनुरोध भेज रहे हैं। कृपया कुछ देर प्रतीक्षा करें।';

  @override
  String get error_serverError =>
      'सर्वर वर्तमान में उपलब्ध नहीं है। कृपया बाद में प्रयास करें।';

  @override
  String get error_smtpAddressRejected =>
      'सर्वर ने प्रेषक या प्राप्तकर्ता का ईमेल अस्वीकार कर दिया। पते जांचें।';

  @override
  String get error_smtpError =>
      'सर्वर ने त्रुटि लौटाई। दर्ज किए गए कनेक्शन पैरामीटर जांचें।';

  @override
  String get error_smtp_forbidden =>
      'कार्रवाई सर्वर द्वारा अस्वीकार कर दी गई। एक्सेस अधिकार जांचें।';

  @override
  String get error_smtp_unauthorized =>
      'प्राधिकरण त्रुटि। लॉगिन और पासवर्ड जांचें।';

  @override
  String get error_tbot_conflict =>
      'चैट आईडी प्राप्त नहीं हो सकी। सक्रिय वेबहुक हटाएं या आईडी मैन्युअल रूप से दर्ज करें।';

  @override
  String get error_tbot_forbidden =>
      'Telegram ने इस कार्रवाई को रोक दिया। सुनिश्चित करें कि बॉट के पास चैट का एक्सेस है।';

  @override
  String get error_tbot_unauthorized =>
      'प्राधिकरण त्रुटि। सही टोकन दर्ज करें और फिर से प्रयास करें।';

  @override
  String get error_tbot_uninitialized =>
      'चैट आईडी प्राप्त नहीं हो सकी। Telegram में अपने बॉट के साथ संवाद शुरू करें और फिर से प्रयास करें।';

  @override
  String get error_unexpectedError =>
      'एक अप्रत्याशित त्रुटि हुई। कृपया बाद में प्रयास करें।';

  @override
  String get error_secretsError =>
      'सुरक्षित स्टोरेज तक पहुंच नहीं हो सकी। फिर से प्रयास करें। यदि त्रुटि बनी रहती है, तो ऐप को पुनः शुरू करें और फ़ॉरवर्डिंग नियमों में पासवर्ड/टोकन जांचें।';

  @override
  String get warn_secretsRecovered =>
      'क्रैश के बाद सुरक्षित स्टोरेज पुनर्प्राप्त किया गया; सहेजे गए पासवर्ड/टोकन हटाए गए हो सकते हैं। फ़ॉरवर्डिंग नियम जांचें और डेटा फिर से दर्ज करें।';
}
