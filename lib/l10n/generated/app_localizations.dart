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

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to your account'**
  String get loginSubtitle;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get fieldEmailHint;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join your mosque community'**
  String get registerSubtitle;

  /// No description provided for @fieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fieldFullName;

  /// No description provided for @fieldFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ahmed Abdi Hassan'**
  String get fieldFullNameHint;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get fieldPhone;

  /// No description provided for @fieldOptional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get fieldOptional;

  /// No description provided for @fieldPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+252 61 234 5678'**
  String get fieldPhoneHint;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get fieldConfirmPassword;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordHelper;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @validationNameShort.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get validationNameShort;

  /// No description provided for @termsAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Use and Privacy Policy'**
  String get termsAgree;

  /// No description provided for @validationTerms.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms to continue'**
  String get validationTerms;

  /// No description provided for @registerHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get registerHaveAccount;

  /// No description provided for @mockTitle.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get mockTitle;

  /// No description provided for @mockLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Your details look correct, but signing in will only work after the app is connected to the server. Nothing was saved.'**
  String get mockLoginMessage;

  /// No description provided for @mockRegisterMessage.
  ///
  /// In en, this message translates to:
  /// **'Your details look correct, but creating an account will only work after the app is connected to the server. Nothing was saved.'**
  String get mockRegisterMessage;

  /// No description provided for @mockResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset emails will be sent once the app is connected to the server. Nothing was sent.'**
  String get mockResetMessage;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the email you registered with. We\'ll send you a link to reset your password.'**
  String get forgotSubtitle;

  /// No description provided for @forgotSend.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get forgotSend;

  /// No description provided for @forgotBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to log in'**
  String get forgotBackToLogin;

  /// No description provided for @demoBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoBannerTitle;

  /// No description provided for @demoBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'You are signed in with sample data. No real account was used and nothing is saved.'**
  String get demoBannerMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @homeGreetingName.
  ///
  /// In en, this message translates to:
  /// **'Assalamu alaikum, {name}'**
  String homeGreetingName(String name);

  /// No description provided for @homeMenuProfile.
  ///
  /// In en, this message translates to:
  /// **'Mosque Profile'**
  String get homeMenuProfile;

  /// No description provided for @homeMenuPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get homeMenuPrayer;

  /// No description provided for @homeMenuCalendar.
  ///
  /// In en, this message translates to:
  /// **'Mosque Calendar'**
  String get homeMenuCalendar;

  /// No description provided for @homeMenuNews.
  ///
  /// In en, this message translates to:
  /// **'News & Articles'**
  String get homeMenuNews;

  /// No description provided for @homeMenuDonations.
  ///
  /// In en, this message translates to:
  /// **'Donation Program'**
  String get homeMenuDonations;

  /// No description provided for @homeMenuContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get homeMenuContact;

  /// No description provided for @coverPhotoPending.
  ///
  /// In en, this message translates to:
  /// **'Mosque photo not added yet'**
  String get coverPhotoPending;

  /// No description provided for @homeMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Mosque services'**
  String get homeMenuTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Mosque Profile'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEdit;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit mosque profile'**
  String get profileEditTitle;

  /// No description provided for @profileNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description added yet.'**
  String get profileNoDescription;

  /// No description provided for @profileNoData.
  ///
  /// In en, this message translates to:
  /// **'No information added yet.'**
  String get profileNoData;

  /// No description provided for @profileAddInfo.
  ///
  /// In en, this message translates to:
  /// **'Add information'**
  String get profileAddInfo;

  /// No description provided for @profileSectionBasic.
  ///
  /// In en, this message translates to:
  /// **'Mosque details'**
  String get profileSectionBasic;

  /// No description provided for @profileSectionLocation.
  ///
  /// In en, this message translates to:
  /// **'Mosque location'**
  String get profileSectionLocation;

  /// No description provided for @profileSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get profileSectionContact;

  /// No description provided for @profileSectionLeadership.
  ///
  /// In en, this message translates to:
  /// **'Mosque leadership'**
  String get profileSectionLeadership;

  /// No description provided for @profileSectionServices.
  ///
  /// In en, this message translates to:
  /// **'Mosque services'**
  String get profileSectionServices;

  /// No description provided for @profileSectionFacilities.
  ///
  /// In en, this message translates to:
  /// **'Mosque facilities'**
  String get profileSectionFacilities;

  /// No description provided for @profileServicesPending.
  ///
  /// In en, this message translates to:
  /// **'Services will appear here as they are added to the app.'**
  String get profileServicesPending;

  /// No description provided for @profileLeadershipPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only names are shown. Personal contact details are never public.'**
  String get profileLeadershipPrivacy;

  /// No description provided for @profileAuthNotice.
  ///
  /// In en, this message translates to:
  /// **'Editing is available because you are signed in (demo). Permissions are checked in the app only for now; the server will enforce them later.'**
  String get profileAuthNotice;

  /// No description provided for @fieldMosqueName.
  ///
  /// In en, this message translates to:
  /// **'Mosque name'**
  String get fieldMosqueName;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get fieldDescription;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Mosque type'**
  String get fieldCategory;

  /// No description provided for @categoryJamia.
  ///
  /// In en, this message translates to:
  /// **'Jāmiʿ (Friday mosque)'**
  String get categoryJamia;

  /// No description provided for @categoryMasjid.
  ///
  /// In en, this message translates to:
  /// **'Mosque'**
  String get categoryMasjid;

  /// No description provided for @categoryMusalla.
  ///
  /// In en, this message translates to:
  /// **'Prayer hall (muṣallā)'**
  String get categoryMusalla;

  /// No description provided for @fieldEstablished.
  ///
  /// In en, this message translates to:
  /// **'Year established'**
  String get fieldEstablished;

  /// No description provided for @fieldRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get fieldRegistration;

  /// No description provided for @fieldCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get fieldCountry;

  /// No description provided for @fieldCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get fieldCity;

  /// No description provided for @fieldDistrict.
  ///
  /// In en, this message translates to:
  /// **'District / neighbourhood'**
  String get fieldDistrict;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get fieldAddress;

  /// No description provided for @fieldLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get fieldLatitude;

  /// No description provided for @fieldLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get fieldLongitude;

  /// No description provided for @fieldCoordinates.
  ///
  /// In en, this message translates to:
  /// **'GPS coordinates'**
  String get fieldCoordinates;

  /// No description provided for @fieldWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get fieldWebsite;

  /// No description provided for @fieldSocial.
  ///
  /// In en, this message translates to:
  /// **'Social media'**
  String get fieldSocial;

  /// No description provided for @fieldImam.
  ///
  /// In en, this message translates to:
  /// **'Imam'**
  String get fieldImam;

  /// No description provided for @fieldChairman.
  ///
  /// In en, this message translates to:
  /// **'Chairman'**
  String get fieldChairman;

  /// No description provided for @fieldAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get fieldAdministrator;

  /// No description provided for @fieldTreasurer.
  ///
  /// In en, this message translates to:
  /// **'Treasurer'**
  String get fieldTreasurer;

  /// No description provided for @fieldLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get fieldLogo;

  /// No description provided for @logoUploadPending.
  ///
  /// In en, this message translates to:
  /// **'Uploading a logo will be possible once storage (Supabase) is connected.'**
  String get logoUploadPending;

  /// No description provided for @logoUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload logo'**
  String get logoUpload;

  /// No description provided for @facilityWomen.
  ///
  /// In en, this message translates to:
  /// **'Women\'s prayer area'**
  String get facilityWomen;

  /// No description provided for @facilityQuranRooms.
  ///
  /// In en, this message translates to:
  /// **'Qur\'an teaching rooms'**
  String get facilityQuranRooms;

  /// No description provided for @facilityAblution.
  ///
  /// In en, this message translates to:
  /// **'Ablution facilities'**
  String get facilityAblution;

  /// No description provided for @facilityParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get facilityParking;

  /// No description provided for @facilityAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility (wheelchair access)'**
  String get facilityAccessibility;

  /// No description provided for @facilitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Tick only the facilities the mosque actually has.'**
  String get facilitiesHint;

  /// No description provided for @editLanguageNote.
  ///
  /// In en, this message translates to:
  /// **'Name and description are edited for the current language: {language}.'**
  String editLanguageNote(String language);

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileSave;

  /// No description provided for @profileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancel;

  /// No description provided for @profileSavedLocal.
  ///
  /// In en, this message translates to:
  /// **'Changes saved on this device only (temporary). They will be lost when the app is closed until the server is connected.'**
  String get profileSavedLocal;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the changes. Please try again.'**
  String get profileSaveError;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardTitle;

  /// No description provided for @discardMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. If you leave now, they will be lost.'**
  String get discardMessage;

  /// No description provided for @discardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardConfirm;

  /// No description provided for @discardKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get discardKeepEditing;

  /// No description provided for @validationWebsite.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid website address (e.g. www.example.com)'**
  String get validationWebsite;

  /// No description provided for @validationYear.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid year between {min} and {max}'**
  String validationYear(int min, int max);

  /// No description provided for @validationLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude must be a number between -90 and 90'**
  String get validationLatitude;

  /// No description provided for @validationLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude must be a number between -180 and 180'**
  String get validationLongitude;

  /// No description provided for @prayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTitle;

  /// No description provided for @prayerNextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get prayerNextLabel;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerSunriseNote.
  ///
  /// In en, this message translates to:
  /// **'Not one of the five obligatory prayers'**
  String get prayerSunriseNote;

  /// No description provided for @prayerAdhan.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get prayerAdhan;

  /// No description provided for @prayerIqamah.
  ///
  /// In en, this message translates to:
  /// **'Iqamah'**
  String get prayerIqamah;

  /// No description provided for @prayerIqamahNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get prayerIqamahNotSet;

  /// No description provided for @prayerDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Five daily prayers'**
  String get prayerDailyTitle;

  /// No description provided for @prayerNextBadge.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get prayerNextBadge;

  /// No description provided for @prayerTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get prayerTomorrow;

  /// No description provided for @prayerCountdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Time remaining'**
  String get prayerCountdownLabel;

  /// No description provided for @prayerNoNext.
  ///
  /// In en, this message translates to:
  /// **'The next prayer time is not available.'**
  String get prayerNoNext;

  /// No description provided for @prayerLocationMissing.
  ///
  /// In en, this message translates to:
  /// **'Mosque location not added yet'**
  String get prayerLocationMissing;

  /// No description provided for @prayerMockTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample data — not real times'**
  String get prayerMockTitle;

  /// No description provided for @prayerMockMessage.
  ///
  /// In en, this message translates to:
  /// **'These times are sample (mock) values used to test the design. They are NOT the real prayer times of the mosque. Real times will be shown once the mosque location and calculation method are configured.'**
  String get prayerMockMessage;

  /// No description provided for @prayerEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No prayer schedule'**
  String get prayerEmptyTitle;

  /// No description provided for @prayerEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Prayer times for this day have not been set yet.'**
  String get prayerEmptyMessage;

  /// No description provided for @prayerRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get prayerRefresh;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Mosque Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarPrevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get calendarPrevMonth;

  /// No description provided for @calendarNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get calendarNextMonth;

  /// No description provided for @calendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarToday;

  /// No description provided for @calendarHijriApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {date} (estimate)'**
  String calendarHijriApprox(String date);

  /// No description provided for @calendarHijriNote.
  ///
  /// In en, this message translates to:
  /// **'Hijri dates are calculated estimates and may differ by 1–2 days from the local moon-sighting announcement.'**
  String get calendarHijriNote;

  /// No description provided for @calendarOccasionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Islamic occasions this month'**
  String get calendarOccasionsTitle;

  /// No description provided for @occasionEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get occasionEstimated;

  /// No description provided for @occasionConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get occasionConfirmed;

  /// No description provided for @occasionRamadanStart.
  ///
  /// In en, this message translates to:
  /// **'Start of Ramadan'**
  String get occasionRamadanStart;

  /// No description provided for @occasionEidFitr.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Fitr'**
  String get occasionEidFitr;

  /// No description provided for @occasionEidAdha.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Adha'**
  String get occasionEidAdha;

  /// No description provided for @occasionArafah.
  ///
  /// In en, this message translates to:
  /// **'Day of Arafah'**
  String get occasionArafah;

  /// No description provided for @occasionIslamicNewYear.
  ///
  /// In en, this message translates to:
  /// **'Islamic New Year'**
  String get occasionIslamicNewYear;

  /// No description provided for @occasionAshura.
  ///
  /// In en, this message translates to:
  /// **'Ashura'**
  String get occasionAshura;

  /// No description provided for @eventsUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get eventsUpcomingTitle;

  /// No description provided for @eventsAllTitle.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get eventsAllTitle;

  /// No description provided for @eventsPastTitle.
  ///
  /// In en, this message translates to:
  /// **'Past events'**
  String get eventsPastTitle;

  /// No description provided for @eventsOnDate.
  ///
  /// In en, this message translates to:
  /// **'Events on {date}'**
  String eventsOnDate(String date);

  /// No description provided for @eventsClearDate.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get eventsClearDate;

  /// No description provided for @eventFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get eventFilterAll;

  /// No description provided for @eventFilterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get eventFilterUpcoming;

  /// No description provided for @eventFilterPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get eventFilterPast;

  /// No description provided for @eventFilterOccasions.
  ///
  /// In en, this message translates to:
  /// **'Islamic occasions'**
  String get eventFilterOccasions;

  /// No description provided for @eventCatQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran classes'**
  String get eventCatQuran;

  /// No description provided for @eventCatLectures.
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get eventCatLectures;

  /// No description provided for @eventCatLessons.
  ///
  /// In en, this message translates to:
  /// **'Religious lessons'**
  String get eventCatLessons;

  /// No description provided for @eventCatCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community meetings'**
  String get eventCatCommunity;

  /// No description provided for @eventCatChildren.
  ///
  /// In en, this message translates to:
  /// **'Children’s programmes'**
  String get eventCatChildren;

  /// No description provided for @eventCatYouth.
  ///
  /// In en, this message translates to:
  /// **'Youth programmes'**
  String get eventCatYouth;

  /// No description provided for @eventCatRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan programmes'**
  String get eventCatRamadan;

  /// No description provided for @eventCatEid.
  ///
  /// In en, this message translates to:
  /// **'Eid celebrations'**
  String get eventCatEid;

  /// No description provided for @eventCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other mosque events'**
  String get eventCatOther;

  /// No description provided for @eventStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get eventStatusScheduled;

  /// No description provided for @eventStatusPostponed.
  ///
  /// In en, this message translates to:
  /// **'Postponed'**
  String get eventStatusPostponed;

  /// No description provided for @eventStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get eventStatusCancelled;

  /// No description provided for @eventTimingUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get eventTimingUpcoming;

  /// No description provided for @eventTimingOngoing.
  ///
  /// In en, this message translates to:
  /// **'Happening now'**
  String get eventTimingOngoing;

  /// No description provided for @eventTimingEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get eventTimingEnded;

  /// No description provided for @eventsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No events'**
  String get eventsEmptyTitle;

  /// No description provided for @eventsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No events match this selection.'**
  String get eventsEmptyMessage;

  /// No description provided for @eventsMockTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample events — not real'**
  String get eventsMockTitle;

  /// No description provided for @eventsMockMessage.
  ///
  /// In en, this message translates to:
  /// **'These events are sample (mock) data for testing the design. They are not real events of the mosque.'**
  String get eventsMockMessage;

  /// No description provided for @eventsAuthNotice.
  ///
  /// In en, this message translates to:
  /// **'You can add and edit events because you signed in (demo). Permission is only checked inside the app for now; the server will enforce it later.'**
  String get eventsAuthNotice;

  /// No description provided for @eventAdd.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get eventAdd;

  /// No description provided for @eventDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Event details'**
  String get eventDetailsTitle;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get eventDate;

  /// No description provided for @eventTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get eventTime;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventLocation;

  /// No description provided for @eventOrganizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get eventOrganizer;

  /// No description provided for @eventCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get eventCategory;

  /// No description provided for @eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get eventDescription;

  /// No description provided for @eventRegistrationRequired.
  ///
  /// In en, this message translates to:
  /// **'Registration required'**
  String get eventRegistrationRequired;

  /// No description provided for @eventNotFound.
  ///
  /// In en, this message translates to:
  /// **'This event was not found.'**
  String get eventNotFound;

  /// No description provided for @eventReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get eventReminder;

  /// No description provided for @eventReminderUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Reminders are not available yet. They will be added in a later phase.'**
  String get eventReminderUnavailable;

  /// No description provided for @eventFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New event'**
  String get eventFormNewTitle;

  /// No description provided for @eventFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get eventFormEditTitle;

  /// No description provided for @eventFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Event title'**
  String get eventFieldTitle;

  /// No description provided for @eventFieldStart.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get eventFieldStart;

  /// No description provided for @eventFieldEnd.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get eventFieldEnd;

  /// No description provided for @eventClearEnd.
  ///
  /// In en, this message translates to:
  /// **'Clear end time'**
  String get eventClearEnd;

  /// No description provided for @eventFieldStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get eventFieldStatus;

  /// No description provided for @eventFieldImage.
  ///
  /// In en, this message translates to:
  /// **'Image (optional)'**
  String get eventFieldImage;

  /// No description provided for @eventImageUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get eventImageUpload;

  /// No description provided for @eventImagePending.
  ///
  /// In en, this message translates to:
  /// **'Image upload will work once storage (server) is connected.'**
  String get eventImagePending;

  /// No description provided for @eventFieldRegistrationDetails.
  ///
  /// In en, this message translates to:
  /// **'Registration details'**
  String get eventFieldRegistrationDetails;

  /// No description provided for @eventValidationEndBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end time must be after the start time.'**
  String get eventValidationEndBeforeStart;

  /// No description provided for @eventValidationPastDate.
  ///
  /// In en, this message translates to:
  /// **'The date cannot be in the past.'**
  String get eventValidationPastDate;

  /// No description provided for @eventValidationChoose.
  ///
  /// In en, this message translates to:
  /// **'Please choose an option'**
  String get eventValidationChoose;

  /// No description provided for @eventSavedLocal.
  ///
  /// In en, this message translates to:
  /// **'The event was saved on this device only (temporary). It will be lost when the app closes, until the server is connected.'**
  String get eventSavedLocal;

  /// No description provided for @eventSaveError.
  ///
  /// In en, this message translates to:
  /// **'The event could not be saved. Please try again.'**
  String get eventSaveError;
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
