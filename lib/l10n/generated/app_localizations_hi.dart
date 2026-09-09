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
  String get action_close => 'बंद करें';

  @override
  String get action_continue => 'जारी रखें';

  @override
  String get action_delete => 'हटाएं';

  @override
  String get action_duplicate => 'डुप्लिकेट';

  @override
  String get action_exit => 'बाहर निकलें';

  @override
  String get action_save => 'सहेजें';

  @override
  String get action_test => 'टेस्ट करें';

  @override
  String get service_title => 'संदेशों को फॉरवर्ड करना';

  @override
  String get service_text => 'बैकग्राउंड में चल रहा है';

  @override
  String get msg_list => 'संदेश';

  @override
  String get msg_welcome => 'निगरानी सक्षम करने के लिए\nस्टार्ट दबाएँ';

  @override
  String get msg_empty => 'पिछले 24 घंटों में\nकोई संदेश नहीं';

  @override
  String get msg_hello => 'नमस्ते! ^._.^';

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
  String get msg_battery => 'बैटरी';

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
  String get rules_setup => 'नियम सेटअप';

  @override
  String get config => 'पैरामीटर';

  @override
  String get connection => 'कनेक्शन';

  @override
  String get tbot_token => 'बॉट टोकन';

  @override
  String get tbot_chatId => 'चैट ID';

  @override
  String get tbot_chatIdInfo => 'डिफ़ॉल्ट: स्वतः पहचान';

  @override
  String get tbot_server => 'सर्वर URL';

  @override
  String tbot_serverInfo(Object url) {
    return 'डिफ़ॉल्ट: $url';
  }

  @override
  String get ntfy_topic => 'विषय';

  @override
  String get ntfy_priority => 'प्राथमिकता';

  @override
  String get ntfy_priority_01 => 'न्यूनतम';

  @override
  String get ntfy_priority_02 => 'निम्न';

  @override
  String get ntfy_priority_03 => 'डिफ़ॉल्ट';

  @override
  String get ntfy_priority_04 => 'उच्च';

  @override
  String get ntfy_priority_05 => 'अधिकतम';

  @override
  String get ntfy_token => 'एक्सेस टोकन';

  @override
  String get ntfy_tokenInfo => 'Bearer टोकन; डिफ़ॉल्ट: कोई टोकन नहीं';

  @override
  String get ntfy_server => 'सर्वर URL';

  @override
  String ntfy_serverInfo(Object url) {
    return 'डिफ़ॉल्ट: $url';
  }

  @override
  String get smtp_host => 'SMTP होस्ट';

  @override
  String get smtp_protocol => 'प्रोटोकॉल';

  @override
  String get smtp_protocolEmpty => 'कोई नहीं';

  @override
  String get smtp_port => 'पोर्ट';

  @override
  String get smtp_insecureTls => 'सरलीकृत प्रमाणपत्र सत्यापन';

  @override
  String get smtp_insecureTlsInfo =>
      'केवल कनेक्शन त्रुटि होने पर सक्षम करें (खासकर पुराने डिवाइस पर)। इससे कनेक्शन की सुरक्षा कम हो जाती है।';

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
  String get smtp_subjectInfo => 'डिफ़ॉल्ट: ऑटो';

  @override
  String get sms_receiver => 'प्राप्तकर्ता';

  @override
  String get sms_number => 'फ़ोन नंबर';

  @override
  String get sms_numberInfo => 'उदाहरण: +12345678900';

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
  String get options => 'विकल्प';

  @override
  String get options_priority => 'नियम प्राथमिकता';

  @override
  String get options_priorityInfo =>
      'यदि उच्च प्राथमिकता वाला नियम सक्रिय होता है, तो नियम को अनदेखा कर दिया जाता है';

  @override
  String get options_priority_01 => 'उच्चतम';

  @override
  String get options_priority_02 => 'उच्च';

  @override
  String get options_priority_03 => 'मध्यम';

  @override
  String get options_priority_04 => 'निम्न';

  @override
  String get options_priority_05 => 'न्यूनतम';

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
  String get settings_attachSimInfo => 'SIM जानकारी';

  @override
  String get settings_format => 'संदेश प्रारूप';

  @override
  String get settings_formatDefault => 'डिफ़ॉल्ट';

  @override
  String get settings_formatPaste => 'पेस्ट करें';

  @override
  String get settings_formatPreview => 'पूर्वावलोकन देखें';

  @override
  String get settings_formatReset => 'रीसेट करें';

  @override
  String get settings_formatError => 'अमान्य टेम्पलेट प्रारूप।';

  @override
  String get settings_deviceLabel => 'डिवाइस लेबल';

  @override
  String get settings_deviceLabelInfo => 'डिफ़ॉल्ट: कोई लेबल नहीं';

  @override
  String get help_about => 'ऐप के बारे में';

  @override
  String get help_appInfo =>
      'SMS की स्मार्ट फ़ॉरवर्डिंग, इनकमिंग कॉल नोटिफिकेशन और बैटरी स्टेटस अपडेट।';

  @override
  String get help_info => 'त्वरित अवलोकन';

  @override
  String get help_info_01 =>
      'संदेशों को Telegram, ntfy, ईमेल या SMS के ज़रिए फ़ॉरवर्ड करें। कई गंतव्य आसानी से कॉन्फ़िगर करें!';

  @override
  String get help_info_02 =>
      'नियमों की मदद से तय करें कि क्या फ़ॉरवर्ड होगा और कहाँ जाएगा। जरूरत पड़ने पर इन्हें आसानी से डुप्लिकेट या बंद किया जा सकता है।';

  @override
  String get help_info_03 =>
      'संदेश सक्रिय नियमों के अनुसार फ़ॉरवर्ड होते हैं। अगर कनेक्शन त्रुटि हो (जैसे इंटरनेट न हो), तो ऐप अपने-आप दोबारा कोशिश करता है।';

  @override
  String get help_opts_01 =>
      'पहले वे इवेंट चुनें जिन्हें आप फ़ॉरवर्ड करना चाहते हैं। ऐप चलते समय हर इवेंट के लिए तय नियमों के अनुसार एक संदेश बनता और भेजा जाता है।';

  @override
  String get help_opts_02 =>
      'परमानेंट बैकग्राउंड मोड संदेश डिलीवरी की विश्वसनीयता बढ़ाता है (खासकर सिस्टम नोटिफिकेशन के लिए), लेकिन बैटरी खपत काफी बढ़ाता है। इस मोड में नोटिफिकेशन पैनल में स्थायी सूचना दिखती है। जरूरत न हो तो इसे ऑन न करें।';

  @override
  String get help_opts_03 =>
      'इनकमिंग SMS और कॉल फ़ॉरवर्ड करते समय SIM डेटा (स्लॉट और ऑपरेटर) जोड़ने के लिए स्विच चालू करें। कुछ सिस्टम में SIM डेटा उपलब्ध नहीं होता, खासकर कॉल के लिए।';

  @override
  String get help_opts_04 =>
      'यदि आप संदेशों का प्रारूप बदलना चाहते हैं, तो टेम्पलेट फ़ाइल डाउनलोड करें, अपने परिवर्तन करें और सेटिंग्स में टेम्पलेट टेक्स्ट पेस्ट करें।';

  @override
  String get help_opts_04h => 'टेम्पलेट डाउनलोड करें';

  @override
  String get help_opts_05 =>
      'अगर आप ऐप को कई फोनों पर इस्तेमाल करते हैं, तो डिवाइस लेबल सेट कर सकते हैं। यह संदेश के साथ भेजा जाता है ताकि प्राप्त करने वाले फोन की पहचान हो सके।';

  @override
  String get help_opts_06 =>
      'इस ऐप के लिए बैटरी ऑप्टिमाइज़ेशन बंद करना बेहतर है, क्योंकि सिस्टम पावर बचाने के लिए बैकग्राउंड गतिविधि सीमित कर सकता है।';

  @override
  String get help_rule_01 =>
      'सेटिंग्स का परीक्षण करें और सेव करें (सफल परीक्षण पर स्वागत संदेश भेजा जाएगा)। फिर सूची में नियम चालू करें और फ़ॉरवर्डिंग शुरू करने के लिए स्टार्ट दबाएँ!';

  @override
  String get help_tbot_01 =>
      'बॉट नहीं है? Telegram के @BotFather से एक बनाएँ और API टोकन प्राप्त करें।';

  @override
  String get help_tbot_02 =>
      'Telegram ऐप में अपने बॉट के साथ चैट खोलें और कोई भी संदेश भेजें। इससे आपकी चैट ID स्वतः पहचानी जा सकेगी।';

  @override
  String get help_tbot_03 =>
      'Telegram नियम जोड़ें और अपना टोकन पेस्ट करें। चाहें तो चैट ID मैन्युअल भी सेट कर सकते हैं।';

  @override
  String get help_tbot_04 =>
      'आधिकारिक Telegram सर्वर की जगह इस्तेमाल करने के लिए कस्टम API सर्वर URL भी सेट कर सकते हैं।';

  @override
  String help_ntfy_01(Object url) {
    return 'ntfy ऐप या वेब वर्शन ($url) में ऐसे नाम से नए विषय की सदस्यता लें जिसे अनुमान लगाना मुश्किल हो।';
  }

  @override
  String get help_ntfy_02 =>
      'नियम बनाएँ, विषय का नाम दर्ज करें, और चाहें तो नोटिफिकेशन प्राथमिकता सेट करें।';

  @override
  String get help_ntfy_03 =>
      'सार्वजनिक विषय उन सभी के लिए उपलब्ध हैं जो उनका नाम जानते हैं। बेहतर सुरक्षा के लिए प्रमाणीकरण और एक्सेस टोकन का उपयोग करें।';

  @override
  String get help_ntfy_04 =>
      'डिफ़ॉल्ट रूप से आधिकारिक ntfy.sh सर्वर इस्तेमाल होता है, लेकिन आप अपना सर्वर भी सेट कर सकते हैं।';

  @override
  String get help_smtp_01 =>
      'संदेश फ़ॉरवर्डिंग के लिए अलग ईमेल अकाउंट (alias नहीं) बनाना और उसे लॉगिन के रूप में इस्तेमाल करना बेहतर है। खासकर Gmail जैसी सेवाओं में यह ज़्यादा जरूरी है।';

  @override
  String get help_smtp_02 =>
      'एक नियम बनाएँ और कनेक्शन विवरण भरें। आमतौर पर \'ऐप पासवर्ड\' की आवश्यकता होती है (जो ईमेल सुरक्षा सेटिंग्स में जनरेट होता है)।';

  @override
  String get help_sms_01 =>
      'ऐप संदेशों को आउटगोइंग SMS के रूप में फ़ॉरवर्ड करना सपोर्ट करता है।';

  @override
  String get help_sms_02 =>
      'एक नियम बनाएं और प्राप्तकर्ता का फ़ोन नंबर दर्ज करें। मोबाइल नंबर + चिन्ह से शुरू होना चाहिए (अंतरराष्ट्रीय प्रारूप)।';

  @override
  String get help_sms_03 =>
      'SMS उसी SIM से भेजे जाते हैं जो फोन सेटिंग्स में डिफ़ॉल्ट चुनी गई हो।';

  @override
  String get help_filters => 'फ़िल्टर';

  @override
  String get help_filters_01 =>
      'किसी भी नियम के लिए आप प्रेषक और संदेश टेक्स्ट के फ़िल्टर सेट कर सकते हैं। जब प्रेषक नंबर/नाम या टेक्स्ट में दिए गए अक्षर मिलते हैं, फ़िल्टर लागू होता है।';

  @override
  String get help_filters_02 =>
      'दो मोड हैं: व्हाइटलिस्ट (कम से कम एक फ़िल्टर मैच हो तो संदेश फ़ॉरवर्ड होगा) और ब्लैकलिस्ट (कोई भी फ़िल्टर मैच हो तो संदेश फ़ॉरवर्ड नहीं होगा)। व्हाइटलिस्ट मोड में कोई फ़िल्टर न हो तो कोई संदेश फ़ॉरवर्ड नहीं होगा।';

  @override
  String get help_filters_03 =>
      'फ़िल्टर के रूप में रेगुलर एक्सप्रेशन सेट करने के लिए दो / चिन्ह का उपयोग करें। उदाहरण के लिए, फ़िल्टर /^\\d*555\$/ उन नंबरों से मेल खाता है जो 555 पर समाप्त होते हैं।';

  @override
  String get help_filters_04 =>
      'यह जांचने के लिए कि मौजूदा फ़िल्टर के आधार पर कोई खास संदेश फ़ॉरवर्ड होगा या नहीं, इनपुट फ़ील्ड में प्रेषक और/या संदेश टेक्स्ट भरें और जांच बटन दबाएँ।';

  @override
  String get help_filters_05 =>
      'सेट किए गए फ़िल्टर सभी इवेंट प्रकारों पर लागू होते हैं, सिर्फ इनकमिंग SMS पर नहीं।';

  @override
  String get help_options_01 =>
      'नियम की प्राथमिकता प्रोसेसिंग क्रम निर्धारित करती है। यदि कोई नियम सक्रिय होता है (संदेश भेजा गया), तो कम प्राथमिकता वाले नियम छोड़ दिए जाते हैं। समान प्राथमिकता वाले नियम एक साथ सक्रिय होते हैं।';

  @override
  String get consent_welcome =>
      'स्वागत है!\nजारी रखकर, आप पुष्टि करते हैं कि आपने यह जानकारी पढ़ ली है:';

  @override
  String get consent_item_01 =>
      'आपके द्वारा सक्षम सुविधाओं के आधार पर, ऐप आने वाले SMS और कॉल का डेटा प्राप्त कर सकता है और आपके बताए नंबरों पर SMS भेज सकता है।';

  @override
  String get consent_item_02 =>
      'डेटा केवल उन्हीं सेवाओं को भेजा जाता है जिन्हें आपने स्वयं कॉन्फ़िगर किया है। कोई छिपा हुआ सर्वर या एनालिटिक्स नहीं है।';

  @override
  String get consent_item_03 =>
      'संवेदनशील अनुमतियां केवल संबंधित सुविधाएं सक्षम करने पर मांगी जाती हैं।';

  @override
  String get consent_details => 'अधिक जानकारी: ';

  @override
  String get consent_privacyPolicy => 'गोपनीयता नीति';

  @override
  String get error_badRequest =>
      'सर्वर ने अनुरोध अस्वीकार कर दिया। कनेक्शन पैरामीटर जांचें।';

  @override
  String get error_forbidden => 'प्रमाणीकरण त्रुटि। एक्सेस अधिकार जांचें।';

  @override
  String get error_invalidParams => 'कनेक्शन पैरामीटर अमान्य हैं।';

  @override
  String get error_networkError =>
      'कनेक्शन त्रुटि। इंटरनेट कनेक्शन या नेटवर्क सेटिंग्स जांचें।';

  @override
  String get error_networkTimeout =>
      'समय सीमा समाप्त हो गई। नेटवर्क या कनेक्शन पैरामीटर जांचें।';

  @override
  String get error_rateLimited =>
      'अनुरोध सीमा पार हो गई। बाद में फिर प्रयास करें।';

  @override
  String get error_serverError => 'सर्वर त्रुटि। बाद में फिर प्रयास करें।';

  @override
  String get error_smtpAddressRejected =>
      'सर्वर ने प्रेषक या प्राप्तकर्ता का ईमेल अस्वीकार कर दिया। पते जांचें।';

  @override
  String get error_smtpError =>
      'सर्वर ने त्रुटि लौटाई। कनेक्शन पैरामीटर जांचें।';

  @override
  String get error_smtp_unauthorized =>
      'एक्सेस त्रुटि। लॉगिन और पासवर्ड जांचें।';

  @override
  String get error_tbot_conflict =>
      'चैट आईडी प्राप्त नहीं हो सकी। सक्रिय वेबहुक हटाएं या आईडी मैन्युअल रूप से दर्ज करें।';

  @override
  String get error_tbot_forbidden =>
      'प्रमाणीकरण त्रुटि। सुनिश्चित करें कि बॉट के पास चैट का एक्सेस है।';

  @override
  String get error_tbot_unauthorized => 'एक्सेस त्रुटि। टोकन जांचें।';

  @override
  String get error_tbot_uninitialized =>
      'चैट आईडी प्राप्त नहीं हो सकी। Telegram में अपने बॉट के साथ संवाद शुरू करें और फिर से प्रयास करें।';

  @override
  String get error_unauthorized => 'एक्सेस त्रुटि। क्रेडेंशियल्स जांचें।';

  @override
  String get error_unexpectedError => 'कार्रवाई पूरी नहीं हो सकी।';

  @override
  String get error_secretsError =>
      'सुरक्षित स्टोरेज तक पहुंच नहीं हो सकी। फिर से प्रयास करें। यदि त्रुटि बनी रहती है, तो ऐप को पुनः शुरू करें और फ़ॉरवर्डिंग नियमों में पासवर्ड/टोकन जांचें।';

  @override
  String get warn_secretsRecovered =>
      'क्रैश के बाद सुरक्षित स्टोरेज पुनर्प्राप्त किया गया; सहेजे गए पासवर्ड/टोकन हटाए गए हो सकते हैं। फ़ॉरवर्डिंग नियम जांचें और डेटा फिर से दर्ज करें।';

  @override
  String get warn_permissionsRequired =>
      'निगरानी शुरू करने के लिए आवश्यक अनुमतियां दें।';
}
