// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get action_cancel => 'Cancelar';

  @override
  String get action_delete => 'Excluir';

  @override
  String get action_duplicate => 'Duplicar';

  @override
  String get action_save => 'Salvar';

  @override
  String get action_test => 'Testar';

  @override
  String get sms => 'SMS';

  @override
  String get sms_welcome => 'Toque em Iniciar para\ncomeçar a encaminhar SMS';

  @override
  String get sms_empty => 'Nenhum SMS recebido\nnas últimas 24 horas';

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
  String get rule => 'Regra';

  @override
  String get rule_add => 'Adicionar regra de encaminhamento';

  @override
  String get rule_copySuffix => 'cópia';

  @override
  String get rule_deleteHeader => 'Excluir regra?';

  @override
  String get rule_deleteText => 'Esta ação não pode ser desfeita.';

  @override
  String get rule_noParams => 'Configure esta regra antes de ativá-la.';

  @override
  String get rules => 'REGRAS';

  @override
  String get rules_empty => 'Ainda não há regras.\nAdicione a primeira!';

  @override
  String get connection => 'Conexão';

  @override
  String get tbot => 'Bot do Telegram';

  @override
  String get tbot_token => 'Token do bot';

  @override
  String get tbot_tokenInfo => 'Token obtido do @BotFather';

  @override
  String get tbot_chatId => 'ID do chat';

  @override
  String get tbot_chatIdInfo => 'ID do chat com seu bot (opcional)';

  @override
  String get smtp => 'Servidor SMTP';

  @override
  String get smtp_host => 'Host SMTP';

  @override
  String get smtp_protocol => 'Protocolo';

  @override
  String get smtp_protocolEmpty => 'Nenhum';

  @override
  String get smtp_port => 'Porta';

  @override
  String get smtp_login => 'Login';

  @override
  String get smtp_loginInfo => 'Geralmente o endereço de e-mail completo';

  @override
  String get smtp_password => 'Senha';

  @override
  String get smtp_passwordInfo => 'Geralmente a senha para apps externos';

  @override
  String get smtp_fromEmail => 'E-mail do remetente';

  @override
  String get smtp_fromEmailInfo => 'Opcional - login se estiver vazio';

  @override
  String get smtp_toEmail => 'E-mail do destinatário';

  @override
  String get smtp_toEmailInfo => 'Endereço de e-mail do destinatário';

  @override
  String get smtp_subject => 'Assunto';

  @override
  String get smtp_subjectInfo => 'Assunto do e-mail (opcional)';

  @override
  String get filters => 'Filtros';

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
  String get settings => 'CONFIGURAÇÕES';

  @override
  String get settings_deviceLabel => 'Rótulo do dispositivo';

  @override
  String get settings_deviceLabelInfo => 'Rótulo personalizado (opcional)';

  @override
  String get help_about => 'Sobre';

  @override
  String get help_appInfo =>
      'App para encaminhar automaticamente mensagens SMS recebidas para um bot do Telegram';

  @override
  String get help_info => 'Introdução';

  @override
  String get help_info_01 =>
      'O aplicativo encaminha SMS para um bot do Telegram ou e-mail. Você precisará de seu próprio bot ou de uma conta com acesso SMTP.';

  @override
  String get help_info_02 =>
      'Para cada conexão, é criada uma regra de encaminhamento que define quais SMS enviar e para onde. As regras podem ser duplicadas, ativadas ou desativadas conforme necessário.';

  @override
  String get help_info_03 =>
      'Quando um SMS chega, o aplicativo verifica as regras ativas e tenta o encaminhamento. Se falhar por motivos técnicos (como falta de internet), o aplicativo tentará novamente mais tarde.';

  @override
  String get help_info_04 =>
      'Ao encaminhar SMS de vários telefones, você pode definir uma etiqueta de dispositivo nas configurações — ela é enviada junto com o SMS para identificar o telefone de origem.';

  @override
  String get help_info_05 =>
      'Recomenda-se desativar a otimização de bateria para o app, pois o sistema pode limitar a atividade dos apps em segundo plano para economizar energia.';

  @override
  String get help_info_06 =>
      'Certifique-se de manter a conexão com a internet ativada para que o app funcione.';

  @override
  String get help_tbot => 'Conexão do Bot do Telegram';

  @override
  String get help_tbot_01 =>
      'Se você ainda não tem um bot do Telegram, use o @BotFather para criar um e obter seu token. É simples e gratuito.';

  @override
  String get help_tbot_02 =>
      'Abra um chat com seu bot no Telegram, inicie uma conversa ou envie qualquer mensagem. Isso é necessário para obter automaticamente o ID do chat na próxima etapa.';

  @override
  String get help_tbot_03 =>
      'No app, crie uma regra para o bot e insira o token (e o ID do chat, se souber). Teste as configurações e salve. Se funcionar, você receberá uma mensagem de boas-vindas.';

  @override
  String get help_tbot_04 =>
      'Pronto! Tudo configurado para encaminhar SMS ao seu bot. Ative a regra e clique em Iniciar para começar.';

  @override
  String get help_smtp => 'Conexão do Servidor SMTP';

  @override
  String get help_smtp_01 =>
      'Para o encaminhamento de SMS, é melhor criar um e-mail separado (não um alias): ele também será o seu login. Especialmente relevante para o Gmail e serviços semelhantes.';

  @override
  String get help_smtp_02 =>
      'Crie uma regra e preencha os dados de conexão. Geralmente é necessária uma \'senha de app\' (gerada nas configurações de segurança do seu e-mail).';

  @override
  String get help_smtp_03 =>
      'Teste e salve as configurações, ative a regra e clique em Iniciar.';

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

  @override
  String get error_badRequest =>
      'A solicitação foi rejeitada. Verifique os parâmetros de conexão informados.';

  @override
  String get error_invalidParams =>
      'Parâmetros de conexão inválidos. Corrija-os e tente novamente.';

  @override
  String get error_networkError =>
      'Verifique sua conexão com a internet e tente novamente.';

  @override
  String get error_networkTimeout =>
      'O tempo de espera foi excedido. Verifique sua internet e confirme que os parâmetros de conexão informados estão corretos.';

  @override
  String get error_rateLimited =>
      'Você está enviando solicitações rápido demais. Aguarde um momento e tente novamente.';

  @override
  String get error_serverError =>
      'O servidor está indisponível no momento. Tente novamente mais tarde.';

  @override
  String get error_smtpAddressRejected =>
      'O servidor rejeitou o e-mail do remetente ou do destinatário. Verifique os endereços.';

  @override
  String get error_smtpError =>
      'O servidor retornou um erro. Verifique os parâmetros de conexão informados.';

  @override
  String get error_smtp_forbidden =>
      'A ação foi rejeitada pelo servidor. Verifique as permissões de acesso.';

  @override
  String get error_smtp_unauthorized =>
      'Erro de autorização. Verifique o login e a senha.';

  @override
  String get error_tbot_conflict =>
      'Não foi possível obter o ID do chat. Remova o webhook ativo ou informe o ID manualmente.';

  @override
  String get error_tbot_forbidden =>
      'O Telegram negou esta ação. Certifique-se de que o bot tem acesso ao chat.';

  @override
  String get error_tbot_unauthorized =>
      'Erro de autorização. Informe um token válido e tente novamente.';

  @override
  String get error_tbot_uninitialized =>
      'Não foi possível obter o ID do chat. Inicie uma conversa com seu bot no Telegram e tente novamente.';

  @override
  String get error_unexpectedError =>
      'Ocorreu um erro inesperado. Tente novamente mais tarde.';

  @override
  String get error_secretsError =>
      'Não foi possível acessar o armazenamento seguro. Tente novamente. Se o erro persistir, reinicie o app e verifique as senhas/tokens nas regras de encaminhamento.';

  @override
  String get warn_secretsRecovered =>
      'O armazenamento seguro foi recuperado após uma falha; senhas/tokens salvos podem ter sido apagados. Verifique as regras de encaminhamento e insira os dados novamente.';
}
