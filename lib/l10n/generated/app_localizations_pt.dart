// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => 'Toque em Iniciar para\ncomeçar a encaminhar SMS';

  @override
  String get sms_empty => 'Nenhum SMS recebido\nna sessão atual';

  @override
  String get sms_hello => 'Olá do SMS Telebot! =^•⩊•^=';

  @override
  String get sms_from => 'SMS de';

  @override
  String get sms_received => 'Recebido';

  @override
  String get sms_sent => 'Encaminhado';

  @override
  String get sms_start => 'Iniciar';

  @override
  String get sms_stop => 'Parar';

  @override
  String get filters => 'FILTROS';

  @override
  String get filters_off => 'Desativado';

  @override
  String get filters_whitelist => 'Lista branca';

  @override
  String get filters_blacklist => 'Lista negra';

  @override
  String get filters_sender => 'Remetente';

  @override
  String get filters_senderInfo => 'Adicione filtros para números ou nomes';

  @override
  String get filters_text => 'Mensagem';

  @override
  String get filters_textInfo => 'Adicione filtros para o texto do SMS';

  @override
  String get filters_test => 'Testar';

  @override
  String get filters_save => 'Salvar';

  @override
  String get settings => 'CONFIGURAÇÕES';

  @override
  String get settings_token => 'Token do bot';

  @override
  String get settings_tokenInfo => 'Token obtido do @BotFather';

  @override
  String get settings_chatId => 'ID do chat';

  @override
  String get settings_chatIdInfo => 'ID do chat com seu bot (opcional)';

  @override
  String get settings_deviceLabel => 'Rótulo do dispositivo';

  @override
  String get settings_deviceLabelInfo => 'Rótulo personalizado (opcional)';

  @override
  String get settings_test => 'Testar e salvar';

  @override
  String get help_about => 'Sobre';

  @override
  String get help_appInfo =>
      'App para encaminhar automaticamente mensagens SMS recebidas para um bot do Telegram';

  @override
  String get help_howToUse => 'Como usar';

  @override
  String get help_howToUse_01 =>
      'Se você ainda não tem um bot do Telegram, use o @BotFather para criar um e obter seu token. É simples e gratuito.';

  @override
  String get help_howToUse_02 =>
      'Abra um chat com seu bot no Telegram, inicie uma conversa ou envie qualquer mensagem. Isso é necessário para obter automaticamente o ID do chat na próxima etapa.';

  @override
  String get help_howToUse_03 =>
      'Abra o app, nas configurações do bot, insira o token e teste as configurações (você também pode definir o ID do chat se souber). Se o teste for bem-sucedido, as configurações são salvas e uma mensagem de boas-vindas é enviada ao chat do Telegram.';

  @override
  String get help_howToUse_04 =>
      'Pronto! O app agora está preparado para encaminhar os SMS recebidos para o seu bot. Toque em Iniciar para ativar o encaminhamento de SMS ou em Parar para desativá‑lo.';

  @override
  String get help_howToUse_04l =>
      'Ao encaminhar SMS de vários dispositivos, você pode definir um rótulo de dispositivo nas configurações para identificar o telefone receptor.';

  @override
  String get help_howToUse_05 =>
      'Alguns telefones podem limitar a atividade em segundo plano para economizar bateria. Se você notar grandes atrasos na entrega, desative a otimização de bateria para o app.';

  @override
  String get help_howToUse_06 =>
      'Certifique-se de manter a conexão com a internet ativada para que o app funcione.';

  @override
  String get help_filters => 'Filtros';

  @override
  String get help_filters_01 =>
      'Você pode definir filtros para o remetente ou texto das mensagens SMS recebidas. Um filtro é acionado se o número/nome do remetente ou o texto contiver os caracteres especificados.';

  @override
  String get help_filters_02 =>
      'Existem dois modos: lista branca (o SMS é encaminhado se pelo menos um filtro corresponder) e lista negra (o SMS não é encaminhado se algum filtro corresponder). No modo lista branca, se nenhum filtro estiver definido, nenhum SMS será encaminhado ao bot.';

  @override
  String get help_filters_03 =>
      'Use duas barras para regex. Por exemplo, o filtro /^\\d*555\$/ corresponde a todos os números que terminam com 555';

  @override
  String get help_filters_04 =>
      'Para verificar se um SMS específico será encaminhado com base nos filtros atuais, insira o remetente e/ou mensagem necessários nos campos de entrada e clique no botão para verificar.';
}
