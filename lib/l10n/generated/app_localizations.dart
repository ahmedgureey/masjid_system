import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_so.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('so'),
  ];

  /// Full application name.
  ///
  /// In en, this message translates to:
  /// **'Masjid Management App'**
  String get appName;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSomali.
  ///
  /// In en, this message translates to:
  /// **'Soomaali'**
  String get languageSomali;

  /// Language names are always written in their own language.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this right now. Please check your connection and try again.'**
  String get errorGenericMessage;

  /// No description provided for @errorOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get errorOfflineTitle;

  /// No description provided for @errorOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Showing saved data. Some actions need an internet connection.'**
  String get errorOfflineMessage;

  /// No description provided for @emptyGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyGenericTitle;

  /// No description provided for @emptyGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'When there is something to show, it will appear here.'**
  String get emptyGenericMessage;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get validationEmail;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validationPhone;

  /// No description provided for @validationPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String validationPasswordLength(int min);

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get statusPresent;

  /// No description provided for @statusAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get statusAbsent;

  /// No description provided for @statusLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get statusLate;

  /// No description provided for @statusExcused.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get statusExcused;

  /// No description provided for @galleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get galleryTitle;

  /// No description provided for @galleryButtons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get galleryButtons;

  /// No description provided for @galleryInputs.
  ///
  /// In en, this message translates to:
  /// **'Input fields'**
  String get galleryInputs;

  /// No description provided for @galleryCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get galleryCards;

  /// No description provided for @galleryStates.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get galleryStates;

  /// No description provided for @galleryChips.
  ///
  /// In en, this message translates to:
  /// **'Status chips'**
  String get galleryChips;

  /// No description provided for @galleryOpen.
  ///
  /// In en, this message translates to:
  /// **'View components'**
  String get galleryOpen;

  /// No description provided for @galleryPrimary.
  ///
  /// In en, this message translates to:
  /// **'Record donation'**
  String get galleryPrimary;

  /// No description provided for @gallerySecondary.
  ///
  /// In en, this message translates to:
  /// **'View receipt'**
  String get gallerySecondary;

  /// No description provided for @galleryAccent.
  ///
  /// In en, this message translates to:
  /// **'Donate now'**
  String get galleryAccent;

  /// No description provided for @galleryTextButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get galleryTextButton;

  /// No description provided for @galleryDestructive.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get galleryDestructive;

  /// No description provided for @galleryFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get galleryFullName;

  /// No description provided for @galleryFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ahmed Abdi'**
  String get galleryFullNameHint;

  /// No description provided for @galleryPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get galleryPassword;

  /// No description provided for @galleryAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get galleryAmount;

  /// No description provided for @galleryNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get galleryNextPrayer;

  /// No description provided for @galleryCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Friday Night Halaqa'**
  String get galleryCardTitle;

  /// No description provided for @galleryCardBody.
  ///
  /// In en, this message translates to:
  /// **'Main hall · 7:30 PM'**
  String get galleryCardBody;

  /// No description provided for @galleryTintedBody.
  ///
  /// In en, this message translates to:
  /// **'Your donation helps maintain the mosque.'**
  String get galleryTintedBody;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your mosque, in one place'**
  String get splashTagline;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change it later in Settings.'**
  String get languageSubtitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Never miss a prayer'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Accurate prayer and Iqamah times, reminders and Qibla for your mosque.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Give with trust'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Support your mosque and see how your donations help.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Learn and stay connected'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an classes, events and announcements in one place.'**
  String get onboarding3Body;

  /// No description provided for @onboardingPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPageLabel(int current, int total);

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Assalamu alaikum'**
  String get welcomeGreeting;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Masjid Management App'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer times, donations, classes and community news for your mosque.'**
  String get welcomeSubtitle;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authLogin;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @welcomeTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the Terms of Use and Privacy Policy.'**
  String get welcomeTerms;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This screen will be built in the next module.'**
  String get comingSoonMessage;
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
      <String>['ar', 'en', 'so'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'so':
      return AppLocalizationsSo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
