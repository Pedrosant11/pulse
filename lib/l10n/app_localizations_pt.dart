// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get splashTagline => 'Seu match está na pista.';

  @override
  String get navDiscover => 'Descobrir';

  @override
  String get navEvents => 'Eventos';

  @override
  String get navChats => 'Chats';

  @override
  String navItemWithBadge(String label, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count novidades',
      one: '1 novidade',
    );
    return '$label, $_temp0';
  }

  @override
  String get navProfile => 'Perfil';

  @override
  String get modeDate => 'Date';

  @override
  String get modeCrew => 'Crew';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get forgotPasswordTitle => 'Recuperar senha';

  @override
  String get onboardingTitle => 'Seu perfil';

  @override
  String get eventsTitle => 'Eventos';

  @override
  String get chatsTitle => 'Chats';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get adminTitle => 'Painel admin';

  @override
  String get signOut => 'Sair';

  @override
  String get signOutAllDevices => 'Sair de todos os dispositivos';

  @override
  String get signOutAllDevicesHint =>
      'Encerra sua sessão em todos os celulares em que você entrou.';

  @override
  String get goToSignup => 'Criar conta';

  @override
  String get goToForgotPassword => 'Esqueci minha senha';

  @override
  String get goToLogin => 'Já tenho conta';

  @override
  String get openSettings => 'Configurações';

  @override
  String get openAdmin => 'Painel admin';

  @override
  String get suggestEvent => 'Sugerir evento';

  @override
  String get stateErrorTitle => 'Algo deu errado';

  @override
  String get stateRetry => 'Tentar de novo';

  @override
  String get stateLoading => 'Carregando';

  @override
  String get fieldFirstName => 'Nome';

  @override
  String get fieldLastName => 'Sobrenome';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldPassword => 'Senha';

  @override
  String get fieldNewPassword => 'Nova senha';

  @override
  String get fieldConfirmPassword => 'Confirme a senha';

  @override
  String get fieldBirthDate => 'Data de nascimento';

  @override
  String get fieldPhone => 'Celular';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String get lastNamePrivacyHint =>
      'Seu sobrenome nunca aparece para outras pessoas.';

  @override
  String get birthDatePrivacyHint => 'Só sua idade aparece no perfil.';

  @override
  String get validationRequired => 'Campo obrigatório';

  @override
  String get validationEmail => 'Digite um e-mail válido';

  @override
  String get validationPassword =>
      'Use pelo menos 8 caracteres, com letras e números';

  @override
  String get validationPasswordMismatch => 'As senhas não são iguais';

  @override
  String get validationUnderage => 'O Pulse é só para maiores de 18 anos.';

  @override
  String get validationPhone => 'Digite um celular válido com DDD';

  @override
  String get passwordStrengthWeak => 'Senha fraca';

  @override
  String get passwordStrengthFair => 'Senha razoável';

  @override
  String get passwordStrengthGood => 'Senha boa';

  @override
  String get passwordStrengthStrong => 'Senha forte';

  @override
  String signupStep(int current, int total) {
    return 'Etapa $current de $total';
  }

  @override
  String get signupAccountTitle => 'Bora começar';

  @override
  String get signupAccountSubtitle =>
      'Seus dados de acesso. Você completa o perfil depois.';

  @override
  String get signupSubmit => 'Criar conta';

  @override
  String get checkEmailTitle => 'Confirme seu e-mail';

  @override
  String checkEmailBody(String email) {
    return 'Enviamos um link de confirmação para $email. Abra o e-mail neste celular e toque no link para continuar.';
  }

  @override
  String get checkEmailSpamHint => 'Não chegou? Confira o spam ou reenvie.';

  @override
  String get resendEmail => 'Reenviar e-mail';

  @override
  String resendEmailIn(int seconds) {
    return 'Reenviar em ${seconds}s';
  }

  @override
  String get emailResent => 'E-mail reenviado.';

  @override
  String get loginSubtitle => 'Que bom te ver de novo.';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get resendConfirmation => 'Reenviar e-mail de confirmação';

  @override
  String get forgotPasswordSubtitle =>
      'Informe seu e-mail e enviaremos um link para criar uma nova senha.';

  @override
  String get forgotPasswordSubmit => 'Enviar link';

  @override
  String get forgotPasswordSent =>
      'Se existir uma conta com esse e-mail, você vai receber o link em instantes.';

  @override
  String get resetPasswordTitle => 'Nova senha';

  @override
  String get resetPasswordSubtitle => 'Escolha uma senha nova para sua conta.';

  @override
  String get resetPasswordSubmit => 'Salvar senha';

  @override
  String get phoneStepTitle => 'Seu celular';

  @override
  String get phoneStepSubtitle =>
      'Cada número só pode ter uma conta. Ele nunca aparece no seu perfil.';

  @override
  String get callingCodeLabel => 'País';

  @override
  String get termsStepTitle => 'Quase lá';

  @override
  String get termsStepSubtitle =>
      'Para usar o Pulse, precisamos do seu aceite.';

  @override
  String get termsAcceptTerms =>
      'Li e aceito os Termos de Uso e as Diretrizes da Comunidade.';

  @override
  String get termsAcceptPrivacy => 'Li e aceito a Política de Privacidade.';

  @override
  String get termsAcceptLgpd =>
      'Autorizo o tratamento dos meus dados pessoais para as finalidades do app, conforme a LGPD.';

  @override
  String termsVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get termsSubmit => 'Aceitar e continuar';

  @override
  String get splashLoadError => 'Não conseguimos carregar sua conta.';

  @override
  String get continueButton => 'Continuar';

  @override
  String get saveButton => 'Salvar';

  @override
  String get savedMessage => 'Alterações salvas.';

  @override
  String get skipForNow => 'Pular por enquanto';

  @override
  String get finishOnboarding => 'Concluir';

  @override
  String get onboardingPhotosTitle => 'Suas fotos';

  @override
  String get onboardingPhotosSubtitle =>
      'Adicione de 2 a 6 fotos. A primeira é a principal — segure e arraste para reordenar.';

  @override
  String get photoMain => 'Principal';

  @override
  String get photoAdd => 'Adicionar foto';

  @override
  String get photoFromGallery => 'Escolher da galeria';

  @override
  String get photoFromCamera => 'Tirar foto';

  @override
  String get photoRemove => 'Remover foto';

  @override
  String get photoCropTitle => 'Ajustar foto';

  @override
  String photosMinHint(int count) {
    return 'Adicione pelo menos $count fotos para continuar.';
  }

  @override
  String photoSlotLabel(int position) {
    return 'Foto $position';
  }

  @override
  String get onboardingBasicsTitle => 'O básico';

  @override
  String get onboardingBasicsSubtitle => 'Como você aparece para as pessoas.';

  @override
  String get fieldCity => 'Cidade';

  @override
  String get cityPickerTitle => 'Sua cidade';

  @override
  String get citySearchHint => 'Buscar cidade';

  @override
  String get useMyLocation => 'Usar minha localização';

  @override
  String get locationPrivacyHint =>
      'Usamos só a cidade. Sua localização exata nunca é salva.';

  @override
  String get locationDenied =>
      'Sem permissão de localização. Escolha sua cidade na lista.';

  @override
  String get locationDisabled =>
      'A localização do celular está desligada. Ative ou escolha na lista.';

  @override
  String get locationFailed =>
      'Não conseguimos sua localização. Escolha na lista.';

  @override
  String get fieldOccupation => 'Área de atuação';

  @override
  String get occupationHint => 'Ex.: Design, Saúde, Tecnologia';

  @override
  String get fieldBio => 'Sobre você';

  @override
  String get bioHint => 'Conte um pouco da sua vibe na pista.';

  @override
  String get fieldGender => 'Gênero';

  @override
  String get fieldOrientation => 'Orientação (opcional)';

  @override
  String get showOrientation => 'Mostrar orientação no perfil';

  @override
  String get notInformed => 'Não informar';

  @override
  String get onboardingAboutTitle => 'Sobre mim';

  @override
  String get onboardingAboutSubtitle =>
      'Tudo opcional — preencha o que quiser.';

  @override
  String get fieldHeight => 'Altura';

  @override
  String heightValue(int cm) {
    return '$cm cm';
  }

  @override
  String get fieldLanguages => 'Idiomas';

  @override
  String get fieldZodiac => 'Signo';

  @override
  String get fieldDrinks => 'Bebida';

  @override
  String get fieldSmokes => 'Fumo';

  @override
  String get fieldPets => 'Pets';

  @override
  String get onboardingMusicTitle => 'Sua música';

  @override
  String get onboardingMusicSubtitle =>
      'Escolha seus gêneros favoritos e até 10 DJs.';

  @override
  String get fieldGenres => 'Gêneros favoritos';

  @override
  String get genresMinHint => 'Escolha pelo menos 1 gênero.';

  @override
  String get fieldDjs => 'DJs favoritos';

  @override
  String get djsHint => 'Nome do DJ';

  @override
  String get addDj => 'Adicionar';

  @override
  String removeDj(String name) {
    return 'Remover $name';
  }

  @override
  String get djsLimit => 'Você já adicionou 10 DJs.';

  @override
  String get onboardingModesTitle => 'Como você quer usar';

  @override
  String get onboardingModesSubtitle =>
      'Escolha pelo menos um modo. Dá para mudar quando quiser.';

  @override
  String get modeDateDescription => 'Encontro, algo casual ou relacionamento.';

  @override
  String get modeCrewDescription =>
      'Fazer amizades e montar a galera pra não ir sozinho.';

  @override
  String get modesMinHint => 'Escolha pelo menos um modo.';

  @override
  String get onboardingIntentTitle => 'O que você busca';

  @override
  String get onboardingIntentSubtitle =>
      'Dá pra mudar quando quiser no seu perfil.';

  @override
  String get onboardingLocationTitle => 'Sua cidade';

  @override
  String get onboardingLocationSubtitle =>
      'Pra gente mostrar as festas perto de você.';

  @override
  String get intentEventsOnly => 'Só eventos';

  @override
  String get intentEventsOnlyDescription =>
      'Só quero achar festas. Sem fotos e sem aparecer para ninguém.';

  @override
  String get intentHint => 'Pode escolher Date e Crew juntos.';

  @override
  String get intentRequired => 'Escolha uma opção para continuar.';

  @override
  String get modesNoneHint =>
      'Sem nenhum modo, você fica só com os eventos: sai do Descobrir e ninguém te encontra.';

  @override
  String get discoverEventsOnlyTitle => 'Conheça gente nas festas';

  @override
  String get discoverEventsOnlyBody =>
      'Ative o Date para dar match ou o Crew para achar galera pro rolê. As fotos e alguns dados só são pedidos na hora de ativar.';

  @override
  String get discoverEventsOnlyAction => 'Ativar Date ou Crew';

  @override
  String get activateModesTitle => 'Ativar Date ou Crew';

  @override
  String get activateModesButton => 'Ativar';

  @override
  String get activateModesDone => 'Pronto! Agora você aparece no Descobrir.';

  @override
  String get notNow => 'Agora não';

  @override
  String get crewsSectionNeedsMode =>
      'As crews fazem parte do modo Crew. Ative para criar ou entrar numa crew deste evento.';

  @override
  String get crewsSectionEnableMode => 'Ativar o modo Crew';

  @override
  String get errorCrewModeRequired =>
      'Ative o modo Crew no seu perfil para usar as crews.';

  @override
  String get dateLookingFor => 'O que você busca';

  @override
  String get dateShowMe => 'Mostrar para mim';

  @override
  String get showMeEveryone => 'Todo mundo';

  @override
  String get showMeWomen => 'Mulheres';

  @override
  String get showMeMen => 'Homens';

  @override
  String get showMeNonBinary => 'Pessoas não binárias';

  @override
  String dateAgeRange(int min, int max) {
    return 'Idade: $min a $max';
  }

  @override
  String get crewSameGender => 'Crew só com pessoas do mesmo gênero';

  @override
  String get crewSameGenderHint =>
      'Ideal para quem quer, por exemplo, uma crew só de mulheres.';

  @override
  String get crewSameGenderUnavailable =>
      'Defina seu gênero no perfil para usar esta opção.';

  @override
  String get onboardingFirstEventTitle => 'Seu primeiro rolê';

  @override
  String get onboardingFirstEventSubtitle =>
      'Marque presença em um evento para ver quem também vai.';

  @override
  String get attendButton => 'Eu vou';

  @override
  String get attendingButton => 'Vou!';

  @override
  String get noUpcomingEvents =>
      'Ainda não há eventos cadastrados. Você vai poder sugerir um na aba Eventos.';

  @override
  String get profileEdit => 'Editar perfil';

  @override
  String get profilePreviewHint => 'É assim que as pessoas veem seu perfil.';

  @override
  String get profileVerified => 'Verificado';

  @override
  String get profileUpcomingEvents => 'Próximos eventos';

  @override
  String get profileNoEvents =>
      'Você ainda não marcou presença em nenhum evento.';

  @override
  String profileNameAge(String name, int age) {
    return '$name, $age';
  }

  @override
  String get profileSectionMusic => 'Música';

  @override
  String get profileSectionAbout => 'Sobre';

  @override
  String get nextPhoto => 'Próxima foto';

  @override
  String get previousPhoto => 'Foto anterior';

  @override
  String get editSectionPhotos => 'Fotos';

  @override
  String get editSectionBasics => 'Básico';

  @override
  String get editSectionAbout => 'Sobre mim';

  @override
  String get editSectionMusic => 'Música';

  @override
  String get editSectionModes => 'Modos e preferências';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get approve => 'Aprovar';

  @override
  String get reject => 'Recusar';

  @override
  String get eventsTabUpcoming => 'Próximos';

  @override
  String get eventsTabMine => 'Meus eventos';

  @override
  String get eventsSearchHint => 'Buscar evento pelo nome';

  @override
  String get eventsSearchNationwide => 'Buscando em todo o Brasil';

  @override
  String eventsRadiusLabel(int km, String city) {
    return 'Até $km km de $city';
  }

  @override
  String get eventsRadiusTitle => 'Distância máxima';

  @override
  String eventsRadiusHint(int km) {
    return 'Eventos e pessoas a até $km km de você.';
  }

  @override
  String get filterAnyDate => 'Qualquer data';

  @override
  String get filterToday => 'Hoje';

  @override
  String get filterWeekend => 'Fim de semana';

  @override
  String get filter30Days => 'Próximos 30 dias';

  @override
  String get eventsEmptyNearby => 'Nenhum evento perto de você';

  @override
  String get eventsEmptyNearbyHint =>
      'Aumente a distância, busque pelo nome ou sugira um evento.';

  @override
  String get eventsEmptySearch => 'Nenhum evento encontrado';

  @override
  String get eventsEmptyMine => 'Você ainda não marcou nenhum evento';

  @override
  String get eventsEmptyMineHint =>
      'Ache um rolê em Próximos e toque em \"Eu vou\".';

  @override
  String get eventsSeeUpcoming => 'Ver próximos eventos';

  @override
  String goingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pessoas vão',
      one: '1 pessoa vai',
      zero: 'Seja a primeira pessoa a ir',
    );
    return '$_temp0';
  }

  @override
  String distanceKm(int km) {
    return '$km km';
  }

  @override
  String get eventOfficial => 'Oficial';

  @override
  String get statusPending => 'Em análise';

  @override
  String get statusApproved => 'Aprovado';

  @override
  String get statusRejected => 'Recusado';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get createEvent => 'Criar evento';

  @override
  String get moderationQueue => 'Fila de aprovação';

  @override
  String get eventWhen => 'Quando';

  @override
  String get eventWhere => 'Onde';

  @override
  String eventMinAge(int age) {
    return 'Classificação: $age+';
  }

  @override
  String get eventLineup => 'Line-up';

  @override
  String get eventAbout => 'Sobre o evento';

  @override
  String get eventBuyTicket => 'Comprar ingresso';

  @override
  String get eventGoing => 'Quem vai';

  @override
  String eventGoingCounts(int date, int crew) {
    return '$date no Date · $crew no Crew';
  }

  @override
  String get eventNobodyGoing => 'Ainda ninguém marcou presença.';

  @override
  String get eventMatchHint => 'Só seus matches aparecem com nome e foto.';

  @override
  String get eventCrews => 'Crews deste evento';

  @override
  String get eventPendingNotice =>
      'Este evento está em análise pela curadoria.';

  @override
  String eventRejectedReason(String reason) {
    return 'Recusado: $reason';
  }

  @override
  String get eventCancelledNotice => 'Este evento foi cancelado.';

  @override
  String get eventEdit => 'Editar';

  @override
  String get eventCancel => 'Cancelar evento';

  @override
  String get eventCancelTitle => 'Cancelar este evento?';

  @override
  String get eventCancelBody =>
      'Quem marcou presença vai ver o evento como cancelado.';

  @override
  String get eventRejectTitle => 'Recusar evento';

  @override
  String get eventRejectReasonHint => 'Explique o motivo para quem sugeriu';

  @override
  String get eventLinkError => 'Não foi possível abrir o link.';

  @override
  String get eventAttendeeAnonymous => 'Pessoa que vai ao evento';

  @override
  String get eventCreatedBy => 'Criado por';

  @override
  String get eventCreatorDeleted => 'Conta excluída';

  @override
  String creatorMemberSince(String date) {
    return 'Membro desde $date';
  }

  @override
  String creatorEventsStats(int created, int rejected) {
    return '$created eventos criados · $rejected recusados';
  }

  @override
  String get creatorOnlyModerators => 'Visível só para curadores e admins.';

  @override
  String get copyEmail => 'Copiar e-mail';

  @override
  String get emailCopied => 'E-mail copiado.';

  @override
  String get eventFormCreateTitle => 'Criar evento';

  @override
  String get eventFormSuggestTitle => 'Sugerir evento';

  @override
  String get eventFormEditTitle => 'Editar evento';

  @override
  String get eventFormSuggestHint =>
      'Sua sugestão passa pela curadoria antes de aparecer para todo mundo.';

  @override
  String get fieldEventName => 'Nome do evento';

  @override
  String get fieldVenue => 'Local';

  @override
  String get eventsViewMap => 'Ver no mapa';

  @override
  String get eventsViewList => 'Ver em lista';

  @override
  String get mapUnavailable =>
      'Não foi possível carregar o mapa agora. Os eventos continuam marcados.';

  @override
  String get mapNoEvents => 'Nenhum evento no mapa com esses filtros.';

  @override
  String get eventDirections => 'Como chegar';

  @override
  String get eventSecretLocation => 'Local secreto';

  @override
  String eventLocationRevealAt(String date) {
    return 'O endereço aparece em $date.';
  }

  @override
  String get eventLocationSearch => 'Endereço do local';

  @override
  String get eventLocationSearchHint =>
      'Rua e número (ex.: Rua Augusta 657) ou o CEP';

  @override
  String eventSecretVisibleToYou(String date) {
    return 'Local secreto: só você e a moderação veem o endereço até $date.';
  }

  @override
  String get eventLocationNoResults =>
      'Nada encontrado. Confira o endereço ou marque no mapa.';

  @override
  String get eventLocationPinHint =>
      'Toque no mapa para ajustar o pin no local exato.';

  @override
  String get eventSecretToggle => 'Local secreto';

  @override
  String eventSecretHint(int hours) {
    return 'O endereço só aparece $hours h antes. Até lá, o mapa mostra só a região.';
  }

  @override
  String eventRevealHours(int hours) {
    return '$hours h antes';
  }

  @override
  String get fieldDescription => 'Descrição (opcional)';

  @override
  String get fieldStartsAt => 'Início';

  @override
  String get fieldEndsAt => 'Término';

  @override
  String get fieldTicketUrl => 'Link do ingresso (opcional)';

  @override
  String get fieldMinAge => 'Classificação etária';

  @override
  String get fieldLineup => 'Line-up';

  @override
  String get lineupHint => 'Nome do artista';

  @override
  String get addArtist => 'Adicionar';

  @override
  String get eventCoverAdd => 'Adicionar capa';

  @override
  String get eventCoverChange => 'Trocar capa';

  @override
  String get validationEndsAfterStart =>
      'O término precisa ser depois do início (até 7 dias).';

  @override
  String get validationUrl => 'Use um link que comece com http:// ou https://';

  @override
  String get validationFuture => 'Escolha uma data futura.';

  @override
  String get eventSaveSuggest => 'Enviar sugestão';

  @override
  String get eventSaveCreate => 'Publicar evento';

  @override
  String get eventSubmittedPending =>
      'Sugestão enviada! A curadoria vai analisar.';

  @override
  String get eventPublished => 'Evento publicado!';

  @override
  String get similarTitle => 'Esse evento já existe?';

  @override
  String get similarBody => 'Achamos eventos parecidos no mesmo dia e cidade:';

  @override
  String get similarUseExisting => 'É este, marcar presença';

  @override
  String get similarCreateAnyway => 'Não, é outro evento';

  @override
  String get queueEmpty => 'Nenhum evento aguardando aprovação.';

  @override
  String get roleRequestTitle => 'Curadoria e produção';

  @override
  String get roleRequestEntry => 'Quero ser curador ou produtor';

  @override
  String get roleCurator => 'Curador';

  @override
  String get roleCuratorDescription =>
      'Cadastra eventos e aprova as sugestões da comunidade.';

  @override
  String get roleProducer => 'Produtor';

  @override
  String get roleProducerDescription =>
      'Publica os próprios eventos com o selo Oficial.';

  @override
  String get roleUser => 'Usuário';

  @override
  String get roleAdmin => 'Admin';

  @override
  String roleCurrent(String role) {
    return 'Seu papel atual: $role';
  }

  @override
  String get roleJustification => 'Por que você quer esse papel?';

  @override
  String get roleLinks => 'Links (Instagram, site, Resident Advisor…)';

  @override
  String get roleLinksHint => 'Um link por linha';

  @override
  String get roleSubmit => 'Enviar pedido';

  @override
  String get roleRequestSent => 'Pedido enviado!';

  @override
  String roleRequestPending(String role) {
    return 'Seu pedido para $role está em análise.';
  }

  @override
  String get roleRequestRejected =>
      'Seu último pedido não foi aprovado. Você pode enviar outro.';

  @override
  String get validationJustification => 'Escreva pelo menos 10 caracteres.';

  @override
  String get adminRoleRequests => 'Pedidos de papel';

  @override
  String get adminNoRoleRequests => 'Nenhum pedido pendente.';

  @override
  String get stampLike => 'CURTI';

  @override
  String get stampCrewLike => 'BORA';

  @override
  String get stampPass => 'PASSO';

  @override
  String discoverGoingTo(String event) {
    return 'Vocês vão: $event';
  }

  @override
  String discoverGoingToMore(String event, int count) {
    return 'Vocês vão: $event +$count';
  }

  @override
  String discoverCrewFor(String event) {
    return 'Procurando crew para: $event';
  }

  @override
  String discoverCrewForMore(String event, int count) {
    return 'Procurando crew para: $event +$count';
  }

  @override
  String discoverLookingFor(String intent) {
    return 'Busca: $intent';
  }

  @override
  String discoverDjs(String djs) {
    return 'Curte: $djs';
  }

  @override
  String get discoverFallbackBanner =>
      'Você já viu todo mundo dos seus eventos por enquanto. Que tal essas pessoas perto de você com o mesmo gosto musical?';

  @override
  String discoverSharedGenres(String genres) {
    return 'Vocês curtem: $genres';
  }

  @override
  String discoverDistance(int km) {
    return 'a $km km';
  }

  @override
  String get discoverNoEventsTitle => 'Marque presença em um evento';

  @override
  String get discoverNoEventsBody =>
      'Aqui aparecem as pessoas que vão aos mesmos eventos que você.';

  @override
  String get discoverGoToEvents => 'Ver eventos';

  @override
  String get discoverEmptyTitle => 'Você viu todo mundo por enquanto';

  @override
  String get discoverEmptyBody =>
      'Volte mais tarde ou marque presença em mais eventos.';

  @override
  String discoverModeOff(String mode) {
    return 'O modo $mode está desligado no seu perfil.';
  }

  @override
  String get discoverEnableMode => 'Ativar nos modos';

  @override
  String get actionPass => 'Passar';

  @override
  String get actionLike => 'Curtir';

  @override
  String get actionUndo => 'Voltar o último';

  @override
  String get actionOpenProfile => 'Ver perfil completo';

  @override
  String get undoNothing => 'Não dá para voltar esse.';

  @override
  String get matchTitleDate => 'É MATCH!';

  @override
  String get matchTitleCrew => 'BORA JUNTOS!';

  @override
  String matchSubtitleDate(String name) {
    return 'Você e $name se curtiram.';
  }

  @override
  String matchSubtitleCrew(String name) {
    return 'Você e $name querem colar juntos no rolê.';
  }

  @override
  String get matchSendMessage => 'Mandar mensagem';

  @override
  String get matchContinue => 'Continuar';

  @override
  String get chatsTabGroups => 'Grupos';

  @override
  String get chatsNewMatches => 'Novos matches';

  @override
  String get chatsEmptyTitle => 'Nenhuma conversa ainda';

  @override
  String get chatsEmptyBody => 'Quando der match, a conversa aparece aqui.';

  @override
  String get chatsGoDiscover => 'Ir para Descobrir';

  @override
  String get chatsGroupsEmptyTitle => 'Suas crews aparecem aqui';

  @override
  String get chatsGroupsEmptyBody =>
      'Crie ou entre numa crew pela tela de um evento.';

  @override
  String chatsYouPrefix(String message) {
    return 'Você: $message';
  }

  @override
  String get chatsSayHi => 'Diga oi 👋';

  @override
  String unreadCount(int count) {
    return '$count não lidas';
  }

  @override
  String get chatTyping => 'digitando…';

  @override
  String get chatInputHint => 'Mensagem';

  @override
  String get chatSend => 'Enviar';

  @override
  String get chatSending => 'Enviando';

  @override
  String get chatSent => 'Enviada';

  @override
  String get chatRead => 'Lida';

  @override
  String get chatFailed => 'Não enviada. Toque para tentar de novo.';

  @override
  String get chatDeleted => 'Mensagem apagada';

  @override
  String get chatDeleteMessage => 'Apagar mensagem';

  @override
  String get chatDeleteTitle => 'Apagar esta mensagem?';

  @override
  String get chatDeleteBody => 'Ela some para as duas pessoas.';

  @override
  String get chatToday => 'Hoje';

  @override
  String get chatYesterday => 'Ontem';

  @override
  String get chatIcebreakersTitle => 'Quebre o gelo';

  @override
  String icebreakerMeet(String event) {
    return 'Bora se encontrar na $event?';
  }

  @override
  String icebreakerLineup(String event) {
    return 'Quem do line-up da $event você não perde?';
  }

  @override
  String icebreakerFirstTime(String event) {
    return 'Primeira vez na $event?';
  }

  @override
  String get icebreakerGenericParty => 'Qual foi a última festa que te marcou?';

  @override
  String get icebreakerGenericDj => 'Qual DJ você mais quer ver ao vivo?';

  @override
  String get chatMenuProfile => 'Ver perfil';

  @override
  String get chatMenuUnmatch => 'Desfazer match';

  @override
  String get chatMenuBlock => 'Bloquear';

  @override
  String get chatMenuReport => 'Denunciar';

  @override
  String chatUnmatchTitle(String name) {
    return 'Desfazer o match com $name?';
  }

  @override
  String get chatUnmatchBody =>
      'A conversa some para vocês dois e não dá para desfazer.';

  @override
  String get chatUnavailable => 'Esta conversa não está mais disponível.';

  @override
  String get crewTitle => 'Crew';

  @override
  String get crewsSectionEmpty =>
      'Ninguém montou uma crew para esse evento ainda.';

  @override
  String get crewsSectionNotGoing =>
      'Marque \"Eu vou\" para ver e montar crews deste evento.';

  @override
  String get crewCreate => 'Montar crew';

  @override
  String get crewFormTitle => 'Nova crew';

  @override
  String get crewFormEditTitle => 'Editar crew';

  @override
  String crewFormFor(String event) {
    return 'Para: $event';
  }

  @override
  String crewFormInviteNote(String name) {
    return '$name vai receber o convite assim que a crew for criada.';
  }

  @override
  String get crewName => 'Nome da crew';

  @override
  String crewNameDefault(String name) {
    return 'Crew de $name';
  }

  @override
  String get crewDescription => 'Descrição (opcional)';

  @override
  String get crewDescriptionHint =>
      'Ex.: Vamos juntos de metrô, encontro às 22h na entrada.';

  @override
  String get crewOpen => 'Aberta';

  @override
  String get crewOpenHint =>
      'Quem vai ao evento pode pedir para entrar. Desligada, só por convite.';

  @override
  String get crewInviteOnly => 'Só convite';

  @override
  String get crewSameGenderOnly => 'Só pessoas do meu gênero';

  @override
  String get crewSameGenderLabel => 'Mesmo gênero';

  @override
  String crewMembersCount(int count, int max) {
    return '$count/$max pessoas';
  }

  @override
  String get crewFull => 'Lotada';

  @override
  String crewByOwner(String name) {
    return 'de $name';
  }

  @override
  String get crewAskToJoin => 'Pedir pra entrar';

  @override
  String get crewRequested => 'Pedido enviado';

  @override
  String get crewCancelRequest => 'Cancelar pedido';

  @override
  String get crewHasInvite => 'Você tem um convite para esta crew';

  @override
  String get crewAcceptInvite => 'Aceitar convite';

  @override
  String get crewDeclineInvite => 'Recusar';

  @override
  String get crewOpenChat => 'Abrir chat do grupo';

  @override
  String get crewMembers => 'Membros';

  @override
  String get crewOwner => 'Dono(a)';

  @override
  String get crewPendingRequests => 'Pedidos para entrar';

  @override
  String get crewPendingInvites => 'Convites enviados';

  @override
  String get crewInvite => 'Convidar';

  @override
  String get crewInviteTitle => 'Convidar para a crew';

  @override
  String get crewInviteEmpty =>
      'Aqui aparecem as pessoas que deram match com você no Crew e vão a esse evento.';

  @override
  String get crewInviteSent => 'Convite enviado!';

  @override
  String get crewCancelInvite => 'Cancelar convite';

  @override
  String get crewRemoveMember => 'Remover da crew';

  @override
  String get crewMakeOwner => 'Passar a posse';

  @override
  String get crewLeave => 'Sair da crew';

  @override
  String crewLeaveTitle(String name) {
    return 'Sair de $name?';
  }

  @override
  String get crewLeaveBody => 'Você sai do grupo e do chat.';

  @override
  String get crewOwnerLeaveHint =>
      'Para sair, passe a posse para outra pessoa ou apague a crew.';

  @override
  String get crewDelete => 'Apagar crew';

  @override
  String crewDeleteTitle(String name) {
    return 'Apagar $name?';
  }

  @override
  String get crewDeleteBody => 'O grupo e o chat somem para todo mundo.';

  @override
  String crewTransferTitle(String name) {
    return 'Passar a posse para $name?';
  }

  @override
  String crewRemoveTitle(String name) {
    return 'Remover $name da crew?';
  }

  @override
  String get crewCreated => 'Crew criada!';

  @override
  String get crewJoined => 'Você entrou na crew!';

  @override
  String get crewNotFound => 'Esta crew não existe mais.';

  @override
  String get crewInvitesTitle => 'Convites de crew';

  @override
  String crewInviteFrom(String name, int count) {
    return '$name te convidou · $count/8';
  }

  @override
  String get crewSolo => 'Vai sozinho(a)';

  @override
  String crewHasCrew(int count) {
    return 'Já tem crew de $count';
  }

  @override
  String crewMembersShort(int count) {
    return '$count pessoas';
  }

  @override
  String typingNamed(String name) {
    return '$name digitando…';
  }

  @override
  String get chatMenuViewCrew => 'Ver crew';

  @override
  String matchBuildCrew(String event) {
    return 'Montar crew para $event';
  }

  @override
  String get genderWoman => 'Mulher';

  @override
  String get genderMan => 'Homem';

  @override
  String get genderNonBinary => 'Pessoa não binária';

  @override
  String get genderOther => 'Outro';

  @override
  String get genderPreferNotSay => 'Prefiro não dizer';

  @override
  String get orientationStraight => 'Hétero';

  @override
  String get orientationGay => 'Gay';

  @override
  String get orientationLesbian => 'Lésbica';

  @override
  String get orientationBisexual => 'Bissexual';

  @override
  String get orientationPansexual => 'Pansexual';

  @override
  String get orientationAsexual => 'Assexual';

  @override
  String get orientationQueer => 'Queer';

  @override
  String get orientationQuestioning => 'Questionando';

  @override
  String get orientationOther => 'Outra';

  @override
  String get intentCasual => 'Algo casual';

  @override
  String get intentDating => 'Encontros';

  @override
  String get intentRelationship => 'Relacionamento';

  @override
  String get intentFiguringOut => 'Ainda descobrindo';

  @override
  String get habitNo => 'Não';

  @override
  String get habitSocially => 'Socialmente';

  @override
  String get habitYes => 'Sim';

  @override
  String get zodiacAries => 'Áries';

  @override
  String get zodiacTaurus => 'Touro';

  @override
  String get zodiacGemini => 'Gêmeos';

  @override
  String get zodiacCancer => 'Câncer';

  @override
  String get zodiacLeo => 'Leão';

  @override
  String get zodiacVirgo => 'Virgem';

  @override
  String get zodiacLibra => 'Libra';

  @override
  String get zodiacScorpio => 'Escorpião';

  @override
  String get zodiacSagittarius => 'Sagitário';

  @override
  String get zodiacCapricorn => 'Capricórnio';

  @override
  String get zodiacAquarius => 'Aquário';

  @override
  String get zodiacPisces => 'Peixes';

  @override
  String get genreTechno => 'Techno';

  @override
  String get genreHouse => 'House';

  @override
  String get genreTechHouse => 'Tech House';

  @override
  String get genreMelodicTechno => 'Melodic Techno';

  @override
  String get genrePsytrance => 'Psytrance';

  @override
  String get genreTrance => 'Trance';

  @override
  String get genreDrumAndBass => 'Drum & Bass';

  @override
  String get genreDubstep => 'Dubstep';

  @override
  String get genreAfroHouse => 'Afro House';

  @override
  String get genreMinimal => 'Minimal';

  @override
  String get genreHardTechno => 'Hard Techno';

  @override
  String get genreDiscoNuDisco => 'Disco / Nu-Disco';

  @override
  String get genreEdm => 'EDM';

  @override
  String get genreOther => 'Outros';

  @override
  String get petDog => 'Cachorro';

  @override
  String get petCat => 'Gato';

  @override
  String get petOther => 'Outros pets';

  @override
  String get petNone => 'Não tenho';

  @override
  String get petWant => 'Quero ter';

  @override
  String get languagePt => 'Português';

  @override
  String get languageEn => 'Inglês';

  @override
  String get languageEs => 'Espanhol';

  @override
  String get languageFr => 'Francês';

  @override
  String get languageIt => 'Italiano';

  @override
  String get languageDe => 'Alemão';

  @override
  String get languageJa => 'Japonês';

  @override
  String get languageZh => 'Chinês';

  @override
  String get languageKo => 'Coreano';

  @override
  String get languageRu => 'Russo';

  @override
  String get languageAr => 'Árabe';

  @override
  String get languageHe => 'Hebraico';

  @override
  String get languageNl => 'Holandês';

  @override
  String get languageLibras => 'Libras';

  @override
  String get errorMinPhotos => 'Seu perfil precisa de pelo menos 2 fotos.';

  @override
  String get errorNetwork =>
      'Sem conexão. Verifique sua internet e tente de novo.';

  @override
  String get errorSessionExpired => 'Sua sessão expirou. Entre novamente.';

  @override
  String get errorPermissionDenied => 'Você não tem permissão para fazer isso.';

  @override
  String get errorNotFound => 'Não encontramos o que você procurou.';

  @override
  String get errorRateLimited =>
      'Calma! Você está indo rápido demais. Tente de novo em instantes.';

  @override
  String get errorInvalidCredentials => 'E-mail ou senha incorretos.';

  @override
  String get errorEmailNotConfirmed =>
      'Confirme seu e-mail pelo link que enviamos antes de entrar.';

  @override
  String get errorEmailInUse => 'Já existe uma conta com esse e-mail.';

  @override
  String get errorWeakPassword =>
      'Essa senha é fraca. Use pelo menos 8 caracteres, com letras e números.';

  @override
  String get errorSamePassword =>
      'A nova senha precisa ser diferente da atual.';

  @override
  String get errorPhoneInUse => 'Esse celular já está vinculado a outra conta.';

  @override
  String get errorUnknown => 'Algo deu errado. Tente novamente.';

  @override
  String get errorWrongPassword => 'Senha incorreta.';

  @override
  String blockTitle(String name) {
    return 'Bloquear $name?';
  }

  @override
  String get blockBody =>
      'Vocês deixam de se ver em todo o app: feed, eventos, crews e conversas. A pessoa não é avisada.';

  @override
  String get blockAction => 'Bloquear';

  @override
  String blockDone(String name) {
    return '$name foi bloqueado(a).';
  }

  @override
  String get safetyMenuTooltip => 'Opções de segurança';

  @override
  String reportUserTitle(String name) {
    return 'Denunciar $name';
  }

  @override
  String get reportMessageTitle => 'Denunciar mensagem';

  @override
  String get reportEventTitle => 'Denunciar evento';

  @override
  String get reportIntro =>
      'Conte o que aconteceu. A pessoa não fica sabendo quem denunciou.';

  @override
  String get reportReasonLabel => 'Motivo';

  @override
  String get reportDetails => 'Detalhes (opcional)';

  @override
  String get reportDetailsHint => 'O que aconteceu, quando, onde…';

  @override
  String reportAlsoBlock(String name) {
    return 'Também bloquear $name';
  }

  @override
  String get reportSubmit => 'Enviar denúncia';

  @override
  String get reportSent =>
      'Denúncia enviada. Obrigado por ajudar a manter a pista segura.';

  @override
  String get reportEventAction => 'Denunciar evento';

  @override
  String get reportReasonHarassment => 'Assédio ou ameaça';

  @override
  String get reportReasonInappropriateContent => 'Conteúdo impróprio';

  @override
  String get reportReasonFakeProfile => 'Perfil falso';

  @override
  String get reportReasonFakeEvent => 'Evento falso ou duplicado';

  @override
  String get reportReasonScam => 'Golpe ou venda';

  @override
  String get reportReasonScamEvent => 'Golpe ou ingresso falso';

  @override
  String get reportReasonSpam => 'Spam';

  @override
  String get reportReasonUnderage => 'Menor de idade';

  @override
  String get reportReasonSafetyConcern => 'Risco à segurança de alguém';

  @override
  String get reportReasonOther => 'Outro motivo';

  @override
  String get settingsAccountSection => 'Conta';

  @override
  String get settingsSafetySection => 'Segurança';

  @override
  String get settingsSessionSection => 'Sessão';

  @override
  String get settingsDangerSection => 'Zona de perigo';

  @override
  String get blockedUsersTitle => 'Bloqueados';

  @override
  String get blockedUsersEmpty => 'Você não bloqueou ninguém.';

  @override
  String get blockedUsersHint =>
      'Ao desbloquear, a pessoa volta a aparecer para você, mas matches e conversas antigas não voltam.';

  @override
  String get unblockAction => 'Desbloquear';

  @override
  String unblockTitle(String name) {
    return 'Desbloquear $name?';
  }

  @override
  String get safetyTipsTitle => 'Dicas de segurança';

  @override
  String get safetyTipsEntry => 'Dicas de segurança na festa';

  @override
  String get safetyTipsIntro =>
      'A noite é pra curtir. Algumas combinações ajudam a voltar bem pra casa.';

  @override
  String get safetyTipPublicTitle => 'Encontre em público';

  @override
  String get safetyTipPublicBody =>
      'Combine o primeiro encontro num lugar movimentado, de preferência no próprio evento.';

  @override
  String get safetyTipFriendTitle => 'Avise alguém';

  @override
  String get safetyTipFriendBody =>
      'Conte a um amigo com quem você vai sair e compartilhe sua localização em tempo real.';

  @override
  String get safetyTipDrinkTitle => 'Cuide do seu copo';

  @override
  String get safetyTipDrinkBody =>
      'Não aceite bebida de desconhecidos e não deixe seu copo sozinho. Se algo parecer estranho, peça ajuda.';

  @override
  String get safetyTipLimitsTitle => 'Hidrate-se e respeite seus limites';

  @override
  String get safetyTipLimitsBody =>
      'Beba água, faça pausas e, se passar mal ou vir alguém passando mal, procure a equipe médica do evento.';

  @override
  String get safetyTipConsentTitle => 'Consentimento sempre';

  @override
  String get safetyTipConsentBody =>
      'Não é não. Se algo te deixar desconfortável, saia da situação e chame a segurança do evento.';

  @override
  String get safetyTipRideTitle => 'Planeje a volta';

  @override
  String get safetyTipRideBody =>
      'Defina como vai voltar antes de sair e use transporte confiável.';

  @override
  String get safetyTipDataTitle => 'Proteja seus dados';

  @override
  String get safetyTipDataBody =>
      'Não passe endereço, documentos ou dados bancários. O Pulse nunca pede sua senha por mensagem.';

  @override
  String get safetyTipReportTitle => 'Denuncie e bloqueie';

  @override
  String get safetyTipReportBody =>
      'Use Denunciar e Bloquear em qualquer perfil, mensagem ou evento. Nossa equipe analisa cada denúncia.';

  @override
  String get safetyEmergency => 'Em emergência';

  @override
  String get safetyCallPolice => 'Polícia · 190';

  @override
  String get safetyCallAmbulance => 'SAMU · 192';

  @override
  String get matchSafetyTips =>
      'Antes de se encontrar, veja as dicas de segurança';

  @override
  String get deleteAccountEntry => 'Excluir conta';

  @override
  String get deleteAccountTitle => 'Excluir conta';

  @override
  String get deleteAccountWarning =>
      'Isso apaga para sempre seu perfil, fotos, matches, conversas e crews. Não dá para desfazer.';

  @override
  String get deleteAccountCrewsNote =>
      'Crews que você criou passam para o membro mais antigo.';

  @override
  String get deleteAccountPassword => 'Digite sua senha para confirmar';

  @override
  String get deleteAccountButton => 'Excluir minha conta';

  @override
  String get deleteAccountConfirmTitle => 'Excluir sua conta agora?';

  @override
  String get deleteAccountConfirmBody =>
      'Sua conta e seus dados serão apagados na hora.';

  @override
  String get deleteAccountDone => 'Sua conta foi excluída.';

  @override
  String get restrictedSuspendedTitle => 'Conta suspensa';

  @override
  String get restrictedBannedTitle => 'Conta banida';

  @override
  String get restrictedSuspendedBody =>
      'Durante a suspensão você não aparece para ninguém e não pode curtir, conversar ou criar eventos.';

  @override
  String get restrictedBannedBody =>
      'Sua conta foi encerrada por violar as regras da comunidade.';

  @override
  String restrictedUntil(String date) {
    return 'Até $date';
  }

  @override
  String restrictedReason(String reason) {
    return 'Motivo: $reason';
  }

  @override
  String get restrictedCheckAgain => 'Verificar de novo';

  @override
  String get warningNoticeTitle => 'Aviso da moderação';

  @override
  String warningNoticeBody(String reason) {
    return 'Recebemos denúncias sobre a sua conta: $reason\n\nSe acontecer de novo, a conta pode ser suspensa.';
  }

  @override
  String get warningNoticeOk => 'Entendi';

  @override
  String get adminReports => 'Denúncias';

  @override
  String get adminReportsEmpty => 'Nenhuma denúncia pendente.';

  @override
  String get adminRestrictedUsers => 'Contas suspensas e banidas';

  @override
  String get adminRestrictedEmpty => 'Nenhuma conta restrita.';

  @override
  String adminReportBy(String name) {
    return 'Denunciado por $name';
  }

  @override
  String get adminReportTargetUser => 'Perfil';

  @override
  String get adminReportTargetMessage => 'Mensagem';

  @override
  String get adminReportTargetEvent => 'Evento';

  @override
  String adminReportedUser(String name) {
    return 'Conta denunciada: $name';
  }

  @override
  String get adminReportedGone => 'A conta denunciada não existe mais.';

  @override
  String adminReportHistory(int reports, int actions) {
    String _temp0 = intl.Intl.pluralLogic(
      reports,
      locale: localeName,
      other: '$reports denúncias',
      one: '1 denúncia',
    );
    String _temp1 = intl.Intl.pluralLogic(
      actions,
      locale: localeName,
      other: '$actions punições',
      one: '1 punição',
      zero: 'nenhuma punição',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String adminReportDetails(String details) {
    return 'Relato: $details';
  }

  @override
  String get adminDecision => 'Decisão';

  @override
  String get adminOutcomeDismiss => 'Arquivar';

  @override
  String get adminOutcomeResolve => 'Só resolver';

  @override
  String get adminOutcomeWarning => 'Advertir';

  @override
  String get adminOutcomeSuspension => 'Suspender';

  @override
  String get adminOutcomeBan => 'Banir';

  @override
  String get adminNote => 'Motivo (a pessoa vai ver)';

  @override
  String get adminNoteInternal => 'Observação (opcional)';

  @override
  String get adminSuspensionDays => 'Dias de suspensão';

  @override
  String adminSuspensionDaysValue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get adminRemoveMessage => 'Apagar a mensagem';

  @override
  String get adminRemoveEvent => 'Tirar o evento do ar';

  @override
  String get adminApply => 'Aplicar';

  @override
  String get adminReportHandled => 'Denúncia resolvida.';

  @override
  String get adminReactivate => 'Reativar';

  @override
  String adminReactivateTitle(String name) {
    return 'Reativar $name?';
  }

  @override
  String get adminReactivateReason => 'Motivo da reativação';

  @override
  String get accountStatusSuspended => 'Suspensa';

  @override
  String get accountStatusBanned => 'Banida';

  @override
  String get badgeTeam => 'Equipe Pulse';

  @override
  String get badgeDj => 'DJ';

  @override
  String get badgePublicFigure => 'Figura pública';

  @override
  String get badgeProducer => 'Produtor';

  @override
  String badgeSemantics(String label) {
    return 'Selo: $label';
  }

  @override
  String get badgeRequestEntry => 'Pedir selo de DJ ou figura pública';

  @override
  String get badgeRequestTitle => 'Selos';

  @override
  String get badgeRequestIntro =>
      'Selos mostram para todo mundo quem você é na cena. A equipe confere cada pedido.';

  @override
  String get badgeYours => 'Seus selos';

  @override
  String badgeRequestPending(String badge) {
    return 'Seu pedido do selo $badge está em análise.';
  }

  @override
  String get badgeNothingToRequest =>
      'Você já tem ou já pediu todos os selos disponíveis.';

  @override
  String get badgeJustification => 'Conte quem você é';

  @override
  String get badgeJustificationHint =>
      'Onde toca, há quanto tempo, por que é conhecido(a)…';

  @override
  String get badgeLinksHint =>
      'Instagram, SoundCloud, Resident Advisor… (um por linha)';

  @override
  String get badgeRequestSent =>
      'Pedido enviado! Você será avisado(a) quando for analisado.';

  @override
  String get adminBadges => 'Selos';

  @override
  String get adminBadgeRequests => 'Pedidos de selo';

  @override
  String get adminNoBadgeRequests => 'Nenhum pedido de selo.';

  @override
  String get adminGiveBadge => 'Dar selo';

  @override
  String get adminSearchPeople => 'Buscar pessoa pelo nome';

  @override
  String adminBadgesOf(String name) {
    return 'Selos de $name';
  }

  @override
  String get adminProducerFromRole =>
      'Produtor vem do papel e não é editado aqui.';

  @override
  String get adminBadgeTitle => 'Título (opcional)';

  @override
  String get adminBadgeTitleHint => 'Ex.: Residente D-Edge';

  @override
  String get adminBadgeTitleTeamHint => 'Ex.: CEO, Moderação';

  @override
  String get adminManageBadges => 'Gerenciar selos';

  @override
  String get legalTerms => 'Termos de Uso';

  @override
  String get legalPrivacy => 'Política de Privacidade';

  @override
  String get legalGuidelines => 'Diretrizes da Comunidade';

  @override
  String get legalDeleteAccount => 'Excluir conta';

  @override
  String get legalRead => 'Ler';

  @override
  String get settingsPrivacySection => 'Privacidade e termos';

  @override
  String get exportDataEntry => 'Baixar meus dados';

  @override
  String get exportDataHint =>
      'Um arquivo com tudo o que o Pulse guarda sobre você.';

  @override
  String get orientationConsent =>
      'Autorizo o Pulse a usar minha orientação sexual (dado sensível) para mostrar perfis compatíveis. Posso remover quando quiser.';

  @override
  String get orientationConsentRequired =>
      'Para salvar a orientação, marque a autorização ou deixe sem informar.';
}
