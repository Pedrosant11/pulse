import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pt')];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pulse'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In pt, this message translates to:
  /// **'Seu match está na pista.'**
  String get splashTagline;

  /// No description provided for @navDiscover.
  ///
  /// In pt, this message translates to:
  /// **'Descobrir'**
  String get navDiscover;

  /// No description provided for @navEvents.
  ///
  /// In pt, this message translates to:
  /// **'Eventos'**
  String get navEvents;

  /// No description provided for @navChats.
  ///
  /// In pt, this message translates to:
  /// **'Chats'**
  String get navChats;

  /// No description provided for @navItemWithBadge.
  ///
  /// In pt, this message translates to:
  /// **'{label}, {count, plural, =1{1 novidade} other{{count} novidades}}'**
  String navItemWithBadge(String label, int count);

  /// No description provided for @navProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @modeDate.
  ///
  /// In pt, this message translates to:
  /// **'Date'**
  String get modeDate;

  /// No description provided for @modeCrew.
  ///
  /// In pt, this message translates to:
  /// **'Crew'**
  String get modeCrew;

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginTitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recuperar senha'**
  String get forgotPasswordTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu perfil'**
  String get onboardingTitle;

  /// No description provided for @eventsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Eventos'**
  String get eventsTitle;

  /// No description provided for @chatsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chats'**
  String get chatsTitle;

  /// No description provided for @profileTitle.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settingsTitle;

  /// No description provided for @adminTitle.
  ///
  /// In pt, this message translates to:
  /// **'Painel admin'**
  String get adminTitle;

  /// No description provided for @signOut.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get signOut;

  /// No description provided for @signOutAllDevices.
  ///
  /// In pt, this message translates to:
  /// **'Sair de todos os dispositivos'**
  String get signOutAllDevices;

  /// No description provided for @signOutAllDevicesHint.
  ///
  /// In pt, this message translates to:
  /// **'Encerra sua sessão em todos os celulares em que você entrou.'**
  String get signOutAllDevicesHint;

  /// No description provided for @goToSignup.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get goToSignup;

  /// No description provided for @goToForgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha'**
  String get goToForgotPassword;

  /// No description provided for @goToLogin.
  ///
  /// In pt, this message translates to:
  /// **'Já tenho conta'**
  String get goToLogin;

  /// No description provided for @openSettings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get openSettings;

  /// No description provided for @openAdmin.
  ///
  /// In pt, this message translates to:
  /// **'Painel admin'**
  String get openAdmin;

  /// No description provided for @suggestEvent.
  ///
  /// In pt, this message translates to:
  /// **'Sugerir evento'**
  String get suggestEvent;

  /// No description provided for @stateErrorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Algo deu errado'**
  String get stateErrorTitle;

  /// No description provided for @stateRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar de novo'**
  String get stateRetry;

  /// No description provided for @stateLoading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando'**
  String get stateLoading;

  /// No description provided for @fieldFirstName.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get fieldFirstName;

  /// No description provided for @fieldLastName.
  ///
  /// In pt, this message translates to:
  /// **'Sobrenome'**
  String get fieldLastName;

  /// No description provided for @fieldEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get fieldPassword;

  /// No description provided for @fieldNewPassword.
  ///
  /// In pt, this message translates to:
  /// **'Nova senha'**
  String get fieldNewPassword;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirme a senha'**
  String get fieldConfirmPassword;

  /// No description provided for @fieldBirthDate.
  ///
  /// In pt, this message translates to:
  /// **'Data de nascimento'**
  String get fieldBirthDate;

  /// No description provided for @fieldPhone.
  ///
  /// In pt, this message translates to:
  /// **'Celular'**
  String get fieldPhone;

  /// No description provided for @showPassword.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar senha'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In pt, this message translates to:
  /// **'Ocultar senha'**
  String get hidePassword;

  /// No description provided for @lastNamePrivacyHint.
  ///
  /// In pt, this message translates to:
  /// **'Seu sobrenome nunca aparece para outras pessoas.'**
  String get lastNamePrivacyHint;

  /// No description provided for @birthDatePrivacyHint.
  ///
  /// In pt, this message translates to:
  /// **'Só sua idade aparece no perfil.'**
  String get birthDatePrivacyHint;

  /// No description provided for @validationRequired.
  ///
  /// In pt, this message translates to:
  /// **'Campo obrigatório'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In pt, this message translates to:
  /// **'Digite um e-mail válido'**
  String get validationEmail;

  /// No description provided for @validationPassword.
  ///
  /// In pt, this message translates to:
  /// **'Use pelo menos 8 caracteres, com letras e números'**
  String get validationPassword;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não são iguais'**
  String get validationPasswordMismatch;

  /// No description provided for @validationUnderage.
  ///
  /// In pt, this message translates to:
  /// **'O Pulse é só para maiores de 18 anos.'**
  String get validationUnderage;

  /// No description provided for @validationPhone.
  ///
  /// In pt, this message translates to:
  /// **'Digite um celular válido com DDD'**
  String get validationPhone;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In pt, this message translates to:
  /// **'Senha fraca'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthFair.
  ///
  /// In pt, this message translates to:
  /// **'Senha razoável'**
  String get passwordStrengthFair;

  /// No description provided for @passwordStrengthGood.
  ///
  /// In pt, this message translates to:
  /// **'Senha boa'**
  String get passwordStrengthGood;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In pt, this message translates to:
  /// **'Senha forte'**
  String get passwordStrengthStrong;

  /// No description provided for @signupStep.
  ///
  /// In pt, this message translates to:
  /// **'Etapa {current} de {total}'**
  String signupStep(int current, int total);

  /// No description provided for @signupAccountTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bora começar'**
  String get signupAccountTitle;

  /// No description provided for @signupAccountSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Seus dados de acesso. Você completa o perfil depois.'**
  String get signupAccountSubtitle;

  /// No description provided for @signupSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get signupSubmit;

  /// No description provided for @checkEmailTitle.
  ///
  /// In pt, this message translates to:
  /// **'Confirme seu e-mail'**
  String get checkEmailTitle;

  /// No description provided for @checkEmailBody.
  ///
  /// In pt, this message translates to:
  /// **'Enviamos um link de confirmação para {email}. Abra o e-mail neste celular e toque no link para continuar.'**
  String checkEmailBody(String email);

  /// No description provided for @checkEmailSpamHint.
  ///
  /// In pt, this message translates to:
  /// **'Não chegou? Confira o spam ou reenvie.'**
  String get checkEmailSpamHint;

  /// No description provided for @resendEmail.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar e-mail'**
  String get resendEmail;

  /// No description provided for @resendEmailIn.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar em {seconds}s'**
  String resendEmailIn(int seconds);

  /// No description provided for @emailResent.
  ///
  /// In pt, this message translates to:
  /// **'E-mail reenviado.'**
  String get emailResent;

  /// No description provided for @loginSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Que bom te ver de novo.'**
  String get loginSubtitle;

  /// No description provided for @loginSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginSubmit;

  /// No description provided for @resendConfirmation.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar e-mail de confirmação'**
  String get resendConfirmation;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu e-mail e enviaremos um link para criar uma nova senha.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Enviar link'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordSent.
  ///
  /// In pt, this message translates to:
  /// **'Se existir uma conta com esse e-mail, você vai receber o link em instantes.'**
  String get forgotPasswordSent;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova senha'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma senha nova para sua conta.'**
  String get resetPasswordSubtitle;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Salvar senha'**
  String get resetPasswordSubmit;

  /// No description provided for @phoneStepTitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu celular'**
  String get phoneStepTitle;

  /// No description provided for @phoneStepSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Cada número só pode ter uma conta. Ele nunca aparece no seu perfil.'**
  String get phoneStepSubtitle;

  /// No description provided for @callingCodeLabel.
  ///
  /// In pt, this message translates to:
  /// **'País'**
  String get callingCodeLabel;

  /// No description provided for @termsStepTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quase lá'**
  String get termsStepTitle;

  /// No description provided for @termsStepSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Para usar o Pulse, precisamos do seu aceite.'**
  String get termsStepSubtitle;

  /// No description provided for @termsAcceptTerms.
  ///
  /// In pt, this message translates to:
  /// **'Li e aceito os Termos de Uso e as Diretrizes da Comunidade.'**
  String get termsAcceptTerms;

  /// No description provided for @termsAcceptPrivacy.
  ///
  /// In pt, this message translates to:
  /// **'Li e aceito a Política de Privacidade.'**
  String get termsAcceptPrivacy;

  /// No description provided for @termsAcceptLgpd.
  ///
  /// In pt, this message translates to:
  /// **'Autorizo o tratamento dos meus dados pessoais para as finalidades do app, conforme a LGPD.'**
  String get termsAcceptLgpd;

  /// No description provided for @termsVersion.
  ///
  /// In pt, this message translates to:
  /// **'Versão {version}'**
  String termsVersion(String version);

  /// No description provided for @termsSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Aceitar e continuar'**
  String get termsSubmit;

  /// No description provided for @splashLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos carregar sua conta.'**
  String get splashLoadError;

  /// No description provided for @continueButton.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueButton;

  /// No description provided for @saveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get saveButton;

  /// No description provided for @savedMessage.
  ///
  /// In pt, this message translates to:
  /// **'Alterações salvas.'**
  String get savedMessage;

  /// No description provided for @skipForNow.
  ///
  /// In pt, this message translates to:
  /// **'Pular por enquanto'**
  String get skipForNow;

  /// No description provided for @finishOnboarding.
  ///
  /// In pt, this message translates to:
  /// **'Concluir'**
  String get finishOnboarding;

  /// No description provided for @onboardingPhotosTitle.
  ///
  /// In pt, this message translates to:
  /// **'Suas fotos'**
  String get onboardingPhotosTitle;

  /// No description provided for @onboardingPhotosSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicione de 2 a 6 fotos. A primeira é a principal — segure e arraste para reordenar.'**
  String get onboardingPhotosSubtitle;

  /// No description provided for @photoMain.
  ///
  /// In pt, this message translates to:
  /// **'Principal'**
  String get photoMain;

  /// No description provided for @photoAdd.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar foto'**
  String get photoAdd;

  /// No description provided for @photoFromGallery.
  ///
  /// In pt, this message translates to:
  /// **'Escolher da galeria'**
  String get photoFromGallery;

  /// No description provided for @photoFromCamera.
  ///
  /// In pt, this message translates to:
  /// **'Tirar foto'**
  String get photoFromCamera;

  /// No description provided for @photoRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover foto'**
  String get photoRemove;

  /// No description provided for @photoCropTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ajustar foto'**
  String get photoCropTitle;

  /// No description provided for @photosMinHint.
  ///
  /// In pt, this message translates to:
  /// **'Adicione pelo menos {count} fotos para continuar.'**
  String photosMinHint(int count);

  /// No description provided for @photoSlotLabel.
  ///
  /// In pt, this message translates to:
  /// **'Foto {position}'**
  String photoSlotLabel(int position);

  /// No description provided for @onboardingBasicsTitle.
  ///
  /// In pt, this message translates to:
  /// **'O básico'**
  String get onboardingBasicsTitle;

  /// No description provided for @onboardingBasicsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Como você aparece para as pessoas.'**
  String get onboardingBasicsSubtitle;

  /// No description provided for @fieldCity.
  ///
  /// In pt, this message translates to:
  /// **'Cidade'**
  String get fieldCity;

  /// No description provided for @cityPickerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua cidade'**
  String get cityPickerTitle;

  /// No description provided for @citySearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar cidade'**
  String get citySearchHint;

  /// No description provided for @useMyLocation.
  ///
  /// In pt, this message translates to:
  /// **'Usar minha localização'**
  String get useMyLocation;

  /// No description provided for @locationPrivacyHint.
  ///
  /// In pt, this message translates to:
  /// **'Usamos só a cidade. Sua localização exata nunca é salva.'**
  String get locationPrivacyHint;

  /// No description provided for @locationDenied.
  ///
  /// In pt, this message translates to:
  /// **'Sem permissão de localização. Escolha sua cidade na lista.'**
  String get locationDenied;

  /// No description provided for @locationDisabled.
  ///
  /// In pt, this message translates to:
  /// **'A localização do celular está desligada. Ative ou escolha na lista.'**
  String get locationDisabled;

  /// No description provided for @locationFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não conseguimos sua localização. Escolha na lista.'**
  String get locationFailed;

  /// No description provided for @fieldOccupation.
  ///
  /// In pt, this message translates to:
  /// **'Área de atuação'**
  String get fieldOccupation;

  /// No description provided for @occupationHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Design, Saúde, Tecnologia'**
  String get occupationHint;

  /// No description provided for @fieldBio.
  ///
  /// In pt, this message translates to:
  /// **'Sobre você'**
  String get fieldBio;

  /// No description provided for @bioHint.
  ///
  /// In pt, this message translates to:
  /// **'Conte um pouco da sua vibe na pista.'**
  String get bioHint;

  /// No description provided for @fieldGender.
  ///
  /// In pt, this message translates to:
  /// **'Gênero'**
  String get fieldGender;

  /// No description provided for @fieldOrientation.
  ///
  /// In pt, this message translates to:
  /// **'Orientação (opcional)'**
  String get fieldOrientation;

  /// No description provided for @showOrientation.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar orientação no perfil'**
  String get showOrientation;

  /// No description provided for @notInformed.
  ///
  /// In pt, this message translates to:
  /// **'Não informar'**
  String get notInformed;

  /// No description provided for @onboardingAboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sobre mim'**
  String get onboardingAboutTitle;

  /// No description provided for @onboardingAboutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Tudo opcional — preencha o que quiser.'**
  String get onboardingAboutSubtitle;

  /// No description provided for @fieldHeight.
  ///
  /// In pt, this message translates to:
  /// **'Altura'**
  String get fieldHeight;

  /// No description provided for @heightValue.
  ///
  /// In pt, this message translates to:
  /// **'{cm} cm'**
  String heightValue(int cm);

  /// No description provided for @fieldLanguages.
  ///
  /// In pt, this message translates to:
  /// **'Idiomas'**
  String get fieldLanguages;

  /// No description provided for @fieldZodiac.
  ///
  /// In pt, this message translates to:
  /// **'Signo'**
  String get fieldZodiac;

  /// No description provided for @fieldDrinks.
  ///
  /// In pt, this message translates to:
  /// **'Bebida'**
  String get fieldDrinks;

  /// No description provided for @fieldSmokes.
  ///
  /// In pt, this message translates to:
  /// **'Fumo'**
  String get fieldSmokes;

  /// No description provided for @fieldPets.
  ///
  /// In pt, this message translates to:
  /// **'Pets'**
  String get fieldPets;

  /// No description provided for @onboardingMusicTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua música'**
  String get onboardingMusicTitle;

  /// No description provided for @onboardingMusicSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha seus gêneros favoritos e até 10 DJs.'**
  String get onboardingMusicSubtitle;

  /// No description provided for @fieldGenres.
  ///
  /// In pt, this message translates to:
  /// **'Gêneros favoritos'**
  String get fieldGenres;

  /// No description provided for @genresMinHint.
  ///
  /// In pt, this message translates to:
  /// **'Escolha pelo menos 1 gênero.'**
  String get genresMinHint;

  /// No description provided for @fieldDjs.
  ///
  /// In pt, this message translates to:
  /// **'DJs favoritos'**
  String get fieldDjs;

  /// No description provided for @djsHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome do DJ'**
  String get djsHint;

  /// No description provided for @addDj.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get addDj;

  /// No description provided for @removeDj.
  ///
  /// In pt, this message translates to:
  /// **'Remover {name}'**
  String removeDj(String name);

  /// No description provided for @djsLimit.
  ///
  /// In pt, this message translates to:
  /// **'Você já adicionou 10 DJs.'**
  String get djsLimit;

  /// No description provided for @onboardingModesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Como você quer usar'**
  String get onboardingModesTitle;

  /// No description provided for @onboardingModesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha pelo menos um modo. Dá para mudar quando quiser.'**
  String get onboardingModesSubtitle;

  /// No description provided for @modeDateDescription.
  ///
  /// In pt, this message translates to:
  /// **'Encontro, algo casual ou relacionamento.'**
  String get modeDateDescription;

  /// No description provided for @modeCrewDescription.
  ///
  /// In pt, this message translates to:
  /// **'Fazer amizades e montar a galera pra não ir sozinho.'**
  String get modeCrewDescription;

  /// No description provided for @modesMinHint.
  ///
  /// In pt, this message translates to:
  /// **'Escolha pelo menos um modo.'**
  String get modesMinHint;

  /// No description provided for @onboardingIntentTitle.
  ///
  /// In pt, this message translates to:
  /// **'O que você busca'**
  String get onboardingIntentTitle;

  /// No description provided for @onboardingIntentSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Dá pra mudar quando quiser no seu perfil.'**
  String get onboardingIntentSubtitle;

  /// No description provided for @onboardingLocationTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua cidade'**
  String get onboardingLocationTitle;

  /// No description provided for @onboardingLocationSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Pra gente mostrar as festas perto de você.'**
  String get onboardingLocationSubtitle;

  /// No description provided for @intentEventsOnly.
  ///
  /// In pt, this message translates to:
  /// **'Só eventos'**
  String get intentEventsOnly;

  /// No description provided for @intentEventsOnlyDescription.
  ///
  /// In pt, this message translates to:
  /// **'Só quero achar festas. Sem fotos e sem aparecer para ninguém.'**
  String get intentEventsOnlyDescription;

  /// No description provided for @intentHint.
  ///
  /// In pt, this message translates to:
  /// **'Pode escolher Date e Crew juntos.'**
  String get intentHint;

  /// No description provided for @intentRequired.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma opção para continuar.'**
  String get intentRequired;

  /// No description provided for @modesNoneHint.
  ///
  /// In pt, this message translates to:
  /// **'Sem nenhum modo, você fica só com os eventos: sai do Descobrir e ninguém te encontra.'**
  String get modesNoneHint;

  /// No description provided for @discoverEventsOnlyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conheça gente nas festas'**
  String get discoverEventsOnlyTitle;

  /// No description provided for @discoverEventsOnlyBody.
  ///
  /// In pt, this message translates to:
  /// **'Ative o Date para dar match ou o Crew para achar galera pro rolê. As fotos e alguns dados só são pedidos na hora de ativar.'**
  String get discoverEventsOnlyBody;

  /// No description provided for @discoverEventsOnlyAction.
  ///
  /// In pt, this message translates to:
  /// **'Ativar Date ou Crew'**
  String get discoverEventsOnlyAction;

  /// No description provided for @activateModesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ativar Date ou Crew'**
  String get activateModesTitle;

  /// No description provided for @activateModesButton.
  ///
  /// In pt, this message translates to:
  /// **'Ativar'**
  String get activateModesButton;

  /// No description provided for @activateModesDone.
  ///
  /// In pt, this message translates to:
  /// **'Pronto! Agora você aparece no Descobrir.'**
  String get activateModesDone;

  /// No description provided for @notNow.
  ///
  /// In pt, this message translates to:
  /// **'Agora não'**
  String get notNow;

  /// No description provided for @crewsSectionNeedsMode.
  ///
  /// In pt, this message translates to:
  /// **'As crews fazem parte do modo Crew. Ative para criar ou entrar numa crew deste evento.'**
  String get crewsSectionNeedsMode;

  /// No description provided for @crewsSectionEnableMode.
  ///
  /// In pt, this message translates to:
  /// **'Ativar o modo Crew'**
  String get crewsSectionEnableMode;

  /// No description provided for @errorCrewModeRequired.
  ///
  /// In pt, this message translates to:
  /// **'Ative o modo Crew no seu perfil para usar as crews.'**
  String get errorCrewModeRequired;

  /// No description provided for @errorCrewNeedsEvent.
  ///
  /// In pt, this message translates to:
  /// **'No Crew, você só curte quem vai a alguma festa com você.'**
  String get errorCrewNeedsEvent;

  /// No description provided for @dateLookingFor.
  ///
  /// In pt, this message translates to:
  /// **'O que você busca'**
  String get dateLookingFor;

  /// No description provided for @dateShowMe.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar para mim'**
  String get dateShowMe;

  /// No description provided for @showMeEveryone.
  ///
  /// In pt, this message translates to:
  /// **'Todo mundo'**
  String get showMeEveryone;

  /// No description provided for @showMeWomen.
  ///
  /// In pt, this message translates to:
  /// **'Mulheres'**
  String get showMeWomen;

  /// No description provided for @showMeMen.
  ///
  /// In pt, this message translates to:
  /// **'Homens'**
  String get showMeMen;

  /// No description provided for @showMeNonBinary.
  ///
  /// In pt, this message translates to:
  /// **'Pessoas não binárias'**
  String get showMeNonBinary;

  /// No description provided for @dateAgeRange.
  ///
  /// In pt, this message translates to:
  /// **'Idade: {min} a {max}'**
  String dateAgeRange(int min, int max);

  /// No description provided for @crewSameGender.
  ///
  /// In pt, this message translates to:
  /// **'Crew só com pessoas do mesmo gênero'**
  String get crewSameGender;

  /// No description provided for @crewSameGenderHint.
  ///
  /// In pt, this message translates to:
  /// **'Ideal para quem quer, por exemplo, uma crew só de mulheres.'**
  String get crewSameGenderHint;

  /// No description provided for @crewSameGenderUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Defina seu gênero no perfil para usar esta opção.'**
  String get crewSameGenderUnavailable;

  /// No description provided for @onboardingFirstEventTitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu primeiro rolê'**
  String get onboardingFirstEventTitle;

  /// No description provided for @onboardingFirstEventSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Marque presença em um evento para ver quem também vai.'**
  String get onboardingFirstEventSubtitle;

  /// No description provided for @attendButton.
  ///
  /// In pt, this message translates to:
  /// **'Eu vou'**
  String get attendButton;

  /// No description provided for @attendingButton.
  ///
  /// In pt, this message translates to:
  /// **'Vou!'**
  String get attendingButton;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não há eventos cadastrados. Você vai poder sugerir um na aba Eventos.'**
  String get noUpcomingEvents;

  /// No description provided for @profileEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar perfil'**
  String get profileEdit;

  /// No description provided for @profilePreviewHint.
  ///
  /// In pt, this message translates to:
  /// **'É assim que as pessoas veem seu perfil.'**
  String get profilePreviewHint;

  /// No description provided for @profileVerified.
  ///
  /// In pt, this message translates to:
  /// **'Verificado'**
  String get profileVerified;

  /// No description provided for @profileUpcomingEvents.
  ///
  /// In pt, this message translates to:
  /// **'Próximos eventos'**
  String get profileUpcomingEvents;

  /// No description provided for @profileNoEvents.
  ///
  /// In pt, this message translates to:
  /// **'Você ainda não marcou presença em nenhum evento.'**
  String get profileNoEvents;

  /// No description provided for @profileNameAge.
  ///
  /// In pt, this message translates to:
  /// **'{name}, {age}'**
  String profileNameAge(String name, int age);

  /// No description provided for @profileSectionMusic.
  ///
  /// In pt, this message translates to:
  /// **'Música'**
  String get profileSectionMusic;

  /// No description provided for @profileSectionAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get profileSectionAbout;

  /// No description provided for @nextPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Próxima foto'**
  String get nextPhoto;

  /// No description provided for @previousPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Foto anterior'**
  String get previousPhoto;

  /// No description provided for @editSectionPhotos.
  ///
  /// In pt, this message translates to:
  /// **'Fotos'**
  String get editSectionPhotos;

  /// No description provided for @editSectionBasics.
  ///
  /// In pt, this message translates to:
  /// **'Básico'**
  String get editSectionBasics;

  /// No description provided for @editSectionAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre mim'**
  String get editSectionAbout;

  /// No description provided for @editSectionMusic.
  ///
  /// In pt, this message translates to:
  /// **'Música'**
  String get editSectionMusic;

  /// No description provided for @editSectionModes.
  ///
  /// In pt, this message translates to:
  /// **'Modos e preferências'**
  String get editSectionModes;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @approve.
  ///
  /// In pt, this message translates to:
  /// **'Aprovar'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In pt, this message translates to:
  /// **'Recusar'**
  String get reject;

  /// No description provided for @eventsTabUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Próximos'**
  String get eventsTabUpcoming;

  /// No description provided for @eventsTabMine.
  ///
  /// In pt, this message translates to:
  /// **'Meus eventos'**
  String get eventsTabMine;

  /// No description provided for @eventsSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar evento pelo nome'**
  String get eventsSearchHint;

  /// No description provided for @eventsSearchNationwide.
  ///
  /// In pt, this message translates to:
  /// **'Buscando em todo o Brasil'**
  String get eventsSearchNationwide;

  /// No description provided for @eventsRadiusLabel.
  ///
  /// In pt, this message translates to:
  /// **'Até {km} km de {city}'**
  String eventsRadiusLabel(int km, String city);

  /// No description provided for @eventsRadiusTitle.
  ///
  /// In pt, this message translates to:
  /// **'Distância máxima'**
  String get eventsRadiusTitle;

  /// No description provided for @eventsRadiusHint.
  ///
  /// In pt, this message translates to:
  /// **'Eventos e pessoas a até {km} km de você.'**
  String eventsRadiusHint(int km);

  /// No description provided for @filterAnyDate.
  ///
  /// In pt, this message translates to:
  /// **'Qualquer data'**
  String get filterAnyDate;

  /// No description provided for @filterToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get filterToday;

  /// No description provided for @filterWeekend.
  ///
  /// In pt, this message translates to:
  /// **'Fim de semana'**
  String get filterWeekend;

  /// No description provided for @filter30Days.
  ///
  /// In pt, this message translates to:
  /// **'Próximos 30 dias'**
  String get filter30Days;

  /// No description provided for @eventsEmptyNearby.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum evento perto de você'**
  String get eventsEmptyNearby;

  /// No description provided for @eventsEmptyNearbyHint.
  ///
  /// In pt, this message translates to:
  /// **'Aumente a distância, busque pelo nome ou sugira um evento.'**
  String get eventsEmptyNearbyHint;

  /// No description provided for @eventsEmptySearch.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum evento encontrado'**
  String get eventsEmptySearch;

  /// No description provided for @eventsEmptyMine.
  ///
  /// In pt, this message translates to:
  /// **'Você ainda não marcou nenhum evento'**
  String get eventsEmptyMine;

  /// No description provided for @eventsEmptyMineHint.
  ///
  /// In pt, this message translates to:
  /// **'Ache um rolê em Próximos e toque em \"Eu vou\".'**
  String get eventsEmptyMineHint;

  /// No description provided for @eventsSeeUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Ver próximos eventos'**
  String get eventsSeeUpcoming;

  /// No description provided for @goingCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Seja a primeira pessoa a ir} =1{1 pessoa vai} other{{count} pessoas vão}}'**
  String goingCount(int count);

  /// No description provided for @distanceKm.
  ///
  /// In pt, this message translates to:
  /// **'{km} km'**
  String distanceKm(int km);

  /// No description provided for @eventOfficial.
  ///
  /// In pt, this message translates to:
  /// **'Oficial'**
  String get eventOfficial;

  /// No description provided for @statusPending.
  ///
  /// In pt, this message translates to:
  /// **'Em análise'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In pt, this message translates to:
  /// **'Aprovado'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In pt, this message translates to:
  /// **'Recusado'**
  String get statusRejected;

  /// No description provided for @statusCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Cancelado'**
  String get statusCancelled;

  /// No description provided for @createEvent.
  ///
  /// In pt, this message translates to:
  /// **'Criar evento'**
  String get createEvent;

  /// No description provided for @moderationQueue.
  ///
  /// In pt, this message translates to:
  /// **'Fila de aprovação'**
  String get moderationQueue;

  /// No description provided for @eventWhen.
  ///
  /// In pt, this message translates to:
  /// **'Quando'**
  String get eventWhen;

  /// No description provided for @eventWhere.
  ///
  /// In pt, this message translates to:
  /// **'Onde'**
  String get eventWhere;

  /// No description provided for @eventMinAge.
  ///
  /// In pt, this message translates to:
  /// **'Classificação: {age}+'**
  String eventMinAge(int age);

  /// No description provided for @eventLineup.
  ///
  /// In pt, this message translates to:
  /// **'Line-up'**
  String get eventLineup;

  /// No description provided for @eventAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre o evento'**
  String get eventAbout;

  /// No description provided for @eventBuyTicket.
  ///
  /// In pt, this message translates to:
  /// **'Comprar ingresso'**
  String get eventBuyTicket;

  /// No description provided for @eventGoing.
  ///
  /// In pt, this message translates to:
  /// **'Quem vai'**
  String get eventGoing;

  /// No description provided for @eventGoingCounts.
  ///
  /// In pt, this message translates to:
  /// **'{date} no Date · {crew} no Crew'**
  String eventGoingCounts(int date, int crew);

  /// No description provided for @eventNobodyGoing.
  ///
  /// In pt, this message translates to:
  /// **'Ainda ninguém marcou presença.'**
  String get eventNobodyGoing;

  /// No description provided for @eventMatchHint.
  ///
  /// In pt, this message translates to:
  /// **'Só seus matches aparecem com nome e foto.'**
  String get eventMatchHint;

  /// No description provided for @eventCrews.
  ///
  /// In pt, this message translates to:
  /// **'Crews deste evento'**
  String get eventCrews;

  /// No description provided for @eventPendingNotice.
  ///
  /// In pt, this message translates to:
  /// **'Este evento está em análise pela curadoria.'**
  String get eventPendingNotice;

  /// No description provided for @eventRejectedReason.
  ///
  /// In pt, this message translates to:
  /// **'Recusado: {reason}'**
  String eventRejectedReason(String reason);

  /// No description provided for @eventCancelledNotice.
  ///
  /// In pt, this message translates to:
  /// **'Este evento foi cancelado.'**
  String get eventCancelledNotice;

  /// No description provided for @eventEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get eventEdit;

  /// No description provided for @eventCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar evento'**
  String get eventCancel;

  /// No description provided for @eventCancelTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar este evento?'**
  String get eventCancelTitle;

  /// No description provided for @eventCancelBody.
  ///
  /// In pt, this message translates to:
  /// **'Quem marcou presença vai ver o evento como cancelado.'**
  String get eventCancelBody;

  /// No description provided for @eventRejectTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recusar evento'**
  String get eventRejectTitle;

  /// No description provided for @eventRejectReasonHint.
  ///
  /// In pt, this message translates to:
  /// **'Explique o motivo para quem sugeriu'**
  String get eventRejectReasonHint;

  /// No description provided for @eventLinkError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir o link.'**
  String get eventLinkError;

  /// No description provided for @eventAttendeeAnonymous.
  ///
  /// In pt, this message translates to:
  /// **'Pessoa que vai ao evento'**
  String get eventAttendeeAnonymous;

  /// No description provided for @eventCreatedBy.
  ///
  /// In pt, this message translates to:
  /// **'Criado por'**
  String get eventCreatedBy;

  /// No description provided for @eventCreatorDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Conta excluída'**
  String get eventCreatorDeleted;

  /// No description provided for @creatorMemberSince.
  ///
  /// In pt, this message translates to:
  /// **'Membro desde {date}'**
  String creatorMemberSince(String date);

  /// No description provided for @creatorEventsStats.
  ///
  /// In pt, this message translates to:
  /// **'Eventos criados: {created} · Recusados: {rejected}'**
  String creatorEventsStats(int created, int rejected);

  /// No description provided for @creatorOnlyModerators.
  ///
  /// In pt, this message translates to:
  /// **'Visível só para curadores e admins.'**
  String get creatorOnlyModerators;

  /// No description provided for @copyEmail.
  ///
  /// In pt, this message translates to:
  /// **'Copiar e-mail'**
  String get copyEmail;

  /// No description provided for @emailCopied.
  ///
  /// In pt, this message translates to:
  /// **'E-mail copiado.'**
  String get emailCopied;

  /// No description provided for @eventFormCreateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar evento'**
  String get eventFormCreateTitle;

  /// No description provided for @eventFormSuggestTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sugerir evento'**
  String get eventFormSuggestTitle;

  /// No description provided for @eventFormEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar evento'**
  String get eventFormEditTitle;

  /// No description provided for @eventFormSuggestHint.
  ///
  /// In pt, this message translates to:
  /// **'Sua sugestão passa pela curadoria antes de aparecer para todo mundo.'**
  String get eventFormSuggestHint;

  /// No description provided for @fieldEventName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do evento'**
  String get fieldEventName;

  /// No description provided for @fieldVenue.
  ///
  /// In pt, this message translates to:
  /// **'Local'**
  String get fieldVenue;

  /// No description provided for @eventsViewMap.
  ///
  /// In pt, this message translates to:
  /// **'Ver no mapa'**
  String get eventsViewMap;

  /// No description provided for @eventsViewList.
  ///
  /// In pt, this message translates to:
  /// **'Ver em lista'**
  String get eventsViewList;

  /// No description provided for @mapUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar o mapa agora. Os eventos continuam marcados.'**
  String get mapUnavailable;

  /// No description provided for @mapNoEvents.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum evento no mapa com esses filtros.'**
  String get mapNoEvents;

  /// No description provided for @eventDirections.
  ///
  /// In pt, this message translates to:
  /// **'Como chegar'**
  String get eventDirections;

  /// No description provided for @eventSecretLocation.
  ///
  /// In pt, this message translates to:
  /// **'Local secreto'**
  String get eventSecretLocation;

  /// No description provided for @eventLocationRevealAt.
  ///
  /// In pt, this message translates to:
  /// **'O endereço aparece em {date}.'**
  String eventLocationRevealAt(String date);

  /// No description provided for @eventLocationSearch.
  ///
  /// In pt, this message translates to:
  /// **'Endereço do local'**
  String get eventLocationSearch;

  /// No description provided for @eventLocationSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Rua e número (ex.: Rua Augusta 657) ou o CEP'**
  String get eventLocationSearchHint;

  /// No description provided for @eventSecretVisibleToYou.
  ///
  /// In pt, this message translates to:
  /// **'Local secreto: só você e a moderação veem o endereço até {date}.'**
  String eventSecretVisibleToYou(String date);

  /// No description provided for @eventLocationNoResults.
  ///
  /// In pt, this message translates to:
  /// **'Nada encontrado. Confira o endereço ou marque no mapa.'**
  String get eventLocationNoResults;

  /// No description provided for @eventLocationPinHint.
  ///
  /// In pt, this message translates to:
  /// **'Toque no mapa para ajustar o pin no local exato.'**
  String get eventLocationPinHint;

  /// No description provided for @eventSecretToggle.
  ///
  /// In pt, this message translates to:
  /// **'Local secreto'**
  String get eventSecretToggle;

  /// No description provided for @eventSecretHint.
  ///
  /// In pt, this message translates to:
  /// **'O endereço só aparece {hours} h antes. Até lá, o mapa mostra só a região.'**
  String eventSecretHint(int hours);

  /// No description provided for @eventRevealHours.
  ///
  /// In pt, this message translates to:
  /// **'{hours} h antes'**
  String eventRevealHours(int hours);

  /// No description provided for @fieldDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descrição (opcional)'**
  String get fieldDescription;

  /// No description provided for @fieldStartsAt.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get fieldStartsAt;

  /// No description provided for @fieldEndsAt.
  ///
  /// In pt, this message translates to:
  /// **'Término'**
  String get fieldEndsAt;

  /// No description provided for @fieldTicketUrl.
  ///
  /// In pt, this message translates to:
  /// **'Link do ingresso (opcional)'**
  String get fieldTicketUrl;

  /// No description provided for @fieldTicketCoupon.
  ///
  /// In pt, this message translates to:
  /// **'Cupom de desconto (opcional)'**
  String get fieldTicketCoupon;

  /// No description provided for @fieldTicketCouponHint.
  ///
  /// In pt, this message translates to:
  /// **'Aparece no evento com botão de copiar, ex.: seu código de promoter.'**
  String get fieldTicketCouponHint;

  /// No description provided for @fieldMinAge.
  ///
  /// In pt, this message translates to:
  /// **'Classificação etária'**
  String get fieldMinAge;

  /// No description provided for @fieldLineup.
  ///
  /// In pt, this message translates to:
  /// **'Line-up'**
  String get fieldLineup;

  /// No description provided for @lineupHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome do artista'**
  String get lineupHint;

  /// No description provided for @addArtist.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get addArtist;

  /// No description provided for @eventCoverAdd.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar capa'**
  String get eventCoverAdd;

  /// No description provided for @eventCoverChange.
  ///
  /// In pt, this message translates to:
  /// **'Trocar capa'**
  String get eventCoverChange;

  /// No description provided for @validationEndsAfterStart.
  ///
  /// In pt, this message translates to:
  /// **'O término precisa ser depois do início (até 7 dias).'**
  String get validationEndsAfterStart;

  /// No description provided for @validationUrl.
  ///
  /// In pt, this message translates to:
  /// **'Use um link que comece com http:// ou https://'**
  String get validationUrl;

  /// No description provided for @validationFuture.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma data futura.'**
  String get validationFuture;

  /// No description provided for @eventSaveSuggest.
  ///
  /// In pt, this message translates to:
  /// **'Enviar sugestão'**
  String get eventSaveSuggest;

  /// No description provided for @venuesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Casas'**
  String get venuesTitle;

  /// No description provided for @venuesSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar casa pelo nome'**
  String get venuesSearchHint;

  /// No description provided for @venuesInState.
  ///
  /// In pt, this message translates to:
  /// **'Em {state}'**
  String venuesInState(String state);

  /// No description provided for @venuesEverywhere.
  ///
  /// In pt, this message translates to:
  /// **'Todo o Brasil'**
  String get venuesEverywhere;

  /// No description provided for @venuesEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma casa por aqui ainda'**
  String get venuesEmpty;

  /// No description provided for @venuesEmptySearch.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma casa com esse nome. Confira a grafia ou cadastre a casa.'**
  String get venuesEmptySearch;

  /// No description provided for @venuesPending.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 casa para aprovar} other{{count} casas para aprovar}}'**
  String venuesPending(int count);

  /// No description provided for @venueNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Essa casa não existe mais'**
  String get venueNotFound;

  /// No description provided for @venueAdd.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar casa'**
  String get venueAdd;

  /// No description provided for @venueSuggest.
  ///
  /// In pt, this message translates to:
  /// **'Enviar para a curadoria'**
  String get venueSuggest;

  /// No description provided for @venueSuggestHint.
  ///
  /// In pt, this message translates to:
  /// **'Sua casa passa pela curadoria antes de aparecer para todo mundo. Enquanto isso, você já pode usá-la nos seus eventos.'**
  String get venueSuggestHint;

  /// No description provided for @venueCreated.
  ///
  /// In pt, this message translates to:
  /// **'Casa cadastrada!'**
  String get venueCreated;

  /// No description provided for @venueSuggested.
  ///
  /// In pt, this message translates to:
  /// **'Casa enviada para a curadoria.'**
  String get venueSuggested;

  /// No description provided for @venueEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar casa'**
  String get venueEdit;

  /// No description provided for @venueName.
  ///
  /// In pt, this message translates to:
  /// **'Nome da casa'**
  String get venueName;

  /// No description provided for @venueNeighborhood.
  ///
  /// In pt, this message translates to:
  /// **'Bairro'**
  String get venueNeighborhood;

  /// No description provided for @venueInstagram.
  ///
  /// In pt, this message translates to:
  /// **'Instagram da casa'**
  String get venueInstagram;

  /// No description provided for @venueInstagramInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Use só o @ (letras, números, ponto e _).'**
  String get venueInstagramInvalid;

  /// No description provided for @venuePhoto.
  ///
  /// In pt, this message translates to:
  /// **'Foto da casa'**
  String get venuePhoto;

  /// No description provided for @venueFollow.
  ///
  /// In pt, this message translates to:
  /// **'Seguir casa'**
  String get venueFollow;

  /// No description provided for @venueFollowing.
  ///
  /// In pt, this message translates to:
  /// **'Seguindo'**
  String get venueFollowing;

  /// No description provided for @venueFollowHint.
  ///
  /// In pt, this message translates to:
  /// **'Quem segue fica sabendo das festas novas daqui.'**
  String get venueFollowHint;

  /// No description provided for @venueFollowers.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Nenhum seguidor} =1{1 seguidor} other{{count} seguidores}}'**
  String venueFollowers(int count);

  /// No description provided for @venueNoRatings.
  ///
  /// In pt, this message translates to:
  /// **'Sem avaliações'**
  String get venueNoRatings;

  /// No description provided for @venueStars.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 estrela} other{{count} estrelas}}'**
  String venueStars(int count);

  /// No description provided for @venueUpcomingCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 festa vindo} other{{count} festas vindo}}'**
  String venueUpcomingCount(int count);

  /// No description provided for @venuePendingBanner.
  ///
  /// In pt, this message translates to:
  /// **'Esta casa está em análise pela curadoria. Só você e a equipe a veem.'**
  String get venuePendingBanner;

  /// No description provided for @venueRejectedBanner.
  ///
  /// In pt, this message translates to:
  /// **'Casa recusada pela curadoria: {reason}'**
  String venueRejectedBanner(String reason);

  /// No description provided for @venueWhere.
  ///
  /// In pt, this message translates to:
  /// **'Onde fica'**
  String get venueWhere;

  /// No description provided for @venueUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Próximas festas'**
  String get venueUpcoming;

  /// No description provided for @venueNoUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma festa marcada aqui por enquanto. Siga a casa para saber quando tiver.'**
  String get venueNoUpcoming;

  /// No description provided for @venuePastEvents.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 festa já rolou aqui pelo app} other{{count} festas já rolaram aqui pelo app}}'**
  String venuePastEvents(int count);

  /// No description provided for @venueRatings.
  ///
  /// In pt, this message translates to:
  /// **'Avaliações'**
  String get venueRatings;

  /// No description provided for @venueRate.
  ///
  /// In pt, this message translates to:
  /// **'Avaliar a casa'**
  String get venueRate;

  /// No description provided for @venueRateEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar minha avaliação'**
  String get venueRateEdit;

  /// No description provided for @venueRateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Como foi na {name}?'**
  String venueRateTitle(String name);

  /// No description provided for @venueRateComment.
  ///
  /// In pt, this message translates to:
  /// **'Conte como foi (opcional)'**
  String get venueRateComment;

  /// No description provided for @venueRateDelete.
  ///
  /// In pt, this message translates to:
  /// **'Apagar minha avaliação'**
  String get venueRateDelete;

  /// No description provided for @venueRateOnlyWent.
  ///
  /// In pt, this message translates to:
  /// **'Só quem foi a uma festa aqui pelo app pode avaliar.'**
  String get venueRateOnlyWent;

  /// No description provided for @venueApprove.
  ///
  /// In pt, this message translates to:
  /// **'Aprovar casa'**
  String get venueApprove;

  /// No description provided for @venueRefuse.
  ///
  /// In pt, this message translates to:
  /// **'Recusar'**
  String get venueRefuse;

  /// No description provided for @venueRefuseTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recusar casa'**
  String get venueRefuseTitle;

  /// No description provided for @venuePickTitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolher a casa'**
  String get venuePickTitle;

  /// No description provided for @venuePickAdd.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar uma casa nova'**
  String get venuePickAdd;

  /// No description provided for @venueLinked.
  ///
  /// In pt, this message translates to:
  /// **'Ligado à página da casa'**
  String get venueLinked;

  /// No description provided for @venueLinkHint.
  ///
  /// In pt, this message translates to:
  /// **'Toque na lojinha para escolher a casa'**
  String get venueLinkHint;

  /// No description provided for @venueSee.
  ///
  /// In pt, this message translates to:
  /// **'Ver a página da {name}'**
  String venueSee(String name);

  /// No description provided for @errorVenueUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Essa casa ainda não foi aprovada. Escolha outra ou aguarde a curadoria.'**
  String get errorVenueUnavailable;

  /// No description provided for @onTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tô ON hoje'**
  String get onTitle;

  /// No description provided for @onHint.
  ///
  /// In pt, this message translates to:
  /// **'Só seus matches e sua crew dessa festa veem. Sem localização.'**
  String get onHint;

  /// No description provided for @onPeopleOne.
  ///
  /// In pt, this message translates to:
  /// **'{name} está ON'**
  String onPeopleOne(String name);

  /// No description provided for @onPeopleTwo.
  ///
  /// In pt, this message translates to:
  /// **'{first} e {second} estão ON'**
  String onPeopleTwo(String first, String second);

  /// No description provided for @onPeopleMore.
  ///
  /// In pt, this message translates to:
  /// **'{name} e mais {count} estão ON'**
  String onPeopleMore(String name, int count);

  /// No description provided for @errorOnNotNow.
  ///
  /// In pt, this message translates to:
  /// **'O \"Tô ON\" só funciona no dia de uma festa em que você marcou \"Eu vou\".'**
  String get errorOnNotNow;

  /// No description provided for @checkInTitle.
  ///
  /// In pt, this message translates to:
  /// **'Check-in'**
  String get checkInTitle;

  /// No description provided for @checkInHint.
  ///
  /// In pt, this message translates to:
  /// **'Prove que você está na festa: vale para suas conquistas e seu passaporte. A localização é usada só agora e não fica salva.'**
  String get checkInHint;

  /// No description provided for @checkInGps.
  ///
  /// In pt, this message translates to:
  /// **'Tô aqui'**
  String get checkInGps;

  /// No description provided for @checkInScan.
  ///
  /// In pt, this message translates to:
  /// **'Ler QR'**
  String get checkInScan;

  /// No description provided for @checkInDone.
  ///
  /// In pt, this message translates to:
  /// **'Check-in feito às {time}'**
  String checkInDone(String time);

  /// No description provided for @checkInDoneHint.
  ///
  /// In pt, this message translates to:
  /// **'Essa festa já conta para suas conquistas.'**
  String get checkInDoneHint;

  /// No description provided for @checkInSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Check-in feito! Essa festa conta para suas conquistas.'**
  String get checkInSuccess;

  /// No description provided for @checkInError.
  ///
  /// In pt, this message translates to:
  /// **'{problem, select, closed{O check-in abre 1 h antes da festa e vai até o fim.} mocked{Não deu para confirmar sua localização. Desative apps de localização falsa ou use o QR da produção.} noVenue{Essa festa não tem o endereço no mapa. Use o QR da produção.} tooFar{Você parece estar longe da festa. Chegando lá, tente de novo ou use o QR da produção.} badCode{Código inválido ou vencido. Leia o QR de novo.} other{Não foi possível fazer o check-in.}}'**
  String checkInError(String problem);

  /// No description provided for @checkInScanTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ler QR de check-in'**
  String get checkInScanTitle;

  /// No description provided for @checkInScanHint.
  ///
  /// In pt, this message translates to:
  /// **'Aponte para o QR que a produção mostra na entrada.'**
  String get checkInScanHint;

  /// No description provided for @checkInScanWrong.
  ///
  /// In pt, this message translates to:
  /// **'Esse QR não é do check-in desta festa.'**
  String get checkInScanWrong;

  /// No description provided for @checkInCodeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Ou digite o código'**
  String get checkInCodeLabel;

  /// No description provided for @checkInCodeSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get checkInCodeSubmit;

  /// No description provided for @checkInQrTitle.
  ///
  /// In pt, this message translates to:
  /// **'QR de check-in'**
  String get checkInQrTitle;

  /// No description provided for @checkInQrHint.
  ///
  /// In pt, this message translates to:
  /// **'Mostre na entrada. O código muda a cada minuto, então print não funciona.'**
  String get checkInQrHint;

  /// No description provided for @checkInQrClosed.
  ///
  /// In pt, this message translates to:
  /// **'O check-in abre 1 h antes da festa e vai até o fim.'**
  String get checkInQrClosed;

  /// No description provided for @checkInQrCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Ninguém fez check-in ainda} =1{1 pessoa fez check-in} other{{count} pessoas fizeram check-in}}'**
  String checkInQrCount(int count);

  /// No description provided for @eventChatTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chat da festa'**
  String get eventChatTitle;

  /// No description provided for @eventChatPeople.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 pessoa vai} other{{count} pessoas vão}}'**
  String eventChatPeople(int count);

  /// No description provided for @eventChatCardBody.
  ///
  /// In pt, this message translates to:
  /// **'Combine carona, esquenta e o rolê com quem vai.'**
  String get eventChatCardBody;

  /// No description provided for @eventChatCardEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Ninguém escreveu ainda. Puxe o papo!'**
  String get eventChatCardEmpty;

  /// No description provided for @eventChatCardLast.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 mensagem} other{{count} mensagens}} · última: {when}'**
  String eventChatCardLast(int count, String when);

  /// No description provided for @eventChatJoinHint.
  ///
  /// In pt, this message translates to:
  /// **'Marque \"Eu vou\" para entrar no chat da festa.'**
  String get eventChatJoinHint;

  /// No description provided for @eventChatReadOnly.
  ///
  /// In pt, this message translates to:
  /// **'A festa acabou: o chat fica só para leitura e some em alguns dias.'**
  String get eventChatReadOnly;

  /// No description provided for @eventChatMuted.
  ///
  /// In pt, this message translates to:
  /// **'A produção silenciou você neste chat.'**
  String get eventChatMuted;

  /// No description provided for @eventChatInputHint.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem para quem vai'**
  String get eventChatInputHint;

  /// No description provided for @eventChatEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Ninguém escreveu ainda. Puxe o papo!'**
  String get eventChatEmpty;

  /// No description provided for @eventChatTeam.
  ///
  /// In pt, this message translates to:
  /// **'Produção'**
  String get eventChatTeam;

  /// No description provided for @eventChatRules.
  ///
  /// In pt, this message translates to:
  /// **'Chat aberto para quem vai. Seja gente boa: nada de venda de ingresso, spam ou assédio. Denuncie o que passar do ponto.'**
  String get eventChatRules;

  /// No description provided for @eventChatLoadOlder.
  ///
  /// In pt, this message translates to:
  /// **'Ver mensagens anteriores'**
  String get eventChatLoadOlder;

  /// No description provided for @eventChatReport.
  ///
  /// In pt, this message translates to:
  /// **'Denunciar'**
  String get eventChatReport;

  /// No description provided for @eventChatMute.
  ///
  /// In pt, this message translates to:
  /// **'Silenciar no chat'**
  String get eventChatMute;

  /// No description provided for @eventChatMuteDone.
  ///
  /// In pt, this message translates to:
  /// **'{name} foi silenciado(a) neste chat.'**
  String eventChatMuteDone(String name);

  /// No description provided for @eventChatDeleteBody.
  ///
  /// In pt, this message translates to:
  /// **'Ela some para todo mundo do chat.'**
  String get eventChatDeleteBody;

  /// No description provided for @eventChatError.
  ///
  /// In pt, this message translates to:
  /// **'{problem, select, notGoing{Marque \"Eu vou\" para escrever no chat.} closed{O chat dessa festa está fechado.} muted{A produção silenciou você neste chat.} other{Não foi possível enviar.}}'**
  String eventChatError(String problem);

  /// No description provided for @afterPartyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Depois da festa'**
  String get afterPartyTitle;

  /// No description provided for @afterPartySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Quem foi na {name}'**
  String afterPartySubtitle(String name);

  /// No description provided for @afterPartyBanner.
  ///
  /// In pt, this message translates to:
  /// **'Você foi na {name}? Veja as {count} pessoas que estavam lá'**
  String afterPartyBanner(String name, int count);

  /// No description provided for @afterPartyCardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Veja quem estava lá'**
  String get afterPartyCardTitle;

  /// No description provided for @afterPartyCardBody.
  ///
  /// In pt, this message translates to:
  /// **'Por 48 h, dê match com quem foi a essa festa.'**
  String get afterPartyCardBody;

  /// No description provided for @afterPartyEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Você já viu todo mundo dessa festa'**
  String get afterPartyEmptyTitle;

  /// No description provided for @afterPartyEmptyBody.
  ///
  /// In pt, this message translates to:
  /// **'Seus matches estão em Chats. Na próxima, marque \"Eu vou\" de novo!'**
  String get afterPartyEmptyBody;

  /// No description provided for @afterPartyBack.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao Descobrir'**
  String get afterPartyBack;

  /// No description provided for @eventSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar festa'**
  String get eventSave;

  /// No description provided for @eventUnsave.
  ///
  /// In pt, this message translates to:
  /// **'Tirar dos salvos'**
  String get eventUnsave;

  /// No description provided for @eventSaved.
  ///
  /// In pt, this message translates to:
  /// **'Festa salva. Ela aparece em \"Meus eventos\" e a gente lembra na véspera.'**
  String get eventSaved;

  /// No description provided for @eventUnsaved.
  ///
  /// In pt, this message translates to:
  /// **'Festa tirada dos salvos.'**
  String get eventUnsaved;

  /// No description provided for @eventSavedPill.
  ///
  /// In pt, this message translates to:
  /// **'Salvo'**
  String get eventSavedPill;

  /// No description provided for @achievementsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conquistas ({unlocked}/{total})'**
  String achievementsTitle(int unlocked, int total);

  /// No description provided for @achievementName.
  ///
  /// In pt, this message translates to:
  /// **'{key, select, firstParty{Primeira festa} partyAnimal{Rato de balada} nightLegend{Lenda da noite} loyalToTheHouse{Fiel à casa} neverAlone{Nunca vai sozinho} explorer{Explorador} eclectic{Eclético} marathoner{Maratonista} other{Conquista}}'**
  String achievementName(String key);

  /// No description provided for @achievementGoal.
  ///
  /// In pt, this message translates to:
  /// **'{key, select, firstParty{Faça check-in na sua primeira festa} partyAnimal{Faça check-in em 5 festas} nightLegend{Faça check-in em 20 festas} loyalToTheHouse{Faça check-in em 3 festas na mesma casa} neverAlone{Entre em 3 crews} explorer{Faça check-in em festas de 3 cidades} eclectic{Faça check-in em festas de 5 estilos} marathoner{Faça check-in em 3 festas de 10 h ou mais} other{}}'**
  String achievementGoal(String key);

  /// No description provided for @passportTitle.
  ///
  /// In pt, this message translates to:
  /// **'Passaporte'**
  String get passportTitle;

  /// No description provided for @passportPrivate.
  ///
  /// In pt, this message translates to:
  /// **'Só você vê. Contam só as festas em que você fez check-in.'**
  String get passportPrivate;

  /// No description provided for @passportParties.
  ///
  /// In pt, this message translates to:
  /// **'festas'**
  String get passportParties;

  /// No description provided for @passportVenues.
  ///
  /// In pt, this message translates to:
  /// **'casas'**
  String get passportVenues;

  /// No description provided for @passportCities.
  ///
  /// In pt, this message translates to:
  /// **'cidades'**
  String get passportCities;

  /// No description provided for @passportGenres.
  ///
  /// In pt, this message translates to:
  /// **'estilos'**
  String get passportGenres;

  /// No description provided for @passportEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Seu passaporte começa no seu primeiro check-in. Na noite da festa, abra o evento e toque em \"Tô aqui\".'**
  String get passportEmpty;

  /// No description provided for @passportSeeAll.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Ver mais 1 festa com o Pulse Black} other{Ver mais {count} festas com o Pulse Black}}'**
  String passportSeeAll(int count);

  /// No description provided for @sectionFeatured.
  ///
  /// In pt, this message translates to:
  /// **'Em destaque'**
  String get sectionFeatured;

  /// No description provided for @mineAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get mineAll;

  /// No description provided for @mineGoing.
  ///
  /// In pt, this message translates to:
  /// **'Vou'**
  String get mineGoing;

  /// No description provided for @mineSaved.
  ///
  /// In pt, this message translates to:
  /// **'Salvos'**
  String get mineSaved;

  /// No description provided for @mineEmptySaved.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma festa salva ainda. Toque no marcador de uma festa para guardar.'**
  String get mineEmptySaved;

  /// No description provided for @mineEmptyGoing.
  ///
  /// In pt, this message translates to:
  /// **'Você ainda não marcou \"Eu vou\" em nenhuma festa.'**
  String get mineEmptyGoing;

  /// No description provided for @sectionTrending.
  ///
  /// In pt, this message translates to:
  /// **'Em alta'**
  String get sectionTrending;

  /// No description provided for @sectionThisWeek.
  ///
  /// In pt, this message translates to:
  /// **'Esta semana'**
  String get sectionThisWeek;

  /// No description provided for @sectionFollowedVenues.
  ///
  /// In pt, this message translates to:
  /// **'Das casas que você segue'**
  String get sectionFollowedVenues;

  /// No description provided for @sectionAllUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Todas as próximas'**
  String get sectionAllUpcoming;

  /// No description provided for @pollCreateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar enquete'**
  String get pollCreateTitle;

  /// No description provided for @pollQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Pergunta'**
  String get pollQuestion;

  /// No description provided for @pollQuestionHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Que horas o esquenta?'**
  String get pollQuestionHint;

  /// No description provided for @pollOption.
  ///
  /// In pt, this message translates to:
  /// **'Opção {number}'**
  String pollOption(int number);

  /// No description provided for @pollAddOption.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar opção'**
  String get pollAddOption;

  /// No description provided for @pollDuration.
  ///
  /// In pt, this message translates to:
  /// **'Fica aberta por'**
  String get pollDuration;

  /// No description provided for @pollHours.
  ///
  /// In pt, this message translates to:
  /// **'{hours} h'**
  String pollHours(int hours);

  /// No description provided for @pollCreate.
  ///
  /// In pt, this message translates to:
  /// **'Mandar enquete'**
  String get pollCreate;

  /// No description provided for @pollVotes.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Ninguém votou ainda} =1{1 voto} other{{count} votos}}'**
  String pollVotes(int count);

  /// No description provided for @pollClosesInHours.
  ///
  /// In pt, this message translates to:
  /// **'{hours, plural, =1{fecha em 1 h} other{fecha em {hours} h}}'**
  String pollClosesInHours(int hours);

  /// No description provided for @pollClosesSoon.
  ///
  /// In pt, this message translates to:
  /// **'fecha em instantes'**
  String get pollClosesSoon;

  /// No description provided for @pollClosed.
  ///
  /// In pt, this message translates to:
  /// **'encerrada'**
  String get pollClosed;

  /// No description provided for @eventShareTitle.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar festa'**
  String get eventShareTitle;

  /// No description provided for @eventShareStory.
  ///
  /// In pt, this message translates to:
  /// **'Postar no story'**
  String get eventShareStory;

  /// No description provided for @eventInviteFriends.
  ///
  /// In pt, this message translates to:
  /// **'Chamar a galera'**
  String get eventInviteFriends;

  /// No description provided for @eventStoryGoing.
  ///
  /// In pt, this message translates to:
  /// **'EU VOU 🔥'**
  String get eventStoryGoing;

  /// No description provided for @eventStoryCoupon.
  ///
  /// In pt, this message translates to:
  /// **'Cupom: {code}'**
  String eventStoryCoupon(String code);

  /// No description provided for @eventStoryTagline.
  ///
  /// In pt, this message translates to:
  /// **'Ache sua galera nas mesmas festas'**
  String get eventStoryTagline;

  /// No description provided for @eventInviteHeadline.
  ///
  /// In pt, this message translates to:
  /// **'Bora na {name}? 🎧'**
  String eventInviteHeadline(String name);

  /// No description provided for @eventInviteLineup.
  ///
  /// In pt, this message translates to:
  /// **'Line-up: {artists}'**
  String eventInviteLineup(String artists);

  /// No description provided for @eventInviteTicket.
  ///
  /// In pt, this message translates to:
  /// **'Ingresso: {url}'**
  String eventInviteTicket(String url);

  /// No description provided for @eventInviteCoupon.
  ///
  /// In pt, this message translates to:
  /// **'Cupom de desconto: {code}'**
  String eventInviteCoupon(String code);

  /// No description provided for @eventInviteFooter.
  ///
  /// In pt, this message translates to:
  /// **'Marca presença no Pulse pra gente montar a crew!'**
  String get eventInviteFooter;

  /// No description provided for @eventDuplicate.
  ///
  /// In pt, this message translates to:
  /// **'Duplicar festa'**
  String get eventDuplicate;

  /// No description provided for @eventDuplicateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova edição'**
  String get eventDuplicateTitle;

  /// No description provided for @eventImportTitle.
  ///
  /// In pt, this message translates to:
  /// **'Importar de um link'**
  String get eventImportTitle;

  /// No description provided for @eventImportHint.
  ///
  /// In pt, this message translates to:
  /// **'Cole o link do ingresso (Sympla, Ingresse, Shotgun…) e a gente preenche o que der.'**
  String get eventImportHint;

  /// No description provided for @eventImportField.
  ///
  /// In pt, this message translates to:
  /// **'Link da página do ingresso'**
  String get eventImportField;

  /// No description provided for @eventImportButton.
  ///
  /// In pt, this message translates to:
  /// **'Importar'**
  String get eventImportButton;

  /// No description provided for @eventImportDone.
  ///
  /// In pt, this message translates to:
  /// **'Pronto! Confira tudo antes de salvar.'**
  String get eventImportDone;

  /// No description provided for @eventImportError.
  ///
  /// In pt, this message translates to:
  /// **'{problem, select, invalid{Esse link não parece válido.} unavailable{Não deu para abrir essa página. Tente de novo ou preencha à mão.} noData{Essa página não traz os dados da festa. Preencha à mão.} other{Não deu para importar esse link.}}'**
  String eventImportError(String problem);

  /// No description provided for @eventSaveCreate.
  ///
  /// In pt, this message translates to:
  /// **'Publicar evento'**
  String get eventSaveCreate;

  /// No description provided for @eventSubmittedPending.
  ///
  /// In pt, this message translates to:
  /// **'Sugestão enviada! A curadoria vai analisar.'**
  String get eventSubmittedPending;

  /// No description provided for @eventPublished.
  ///
  /// In pt, this message translates to:
  /// **'Evento publicado!'**
  String get eventPublished;

  /// No description provided for @similarTitle.
  ///
  /// In pt, this message translates to:
  /// **'Esse evento já existe?'**
  String get similarTitle;

  /// No description provided for @similarBody.
  ///
  /// In pt, this message translates to:
  /// **'Achamos eventos parecidos no mesmo dia e cidade:'**
  String get similarBody;

  /// No description provided for @similarUseExisting.
  ///
  /// In pt, this message translates to:
  /// **'É este, marcar presença'**
  String get similarUseExisting;

  /// No description provided for @similarCreateAnyway.
  ///
  /// In pt, this message translates to:
  /// **'Não, é outro evento'**
  String get similarCreateAnyway;

  /// No description provided for @queueEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum evento aguardando aprovação.'**
  String get queueEmpty;

  /// No description provided for @roleRequestTitle.
  ///
  /// In pt, this message translates to:
  /// **'Curadoria e produção'**
  String get roleRequestTitle;

  /// No description provided for @roleRequestEntry.
  ///
  /// In pt, this message translates to:
  /// **'Quero ser curador ou produtor'**
  String get roleRequestEntry;

  /// No description provided for @roleCurator.
  ///
  /// In pt, this message translates to:
  /// **'Curador'**
  String get roleCurator;

  /// No description provided for @roleCuratorDescription.
  ///
  /// In pt, this message translates to:
  /// **'Cadastra eventos e aprova as sugestões da comunidade.'**
  String get roleCuratorDescription;

  /// No description provided for @roleProducer.
  ///
  /// In pt, this message translates to:
  /// **'Produtor'**
  String get roleProducer;

  /// No description provided for @roleProducerDescription.
  ///
  /// In pt, this message translates to:
  /// **'Publica os próprios eventos com o selo Oficial.'**
  String get roleProducerDescription;

  /// No description provided for @roleUser.
  ///
  /// In pt, this message translates to:
  /// **'Usuário'**
  String get roleUser;

  /// No description provided for @roleAdmin.
  ///
  /// In pt, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleCurrent.
  ///
  /// In pt, this message translates to:
  /// **'Seu papel atual: {role}'**
  String roleCurrent(String role);

  /// No description provided for @roleJustification.
  ///
  /// In pt, this message translates to:
  /// **'Por que você quer esse papel?'**
  String get roleJustification;

  /// No description provided for @roleLinks.
  ///
  /// In pt, this message translates to:
  /// **'Links (Instagram, site, Resident Advisor…)'**
  String get roleLinks;

  /// No description provided for @roleLinksHint.
  ///
  /// In pt, this message translates to:
  /// **'Um link por linha'**
  String get roleLinksHint;

  /// No description provided for @roleSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Enviar pedido'**
  String get roleSubmit;

  /// No description provided for @roleRequestSent.
  ///
  /// In pt, this message translates to:
  /// **'Pedido enviado!'**
  String get roleRequestSent;

  /// No description provided for @roleRequestPending.
  ///
  /// In pt, this message translates to:
  /// **'Seu pedido para {role} está em análise.'**
  String roleRequestPending(String role);

  /// No description provided for @roleRequestRejected.
  ///
  /// In pt, this message translates to:
  /// **'Seu último pedido não foi aprovado. Você pode enviar outro.'**
  String get roleRequestRejected;

  /// No description provided for @validationJustification.
  ///
  /// In pt, this message translates to:
  /// **'Escreva pelo menos 10 caracteres.'**
  String get validationJustification;

  /// No description provided for @adminRoleRequests.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos de papel'**
  String get adminRoleRequests;

  /// No description provided for @startCrewAction.
  ///
  /// In pt, this message translates to:
  /// **'Montar crew'**
  String get startCrewAction;

  /// No description provided for @startCrewTitle.
  ///
  /// In pt, this message translates to:
  /// **'Montar uma crew com {name}'**
  String startCrewTitle(String name);

  /// No description provided for @startCrewSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma festa que vocês dois vão. A crew já é criada com o convite.'**
  String get startCrewSubtitle;

  /// No description provided for @startCrewNoEvents.
  ///
  /// In pt, this message translates to:
  /// **'Vocês ainda não têm festa em comum. Marquem presença no mesmo evento para montar uma crew com {name}.'**
  String startCrewNoEvents(String name);

  /// No description provided for @requesterUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Pessoa sem nome'**
  String get requesterUnknown;

  /// No description provided for @requesterViewProfile.
  ///
  /// In pt, this message translates to:
  /// **'Ver perfil'**
  String get requesterViewProfile;

  /// No description provided for @adminNoRoleRequests.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum pedido pendente.'**
  String get adminNoRoleRequests;

  /// No description provided for @stampLike.
  ///
  /// In pt, this message translates to:
  /// **'CURTI'**
  String get stampLike;

  /// No description provided for @stampCrewLike.
  ///
  /// In pt, this message translates to:
  /// **'BORA'**
  String get stampCrewLike;

  /// No description provided for @stampPass.
  ///
  /// In pt, this message translates to:
  /// **'PASSO'**
  String get stampPass;

  /// No description provided for @discoverGoingTo.
  ///
  /// In pt, this message translates to:
  /// **'Vocês vão: {event}'**
  String discoverGoingTo(String event);

  /// No description provided for @discoverGoingToMore.
  ///
  /// In pt, this message translates to:
  /// **'Vocês vão: {event} +{count}'**
  String discoverGoingToMore(String event, int count);

  /// No description provided for @discoverCrewFor.
  ///
  /// In pt, this message translates to:
  /// **'Procurando crew para: {event}'**
  String discoverCrewFor(String event);

  /// No description provided for @discoverCrewForMore.
  ///
  /// In pt, this message translates to:
  /// **'Procurando crew para: {event} +{count}'**
  String discoverCrewForMore(String event, int count);

  /// No description provided for @discoverLookingFor.
  ///
  /// In pt, this message translates to:
  /// **'Busca: {intent}'**
  String discoverLookingFor(String intent);

  /// No description provided for @discoverMusicMatch.
  ///
  /// In pt, this message translates to:
  /// **'{percent}% de match musical'**
  String discoverMusicMatch(int percent);

  /// No description provided for @discoverDjs.
  ///
  /// In pt, this message translates to:
  /// **'Curte: {djs}'**
  String discoverDjs(String djs);

  /// No description provided for @discoverSharedGenres.
  ///
  /// In pt, this message translates to:
  /// **'Vocês curtem: {genres}'**
  String discoverSharedGenres(String genres);

  /// No description provided for @discoverDistance.
  ///
  /// In pt, this message translates to:
  /// **'a {km} km'**
  String discoverDistance(int km);

  /// No description provided for @discoverNoEventsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Marque presença em um evento'**
  String get discoverNoEventsTitle;

  /// No description provided for @discoverNoEventsBody.
  ///
  /// In pt, this message translates to:
  /// **'No Crew aparecem só as pessoas que vão às mesmas festas que você.'**
  String get discoverNoEventsBody;

  /// No description provided for @discoverGoToEvents.
  ///
  /// In pt, this message translates to:
  /// **'Ver eventos'**
  String get discoverGoToEvents;

  /// No description provided for @discoverEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Você viu todo mundo dos seus eventos'**
  String get discoverEmptyTitle;

  /// No description provided for @discoverEmptyBody.
  ///
  /// In pt, this message translates to:
  /// **'Volte mais tarde ou marque presença em mais festas para achar sua crew.'**
  String get discoverEmptyBody;

  /// No description provided for @discoverDateEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ninguém novo por perto agora'**
  String get discoverDateEmptyTitle;

  /// No description provided for @discoverDateEmptyBody.
  ///
  /// In pt, this message translates to:
  /// **'Volte mais tarde ou aumente a distância máxima (em Eventos, toque em \"Até … km\").'**
  String get discoverDateEmptyBody;

  /// No description provided for @discoverModeOff.
  ///
  /// In pt, this message translates to:
  /// **'O modo {mode} está desligado no seu perfil.'**
  String discoverModeOff(String mode);

  /// No description provided for @discoverEnableMode.
  ///
  /// In pt, this message translates to:
  /// **'Ativar nos modos'**
  String get discoverEnableMode;

  /// No description provided for @actionPass.
  ///
  /// In pt, this message translates to:
  /// **'Passar'**
  String get actionPass;

  /// No description provided for @actionLike.
  ///
  /// In pt, this message translates to:
  /// **'Curtir'**
  String get actionLike;

  /// No description provided for @actionUndo.
  ///
  /// In pt, this message translates to:
  /// **'Voltar o último'**
  String get actionUndo;

  /// No description provided for @actionOpenProfile.
  ///
  /// In pt, this message translates to:
  /// **'Ver perfil completo'**
  String get actionOpenProfile;

  /// No description provided for @undoNothing.
  ///
  /// In pt, this message translates to:
  /// **'Não dá para voltar esse.'**
  String get undoNothing;

  /// No description provided for @matchTitleDate.
  ///
  /// In pt, this message translates to:
  /// **'É MATCH!'**
  String get matchTitleDate;

  /// No description provided for @matchTitleCrew.
  ///
  /// In pt, this message translates to:
  /// **'BORA JUNTOS!'**
  String get matchTitleCrew;

  /// No description provided for @matchSubtitleDate.
  ///
  /// In pt, this message translates to:
  /// **'Você e {name} se curtiram.'**
  String matchSubtitleDate(String name);

  /// No description provided for @matchSubtitleCrew.
  ///
  /// In pt, this message translates to:
  /// **'Você e {name} querem colar juntos no rolê.'**
  String matchSubtitleCrew(String name);

  /// No description provided for @matchSendMessage.
  ///
  /// In pt, this message translates to:
  /// **'Mandar mensagem'**
  String get matchSendMessage;

  /// No description provided for @matchContinue.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get matchContinue;

  /// No description provided for @chatsTabGroups.
  ///
  /// In pt, this message translates to:
  /// **'Grupos'**
  String get chatsTabGroups;

  /// No description provided for @chatsNewMatches.
  ///
  /// In pt, this message translates to:
  /// **'Novos matches'**
  String get chatsNewMatches;

  /// No description provided for @chatsEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma conversa ainda'**
  String get chatsEmptyTitle;

  /// No description provided for @chatsEmptyBody.
  ///
  /// In pt, this message translates to:
  /// **'Quando der match, a conversa aparece aqui.'**
  String get chatsEmptyBody;

  /// No description provided for @chatsGoDiscover.
  ///
  /// In pt, this message translates to:
  /// **'Ir para Descobrir'**
  String get chatsGoDiscover;

  /// No description provided for @chatsGroupsEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Suas crews aparecem aqui'**
  String get chatsGroupsEmptyTitle;

  /// No description provided for @chatsGroupsEmptyBody.
  ///
  /// In pt, this message translates to:
  /// **'Crie ou entre numa crew pela tela de um evento.'**
  String get chatsGroupsEmptyBody;

  /// No description provided for @chatsYouPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Você: {message}'**
  String chatsYouPrefix(String message);

  /// No description provided for @chatsSayHi.
  ///
  /// In pt, this message translates to:
  /// **'Diga oi 👋'**
  String get chatsSayHi;

  /// No description provided for @unreadCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} não lidas'**
  String unreadCount(int count);

  /// No description provided for @chatTyping.
  ///
  /// In pt, this message translates to:
  /// **'digitando…'**
  String get chatTyping;

  /// No description provided for @chatInputHint.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get chatInputHint;

  /// No description provided for @chatSend.
  ///
  /// In pt, this message translates to:
  /// **'Enviar'**
  String get chatSend;

  /// No description provided for @chatSending.
  ///
  /// In pt, this message translates to:
  /// **'Enviando'**
  String get chatSending;

  /// No description provided for @chatSent.
  ///
  /// In pt, this message translates to:
  /// **'Enviada'**
  String get chatSent;

  /// No description provided for @chatRead.
  ///
  /// In pt, this message translates to:
  /// **'Lida'**
  String get chatRead;

  /// No description provided for @chatFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não enviada. Toque para tentar de novo.'**
  String get chatFailed;

  /// No description provided for @chatDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem apagada'**
  String get chatDeleted;

  /// No description provided for @chatDeleteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Apagar mensagem'**
  String get chatDeleteMessage;

  /// No description provided for @chatDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Apagar esta mensagem?'**
  String get chatDeleteTitle;

  /// No description provided for @chatDeleteBody.
  ///
  /// In pt, this message translates to:
  /// **'Ela some para as duas pessoas.'**
  String get chatDeleteBody;

  /// No description provided for @chatToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get chatToday;

  /// No description provided for @chatYesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get chatYesterday;

  /// No description provided for @chatIcebreakersTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quebre o gelo'**
  String get chatIcebreakersTitle;

  /// No description provided for @icebreakerMeet.
  ///
  /// In pt, this message translates to:
  /// **'Bora se encontrar na {event}?'**
  String icebreakerMeet(String event);

  /// No description provided for @icebreakerLineup.
  ///
  /// In pt, this message translates to:
  /// **'Quem do line-up da {event} você não perde?'**
  String icebreakerLineup(String event);

  /// No description provided for @icebreakerFirstTime.
  ///
  /// In pt, this message translates to:
  /// **'Primeira vez na {event}?'**
  String icebreakerFirstTime(String event);

  /// No description provided for @icebreakerGenericParty.
  ///
  /// In pt, this message translates to:
  /// **'Qual foi a última festa que te marcou?'**
  String get icebreakerGenericParty;

  /// No description provided for @icebreakerGenericDj.
  ///
  /// In pt, this message translates to:
  /// **'Qual DJ você mais quer ver ao vivo?'**
  String get icebreakerGenericDj;

  /// No description provided for @chatMenuProfile.
  ///
  /// In pt, this message translates to:
  /// **'Ver perfil'**
  String get chatMenuProfile;

  /// No description provided for @chatMenuUnmatch.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer match'**
  String get chatMenuUnmatch;

  /// No description provided for @chatMenuBlock.
  ///
  /// In pt, this message translates to:
  /// **'Bloquear'**
  String get chatMenuBlock;

  /// No description provided for @chatMenuReport.
  ///
  /// In pt, this message translates to:
  /// **'Denunciar'**
  String get chatMenuReport;

  /// No description provided for @chatUnmatchTitle.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer o match com {name}?'**
  String chatUnmatchTitle(String name);

  /// No description provided for @chatUnmatchBody.
  ///
  /// In pt, this message translates to:
  /// **'A conversa some para vocês dois e não dá para desfazer.'**
  String get chatUnmatchBody;

  /// No description provided for @chatUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Esta conversa não está mais disponível.'**
  String get chatUnavailable;

  /// No description provided for @crewTitle.
  ///
  /// In pt, this message translates to:
  /// **'Crew'**
  String get crewTitle;

  /// No description provided for @crewsSectionEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Ninguém montou uma crew para esse evento ainda.'**
  String get crewsSectionEmpty;

  /// No description provided for @crewsSectionNotGoing.
  ///
  /// In pt, this message translates to:
  /// **'Marque \"Eu vou\" para ver e montar crews deste evento.'**
  String get crewsSectionNotGoing;

  /// No description provided for @crewCreate.
  ///
  /// In pt, this message translates to:
  /// **'Montar crew'**
  String get crewCreate;

  /// No description provided for @crewFormTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova crew'**
  String get crewFormTitle;

  /// No description provided for @crewFormEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar crew'**
  String get crewFormEditTitle;

  /// No description provided for @crewFormFor.
  ///
  /// In pt, this message translates to:
  /// **'Para: {event}'**
  String crewFormFor(String event);

  /// No description provided for @crewFormInviteNote.
  ///
  /// In pt, this message translates to:
  /// **'{name} vai receber o convite assim que a crew for criada.'**
  String crewFormInviteNote(String name);

  /// No description provided for @crewName.
  ///
  /// In pt, this message translates to:
  /// **'Nome da crew'**
  String get crewName;

  /// No description provided for @crewNameDefault.
  ///
  /// In pt, this message translates to:
  /// **'Crew de {name}'**
  String crewNameDefault(String name);

  /// No description provided for @crewDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descrição (opcional)'**
  String get crewDescription;

  /// No description provided for @crewDescriptionHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Vamos juntos de metrô, encontro às 22h na entrada.'**
  String get crewDescriptionHint;

  /// No description provided for @crewOpen.
  ///
  /// In pt, this message translates to:
  /// **'Aberta'**
  String get crewOpen;

  /// No description provided for @crewOpenHint.
  ///
  /// In pt, this message translates to:
  /// **'Quem vai ao evento pode pedir para entrar. Desligada, só por convite.'**
  String get crewOpenHint;

  /// No description provided for @crewInviteOnly.
  ///
  /// In pt, this message translates to:
  /// **'Só convite'**
  String get crewInviteOnly;

  /// No description provided for @crewSameGenderOnly.
  ///
  /// In pt, this message translates to:
  /// **'Só pessoas do meu gênero'**
  String get crewSameGenderOnly;

  /// No description provided for @crewSameGenderLabel.
  ///
  /// In pt, this message translates to:
  /// **'Mesmo gênero'**
  String get crewSameGenderLabel;

  /// No description provided for @crewMembersCount.
  ///
  /// In pt, this message translates to:
  /// **'{count}/{max} pessoas'**
  String crewMembersCount(int count, int max);

  /// No description provided for @crewFull.
  ///
  /// In pt, this message translates to:
  /// **'Lotada'**
  String get crewFull;

  /// No description provided for @crewByOwner.
  ///
  /// In pt, this message translates to:
  /// **'de {name}'**
  String crewByOwner(String name);

  /// No description provided for @crewAskToJoin.
  ///
  /// In pt, this message translates to:
  /// **'Pedir pra entrar'**
  String get crewAskToJoin;

  /// No description provided for @crewRequested.
  ///
  /// In pt, this message translates to:
  /// **'Pedido enviado'**
  String get crewRequested;

  /// No description provided for @crewCancelRequest.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar pedido'**
  String get crewCancelRequest;

  /// No description provided for @crewHasInvite.
  ///
  /// In pt, this message translates to:
  /// **'Você tem um convite para esta crew'**
  String get crewHasInvite;

  /// No description provided for @crewAcceptInvite.
  ///
  /// In pt, this message translates to:
  /// **'Aceitar convite'**
  String get crewAcceptInvite;

  /// No description provided for @crewDeclineInvite.
  ///
  /// In pt, this message translates to:
  /// **'Recusar'**
  String get crewDeclineInvite;

  /// No description provided for @crewOpenChat.
  ///
  /// In pt, this message translates to:
  /// **'Abrir chat do grupo'**
  String get crewOpenChat;

  /// No description provided for @crewMembers.
  ///
  /// In pt, this message translates to:
  /// **'Membros'**
  String get crewMembers;

  /// No description provided for @crewOwner.
  ///
  /// In pt, this message translates to:
  /// **'Dono(a)'**
  String get crewOwner;

  /// No description provided for @crewPendingRequests.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos para entrar'**
  String get crewPendingRequests;

  /// No description provided for @crewPendingInvites.
  ///
  /// In pt, this message translates to:
  /// **'Convites enviados'**
  String get crewPendingInvites;

  /// No description provided for @crewInvite.
  ///
  /// In pt, this message translates to:
  /// **'Convidar'**
  String get crewInvite;

  /// No description provided for @crewInviteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Convidar para a crew'**
  String get crewInviteTitle;

  /// No description provided for @crewInviteEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Aqui aparecem as pessoas que deram match com você no Crew e vão a esse evento.'**
  String get crewInviteEmpty;

  /// No description provided for @crewInviteSent.
  ///
  /// In pt, this message translates to:
  /// **'Convite enviado!'**
  String get crewInviteSent;

  /// No description provided for @crewCancelInvite.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar convite'**
  String get crewCancelInvite;

  /// No description provided for @crewRemoveMember.
  ///
  /// In pt, this message translates to:
  /// **'Remover da crew'**
  String get crewRemoveMember;

  /// No description provided for @crewMakeOwner.
  ///
  /// In pt, this message translates to:
  /// **'Passar a posse'**
  String get crewMakeOwner;

  /// No description provided for @crewLeave.
  ///
  /// In pt, this message translates to:
  /// **'Sair da crew'**
  String get crewLeave;

  /// No description provided for @crewLeaveTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sair de {name}?'**
  String crewLeaveTitle(String name);

  /// No description provided for @crewLeaveBody.
  ///
  /// In pt, this message translates to:
  /// **'Você sai do grupo e do chat.'**
  String get crewLeaveBody;

  /// No description provided for @crewOwnerLeaveHint.
  ///
  /// In pt, this message translates to:
  /// **'Para sair, passe a posse para outra pessoa ou apague a crew.'**
  String get crewOwnerLeaveHint;

  /// No description provided for @crewDelete.
  ///
  /// In pt, this message translates to:
  /// **'Apagar crew'**
  String get crewDelete;

  /// No description provided for @crewDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Apagar {name}?'**
  String crewDeleteTitle(String name);

  /// No description provided for @crewDeleteBody.
  ///
  /// In pt, this message translates to:
  /// **'O grupo e o chat somem para todo mundo.'**
  String get crewDeleteBody;

  /// No description provided for @crewTransferTitle.
  ///
  /// In pt, this message translates to:
  /// **'Passar a posse para {name}?'**
  String crewTransferTitle(String name);

  /// No description provided for @crewRemoveTitle.
  ///
  /// In pt, this message translates to:
  /// **'Remover {name} da crew?'**
  String crewRemoveTitle(String name);

  /// No description provided for @crewCreated.
  ///
  /// In pt, this message translates to:
  /// **'Crew criada!'**
  String get crewCreated;

  /// No description provided for @crewJoined.
  ///
  /// In pt, this message translates to:
  /// **'Você entrou na crew!'**
  String get crewJoined;

  /// No description provided for @crewNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Esta crew não existe mais.'**
  String get crewNotFound;

  /// No description provided for @crewInvitesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Convites de crew'**
  String get crewInvitesTitle;

  /// No description provided for @crewInviteFrom.
  ///
  /// In pt, this message translates to:
  /// **'{name} te convidou · {count}/8'**
  String crewInviteFrom(String name, int count);

  /// No description provided for @crewSolo.
  ///
  /// In pt, this message translates to:
  /// **'Vai sozinho(a)'**
  String get crewSolo;

  /// No description provided for @crewHasCrew.
  ///
  /// In pt, this message translates to:
  /// **'Já tem crew de {count}'**
  String crewHasCrew(int count);

  /// No description provided for @crewMembersShort.
  ///
  /// In pt, this message translates to:
  /// **'{count} pessoas'**
  String crewMembersShort(int count);

  /// No description provided for @typingNamed.
  ///
  /// In pt, this message translates to:
  /// **'{name} digitando…'**
  String typingNamed(String name);

  /// No description provided for @chatMenuViewCrew.
  ///
  /// In pt, this message translates to:
  /// **'Ver crew'**
  String get chatMenuViewCrew;

  /// No description provided for @matchBuildCrew.
  ///
  /// In pt, this message translates to:
  /// **'Montar crew para {event}'**
  String matchBuildCrew(String event);

  /// No description provided for @genderWoman.
  ///
  /// In pt, this message translates to:
  /// **'Mulher'**
  String get genderWoman;

  /// No description provided for @genderMan.
  ///
  /// In pt, this message translates to:
  /// **'Homem'**
  String get genderMan;

  /// No description provided for @genderNonBinary.
  ///
  /// In pt, this message translates to:
  /// **'Pessoa não binária'**
  String get genderNonBinary;

  /// No description provided for @genderOther.
  ///
  /// In pt, this message translates to:
  /// **'Outro'**
  String get genderOther;

  /// No description provided for @genderPreferNotSay.
  ///
  /// In pt, this message translates to:
  /// **'Prefiro não dizer'**
  String get genderPreferNotSay;

  /// No description provided for @orientationStraight.
  ///
  /// In pt, this message translates to:
  /// **'Hétero'**
  String get orientationStraight;

  /// No description provided for @orientationGay.
  ///
  /// In pt, this message translates to:
  /// **'Gay'**
  String get orientationGay;

  /// No description provided for @orientationLesbian.
  ///
  /// In pt, this message translates to:
  /// **'Lésbica'**
  String get orientationLesbian;

  /// No description provided for @orientationBisexual.
  ///
  /// In pt, this message translates to:
  /// **'Bissexual'**
  String get orientationBisexual;

  /// No description provided for @orientationPansexual.
  ///
  /// In pt, this message translates to:
  /// **'Pansexual'**
  String get orientationPansexual;

  /// No description provided for @orientationAsexual.
  ///
  /// In pt, this message translates to:
  /// **'Assexual'**
  String get orientationAsexual;

  /// No description provided for @orientationQueer.
  ///
  /// In pt, this message translates to:
  /// **'Queer'**
  String get orientationQueer;

  /// No description provided for @orientationQuestioning.
  ///
  /// In pt, this message translates to:
  /// **'Questionando'**
  String get orientationQuestioning;

  /// No description provided for @orientationOther.
  ///
  /// In pt, this message translates to:
  /// **'Outra'**
  String get orientationOther;

  /// No description provided for @intentCasual.
  ///
  /// In pt, this message translates to:
  /// **'Algo casual'**
  String get intentCasual;

  /// No description provided for @intentDating.
  ///
  /// In pt, this message translates to:
  /// **'Encontros'**
  String get intentDating;

  /// No description provided for @intentRelationship.
  ///
  /// In pt, this message translates to:
  /// **'Relacionamento'**
  String get intentRelationship;

  /// No description provided for @intentFiguringOut.
  ///
  /// In pt, this message translates to:
  /// **'Ainda descobrindo'**
  String get intentFiguringOut;

  /// No description provided for @habitNo.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get habitNo;

  /// No description provided for @habitSocially.
  ///
  /// In pt, this message translates to:
  /// **'Socialmente'**
  String get habitSocially;

  /// No description provided for @habitYes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get habitYes;

  /// No description provided for @zodiacAries.
  ///
  /// In pt, this message translates to:
  /// **'Áries'**
  String get zodiacAries;

  /// No description provided for @zodiacTaurus.
  ///
  /// In pt, this message translates to:
  /// **'Touro'**
  String get zodiacTaurus;

  /// No description provided for @zodiacGemini.
  ///
  /// In pt, this message translates to:
  /// **'Gêmeos'**
  String get zodiacGemini;

  /// No description provided for @zodiacCancer.
  ///
  /// In pt, this message translates to:
  /// **'Câncer'**
  String get zodiacCancer;

  /// No description provided for @zodiacLeo.
  ///
  /// In pt, this message translates to:
  /// **'Leão'**
  String get zodiacLeo;

  /// No description provided for @zodiacVirgo.
  ///
  /// In pt, this message translates to:
  /// **'Virgem'**
  String get zodiacVirgo;

  /// No description provided for @zodiacLibra.
  ///
  /// In pt, this message translates to:
  /// **'Libra'**
  String get zodiacLibra;

  /// No description provided for @zodiacScorpio.
  ///
  /// In pt, this message translates to:
  /// **'Escorpião'**
  String get zodiacScorpio;

  /// No description provided for @zodiacSagittarius.
  ///
  /// In pt, this message translates to:
  /// **'Sagitário'**
  String get zodiacSagittarius;

  /// No description provided for @zodiacCapricorn.
  ///
  /// In pt, this message translates to:
  /// **'Capricórnio'**
  String get zodiacCapricorn;

  /// No description provided for @zodiacAquarius.
  ///
  /// In pt, this message translates to:
  /// **'Aquário'**
  String get zodiacAquarius;

  /// No description provided for @zodiacPisces.
  ///
  /// In pt, this message translates to:
  /// **'Peixes'**
  String get zodiacPisces;

  /// No description provided for @genreTechno.
  ///
  /// In pt, this message translates to:
  /// **'Techno'**
  String get genreTechno;

  /// No description provided for @genreHouse.
  ///
  /// In pt, this message translates to:
  /// **'House'**
  String get genreHouse;

  /// No description provided for @genreTechHouse.
  ///
  /// In pt, this message translates to:
  /// **'Tech House'**
  String get genreTechHouse;

  /// No description provided for @genreMelodicTechno.
  ///
  /// In pt, this message translates to:
  /// **'Melodic Techno'**
  String get genreMelodicTechno;

  /// No description provided for @genrePsytrance.
  ///
  /// In pt, this message translates to:
  /// **'Psytrance'**
  String get genrePsytrance;

  /// No description provided for @genreTrance.
  ///
  /// In pt, this message translates to:
  /// **'Trance'**
  String get genreTrance;

  /// No description provided for @genreDrumAndBass.
  ///
  /// In pt, this message translates to:
  /// **'Drum & Bass'**
  String get genreDrumAndBass;

  /// No description provided for @genreDubstep.
  ///
  /// In pt, this message translates to:
  /// **'Dubstep'**
  String get genreDubstep;

  /// No description provided for @genreAfroHouse.
  ///
  /// In pt, this message translates to:
  /// **'Afro House'**
  String get genreAfroHouse;

  /// No description provided for @genreMinimal.
  ///
  /// In pt, this message translates to:
  /// **'Minimal'**
  String get genreMinimal;

  /// No description provided for @genreHardTechno.
  ///
  /// In pt, this message translates to:
  /// **'Hard Techno'**
  String get genreHardTechno;

  /// No description provided for @genreDiscoNuDisco.
  ///
  /// In pt, this message translates to:
  /// **'Disco / Nu-Disco'**
  String get genreDiscoNuDisco;

  /// No description provided for @genreEdm.
  ///
  /// In pt, this message translates to:
  /// **'EDM'**
  String get genreEdm;

  /// No description provided for @genreOther.
  ///
  /// In pt, this message translates to:
  /// **'Outros'**
  String get genreOther;

  /// No description provided for @petDog.
  ///
  /// In pt, this message translates to:
  /// **'Cachorro'**
  String get petDog;

  /// No description provided for @petCat.
  ///
  /// In pt, this message translates to:
  /// **'Gato'**
  String get petCat;

  /// No description provided for @petOther.
  ///
  /// In pt, this message translates to:
  /// **'Outros pets'**
  String get petOther;

  /// No description provided for @petNone.
  ///
  /// In pt, this message translates to:
  /// **'Não tenho'**
  String get petNone;

  /// No description provided for @petWant.
  ///
  /// In pt, this message translates to:
  /// **'Quero ter'**
  String get petWant;

  /// No description provided for @languagePt.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get languagePt;

  /// No description provided for @languageEn.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get languageEn;

  /// No description provided for @languageEs.
  ///
  /// In pt, this message translates to:
  /// **'Espanhol'**
  String get languageEs;

  /// No description provided for @languageFr.
  ///
  /// In pt, this message translates to:
  /// **'Francês'**
  String get languageFr;

  /// No description provided for @languageIt.
  ///
  /// In pt, this message translates to:
  /// **'Italiano'**
  String get languageIt;

  /// No description provided for @languageDe.
  ///
  /// In pt, this message translates to:
  /// **'Alemão'**
  String get languageDe;

  /// No description provided for @languageJa.
  ///
  /// In pt, this message translates to:
  /// **'Japonês'**
  String get languageJa;

  /// No description provided for @languageZh.
  ///
  /// In pt, this message translates to:
  /// **'Chinês'**
  String get languageZh;

  /// No description provided for @languageKo.
  ///
  /// In pt, this message translates to:
  /// **'Coreano'**
  String get languageKo;

  /// No description provided for @languageRu.
  ///
  /// In pt, this message translates to:
  /// **'Russo'**
  String get languageRu;

  /// No description provided for @languageAr.
  ///
  /// In pt, this message translates to:
  /// **'Árabe'**
  String get languageAr;

  /// No description provided for @languageHe.
  ///
  /// In pt, this message translates to:
  /// **'Hebraico'**
  String get languageHe;

  /// No description provided for @languageNl.
  ///
  /// In pt, this message translates to:
  /// **'Holandês'**
  String get languageNl;

  /// No description provided for @languageLibras.
  ///
  /// In pt, this message translates to:
  /// **'Libras'**
  String get languageLibras;

  /// No description provided for @errorMinPhotos.
  ///
  /// In pt, this message translates to:
  /// **'Seu perfil precisa de pelo menos 2 fotos.'**
  String get errorMinPhotos;

  /// No description provided for @errorNetwork.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão. Verifique sua internet e tente de novo.'**
  String get errorNetwork;

  /// No description provided for @errorSessionExpired.
  ///
  /// In pt, this message translates to:
  /// **'Sua sessão expirou. Entre novamente.'**
  String get errorSessionExpired;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In pt, this message translates to:
  /// **'Você não tem permissão para fazer isso.'**
  String get errorPermissionDenied;

  /// No description provided for @errorNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Não encontramos o que você procurou.'**
  String get errorNotFound;

  /// No description provided for @errorRateLimited.
  ///
  /// In pt, this message translates to:
  /// **'Calma! Você está indo rápido demais. Tente de novo em instantes.'**
  String get errorRateLimited;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In pt, this message translates to:
  /// **'E-mail ou senha incorretos.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In pt, this message translates to:
  /// **'Confirme seu e-mail pelo link que enviamos antes de entrar.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorEmailInUse.
  ///
  /// In pt, this message translates to:
  /// **'Já existe uma conta com esse e-mail.'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In pt, this message translates to:
  /// **'Essa senha é fraca. Use pelo menos 8 caracteres, com letras e números.'**
  String get errorWeakPassword;

  /// No description provided for @errorSamePassword.
  ///
  /// In pt, this message translates to:
  /// **'A nova senha precisa ser diferente da atual.'**
  String get errorSamePassword;

  /// No description provided for @errorPhoneInUse.
  ///
  /// In pt, this message translates to:
  /// **'Esse celular já está vinculado a outra conta.'**
  String get errorPhoneInUse;

  /// No description provided for @errorUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Algo deu errado. Tente novamente.'**
  String get errorUnknown;

  /// No description provided for @errorWrongPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha incorreta.'**
  String get errorWrongPassword;

  /// No description provided for @blockTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bloquear {name}?'**
  String blockTitle(String name);

  /// No description provided for @blockBody.
  ///
  /// In pt, this message translates to:
  /// **'Vocês deixam de se ver em todo o app: feed, eventos, crews e conversas. A pessoa não é avisada.'**
  String get blockBody;

  /// No description provided for @blockAction.
  ///
  /// In pt, this message translates to:
  /// **'Bloquear'**
  String get blockAction;

  /// No description provided for @blockDone.
  ///
  /// In pt, this message translates to:
  /// **'{name} foi bloqueado(a).'**
  String blockDone(String name);

  /// No description provided for @safetyMenuTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Opções de segurança'**
  String get safetyMenuTooltip;

  /// No description provided for @reportUserTitle.
  ///
  /// In pt, this message translates to:
  /// **'Denunciar {name}'**
  String reportUserTitle(String name);

  /// No description provided for @reportMessageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Denunciar mensagem'**
  String get reportMessageTitle;

  /// No description provided for @reportEventTitle.
  ///
  /// In pt, this message translates to:
  /// **'Denunciar evento'**
  String get reportEventTitle;

  /// No description provided for @reportIntro.
  ///
  /// In pt, this message translates to:
  /// **'Conte o que aconteceu. A pessoa não fica sabendo quem denunciou.'**
  String get reportIntro;

  /// No description provided for @reportReasonLabel.
  ///
  /// In pt, this message translates to:
  /// **'Motivo'**
  String get reportReasonLabel;

  /// No description provided for @reportDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes (opcional)'**
  String get reportDetails;

  /// No description provided for @reportDetailsHint.
  ///
  /// In pt, this message translates to:
  /// **'O que aconteceu, quando, onde…'**
  String get reportDetailsHint;

  /// No description provided for @reportAlsoBlock.
  ///
  /// In pt, this message translates to:
  /// **'Também bloquear {name}'**
  String reportAlsoBlock(String name);

  /// No description provided for @reportSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Enviar denúncia'**
  String get reportSubmit;

  /// No description provided for @reportSent.
  ///
  /// In pt, this message translates to:
  /// **'Denúncia enviada. Obrigado por ajudar a manter a pista segura.'**
  String get reportSent;

  /// No description provided for @reportEventAction.
  ///
  /// In pt, this message translates to:
  /// **'Denunciar evento'**
  String get reportEventAction;

  /// No description provided for @reportReasonHarassment.
  ///
  /// In pt, this message translates to:
  /// **'Assédio ou ameaça'**
  String get reportReasonHarassment;

  /// No description provided for @reportReasonInappropriateContent.
  ///
  /// In pt, this message translates to:
  /// **'Conteúdo impróprio'**
  String get reportReasonInappropriateContent;

  /// No description provided for @reportReasonFakeProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil falso'**
  String get reportReasonFakeProfile;

  /// No description provided for @reportReasonFakeEvent.
  ///
  /// In pt, this message translates to:
  /// **'Evento falso ou duplicado'**
  String get reportReasonFakeEvent;

  /// No description provided for @reportReasonScam.
  ///
  /// In pt, this message translates to:
  /// **'Golpe ou venda'**
  String get reportReasonScam;

  /// No description provided for @reportReasonScamEvent.
  ///
  /// In pt, this message translates to:
  /// **'Golpe ou ingresso falso'**
  String get reportReasonScamEvent;

  /// No description provided for @reportReasonSpam.
  ///
  /// In pt, this message translates to:
  /// **'Spam'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonUnderage.
  ///
  /// In pt, this message translates to:
  /// **'Menor de idade'**
  String get reportReasonUnderage;

  /// No description provided for @reportReasonSafetyConcern.
  ///
  /// In pt, this message translates to:
  /// **'Risco à segurança de alguém'**
  String get reportReasonSafetyConcern;

  /// No description provided for @reportReasonOther.
  ///
  /// In pt, this message translates to:
  /// **'Outro motivo'**
  String get reportReasonOther;

  /// No description provided for @settingsAccountSection.
  ///
  /// In pt, this message translates to:
  /// **'Conta'**
  String get settingsAccountSection;

  /// No description provided for @settingsSafetySection.
  ///
  /// In pt, this message translates to:
  /// **'Segurança'**
  String get settingsSafetySection;

  /// No description provided for @settingsSessionSection.
  ///
  /// In pt, this message translates to:
  /// **'Sessão'**
  String get settingsSessionSection;

  /// No description provided for @settingsDangerSection.
  ///
  /// In pt, this message translates to:
  /// **'Zona de perigo'**
  String get settingsDangerSection;

  /// No description provided for @blockedUsersTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueados'**
  String get blockedUsersTitle;

  /// No description provided for @blockedUsersEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Você não bloqueou ninguém.'**
  String get blockedUsersEmpty;

  /// No description provided for @blockedUsersHint.
  ///
  /// In pt, this message translates to:
  /// **'Ao desbloquear, a pessoa volta a aparecer para você, mas matches e conversas antigas não voltam.'**
  String get blockedUsersHint;

  /// No description provided for @unblockAction.
  ///
  /// In pt, this message translates to:
  /// **'Desbloquear'**
  String get unblockAction;

  /// No description provided for @unblockTitle.
  ///
  /// In pt, this message translates to:
  /// **'Desbloquear {name}?'**
  String unblockTitle(String name);

  /// No description provided for @safetyTipsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dicas de segurança'**
  String get safetyTipsTitle;

  /// No description provided for @safetyTipsEntry.
  ///
  /// In pt, this message translates to:
  /// **'Dicas de segurança na festa'**
  String get safetyTipsEntry;

  /// No description provided for @safetyTipsIntro.
  ///
  /// In pt, this message translates to:
  /// **'A noite é pra curtir. Algumas combinações ajudam a voltar bem pra casa.'**
  String get safetyTipsIntro;

  /// No description provided for @safetyTipPublicTitle.
  ///
  /// In pt, this message translates to:
  /// **'Encontre em público'**
  String get safetyTipPublicTitle;

  /// No description provided for @safetyTipPublicBody.
  ///
  /// In pt, this message translates to:
  /// **'Combine o primeiro encontro num lugar movimentado, de preferência no próprio evento.'**
  String get safetyTipPublicBody;

  /// No description provided for @safetyTipFriendTitle.
  ///
  /// In pt, this message translates to:
  /// **'Avise alguém'**
  String get safetyTipFriendTitle;

  /// No description provided for @safetyTipFriendBody.
  ///
  /// In pt, this message translates to:
  /// **'Conte a um amigo com quem você vai sair e compartilhe sua localização em tempo real.'**
  String get safetyTipFriendBody;

  /// No description provided for @safetyTipDrinkTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cuide do seu copo'**
  String get safetyTipDrinkTitle;

  /// No description provided for @safetyTipDrinkBody.
  ///
  /// In pt, this message translates to:
  /// **'Não aceite bebida de desconhecidos e não deixe seu copo sozinho. Se algo parecer estranho, peça ajuda.'**
  String get safetyTipDrinkBody;

  /// No description provided for @safetyTipLimitsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Hidrate-se e respeite seus limites'**
  String get safetyTipLimitsTitle;

  /// No description provided for @safetyTipLimitsBody.
  ///
  /// In pt, this message translates to:
  /// **'Beba água, faça pausas e, se passar mal ou vir alguém passando mal, procure a equipe médica do evento.'**
  String get safetyTipLimitsBody;

  /// No description provided for @safetyTipConsentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Consentimento sempre'**
  String get safetyTipConsentTitle;

  /// No description provided for @safetyTipConsentBody.
  ///
  /// In pt, this message translates to:
  /// **'Não é não. Se algo te deixar desconfortável, saia da situação e chame a segurança do evento.'**
  String get safetyTipConsentBody;

  /// No description provided for @safetyTipRideTitle.
  ///
  /// In pt, this message translates to:
  /// **'Planeje a volta'**
  String get safetyTipRideTitle;

  /// No description provided for @safetyTipRideBody.
  ///
  /// In pt, this message translates to:
  /// **'Defina como vai voltar antes de sair e use transporte confiável.'**
  String get safetyTipRideBody;

  /// No description provided for @safetyTipDataTitle.
  ///
  /// In pt, this message translates to:
  /// **'Proteja seus dados'**
  String get safetyTipDataTitle;

  /// No description provided for @safetyTipDataBody.
  ///
  /// In pt, this message translates to:
  /// **'Não passe endereço, documentos ou dados bancários. O Pulse nunca pede sua senha por mensagem.'**
  String get safetyTipDataBody;

  /// No description provided for @safetyTipReportTitle.
  ///
  /// In pt, this message translates to:
  /// **'Denuncie e bloqueie'**
  String get safetyTipReportTitle;

  /// No description provided for @safetyTipReportBody.
  ///
  /// In pt, this message translates to:
  /// **'Use Denunciar e Bloquear em qualquer perfil, mensagem ou evento. Nossa equipe analisa cada denúncia.'**
  String get safetyTipReportBody;

  /// No description provided for @safetyEmergency.
  ///
  /// In pt, this message translates to:
  /// **'Em emergência'**
  String get safetyEmergency;

  /// No description provided for @safetyCallPolice.
  ///
  /// In pt, this message translates to:
  /// **'Polícia · 190'**
  String get safetyCallPolice;

  /// No description provided for @safetyCallAmbulance.
  ///
  /// In pt, this message translates to:
  /// **'SAMU · 192'**
  String get safetyCallAmbulance;

  /// No description provided for @matchSafetyTips.
  ///
  /// In pt, this message translates to:
  /// **'Antes de se encontrar, veja as dicas de segurança'**
  String get matchSafetyTips;

  /// No description provided for @deleteAccountEntry.
  ///
  /// In pt, this message translates to:
  /// **'Excluir conta'**
  String get deleteAccountEntry;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir conta'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In pt, this message translates to:
  /// **'Isso apaga para sempre seu perfil, fotos, matches, conversas e crews. Não dá para desfazer.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountCrewsNote.
  ///
  /// In pt, this message translates to:
  /// **'Crews que você criou passam para o membro mais antigo.'**
  String get deleteAccountCrewsNote;

  /// No description provided for @deleteAccountPassword.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua senha para confirmar'**
  String get deleteAccountPassword;

  /// No description provided for @deleteAccountButton.
  ///
  /// In pt, this message translates to:
  /// **'Excluir minha conta'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir sua conta agora?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmBody.
  ///
  /// In pt, this message translates to:
  /// **'Sua conta e seus dados serão apagados na hora.'**
  String get deleteAccountConfirmBody;

  /// No description provided for @deleteAccountDone.
  ///
  /// In pt, this message translates to:
  /// **'Sua conta foi excluída.'**
  String get deleteAccountDone;

  /// No description provided for @restrictedSuspendedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conta suspensa'**
  String get restrictedSuspendedTitle;

  /// No description provided for @restrictedBannedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conta banida'**
  String get restrictedBannedTitle;

  /// No description provided for @restrictedSuspendedBody.
  ///
  /// In pt, this message translates to:
  /// **'Durante a suspensão você não aparece para ninguém e não pode curtir, conversar ou criar eventos.'**
  String get restrictedSuspendedBody;

  /// No description provided for @restrictedBannedBody.
  ///
  /// In pt, this message translates to:
  /// **'Sua conta foi encerrada por violar as regras da comunidade.'**
  String get restrictedBannedBody;

  /// No description provided for @restrictedUntil.
  ///
  /// In pt, this message translates to:
  /// **'Até {date}'**
  String restrictedUntil(String date);

  /// No description provided for @restrictedReason.
  ///
  /// In pt, this message translates to:
  /// **'Motivo: {reason}'**
  String restrictedReason(String reason);

  /// No description provided for @restrictedCheckAgain.
  ///
  /// In pt, this message translates to:
  /// **'Verificar de novo'**
  String get restrictedCheckAgain;

  /// No description provided for @warningNoticeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Aviso da moderação'**
  String get warningNoticeTitle;

  /// No description provided for @warningNoticeBody.
  ///
  /// In pt, this message translates to:
  /// **'Recebemos denúncias sobre a sua conta: {reason}\n\nSe acontecer de novo, a conta pode ser suspensa.'**
  String warningNoticeBody(String reason);

  /// No description provided for @warningNoticeOk.
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get warningNoticeOk;

  /// No description provided for @adminReports.
  ///
  /// In pt, this message translates to:
  /// **'Denúncias'**
  String get adminReports;

  /// No description provided for @adminReportsEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma denúncia pendente.'**
  String get adminReportsEmpty;

  /// No description provided for @adminRestrictedUsers.
  ///
  /// In pt, this message translates to:
  /// **'Contas suspensas e banidas'**
  String get adminRestrictedUsers;

  /// No description provided for @adminRestrictedEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma conta restrita.'**
  String get adminRestrictedEmpty;

  /// No description provided for @adminReportBy.
  ///
  /// In pt, this message translates to:
  /// **'Denunciado por {name}'**
  String adminReportBy(String name);

  /// No description provided for @adminReportTargetUser.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get adminReportTargetUser;

  /// No description provided for @adminReportTargetMessage.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get adminReportTargetMessage;

  /// No description provided for @adminReportTargetEvent.
  ///
  /// In pt, this message translates to:
  /// **'Evento'**
  String get adminReportTargetEvent;

  /// No description provided for @adminReportedUser.
  ///
  /// In pt, this message translates to:
  /// **'Conta denunciada: {name}'**
  String adminReportedUser(String name);

  /// No description provided for @adminReportedGone.
  ///
  /// In pt, this message translates to:
  /// **'A conta denunciada não existe mais.'**
  String get adminReportedGone;

  /// No description provided for @adminReportHistory.
  ///
  /// In pt, this message translates to:
  /// **'{reports, plural, =1{1 denúncia} other{{reports} denúncias}} · {actions, plural, =0{nenhuma punição} =1{1 punição} other{{actions} punições}}'**
  String adminReportHistory(int reports, int actions);

  /// No description provided for @adminReportDetails.
  ///
  /// In pt, this message translates to:
  /// **'Relato: {details}'**
  String adminReportDetails(String details);

  /// No description provided for @adminDecision.
  ///
  /// In pt, this message translates to:
  /// **'Decisão'**
  String get adminDecision;

  /// No description provided for @adminOutcomeDismiss.
  ///
  /// In pt, this message translates to:
  /// **'Arquivar'**
  String get adminOutcomeDismiss;

  /// No description provided for @adminOutcomeResolve.
  ///
  /// In pt, this message translates to:
  /// **'Só resolver'**
  String get adminOutcomeResolve;

  /// No description provided for @adminOutcomeWarning.
  ///
  /// In pt, this message translates to:
  /// **'Advertir'**
  String get adminOutcomeWarning;

  /// No description provided for @adminOutcomeSuspension.
  ///
  /// In pt, this message translates to:
  /// **'Suspender'**
  String get adminOutcomeSuspension;

  /// No description provided for @adminOutcomeBan.
  ///
  /// In pt, this message translates to:
  /// **'Banir'**
  String get adminOutcomeBan;

  /// No description provided for @adminNote.
  ///
  /// In pt, this message translates to:
  /// **'Motivo (a pessoa vai ver)'**
  String get adminNote;

  /// No description provided for @adminNoteInternal.
  ///
  /// In pt, this message translates to:
  /// **'Observação (opcional)'**
  String get adminNoteInternal;

  /// No description provided for @adminSuspensionDays.
  ///
  /// In pt, this message translates to:
  /// **'Dias de suspensão'**
  String get adminSuspensionDays;

  /// No description provided for @adminSuspensionDaysValue.
  ///
  /// In pt, this message translates to:
  /// **'{days, plural, =1{1 dia} other{{days} dias}}'**
  String adminSuspensionDaysValue(int days);

  /// No description provided for @adminRemoveMessage.
  ///
  /// In pt, this message translates to:
  /// **'Apagar a mensagem'**
  String get adminRemoveMessage;

  /// No description provided for @adminRemoveEvent.
  ///
  /// In pt, this message translates to:
  /// **'Tirar o evento do ar'**
  String get adminRemoveEvent;

  /// No description provided for @adminApply.
  ///
  /// In pt, this message translates to:
  /// **'Aplicar'**
  String get adminApply;

  /// No description provided for @adminReportHandled.
  ///
  /// In pt, this message translates to:
  /// **'Denúncia resolvida.'**
  String get adminReportHandled;

  /// No description provided for @adminReactivate.
  ///
  /// In pt, this message translates to:
  /// **'Reativar'**
  String get adminReactivate;

  /// No description provided for @adminReactivateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Reativar {name}?'**
  String adminReactivateTitle(String name);

  /// No description provided for @adminReactivateReason.
  ///
  /// In pt, this message translates to:
  /// **'Motivo da reativação'**
  String get adminReactivateReason;

  /// No description provided for @accountStatusSuspended.
  ///
  /// In pt, this message translates to:
  /// **'Suspensa'**
  String get accountStatusSuspended;

  /// No description provided for @accountStatusBanned.
  ///
  /// In pt, this message translates to:
  /// **'Banida'**
  String get accountStatusBanned;

  /// No description provided for @badgeTeam.
  ///
  /// In pt, this message translates to:
  /// **'Equipe Pulse'**
  String get badgeTeam;

  /// No description provided for @badgeDj.
  ///
  /// In pt, this message translates to:
  /// **'DJ'**
  String get badgeDj;

  /// No description provided for @badgePublicFigure.
  ///
  /// In pt, this message translates to:
  /// **'Figura pública'**
  String get badgePublicFigure;

  /// No description provided for @badgeProducer.
  ///
  /// In pt, this message translates to:
  /// **'Produtor'**
  String get badgeProducer;

  /// No description provided for @badgeSemantics.
  ///
  /// In pt, this message translates to:
  /// **'Selo: {label}'**
  String badgeSemantics(String label);

  /// No description provided for @badgeRequestEntry.
  ///
  /// In pt, this message translates to:
  /// **'Pedir selo de DJ ou figura pública'**
  String get badgeRequestEntry;

  /// No description provided for @badgeRequestTitle.
  ///
  /// In pt, this message translates to:
  /// **'Selos'**
  String get badgeRequestTitle;

  /// No description provided for @badgeRequestIntro.
  ///
  /// In pt, this message translates to:
  /// **'Selos mostram para todo mundo quem você é na cena. A equipe confere cada pedido.'**
  String get badgeRequestIntro;

  /// No description provided for @badgeYours.
  ///
  /// In pt, this message translates to:
  /// **'Seus selos'**
  String get badgeYours;

  /// No description provided for @badgeRequestPending.
  ///
  /// In pt, this message translates to:
  /// **'Seu pedido do selo {badge} está em análise.'**
  String badgeRequestPending(String badge);

  /// No description provided for @badgeNothingToRequest.
  ///
  /// In pt, this message translates to:
  /// **'Você já tem ou já pediu todos os selos disponíveis.'**
  String get badgeNothingToRequest;

  /// No description provided for @badgeJustification.
  ///
  /// In pt, this message translates to:
  /// **'Conte quem você é'**
  String get badgeJustification;

  /// No description provided for @badgeJustificationHint.
  ///
  /// In pt, this message translates to:
  /// **'Onde toca, há quanto tempo, por que é conhecido(a)…'**
  String get badgeJustificationHint;

  /// No description provided for @badgeLinksHint.
  ///
  /// In pt, this message translates to:
  /// **'Instagram, SoundCloud, Resident Advisor… (um por linha)'**
  String get badgeLinksHint;

  /// No description provided for @badgeRequestSent.
  ///
  /// In pt, this message translates to:
  /// **'Pedido enviado! Você será avisado(a) quando for analisado.'**
  String get badgeRequestSent;

  /// No description provided for @adminBadges.
  ///
  /// In pt, this message translates to:
  /// **'Selos'**
  String get adminBadges;

  /// No description provided for @adminBadgeRequests.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos de selo'**
  String get adminBadgeRequests;

  /// No description provided for @adminNoBadgeRequests.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum pedido de selo.'**
  String get adminNoBadgeRequests;

  /// No description provided for @adminGiveBadge.
  ///
  /// In pt, this message translates to:
  /// **'Dar selo'**
  String get adminGiveBadge;

  /// No description provided for @adminSearchPeople.
  ///
  /// In pt, this message translates to:
  /// **'Buscar pessoa pelo nome'**
  String get adminSearchPeople;

  /// No description provided for @adminBadgesOf.
  ///
  /// In pt, this message translates to:
  /// **'Selos de {name}'**
  String adminBadgesOf(String name);

  /// No description provided for @adminProducerFromRole.
  ///
  /// In pt, this message translates to:
  /// **'Produtor vem do papel e não é editado aqui.'**
  String get adminProducerFromRole;

  /// No description provided for @adminBadgeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título (opcional)'**
  String get adminBadgeTitle;

  /// No description provided for @adminBadgeTitleHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Residente D-Edge'**
  String get adminBadgeTitleHint;

  /// No description provided for @adminBadgeTitleTeamHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: CEO, Moderação'**
  String get adminBadgeTitleTeamHint;

  /// No description provided for @adminManageBadges.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar selos'**
  String get adminManageBadges;

  /// No description provided for @legalTerms.
  ///
  /// In pt, this message translates to:
  /// **'Termos de Uso'**
  String get legalTerms;

  /// No description provided for @legalPrivacy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get legalPrivacy;

  /// No description provided for @legalGuidelines.
  ///
  /// In pt, this message translates to:
  /// **'Diretrizes da Comunidade'**
  String get legalGuidelines;

  /// No description provided for @legalDeleteAccount.
  ///
  /// In pt, this message translates to:
  /// **'Excluir conta'**
  String get legalDeleteAccount;

  /// No description provided for @legalRead.
  ///
  /// In pt, this message translates to:
  /// **'Ler'**
  String get legalRead;

  /// No description provided for @settingsPrivacySection.
  ///
  /// In pt, this message translates to:
  /// **'Privacidade e termos'**
  String get settingsPrivacySection;

  /// No description provided for @exportDataEntry.
  ///
  /// In pt, this message translates to:
  /// **'Baixar meus dados'**
  String get exportDataEntry;

  /// No description provided for @exportDataHint.
  ///
  /// In pt, this message translates to:
  /// **'Um arquivo com tudo o que o Pulse guarda sobre você.'**
  String get exportDataHint;

  /// No description provided for @orientationConsent.
  ///
  /// In pt, this message translates to:
  /// **'Autorizo o Pulse a usar minha orientação sexual (dado sensível) para mostrar perfis compatíveis. Posso remover quando quiser.'**
  String get orientationConsent;

  /// No description provided for @orientationConsentRequired.
  ///
  /// In pt, this message translates to:
  /// **'Para salvar a orientação, marque a autorização ou deixe sem informar.'**
  String get orientationConsentRequired;

  /// No description provided for @errorLikeLimit.
  ///
  /// In pt, this message translates to:
  /// **'Seus likes de hoje acabaram. Amanhã tem mais, ou assine para curtir sem limite.'**
  String get errorLikeLimit;

  /// No description provided for @errorSuperlikeLimit.
  ///
  /// In pt, this message translates to:
  /// **'Seus superlikes acabaram.'**
  String get errorSuperlikeLimit;

  /// No description provided for @errorPlanRequired.
  ///
  /// In pt, this message translates to:
  /// **'Isso faz parte dos planos do Pulse.'**
  String get errorPlanRequired;

  /// No description provided for @errorBoostUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Você não tem boosts disponíveis.'**
  String get errorBoostUnavailable;

  /// No description provided for @errorBoostActive.
  ///
  /// In pt, this message translates to:
  /// **'Seu boost já está ativo.'**
  String get errorBoostActive;

  /// No description provided for @plansTitle.
  ///
  /// In pt, this message translates to:
  /// **'Planos'**
  String get plansTitle;

  /// No description provided for @plansPurchaseDone.
  ///
  /// In pt, this message translates to:
  /// **'Compra concluída. Aproveite!'**
  String get plansPurchaseDone;

  /// No description provided for @plansStoreUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'As compras ainda não estão disponíveis nesta versão do app.'**
  String get plansStoreUnavailable;

  /// No description provided for @plansSoon.
  ///
  /// In pt, this message translates to:
  /// **'Em breve'**
  String get plansSoon;

  /// No description provided for @plansSee.
  ///
  /// In pt, this message translates to:
  /// **'Ver planos'**
  String get plansSee;

  /// No description provided for @plansRestore.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar compras'**
  String get plansRestore;

  /// No description provided for @plansLegal.
  ///
  /// In pt, this message translates to:
  /// **'A assinatura é cobrada na sua conta da Google Play ou da App Store e renova sozinha todo mês, até você cancelar. Dá para cancelar a qualquer momento nas assinaturas da loja; o plano continua até o fim do período pago.'**
  String get plansLegal;

  /// No description provided for @plansPacksTitle.
  ///
  /// In pt, this message translates to:
  /// **'Avulsos'**
  String get plansPacksTitle;

  /// No description provided for @plansWallet.
  ///
  /// In pt, this message translates to:
  /// **'Seu saldo: {superlikes, plural, =1{1 superlike} other{{superlikes} superlikes}} e {boosts, plural, =1{1 boost} other{{boosts} boosts}}.'**
  String plansWallet(int superlikes, int boosts);

  /// No description provided for @packSuperlikes.
  ///
  /// In pt, this message translates to:
  /// **'{count} superlikes'**
  String packSuperlikes(int count);

  /// No description provided for @packBoosts.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 boost} other{{count} boosts}}'**
  String packBoosts(int count);

  /// No description provided for @planName.
  ///
  /// In pt, this message translates to:
  /// **'{tier, select, plus{Pulse+} black{Pulse Black} other{Pulse}}'**
  String planName(String tier);

  /// No description provided for @planFree.
  ///
  /// In pt, this message translates to:
  /// **'Grátis'**
  String get planFree;

  /// No description provided for @planYours.
  ///
  /// In pt, this message translates to:
  /// **'Você tem o {plan}'**
  String planYours(String plan);

  /// No description provided for @planGrantedByTeam.
  ///
  /// In pt, this message translates to:
  /// **'Liberado pela equipe Pulse'**
  String get planGrantedByTeam;

  /// No description provided for @planRenewsOn.
  ///
  /// In pt, this message translates to:
  /// **'Renova em {date}'**
  String planRenewsOn(String date);

  /// No description provided for @planEndsOn.
  ///
  /// In pt, this message translates to:
  /// **'Válido até {date}'**
  String planEndsOn(String date);

  /// No description provided for @planPricePer.
  ///
  /// In pt, this message translates to:
  /// **'{price}/{period, select, weekly{semana} monthly{mês} annual{ano} other{mês}}'**
  String planPricePer(String price, String period);

  /// No description provided for @planCurrent.
  ///
  /// In pt, this message translates to:
  /// **'Seu plano atual'**
  String get planCurrent;

  /// No description provided for @planSubscribe.
  ///
  /// In pt, this message translates to:
  /// **'Assinar'**
  String get planSubscribe;

  /// No description provided for @planBenefitUnlimitedLikes.
  ///
  /// In pt, this message translates to:
  /// **'Likes ilimitados'**
  String get planBenefitUnlimitedLikes;

  /// No description provided for @planBenefitRewind.
  ///
  /// In pt, this message translates to:
  /// **'Voltar o último swipe'**
  String get planBenefitRewind;

  /// No description provided for @planBenefitTravel.
  ///
  /// In pt, this message translates to:
  /// **'Modo viagem: descubra gente em outra cidade ou festival'**
  String get planBenefitTravel;

  /// No description provided for @planBenefitSuperlikes.
  ///
  /// In pt, this message translates to:
  /// **'{count} superlikes por semana'**
  String planBenefitSuperlikes(int count);

  /// No description provided for @planBenefitEverythingPlus.
  ///
  /// In pt, this message translates to:
  /// **'Tudo do Pulse+'**
  String get planBenefitEverythingPlus;

  /// No description provided for @planBenefitLikedYou.
  ///
  /// In pt, this message translates to:
  /// **'Veja quem já curtiu você'**
  String get planBenefitLikedYou;

  /// No description provided for @planBenefitBoost.
  ///
  /// In pt, this message translates to:
  /// **'1 boost por mês: apareça primeiro por 30 minutos'**
  String get planBenefitBoost;

  /// No description provided for @planBenefitIncognito.
  ///
  /// In pt, this message translates to:
  /// **'Modo discreto: só te vê quem você curtiu'**
  String get planBenefitIncognito;

  /// No description provided for @planFeatureHeadline.
  ///
  /// In pt, this message translates to:
  /// **'{feature, select, likes{Curta sem limite} rewind{Voltar é do Pulse+} superlikes{Mais superlikes} travel{Vai viajar? Chegue conhecendo gente} likedYou{Veja quem curtiu você} boost{Apareça primeiro} incognito{Modo discreto} other{Pulse+ e Pulse Black}}'**
  String planFeatureHeadline(String feature);

  /// No description provided for @planFeaturePitch.
  ///
  /// In pt, this message translates to:
  /// **'{feature, select, likes{Seus likes de hoje acabaram. Com o Pulse+ você curte quantas pessoas quiser.} rewind{Passou sem querer? Com o Pulse+ você volta o último swipe.} superlikes{Superlikes avisam que você curtiu e te colocam no topo. Assine ou compre um pacote.} travel{Com o modo viagem você descobre gente da cidade ou do festival antes de chegar.} likedYou{Com o Pulse Black você vê quem já curtiu você e dá match na hora.} boost{O boost te coloca no topo do Descobrir por 30 minutos, ideal na noite da festa.} incognito{Com o Pulse Black só te vê quem você curtiu.} other{Conheça os planos do Pulse.}}'**
  String planFeaturePitch(String feature);

  /// No description provided for @likesYouTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quem curtiu você'**
  String get likesYouTitle;

  /// No description provided for @likesYouNoneYetTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ninguém novo por enquanto'**
  String get likesYouNoneYetTitle;

  /// No description provided for @likesYouNoneYet.
  ///
  /// In pt, this message translates to:
  /// **'Marque presença em eventos e complete o perfil para aparecer para mais gente.'**
  String get likesYouNoneYet;

  /// No description provided for @likesYouLockedBody.
  ///
  /// In pt, this message translates to:
  /// **'Com o Pulse Black você vê quem são e dá match na hora, sem esperar aparecer no Descobrir.'**
  String get likesYouLockedBody;

  /// No description provided for @likesYouHint.
  ///
  /// In pt, this message translates to:
  /// **'Curta de volta para dar match na hora. Toque na foto para ver o perfil.'**
  String get likesYouHint;

  /// No description provided for @likesYouAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get likesYouAll;

  /// No description provided for @likesYouCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 pessoa curtiu você} other{{count} pessoas curtiram você}}'**
  String likesYouCount(int count);

  /// No description provided for @likesYouUnlock.
  ///
  /// In pt, this message translates to:
  /// **'Ver quem são com o Pulse Black'**
  String get likesYouUnlock;

  /// No description provided for @likesYouMatched.
  ///
  /// In pt, this message translates to:
  /// **'Deu match com {name}!'**
  String likesYouMatched(String name);

  /// No description provided for @likesYouOpenChat.
  ///
  /// In pt, this message translates to:
  /// **'Abrir conversa'**
  String get likesYouOpenChat;

  /// No description provided for @superlikeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Superlike'**
  String get superlikeLabel;

  /// No description provided for @discoverSuperLikedYou.
  ///
  /// In pt, this message translates to:
  /// **'Te deu superlike'**
  String get discoverSuperLikedYou;

  /// No description provided for @travelTitle.
  ///
  /// In pt, this message translates to:
  /// **'Modo viagem'**
  String get travelTitle;

  /// No description provided for @travelExplain.
  ///
  /// In pt, this message translates to:
  /// **'Escolha a cidade para onde você vai e descubra gente de lá antes de chegar.'**
  String get travelExplain;

  /// No description provided for @travelActive.
  ///
  /// In pt, this message translates to:
  /// **'Você está descobrindo gente em {city}.'**
  String travelActive(String city);

  /// No description provided for @travelBanner.
  ///
  /// In pt, this message translates to:
  /// **'Modo viagem: {city}'**
  String travelBanner(String city);

  /// No description provided for @travelPick.
  ///
  /// In pt, this message translates to:
  /// **'Escolher cidade'**
  String get travelPick;

  /// No description provided for @travelChange.
  ///
  /// In pt, this message translates to:
  /// **'Trocar cidade'**
  String get travelChange;

  /// No description provided for @travelBackHome.
  ///
  /// In pt, this message translates to:
  /// **'Voltar para minha cidade'**
  String get travelBackHome;

  /// No description provided for @boostTitle.
  ///
  /// In pt, this message translates to:
  /// **'Boost'**
  String get boostTitle;

  /// No description provided for @boostConfirmTitle.
  ///
  /// In pt, this message translates to:
  /// **'Ativar boost?'**
  String get boostConfirmTitle;

  /// No description provided for @boostConfirmBody.
  ///
  /// In pt, this message translates to:
  /// **'Você aparece primeiro no Descobrir por 30 minutos. {count, plural, =1{Você tem 1 boost.} other{Você tem {count} boosts.}}'**
  String boostConfirmBody(int count);

  /// No description provided for @boostActivate.
  ///
  /// In pt, this message translates to:
  /// **'Ativar'**
  String get boostActivate;

  /// No description provided for @boostRunningUntil.
  ///
  /// In pt, this message translates to:
  /// **'Boost ativo até {time}'**
  String boostRunningUntil(String time);

  /// No description provided for @settingsPlanSection.
  ///
  /// In pt, this message translates to:
  /// **'Plano'**
  String get settingsPlanSection;

  /// No description provided for @settingsMyPlan.
  ///
  /// In pt, this message translates to:
  /// **'Meu plano'**
  String get settingsMyPlan;

  /// No description provided for @incognitoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Modo discreto'**
  String get incognitoTitle;

  /// No description provided for @incognitoSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Só te vê quem você curtiu (Pulse Black).'**
  String get incognitoSubtitle;

  /// No description provided for @adminPlanTitle.
  ///
  /// In pt, this message translates to:
  /// **'Plano e avulsos'**
  String get adminPlanTitle;

  /// No description provided for @adminGrantPlan.
  ///
  /// In pt, this message translates to:
  /// **'Liberar {plan} (30 dias)'**
  String adminGrantPlan(String plan);

  /// No description provided for @adminRemovePlan.
  ///
  /// In pt, this message translates to:
  /// **'Remover plano liberado'**
  String get adminRemovePlan;

  /// No description provided for @adminGiveSuperlikes.
  ///
  /// In pt, this message translates to:
  /// **'+{count} superlikes'**
  String adminGiveSuperlikes(int count);

  /// No description provided for @adminGiveBoosts.
  ///
  /// In pt, this message translates to:
  /// **'+{count} boost'**
  String adminGiveBoosts(int count);

  /// No description provided for @eventCouponLabel.
  ///
  /// In pt, this message translates to:
  /// **'Cupom de desconto'**
  String get eventCouponLabel;

  /// No description provided for @eventCouponCopy.
  ///
  /// In pt, this message translates to:
  /// **'Copiar'**
  String get eventCouponCopy;

  /// No description provided for @eventCouponCopied.
  ///
  /// In pt, this message translates to:
  /// **'Cupom copiado. Use na compra do ingresso.'**
  String get eventCouponCopied;

  /// No description provided for @shareNightSubject.
  ///
  /// In pt, this message translates to:
  /// **'Meu rolê'**
  String get shareNightSubject;

  /// No description provided for @shareNightIntro.
  ///
  /// In pt, this message translates to:
  /// **'🛡️ Meu rolê (pelo Pulse):'**
  String get shareNightIntro;

  /// No description provided for @shareNightEvent.
  ///
  /// In pt, this message translates to:
  /// **'📍 {place} {when}'**
  String shareNightEvent(String place, String when);

  /// No description provided for @shareNightWith.
  ///
  /// In pt, this message translates to:
  /// **'👤 Vou encontrar {name}, que conheci no Pulse.'**
  String shareNightWith(String name);

  /// No description provided for @shareNightOutro.
  ///
  /// In pt, this message translates to:
  /// **'Se eu não der notícia, me liga!'**
  String get shareNightOutro;

  /// No description provided for @shareNightAction.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar meu rolê'**
  String get shareNightAction;

  /// No description provided for @chatMenuShareDate.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar encontro'**
  String get chatMenuShareDate;

  /// No description provided for @nightSafetyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rolê seguro'**
  String get nightSafetyTitle;

  /// No description provided for @nightSafetyCardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rolê seguro'**
  String get nightSafetyCardTitle;

  /// No description provided for @nightSafetyCardBody.
  ///
  /// In pt, this message translates to:
  /// **'Avise alguém de confiança aonde você vai e tenha os números de emergência à mão.'**
  String get nightSafetyCardBody;

  /// No description provided for @nightSafetyTipsAction.
  ///
  /// In pt, this message translates to:
  /// **'Dicas e emergência'**
  String get nightSafetyTipsAction;

  /// No description provided for @nightTipWater.
  ///
  /// In pt, this message translates to:
  /// **'Beba água entre um drink e outro e faça pausas para descansar.'**
  String get nightTipWater;

  /// No description provided for @nightTipDrink.
  ///
  /// In pt, this message translates to:
  /// **'Não aceite bebida aberta de desconhecidos e não deixe seu copo sozinho.'**
  String get nightTipDrink;

  /// No description provided for @nightTipMeetingPoint.
  ///
  /// In pt, this message translates to:
  /// **'Combine um ponto de encontro com sua crew para quando o sinal cair.'**
  String get nightTipMeetingPoint;

  /// No description provided for @nightTipBattery.
  ///
  /// In pt, this message translates to:
  /// **'Saia com bateria cheia (ou um carregador) para chamar ajuda ou um carro.'**
  String get nightTipBattery;

  /// No description provided for @nightTipRide.
  ///
  /// In pt, this message translates to:
  /// **'Na volta, confira a placa e o motorista do app antes de entrar.'**
  String get nightTipRide;

  /// No description provided for @nightTipHelp.
  ///
  /// In pt, this message translates to:
  /// **'Se algo der errado, procure a equipe de saúde, a segurança ou a brigada do evento.'**
  String get nightTipHelp;

  /// No description provided for @emergencyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Emergência'**
  String get emergencyTitle;

  /// No description provided for @emergencyPolice.
  ///
  /// In pt, this message translates to:
  /// **'Polícia'**
  String get emergencyPolice;

  /// No description provided for @emergencySamu.
  ///
  /// In pt, this message translates to:
  /// **'SAMU'**
  String get emergencySamu;

  /// No description provided for @emergencyWomen.
  ///
  /// In pt, this message translates to:
  /// **'Central de Atendimento à Mulher'**
  String get emergencyWomen;

  /// No description provided for @emergencyCvv.
  ///
  /// In pt, this message translates to:
  /// **'CVV (apoio emocional)'**
  String get emergencyCvv;

  /// No description provided for @verificationTitle.
  ///
  /// In pt, this message translates to:
  /// **'Verificar perfil'**
  String get verificationTitle;

  /// No description provided for @verificationIntro.
  ///
  /// In pt, this message translates to:
  /// **'Tire uma selfie fazendo a pose pedida. A equipe do Pulse compara com as fotos do seu perfil e libera o selo de verificado.'**
  String get verificationIntro;

  /// No description provided for @verificationPrivacy.
  ///
  /// In pt, this message translates to:
  /// **'A selfie é usada só para isso e apagada logo depois da análise. Ela não aparece no seu perfil.'**
  String get verificationPrivacy;

  /// No description provided for @verificationPoseTitle.
  ///
  /// In pt, this message translates to:
  /// **'Faça esta pose'**
  String get verificationPoseTitle;

  /// No description provided for @poseThumbsUp.
  ///
  /// In pt, this message translates to:
  /// **'Polegar para cima ao lado do rosto'**
  String get poseThumbsUp;

  /// No description provided for @posePeaceSign.
  ///
  /// In pt, this message translates to:
  /// **'Sinal de paz com uma das mãos'**
  String get posePeaceSign;

  /// No description provided for @poseHandOnHead.
  ///
  /// In pt, this message translates to:
  /// **'As duas mãos em cima da cabeça'**
  String get poseHandOnHead;

  /// No description provided for @posePointUp.
  ///
  /// In pt, this message translates to:
  /// **'Apontando para cima com o indicador'**
  String get posePointUp;

  /// No description provided for @poseHandOnChin.
  ///
  /// In pt, this message translates to:
  /// **'Mão no queixo'**
  String get poseHandOnChin;

  /// No description provided for @verificationOtherPose.
  ///
  /// In pt, this message translates to:
  /// **'Sortear outra pose'**
  String get verificationOtherPose;

  /// No description provided for @verificationConsent.
  ///
  /// In pt, this message translates to:
  /// **'Autorizo o uso desta selfie apenas para verificar meu perfil.'**
  String get verificationConsent;

  /// No description provided for @verificationTakeSelfie.
  ///
  /// In pt, this message translates to:
  /// **'Tirar selfie'**
  String get verificationTakeSelfie;

  /// No description provided for @verificationRetake.
  ///
  /// In pt, this message translates to:
  /// **'Tirar outra'**
  String get verificationRetake;

  /// No description provided for @verificationSend.
  ///
  /// In pt, this message translates to:
  /// **'Enviar para análise'**
  String get verificationSend;

  /// No description provided for @verificationSent.
  ///
  /// In pt, this message translates to:
  /// **'Selfie enviada! Você recebe um aviso quando for analisada.'**
  String get verificationSent;

  /// No description provided for @verificationPendingTitle.
  ///
  /// In pt, this message translates to:
  /// **'Em análise'**
  String get verificationPendingTitle;

  /// No description provided for @verificationPendingBody.
  ///
  /// In pt, this message translates to:
  /// **'Recebemos sua selfie. Você recebe um aviso quando a equipe analisar.'**
  String get verificationPendingBody;

  /// No description provided for @verificationApprovedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Perfil verificado'**
  String get verificationApprovedTitle;

  /// No description provided for @verificationApprovedBody.
  ///
  /// In pt, this message translates to:
  /// **'O selo de verificado aparece no seu perfil e nos cards do Descobrir.'**
  String get verificationApprovedBody;

  /// No description provided for @verificationRejectedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Verificação não aprovada'**
  String get verificationRejectedTitle;

  /// No description provided for @verificationRejectedReason.
  ///
  /// In pt, this message translates to:
  /// **'Motivo: {reason}'**
  String verificationRejectedReason(String reason);

  /// No description provided for @verificationNeedsPhotos.
  ///
  /// In pt, this message translates to:
  /// **'Para verificar, seu perfil precisa de pelo menos 2 fotos.'**
  String get verificationNeedsPhotos;

  /// No description provided for @verificationAddPhotos.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar fotos'**
  String get verificationAddPhotos;

  /// No description provided for @verificationStatusVerified.
  ///
  /// In pt, this message translates to:
  /// **'Verificado'**
  String get verificationStatusVerified;

  /// No description provided for @verificationStatusPending.
  ///
  /// In pt, this message translates to:
  /// **'Em análise'**
  String get verificationStatusPending;

  /// No description provided for @verificationStatusNone.
  ///
  /// In pt, this message translates to:
  /// **'Ganhe o selo de verificado'**
  String get verificationStatusNone;

  /// No description provided for @adminVerifications.
  ///
  /// In pt, this message translates to:
  /// **'Verificações'**
  String get adminVerifications;

  /// No description provided for @adminVerificationEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma verificação pendente.'**
  String get adminVerificationEmpty;

  /// No description provided for @adminVerificationPose.
  ///
  /// In pt, this message translates to:
  /// **'Pose pedida: {pose}'**
  String adminVerificationPose(String pose);

  /// No description provided for @adminVerificationRejectHint.
  ///
  /// In pt, this message translates to:
  /// **'Motivo (a pessoa vê)'**
  String get adminVerificationRejectHint;

  /// No description provided for @crewMeetingPoint.
  ///
  /// In pt, this message translates to:
  /// **'Ponto de encontro'**
  String get crewMeetingPoint;

  /// No description provided for @crewMeetingPointHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: perto do bar do fundo, 1h'**
  String get crewMeetingPointHint;

  /// No description provided for @crewMeetingPointEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Ninguém definiu ainda. Toque no lápis para combinar.'**
  String get crewMeetingPointEmpty;

  /// No description provided for @crewMeetingPointEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar ponto de encontro'**
  String get crewMeetingPointEdit;

  /// No description provided for @eventFeatured.
  ///
  /// In pt, this message translates to:
  /// **'Destaque'**
  String get eventFeatured;

  /// No description provided for @eventFeature.
  ///
  /// In pt, this message translates to:
  /// **'Destacar evento'**
  String get eventFeature;

  /// No description provided for @eventUnfeature.
  ///
  /// In pt, this message translates to:
  /// **'Remover destaque'**
  String get eventUnfeature;

  /// No description provided for @eventFeatureTitle.
  ///
  /// In pt, this message translates to:
  /// **'Destacar por quantos dias?'**
  String get eventFeatureTitle;

  /// No description provided for @eventFeatureDays.
  ///
  /// In pt, this message translates to:
  /// **'{days} dias'**
  String eventFeatureDays(int days);

  /// No description provided for @insightsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Painel do evento'**
  String get insightsTitle;

  /// No description provided for @insightsGoing.
  ///
  /// In pt, this message translates to:
  /// **'Pessoas vão'**
  String get insightsGoing;

  /// No description provided for @insightsTicketClicks.
  ///
  /// In pt, this message translates to:
  /// **'Toques em Comprar ingresso'**
  String get insightsTicketClicks;

  /// No description provided for @insightsGoingDate.
  ///
  /// In pt, this message translates to:
  /// **'Vão no Date'**
  String get insightsGoingDate;

  /// No description provided for @insightsGoingCrew.
  ///
  /// In pt, this message translates to:
  /// **'Vão no Crew'**
  String get insightsGoingCrew;

  /// No description provided for @insightsCrews.
  ///
  /// In pt, this message translates to:
  /// **'Crews formadas'**
  String get insightsCrews;

  /// No description provided for @insightsCheckedIn.
  ///
  /// In pt, this message translates to:
  /// **'Fizeram check-in'**
  String get insightsCheckedIn;

  /// No description provided for @eventCheckInQr.
  ///
  /// In pt, this message translates to:
  /// **'QR de check-in'**
  String get eventCheckInQr;

  /// No description provided for @insightsTooFew.
  ///
  /// In pt, this message translates to:
  /// **'Os detalhes do público aparecem a partir de 5 pessoas confirmadas.'**
  String get insightsTooFew;

  /// No description provided for @insightsGenres.
  ///
  /// In pt, this message translates to:
  /// **'Estilos que o público curte'**
  String get insightsGenres;

  /// No description provided for @insightsCities.
  ///
  /// In pt, this message translates to:
  /// **'De onde o público vem'**
  String get insightsCities;

  /// No description provided for @insightsGender.
  ///
  /// In pt, this message translates to:
  /// **'Gênero'**
  String get insightsGender;

  /// No description provided for @insightsGenderUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Não informado'**
  String get insightsGenderUnknown;

  /// No description provided for @insightsAge.
  ///
  /// In pt, this message translates to:
  /// **'Idade'**
  String get insightsAge;

  /// No description provided for @insightsPrivacy.
  ///
  /// In pt, this message translates to:
  /// **'Números agregados: ninguém é identificado.'**
  String get insightsPrivacy;

  /// No description provided for @insightsFeaturedUntil.
  ///
  /// In pt, this message translates to:
  /// **'Em destaque até {date}'**
  String insightsFeaturedUntil(String date);

  /// No description provided for @insightsFeatureHint.
  ///
  /// In pt, this message translates to:
  /// **'Quer mais gente no seu evento? Fale com a equipe Pulse para destacá-lo.'**
  String get insightsFeatureHint;

  /// No description provided for @planPeriodName.
  ///
  /// In pt, this message translates to:
  /// **'{period, select, weekly{Semanal} monthly{Mensal} annual{Anual} other{Mensal}}'**
  String planPeriodName(String period);

  /// No description provided for @planAnnualSavings.
  ///
  /// In pt, this message translates to:
  /// **'Economize {percent}%'**
  String planAnnualSavings(int percent);

  /// No description provided for @planTrialUntil.
  ///
  /// In pt, this message translates to:
  /// **'Teste grátis até {date}, sem cobrança'**
  String planTrialUntil(String date);

  /// No description provided for @referralTitle.
  ///
  /// In pt, this message translates to:
  /// **'Indique e ganhe'**
  String get referralTitle;

  /// No description provided for @referralSettingsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Ganhe superlikes e boosts chamando amigos'**
  String get referralSettingsSubtitle;

  /// No description provided for @referralHeadline.
  ///
  /// In pt, this message translates to:
  /// **'Chame a galera pro rolê'**
  String get referralHeadline;

  /// No description provided for @referralExplainer.
  ///
  /// In pt, this message translates to:
  /// **'Quando um amigo entra com seu código e dá o primeiro match, você ganha {superlikes} superlikes e {boosts, plural, =1{1 boost} other{{boosts} boosts}}. Ele ganha {friendSuperlikes} superlikes na hora.'**
  String referralExplainer(int superlikes, int boosts, int friendSuperlikes);

  /// No description provided for @referralYourCode.
  ///
  /// In pt, this message translates to:
  /// **'Seu código'**
  String get referralYourCode;

  /// No description provided for @referralCopy.
  ///
  /// In pt, this message translates to:
  /// **'Copiar'**
  String get referralCopy;

  /// No description provided for @referralCopied.
  ///
  /// In pt, this message translates to:
  /// **'Código copiado'**
  String get referralCopied;

  /// No description provided for @referralShare.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar convite'**
  String get referralShare;

  /// No description provided for @referralShareText.
  ///
  /// In pt, this message translates to:
  /// **'Bora pro Pulse? É o app pra dar match com quem vai nas mesmas festas. Use meu código {code} em Configurações → Indique e ganhe e ganhe {superlikes} superlikes.'**
  String referralShareText(String code, int superlikes);

  /// No description provided for @referralInvited.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{amigos usaram seu código} =1{amigo usou seu código} other{amigos usaram seu código}}'**
  String referralInvited(int count);

  /// No description provided for @referralRewarded.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{deram match (recompensas suas)} =1{deu match (recompensa sua)} other{deram match (recompensas suas)}}'**
  String referralRewarded(int count);

  /// No description provided for @referralGotCode.
  ///
  /// In pt, this message translates to:
  /// **'Recebeu um convite?'**
  String get referralGotCode;

  /// No description provided for @referralGotCodeHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite o código do seu amigo e ganhe {superlikes} superlikes. Vale até o seu primeiro match.'**
  String referralGotCodeHint(int superlikes);

  /// No description provided for @referralCodeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Código do amigo'**
  String get referralCodeLabel;

  /// No description provided for @referralRedeem.
  ///
  /// In pt, this message translates to:
  /// **'Usar código'**
  String get referralRedeem;

  /// No description provided for @referralRedeemed.
  ///
  /// In pt, this message translates to:
  /// **'Código aplicado! {superlikes} superlikes na sua carteira.'**
  String referralRedeemed(int superlikes);

  /// No description provided for @referralFinePrint.
  ///
  /// In pt, this message translates to:
  /// **'As recompensas de quem indica valem para até 10 amigos por mês. Contas falsas ou combinadas podem perder as recompensas.'**
  String get referralFinePrint;

  /// No description provided for @referralError.
  ///
  /// In pt, this message translates to:
  /// **'{problem, select, invalid{Código não encontrado. Confira as letras e os números.} own{Esse código é seu (ou de alguém que você indicou).} used{Você já usou um código de convite.} tooLate{Os códigos de convite valem só até o primeiro match.} other{Não foi possível usar o código.}}'**
  String referralError(String problem);

  /// No description provided for @adSponsored.
  ///
  /// In pt, this message translates to:
  /// **'Patrocinado'**
  String get adSponsored;

  /// No description provided for @adLearnMore.
  ///
  /// In pt, this message translates to:
  /// **'Saiba mais'**
  String get adLearnMore;

  /// No description provided for @adStampNext.
  ///
  /// In pt, this message translates to:
  /// **'PRÓXIMO'**
  String get adStampNext;

  /// No description provided for @adSwipeHint.
  ///
  /// In pt, this message translates to:
  /// **'Deslize para continuar'**
  String get adSwipeHint;

  /// No description provided for @adminAds.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios'**
  String get adminAds;

  /// No description provided for @adNew.
  ///
  /// In pt, this message translates to:
  /// **'Novo anúncio'**
  String get adNew;

  /// No description provided for @adEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar anúncio'**
  String get adEdit;

  /// No description provided for @adsEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum anúncio ainda'**
  String get adsEmptyTitle;

  /// No description provided for @adsEmptyBody.
  ///
  /// In pt, this message translates to:
  /// **'Crie anúncios de festas e parceiros. Eles aparecem na lista de eventos e no Descobrir; sem anúncio próprio, entram os anúncios do Google.'**
  String get adsEmptyBody;

  /// No description provided for @adRunning.
  ///
  /// In pt, this message translates to:
  /// **'No ar'**
  String get adRunning;

  /// No description provided for @adNotRunning.
  ///
  /// In pt, this message translates to:
  /// **'Fora do ar'**
  String get adNotRunning;

  /// No description provided for @adUntil.
  ///
  /// In pt, this message translates to:
  /// **'até {date}'**
  String adUntil(String date);

  /// No description provided for @adNoEnd.
  ///
  /// In pt, this message translates to:
  /// **'Sem data de fim'**
  String get adNoEnd;

  /// No description provided for @adStats.
  ///
  /// In pt, this message translates to:
  /// **'{views} views · {taps} toques ({ctr}%)'**
  String adStats(int views, int taps, String ctr);

  /// No description provided for @adImage.
  ///
  /// In pt, this message translates to:
  /// **'Imagem do anúncio (16:9)'**
  String get adImage;

  /// No description provided for @adTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get adTitle;

  /// No description provided for @adTitleRequired.
  ///
  /// In pt, this message translates to:
  /// **'Dê um título ao anúncio'**
  String get adTitleRequired;

  /// No description provided for @adBody.
  ///
  /// In pt, this message translates to:
  /// **'Texto (opcional)'**
  String get adBody;

  /// No description provided for @adCta.
  ///
  /// In pt, this message translates to:
  /// **'Texto do botão (opcional)'**
  String get adCta;

  /// No description provided for @adLink.
  ///
  /// In pt, this message translates to:
  /// **'Link (site, ingresso, Instagram)'**
  String get adLink;

  /// No description provided for @adLinkInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Use um link completo, começando com https://'**
  String get adLinkInvalid;

  /// No description provided for @adLinkedEvent.
  ///
  /// In pt, this message translates to:
  /// **'Evento vinculado'**
  String get adLinkedEvent;

  /// No description provided for @adPlacements.
  ///
  /// In pt, this message translates to:
  /// **'Onde aparece'**
  String get adPlacements;

  /// No description provided for @adPlacement.
  ///
  /// In pt, this message translates to:
  /// **'{placement, select, events{Lista de eventos} discover{Descobrir} other{Outro}}'**
  String adPlacement(String placement);

  /// No description provided for @adStartsAt.
  ///
  /// In pt, this message translates to:
  /// **'Começa em'**
  String get adStartsAt;

  /// No description provided for @adEndsAt.
  ///
  /// In pt, this message translates to:
  /// **'Termina em'**
  String get adEndsAt;

  /// No description provided for @adActive.
  ///
  /// In pt, this message translates to:
  /// **'Anúncio ativo'**
  String get adActive;

  /// No description provided for @adSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar anúncio'**
  String get adSave;

  /// No description provided for @adDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get adDelete;

  /// No description provided for @adDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir este anúncio?'**
  String get adDeleteTitle;

  /// No description provided for @eventAdvertise.
  ///
  /// In pt, this message translates to:
  /// **'Anunciar evento'**
  String get eventAdvertise;

  /// No description provided for @errorFeaturedLimit.
  ///
  /// In pt, this message translates to:
  /// **'Esta região já tem 5 eventos em destaque. Espere um terminar ou tire o destaque de outro.'**
  String get errorFeaturedLimit;

  /// No description provided for @errorFeaturedUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Só dá para destacar festas aprovadas que ainda não aconteceram.'**
  String get errorFeaturedUnavailable;

  /// No description provided for @featuredPromoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Coloque sua festa no topo'**
  String get featuredPromoTitle;

  /// No description provided for @featuredPromoBody.
  ///
  /// In pt, this message translates to:
  /// **'Destaque a festa e ela aparece primeiro em Próximos, com o selo Destaque, para quem está na região.'**
  String get featuredPromoBody;

  /// No description provided for @featuredCta.
  ///
  /// In pt, this message translates to:
  /// **'Destacar festa'**
  String get featuredCta;

  /// No description provided for @featuredOnTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua festa está em destaque'**
  String get featuredOnTitle;

  /// No description provided for @featuredOnBody.
  ///
  /// In pt, this message translates to:
  /// **'No topo de Próximos até {date}.'**
  String featuredOnBody(String date);

  /// No description provided for @featuredExtend.
  ///
  /// In pt, this message translates to:
  /// **'Estender destaque'**
  String get featuredExtend;

  /// No description provided for @featuredRequestedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de destaque enviado'**
  String get featuredRequestedTitle;

  /// No description provided for @featuredRequestedBody.
  ///
  /// In pt, this message translates to:
  /// **'{days} dias · {price}. A equipe Pulse vai te chamar para combinar.'**
  String featuredRequestedBody(int days, String price);

  /// No description provided for @featuredChange.
  ///
  /// In pt, this message translates to:
  /// **'Mudar pedido'**
  String get featuredChange;

  /// No description provided for @featuredSheetTitle.
  ///
  /// In pt, this message translates to:
  /// **'Por quantos dias?'**
  String get featuredSheetTitle;

  /// No description provided for @featuredSheetBody.
  ///
  /// In pt, this message translates to:
  /// **'Quanto mais dias, menor o preço por dia. O destaque começa assim que o pagamento é confirmado e soma com o tempo que ainda falta.'**
  String get featuredSheetBody;

  /// No description provided for @featuredDays.
  ///
  /// In pt, this message translates to:
  /// **'{days} dias'**
  String featuredDays(int days);

  /// No description provided for @featuredPerDay.
  ///
  /// In pt, this message translates to:
  /// **'{price} por dia'**
  String featuredPerDay(String price);

  /// No description provided for @featuredBestValue.
  ///
  /// In pt, this message translates to:
  /// **'Melhor preço por dia'**
  String get featuredBestValue;

  /// No description provided for @featuredBuyNow.
  ///
  /// In pt, this message translates to:
  /// **'Destacar agora · {price}'**
  String featuredBuyNow(String price);

  /// No description provided for @featuredAskTeam.
  ///
  /// In pt, this message translates to:
  /// **'Pedir pela equipe Pulse'**
  String get featuredAskTeam;

  /// No description provided for @featuredTeamHint.
  ///
  /// In pt, this message translates to:
  /// **'A equipe também monta pacotes para várias festas.'**
  String get featuredTeamHint;

  /// No description provided for @featuredBought.
  ///
  /// In pt, this message translates to:
  /// **'Pagamento confirmado! Sua festa entra no topo em instantes.'**
  String get featuredBought;

  /// No description provided for @featuredRequestSent.
  ///
  /// In pt, this message translates to:
  /// **'Pedido enviado! A equipe Pulse vai te chamar para combinar.'**
  String get featuredRequestSent;

  /// No description provided for @adminFeatured.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos de destaque'**
  String get adminFeatured;

  /// No description provided for @adminFeaturedEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum pedido de destaque'**
  String get adminFeaturedEmpty;

  /// No description provided for @adminFeaturedEmptyHint.
  ///
  /// In pt, this message translates to:
  /// **'Os pedidos feitos pela equipe aparecem aqui. Compras pela loja entram sozinhas.'**
  String get adminFeaturedEmptyHint;

  /// No description provided for @adminFeaturedLine.
  ///
  /// In pt, this message translates to:
  /// **'{name} · {days} dias · {price}'**
  String adminFeaturedLine(String name, int days, String price);

  /// No description provided for @adminFeaturedPaid.
  ///
  /// In pt, this message translates to:
  /// **'Pago, ativar'**
  String get adminFeaturedPaid;

  /// No description provided for @pauseTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pausar conta'**
  String get pauseTitle;

  /// No description provided for @pauseSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Some do Descobrir sem perder nada. Matches, chats e crews continuam.'**
  String get pauseSubtitle;

  /// No description provided for @pausedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua conta está pausada'**
  String get pausedTitle;

  /// No description provided for @pausedBody.
  ///
  /// In pt, this message translates to:
  /// **'Ninguém te vê no Descobrir enquanto isso. Seus matches, chats, crews e eventos continuam aqui.'**
  String get pausedBody;

  /// No description provided for @pausedResume.
  ///
  /// In pt, this message translates to:
  /// **'Voltar a aparecer'**
  String get pausedResume;

  /// No description provided for @errorAccountPaused.
  ///
  /// In pt, this message translates to:
  /// **'Sua conta está pausada. Volte a aparecer para curtir pessoas.'**
  String get errorAccountPaused;

  /// No description provided for @editSectionPrompts.
  ///
  /// In pt, this message translates to:
  /// **'Perguntas'**
  String get editSectionPrompts;

  /// No description provided for @promptsIntro.
  ///
  /// In pt, this message translates to:
  /// **'Responda até 3 perguntas. Elas aparecem no seu perfil e dão assunto para puxar conversa.'**
  String get promptsIntro;

  /// No description provided for @promptsPick.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma pergunta'**
  String get promptsPick;

  /// No description provided for @promptsAdd.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar pergunta'**
  String get promptsAdd;

  /// No description provided for @promptsRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get promptsRemove;

  /// No description provided for @promptsAnswerHint.
  ///
  /// In pt, this message translates to:
  /// **'Sua resposta'**
  String get promptsAnswerHint;

  /// No description provided for @prompt.
  ///
  /// In pt, this message translates to:
  /// **'{prompt, select, dreamSet{Meu set dos sonhos é…} onTheFloor{Na pista eu sou…} afterParty{Depois da festa, eu…} bestParty{A melhor festa da minha vida foi…} trackOnRepeat{A música que não sai da minha cabeça…} festivalMust{Num festival eu não vivo sem…} greenFlag{Green flag na pista é…} crewRole{Na minha crew eu sou quem…} matchIf{Bora dar match se você…} winsMeOver{O que me ganha numa festa…} other{Pergunta}}'**
  String prompt(String prompt);

  /// No description provided for @chatPhoto.
  ///
  /// In pt, this message translates to:
  /// **'📷 Foto'**
  String get chatPhoto;

  /// No description provided for @chatVoice.
  ///
  /// In pt, this message translates to:
  /// **'🎤 Áudio'**
  String get chatVoice;

  /// No description provided for @chatSendPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Enviar foto'**
  String get chatSendPhoto;

  /// No description provided for @chatPhotoCamera.
  ///
  /// In pt, this message translates to:
  /// **'Tirar foto'**
  String get chatPhotoCamera;

  /// No description provided for @chatPhotoGallery.
  ///
  /// In pt, this message translates to:
  /// **'Escolher da galeria'**
  String get chatPhotoGallery;

  /// No description provided for @chatPhotoCaption.
  ///
  /// In pt, this message translates to:
  /// **'Legenda (opcional)'**
  String get chatPhotoCaption;

  /// No description provided for @chatRecordVoice.
  ///
  /// In pt, this message translates to:
  /// **'Gravar áudio'**
  String get chatRecordVoice;

  /// No description provided for @chatVoiceRecording.
  ///
  /// In pt, this message translates to:
  /// **'Gravando… {time}'**
  String chatVoiceRecording(String time);

  /// No description provided for @chatVoiceCancel.
  ///
  /// In pt, this message translates to:
  /// **'Descartar áudio'**
  String get chatVoiceCancel;

  /// No description provided for @chatVoicePlay.
  ///
  /// In pt, this message translates to:
  /// **'Ouvir áudio'**
  String get chatVoicePlay;

  /// No description provided for @chatVoicePause.
  ///
  /// In pt, this message translates to:
  /// **'Pausar áudio'**
  String get chatVoicePause;

  /// No description provided for @chatVoiceNoPermission.
  ///
  /// In pt, this message translates to:
  /// **'Permita o microfone nas configurações do celular para mandar áudios.'**
  String get chatVoiceNoPermission;

  /// No description provided for @notifyEventsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Avisos de festas'**
  String get notifyEventsTitle;

  /// No description provided for @notifyEventsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Festas novas perto de você, DJs que você curte e lembrete na véspera.'**
  String get notifyEventsSubtitle;

  /// No description provided for @consoleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Admin'**
  String get consoleTitle;

  /// No description provided for @consoleDenied.
  ///
  /// In pt, this message translates to:
  /// **'Este painel é só para admins do Pulse.'**
  String get consoleDenied;

  /// No description provided for @consoleDashboard.
  ///
  /// In pt, this message translates to:
  /// **'Dashboard'**
  String get consoleDashboard;

  /// No description provided for @consolePeople.
  ///
  /// In pt, this message translates to:
  /// **'Pessoas e selos'**
  String get consolePeople;

  /// No description provided for @consoleUsersSection.
  ///
  /// In pt, this message translates to:
  /// **'Pessoas'**
  String get consoleUsersSection;

  /// No description provided for @consoleSettings.
  ///
  /// In pt, this message translates to:
  /// **'Ajustes'**
  String get consoleSettings;

  /// No description provided for @consolePending.
  ///
  /// In pt, this message translates to:
  /// **'Esperando você'**
  String get consolePending;

  /// No description provided for @consoleNothingPending.
  ///
  /// In pt, this message translates to:
  /// **'Nada pendente. Tudo em dia!'**
  String get consoleNothingPending;

  /// No description provided for @consoleBadgeRequests.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos de selo'**
  String get consoleBadgeRequests;

  /// No description provided for @consoleUsersTotal.
  ///
  /// In pt, this message translates to:
  /// **'Pessoas no app'**
  String get consoleUsersTotal;

  /// No description provided for @consoleUsersNew.
  ///
  /// In pt, this message translates to:
  /// **'Novas em 7 dias'**
  String get consoleUsersNew;

  /// No description provided for @consoleToday.
  ///
  /// In pt, this message translates to:
  /// **'{count} hoje'**
  String consoleToday(int count);

  /// No description provided for @consoleUsersActive.
  ///
  /// In pt, this message translates to:
  /// **'Ativas em 24 h'**
  String get consoleUsersActive;

  /// No description provided for @consoleLast7d.
  ///
  /// In pt, this message translates to:
  /// **'{count} em 7 dias'**
  String consoleLast7d(int count);

  /// No description provided for @consoleUsersPaused.
  ///
  /// In pt, this message translates to:
  /// **'Contas pausadas'**
  String get consoleUsersPaused;

  /// No description provided for @consoleRestricted.
  ///
  /// In pt, this message translates to:
  /// **'{count} suspensas ou banidas'**
  String consoleRestricted(int count);

  /// No description provided for @consoleSignupsChart.
  ///
  /// In pt, this message translates to:
  /// **'Cadastros por dia (30 dias)'**
  String get consoleSignupsChart;

  /// No description provided for @consoleMatchesChart.
  ///
  /// In pt, this message translates to:
  /// **'Matches por dia (30 dias)'**
  String get consoleMatchesChart;

  /// No description provided for @consoleChartTotal.
  ///
  /// In pt, this message translates to:
  /// **'{total} no período'**
  String consoleChartTotal(String total);

  /// No description provided for @consoleActivity.
  ///
  /// In pt, this message translates to:
  /// **'Atividade'**
  String get consoleActivity;

  /// No description provided for @consoleMatches.
  ///
  /// In pt, this message translates to:
  /// **'Matches em 24 h'**
  String get consoleMatches;

  /// No description provided for @consoleMessages.
  ///
  /// In pt, this message translates to:
  /// **'Mensagens em 24 h'**
  String get consoleMessages;

  /// No description provided for @consoleUpcomingEvents.
  ///
  /// In pt, this message translates to:
  /// **'Festas por vir'**
  String get consoleUpcomingEvents;

  /// No description provided for @consoleFeaturedNow.
  ///
  /// In pt, this message translates to:
  /// **'{count} em destaque'**
  String consoleFeaturedNow(int count);

  /// No description provided for @consoleMoney.
  ///
  /// In pt, this message translates to:
  /// **'Planos e receita'**
  String get consoleMoney;

  /// No description provided for @consoleTrials.
  ///
  /// In pt, this message translates to:
  /// **'Em teste grátis'**
  String get consoleTrials;

  /// No description provided for @consoleStoreRevenue.
  ///
  /// In pt, this message translates to:
  /// **'Lojas (30 dias)'**
  String get consoleStoreRevenue;

  /// No description provided for @consoleFeaturedRevenue.
  ///
  /// In pt, this message translates to:
  /// **'Destaques pela equipe (30 dias)'**
  String get consoleFeaturedRevenue;

  /// No description provided for @consoleRevenueHint.
  ///
  /// In pt, this message translates to:
  /// **'Lojas: valor bruto em dólar informado pelo RevenueCat, antes da taxa da loja. Destaques: pedidos marcados como pagos no painel.'**
  String get consoleRevenueHint;

  /// No description provided for @consoleSettingsHint.
  ///
  /// In pt, this message translates to:
  /// **'Mudanças valem na hora para todo mundo, sem lançar versão nova do app.'**
  String get consoleSettingsHint;

  /// No description provided for @consoleFeaturedPrices.
  ///
  /// In pt, this message translates to:
  /// **'Preços de destaque'**
  String get consoleFeaturedPrices;

  /// No description provided for @consoleFeaturedPricesHint.
  ///
  /// In pt, this message translates to:
  /// **'Valem para os pedidos pela equipe. Na compra pelo app vale o preço da loja: mude também no Play Console e na App Store.'**
  String get consoleFeaturedPricesHint;

  /// No description provided for @consoleSettingName.
  ///
  /// In pt, this message translates to:
  /// **'{key, select, ads_discover_every{Anúncio a cada N perfis no Descobrir} ads_enabled{Anúncios ligados (1) ou desligados (0)} ads_events_every{Anúncio a cada N eventos em Próximos} ads_for_paid{Quem paga vê anúncios (1 sim, 0 não)} black_monthly_boosts{Boosts por mês no Pulse Black} boost_minutes{Duração do boost (minutos)} event_push_daily_cap{Avisos de festa nova por dia, por pessoa} event_push_horizon_days{Avisar festas até N dias à frente} featured_max_per_region{Destaques ao mesmo tempo por região} featured_region_km{Raio da região de destaque (km)} free_daily_likes{Curtidas por dia no plano grátis} free_weekly_superlikes{Superlikes por semana no plano grátis} plan_weekly_superlikes{Superlikes por semana nos planos} referral_monthly_cap{Indicações recompensadas por mês} referral_referred_superlikes{Superlikes para quem usa um convite} referral_referrer_boosts{Boosts para quem indicou} referral_referrer_superlikes{Superlikes para quem indicou} trial_days{Dias de teste grátis do Black} other{Outro ajuste}}'**
  String consoleSettingName(String key);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
