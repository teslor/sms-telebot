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
  String get service_title => 'SMS Telebot सक्रिय है';

  @override
  String get service_text => 'घटनाओं की निगरानी की जा रही है';

  @override
  String get msg_list => 'संदेश';

  @override
  String get msg_welcome => 'निगरानी सक्षम करने के लिए\nस्टार्ट दबाएँ';

  @override
  String get msg_empty => 'पिछले 24 घंटों में\nकोई संदेश नहीं';

  @override
  String get msg_hello => 'नमस्ते! =^•⩊•^=';

  @override
  String get msg_received => 'प्राप्त';

  @override
  String get msg_sent => 'फ़ॉरवर्ड किया गया';

  @override
  String get msg_start => 'स्टार्ट';

  @override
  String get msg_stop => 'स्टॉप';

  @override
  String get msg_sms => 'SMS';

  @override
  String get msg_call => 'कॉल';

  @override
  String get msg_lowBattery => 'बैटरी कम';

  @override
  String get msg_chargerConnected => 'चार्जर कनेक्टेड';

  @override
  String get msg_chargerDisconnected => 'चार्जर डिस्कनेक्टेड';

  @override
  String get rule => 'नियम';

  @override
  String get rule_add => 'नियम जोड़ें';

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
  String get tbot_chatId => 'चैट ID';

  @override
  String get tbot_chatIdInfo => 'डिफ़ॉल्ट: स्वतः पहचान';

  @override
  String get tbot_apiUrl => 'API URL';

  @override
  String get tbot_apiUrlInfo => 'डिफ़ॉल्ट: मानक Telegram URL';

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
  String get smtp_fromEmailInfo => 'डिफ़ॉल्ट: लॉगिन';

  @override
  String get smtp_toEmail => 'प्राप्तकर्ता ईमेल';

  @override
  String get smtp_toEmailInfo => 'डिफ़ॉल्ट: लॉगिन';

  @override
  String get smtp_subject => 'विषय';

  @override
  String get smtp_subjectInfo => 'डिफ़ॉल्ट: विषय नहीं';

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
  String get filters_textInfo => 'टेक्स्ट फ़िल्टर जोड़ें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get settings_forwardEvents => 'फ़ॉरवर्ड करने के लिए इवेंट्स';

  @override
  String get settings_forwardSms => 'इनकमिंग SMS';

  @override
  String get settings_forwardCalls => 'इनकमिंग कॉल';

  @override
  String get settings_notifyLowBattery => 'बैटरी कम';

  @override
  String get settings_notifyChargerState => 'चार्जर कनेक्शन';

  @override
  String get settings_enableForeground => 'हमेशा बैकग्राउंड में चलाएं';

  @override
  String get settings_deviceLabel => 'डिवाइस लेबल';

  @override
  String get settings_deviceLabelInfo => 'डिफ़ॉल्ट: कोई लेबल नहीं';

  @override
  String get help_about => 'ऐप के बारे में';

  @override
  String get help_appInfo =>
      'आने वाले SMS को अपने-आप फ़ॉरवर्ड करने के लिए ऐप।\nअतिरिक्त फीचर: इनकमिंग कॉल और बैटरी स्टेटस की सूचनाएं।';

  @override
  String get help_info => 'त्वरित अवलोकन';

  @override
  String get help_info_01 =>
      'इस ऐप से आप संदेशों को Telegram बॉट या SMTP एक्सेस वाले ईमेल पते पर फ़ॉरवर्ड कर सकते हैं। आप एक से अधिक बॉट या ईमेल पते जोड़ सकते हैं।';

  @override
  String get help_info_02 =>
      'हर कनेक्शन के लिए एक फ़ॉरवर्डिंग नियम बनता है — वही तय करता है कि कौन से संदेश कहाँ भेजने हैं। जरूरत पड़ने पर नियमों को डुप्लिकेट, ऑन या ऑफ किया जा सकता है।';

  @override
  String get help_info_03 =>
      'ऐप सक्रिय नियमों को देखकर नए संदेश को फ़ॉरवर्ड करने की कोशिश करता है। अगर तकनीकी कारण (जैसे इंटरनेट न होना) से असफल हो जाए, तो बाद में फिर प्रयास करेगा।';

  @override
  String get help_info_04 =>
      'ऐप के सही काम करने के लिए इंटरनेट कनेक्शन चालू रखें।';

  @override
  String get help_opts_01 =>
      'पहले वे इवेंट चुनें जिन्हें आप फ़ॉरवर्ड करना चाहते हैं। ऐप चलते समय हर इवेंट के लिए तय नियमों के अनुसार एक संदेश बनता और भेजा जाता है।';

  @override
  String get help_opts_02 =>
      'परमानेंट बैकग्राउंड मोड संदेश डिलीवरी की विश्वसनीयता बढ़ाता है (खासकर सिस्टम नोटिफिकेशन के लिए), लेकिन बैटरी खपत काफी बढ़ाता है। इस मोड में नोटिफिकेशन पैनल में स्थायी सूचना दिखती है। जरूरत न हो तो इसे ऑन न करें।';

  @override
  String get help_opts_03 =>
      'अगर आप कई फोनों से संदेश फ़ॉरवर्ड कर रहे हैं, तो डिवाइस लेबल सेट कर सकते हैं। यह संदेश के साथ भेजा जाता है ताकि स्रोत फोन की पहचान हो सके।';

  @override
  String get help_opts_04 =>
      'इस ऐप के लिए बैटरी ऑप्टिमाइज़ेशन बंद करना बेहतर है, क्योंकि सिस्टम पावर बचाने के लिए बैकग्राउंड गतिविधि सीमित कर सकता है।';

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
      'हो गया! अब संदेश आपके बॉट को फ़ॉरवर्ड करने के लिए सब तैयार है। नियम चालू करें और शुरू करने के लिए \'Start\' दबाएँ।';

  @override
  String get help_tbot_05 =>
      'आप चाहें तो आधिकारिक Telegram सर्वर की जगह कस्टम API सर्वर URL भी सेट कर सकते हैं।';

  @override
  String get help_smtp => 'SMTP सर्वर कनेक्ट करना';

  @override
  String get help_smtp_01 =>
      'संदेश फ़ॉरवर्डिंग के लिए अलग ईमेल (alias नहीं) बनाना बेहतर है — यही आपका लॉगिन भी होगा। खासकर Gmail जैसी सेवाओं में यह ज़्यादा जरूरी है।';

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
      'आप प्रेषक या संदेश टेक्स्ट के लिए फ़िल्टर सेट कर सकते हैं। जब प्रेषक नंबर/नाम या टेक्स्ट में दिए गए अक्षर मिलते हैं, फ़िल्टर लागू होता है।';

  @override
  String get help_filters_02 =>
      'दो मोड हैं: व्हाइटलिस्ट (कम से कम एक फ़िल्टर मैच हो तो संदेश फ़ॉरवर्ड होगा) और ब्लैकलिस्ट (कोई भी फ़िल्टर मैच हो तो संदेश फ़ॉरवर्ड नहीं होगा)। व्हाइटलिस्ट मोड में कोई फ़िल्टर न हो तो कोई संदेश फ़ॉरवर्ड नहीं होगा।';

  @override
  String get help_filters_03 =>
      'regex के लिए दो स्लैश का उपयोग करें। उदाहरण के लिए, फ़िल्टर /^\\d*555\$/ सभी नंबरों से मेल खाता है जो 555 पर समाप्त होते हैं';

  @override
  String get help_filters_04 =>
      'यह जांचने के लिए कि मौजूदा फ़िल्टर के आधार पर कोई खास संदेश फ़ॉरवर्ड होगा या नहीं, इनपुट फ़ील्ड में प्रेषक और/या संदेश टेक्स्ट भरें और जांच बटन दबाएँ।';

  @override
  String get help_filters_05 =>
      'सेट किए गए फ़िल्टर सभी इवेंट प्रकारों पर लागू होते हैं, सिर्फ इनकमिंग SMS पर नहीं।';

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

  @override
  String get warn_permissionsRequired =>
      'निगरानी शुरू करने के लिए, कृपया आवश्यक अनुमति दें।';
}
