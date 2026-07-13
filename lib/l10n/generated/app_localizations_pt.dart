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
  String get service_title => 'SMS Telebot está ativo';

  @override
  String get service_text => 'Monitorando eventos';

  @override
  String get msg_list => 'Mensagens';

  @override
  String get msg_welcome => 'Toque em Iniciar\npara habilitar o monitoramento';

  @override
  String get msg_empty => 'Nenhuma mensagem\nnas últimas 24 horas';

  @override
  String get msg_hello => 'Olá! ^._.^';

  @override
  String get msg_received => 'Recebido';

  @override
  String get msg_sent => 'Encaminhado';

  @override
  String get msg_start => 'Iniciar';

  @override
  String get msg_stop => 'Parar';

  @override
  String get msg_sms => 'SMS';

  @override
  String get msg_call => 'Chamada';

  @override
  String get msg_lowBattery => 'Bateria fraca';

  @override
  String get msg_chargerConnected => 'Carregador conectado';

  @override
  String get msg_chargerDisconnected => 'Carregador desconectado';

  @override
  String get rule => 'Regra';

  @override
  String get rule_add => 'Adicionar regra';

  @override
  String get rule_copySuffix => 'cópia';

  @override
  String get rule_deleteHeader => 'Excluir regra?';

  @override
  String get rule_deleteText => 'Esta ação não pode ser desfeita.';

  @override
  String get rule_noParams => 'Configure esta regra antes de ativá-la.';

  @override
  String get rules => 'Regras';

  @override
  String get rules_empty => 'Ainda não há regras.\nAdicione a primeira!';

  @override
  String get config => 'Parâmetros';

  @override
  String get connection => 'Conexão';

  @override
  String get tbot => 'Bot do Telegram';

  @override
  String get tbot_token => 'Token do bot';

  @override
  String get tbot_chatId => 'ID do chat';

  @override
  String get tbot_chatIdInfo => 'Padrão: detecção automática';

  @override
  String get tbot_apiUrl => 'URL da API';

  @override
  String get tbot_apiUrlInfo => 'Padrão: URL padrão do Telegram';

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
  String get smtp_insecureTls => 'Validação de certificado simplificada';

  @override
  String get smtp_insecureTlsInfo =>
      'Ative apenas se houver erros de conexão (especialmente em dispositivos antigos). Isso reduz a segurança da conexão.';

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
  String get smtp_fromEmailInfo => 'Padrão: login';

  @override
  String get smtp_toEmail => 'E-mail do destinatário';

  @override
  String get smtp_toEmailInfo => 'Padrão: login';

  @override
  String get smtp_subject => 'Assunto';

  @override
  String get smtp_subjectInfo => 'Padrão: auto';

  @override
  String get sms_receiver => 'Destinatário';

  @override
  String get sms_number => 'Número de telefone';

  @override
  String get sms_numberInfo => 'Exemplo: +12345678900';

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
  String get filters_textInfo => 'Adicionar filtros de texto';

  @override
  String get options => 'Opções';

  @override
  String get options_priority => 'Prioridade da regra';

  @override
  String get options_priorityInfo =>
      'Regra é ignorada se uma regra de maior prioridade for acionada';

  @override
  String get options_priority_01 => 'Máxima';

  @override
  String get options_priority_02 => 'Alta';

  @override
  String get options_priority_03 => 'Média';

  @override
  String get options_priority_04 => 'Baixa';

  @override
  String get options_priority_05 => 'Mínima';

  @override
  String get settings => 'Configurações';

  @override
  String get settings_forwardEvents => 'Eventos para encaminhar';

  @override
  String get settings_forwardSms => 'SMS recebidos';

  @override
  String get settings_forwardCalls => 'Chamadas recebidas';

  @override
  String get settings_notifyLowBattery => 'Bateria fraca';

  @override
  String get settings_notifyChargerState => 'Estado do carregador';

  @override
  String get settings_enableForeground => 'Sempre executar em segundo plano';

  @override
  String get settings_attachSimInfo => 'Anexar dados SIM';

  @override
  String get settings_deviceLabel => 'Rótulo do dispositivo';

  @override
  String get settings_deviceLabelInfo => 'Padrão: sem rótulo';

  @override
  String get help_about => 'Sobre';

  @override
  String get help_appInfo =>
      'Encaminhamento inteligente de SMS, notificações de chamadas recebidas e status da bateria.';

  @override
  String get help_info => 'Introdução';

  @override
  String get help_info_01 =>
      'Encaminhe mensagens para um bot do Telegram, por e-mail (SMTP) ou como SMS. Você pode adicionar vários bots ou endereços de e-mail.';

  @override
  String get help_info_02 =>
      'Use regras para definir o que encaminhar e para onde. Você pode duplicá-las ou desativá-las quando necessário.';

  @override
  String get help_info_03 =>
      'As mensagens são encaminhadas conforme as regras ativas. Se ocorrer um erro de conexão (por exemplo, sem internet), novas tentativas são feitas automaticamente.';

  @override
  String get help_opts_01 =>
      'Primeiro, selecione os eventos que você quer encaminhar. Enquanto o app estiver em execução, uma mensagem é gerada e enviada para cada evento conforme as regras definidas.';

  @override
  String get help_opts_02 =>
      'O modo permanente em segundo plano melhora a confiabilidade do envio (principalmente para notificações do sistema), mas aumenta bastante o consumo de bateria. Nesse modo, aparece uma notificação persistente. Não é recomendado ativar sem necessidade.';

  @override
  String get help_opts_025 =>
      'Para incluir dados do SIM (número do slot e operadora) ao encaminhar SMS e chamadas, ative o interruptor correspondente.';

  @override
  String get help_opts_03 =>
      'Se você usa o app em vários telefones, pode definir um rótulo do dispositivo. Ele é enviado junto com a mensagem para identificar o telefone de destino.';

  @override
  String get help_opts_04 =>
      'É recomendado desativar a otimização de bateria para este app, pois o sistema pode limitar a atividade em segundo plano para economizar energia.';

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
      'Pronto! Agora está tudo configurado para encaminhar mensagens ao seu bot. Ative a regra e toque em Iniciar para começar.';

  @override
  String get help_tbot_05 =>
      'Você também pode definir uma URL de servidor de API personalizada para usá-la no lugar do servidor oficial do Telegram.';

  @override
  String get help_smtp => 'Conexão do Servidor SMTP';

  @override
  String get help_smtp_01 =>
      'Recomenda-se criar uma conta de e-mail separada (não um alias) especificamente para encaminhamento de mensagens e usá-la como login. Isso é especialmente importante no Gmail e em serviços semelhantes.';

  @override
  String get help_smtp_02 =>
      'Crie uma regra e preencha os dados de conexão. Geralmente é necessária uma \'senha de app\' (gerada nas configurações de segurança do seu e-mail).';

  @override
  String get help_smtp_03 =>
      'Teste e salve as configurações, ative a regra e clique em Iniciar.';

  @override
  String get help_sms => 'Envio de SMS';

  @override
  String get help_sms_01 =>
      'O app oferece suporte ao encaminhamento de mensagens como SMS de saída.';

  @override
  String get help_sms_02 =>
      'Crie uma regra e informe o número de telefone do destinatário. O número móvel deve começar com o símbolo + (formato internacional).';

  @override
  String get help_sms_03 =>
      'Os SMS são enviados usando o SIM definido como padrão nas configurações do telefone.';

  @override
  String get help_filters => 'Filtros';

  @override
  String get help_filters_01 =>
      'Para qualquer regra, você pode definir filtros de remetente e de texto da mensagem. O filtro é acionado quando o número/nome do remetente ou o texto contém os caracteres informados.';

  @override
  String get help_filters_02 =>
      'Há dois modos: lista branca (a mensagem é encaminhada se ao menos um filtro corresponder) e lista negra (a mensagem não é encaminhada se algum filtro corresponder). No modo lista branca, sem filtros definidos, nenhuma mensagem será encaminhada.';

  @override
  String get help_filters_03 =>
      'Use dois caracteres / para definir uma expressão regular como filtro. Por exemplo, o filtro /^\\d*555\$/ corresponde aos números que terminam com 555.';

  @override
  String get help_filters_04 =>
      'Para verificar se uma mensagem específica será encaminhada com os filtros atuais, preencha remetente e/ou texto da mensagem nos campos e toque no botão de verificação.';

  @override
  String get help_filters_05 =>
      'Os filtros definidos são aplicados a todos os tipos de eventos, não apenas a SMS recebidos.';

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

  @override
  String get warn_permissionsRequired =>
      'Para iniciar o monitoramento, conceda as permissões necessárias.';
}
