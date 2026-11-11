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

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'News & Articles'**
  String get newsTitle;

  /// No description provided for @newsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search articles'**
  String get newsSearchHint;

  /// No description provided for @newsClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get newsClearSearch;

  /// No description provided for @newsAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get newsAllCategories;

  /// No description provided for @newsFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get newsFeatured;

  /// No description provided for @newsLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest news'**
  String get newsLatest;

  /// No description provided for @newsRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get newsRecommended;

  /// No description provided for @newsAllArticles.
  ///
  /// In en, this message translates to:
  /// **'All articles'**
  String get newsAllArticles;

  /// No description provided for @newsSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newsSortNewest;

  /// No description provided for @newsSortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get newsSortOldest;

  /// No description provided for @newsResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String newsResultsCount(int count);

  /// No description provided for @newsClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get newsClearFilters;

  /// No description provided for @newsNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No articles found'**
  String get newsNoResultsTitle;

  /// No description provided for @newsNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try other words or another category.'**
  String get newsNoResultsMessage;

  /// No description provided for @newsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No articles yet'**
  String get newsEmptyTitle;

  /// No description provided for @newsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Published news and articles will appear here.'**
  String get newsEmptyMessage;

  /// No description provided for @newsReadingTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String newsReadingTime(int minutes);

  /// No description provided for @newsMockTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample articles — not real'**
  String get newsMockTitle;

  /// No description provided for @newsMockMessage.
  ///
  /// In en, this message translates to:
  /// **'These articles are sample (mock) data for testing the design. They are not real news of the mosque and contain no religious rulings, verses, hadith or quotations.'**
  String get newsMockMessage;

  /// No description provided for @newsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved articles'**
  String get newsSaved;

  /// No description provided for @newsBookmark.
  ///
  /// In en, this message translates to:
  /// **'Save article'**
  String get newsBookmark;

  /// No description provided for @newsRemoveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get newsRemoveBookmark;

  /// No description provided for @newsBookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device only.'**
  String get newsBookmarkAdded;

  /// No description provided for @newsBookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved articles.'**
  String get newsBookmarkRemoved;

  /// No description provided for @newsBookmarkError.
  ///
  /// In en, this message translates to:
  /// **'Could not update saved articles. Please try again.'**
  String get newsBookmarkError;

  /// No description provided for @newsBookmarkLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save articles.'**
  String get newsBookmarkLoginRequired;

  /// No description provided for @newsSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get newsSignIn;

  /// No description provided for @newsSavedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved articles'**
  String get newsSavedEmptyTitle;

  /// No description provided for @newsSavedEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the bookmark icon on an article to save it.'**
  String get newsSavedEmptyMessage;

  /// No description provided for @newsSavedLocalNote.
  ///
  /// In en, this message translates to:
  /// **'Saved articles are stored on this device only. They are not synced to other devices yet.'**
  String get newsSavedLocalNote;

  /// No description provided for @newsSavedSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your saved articles.'**
  String get newsSavedSignedOut;

  /// No description provided for @newsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This article is no longer available.'**
  String get newsUnavailable;

  /// No description provided for @newsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get newsShare;

  /// No description provided for @newsShareError.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available right now.'**
  String get newsShareError;

  /// No description provided for @newsNotFound.
  ///
  /// In en, this message translates to:
  /// **'This article was not found.'**
  String get newsNotFound;

  /// No description provided for @newsPublished.
  ///
  /// In en, this message translates to:
  /// **'Published {date}'**
  String newsPublished(String date);

  /// No description provided for @newsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String newsUpdated(String date);

  /// No description provided for @newsReferences.
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get newsReferences;

  /// No description provided for @newsRelated.
  ///
  /// In en, this message translates to:
  /// **'Related articles'**
  String get newsRelated;

  /// No description provided for @donTitle.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get donTitle;

  /// No description provided for @donIntro.
  ///
  /// In en, this message translates to:
  /// **'Your donations help maintain the mosque, support Quran education and help families in need. May Allah reward you.'**
  String get donIntro;

  /// No description provided for @donSampleTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample data — not real campaigns or money'**
  String get donSampleTitle;

  /// No description provided for @donSampleMessage.
  ///
  /// In en, this message translates to:
  /// **'These campaigns, amounts and records are sample (mock) data for testing the design. No money is collected and no payment is processed.'**
  String get donSampleMessage;

  /// No description provided for @donConfirmedVsPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirmed and pending'**
  String get donConfirmedVsPendingTitle;

  /// No description provided for @donConfirmedVsPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Only donations verified by the mosque treasurer are counted as confirmed. Pending donations are shown separately and are not added to the totals.'**
  String get donConfirmedVsPendingBody;

  /// No description provided for @donActiveCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Active campaigns'**
  String get donActiveCampaigns;

  /// No description provided for @donSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get donSeeAll;

  /// No description provided for @donNoCampaigns.
  ///
  /// In en, this message translates to:
  /// **'No campaigns'**
  String get donNoCampaigns;

  /// No description provided for @donNoCampaignsMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no active fundraising campaigns at the moment.'**
  String get donNoCampaignsMessage;

  /// No description provided for @donNoCampaignsFilter.
  ///
  /// In en, this message translates to:
  /// **'No campaigns match this filter.'**
  String get donNoCampaignsFilter;

  /// No description provided for @donDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get donDonate;

  /// No description provided for @donHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation history'**
  String get donHistoryTitle;

  /// No description provided for @donCampaignsTitle.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get donCampaignsTitle;

  /// No description provided for @donStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation management'**
  String get donStaffTitle;

  /// No description provided for @donFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get donFilterAll;

  /// No description provided for @donAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get donAllCategories;

  /// No description provided for @donAllMethods.
  ///
  /// In en, this message translates to:
  /// **'All methods'**
  String get donAllMethods;

  /// No description provided for @donCatConstruction.
  ///
  /// In en, this message translates to:
  /// **'Mosque construction'**
  String get donCatConstruction;

  /// No description provided for @donCatMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Mosque maintenance'**
  String get donCatMaintenance;

  /// No description provided for @donCatUtilities.
  ///
  /// In en, this message translates to:
  /// **'Electricity and water'**
  String get donCatUtilities;

  /// No description provided for @donCatQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran education'**
  String get donCatQuran;

  /// No description provided for @donCatFamilies.
  ///
  /// In en, this message translates to:
  /// **'Support for needy families'**
  String get donCatFamilies;

  /// No description provided for @donCatRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan food distribution'**
  String get donCatRamadan;

  /// No description provided for @donCatGeneral.
  ///
  /// In en, this message translates to:
  /// **'General mosque donations'**
  String get donCatGeneral;

  /// No description provided for @donCampaignDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get donCampaignDraft;

  /// No description provided for @donCampaignActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get donCampaignActive;

  /// No description provided for @donCampaignCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get donCampaignCompleted;

  /// No description provided for @donCampaignArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get donCampaignArchived;

  /// No description provided for @donMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get donMethodCash;

  /// No description provided for @donMethodBank.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get donMethodBank;

  /// No description provided for @donMethodMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile money'**
  String get donMethodMobile;

  /// No description provided for @donMethodOnline.
  ///
  /// In en, this message translates to:
  /// **'Online payment'**
  String get donMethodOnline;

  /// No description provided for @donStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get donStatusPending;

  /// No description provided for @donStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get donStatusConfirmed;

  /// No description provided for @donStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get donStatusFailed;

  /// No description provided for @donStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get donStatusRefunded;

  /// No description provided for @donStatusDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo — not processed'**
  String get donStatusDemo;

  /// No description provided for @donStatusVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get donStatusVoided;

  /// No description provided for @donProgressSemantics.
  ///
  /// In en, this message translates to:
  /// **'{raised} confirmed of {target}, {percent} percent'**
  String donProgressSemantics(String raised, String target, int percent);

  /// No description provided for @donRaisedOf.
  ///
  /// In en, this message translates to:
  /// **'of {target}'**
  String donRaisedOf(String target);

  /// No description provided for @donRemaining.
  ///
  /// In en, this message translates to:
  /// **'{amount} remaining'**
  String donRemaining(String amount);

  /// No description provided for @donPendingNotCounted.
  ///
  /// In en, this message translates to:
  /// **'Pending verification (not counted): {amount}'**
  String donPendingNotCounted(String amount);

  /// No description provided for @donCampaignDetails.
  ///
  /// In en, this message translates to:
  /// **'Campaign details'**
  String get donCampaignDetails;

  /// No description provided for @donCampaignNotFound.
  ///
  /// In en, this message translates to:
  /// **'This campaign was not found.'**
  String get donCampaignNotFound;

  /// No description provided for @donTarget.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get donTarget;

  /// No description provided for @donConfirmedReceived.
  ///
  /// In en, this message translates to:
  /// **'Confirmed donations received'**
  String get donConfirmedReceived;

  /// No description provided for @donRemainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get donRemainingLabel;

  /// No description provided for @donCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get donCurrencyLabel;

  /// No description provided for @donStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get donStartDate;

  /// No description provided for @donEndDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get donEndDate;

  /// No description provided for @donNoConfirmedYet.
  ///
  /// In en, this message translates to:
  /// **'No confirmed donations have been recorded for this campaign yet.'**
  String get donNoConfirmedYet;

  /// No description provided for @donCampaignClosed.
  ///
  /// In en, this message translates to:
  /// **'This campaign is not accepting donations.'**
  String get donCampaignClosed;

  /// No description provided for @donDemoWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo mode — no payment is processed'**
  String get donDemoWarningTitle;

  /// No description provided for @donDemoWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Real donations cannot be made in this version. Submitting creates a demo record only: no money is taken, it is not added to any total and no receipt is issued. Never enter card numbers, PINs or bank passwords.'**
  String get donDemoWarningBody;

  /// No description provided for @donCampaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get donCampaign;

  /// No description provided for @donSuggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested amounts'**
  String get donSuggested;

  /// No description provided for @donAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount ({code})'**
  String donAmountLabel(String code);

  /// No description provided for @donCurrencyNote.
  ///
  /// In en, this message translates to:
  /// **'Currency: {code}'**
  String donCurrencyNote(String code);

  /// No description provided for @donAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Donate anonymously'**
  String get donAnonymous;

  /// No description provided for @donAnonymousHint.
  ///
  /// In en, this message translates to:
  /// **'Your name will not be recorded or shown.'**
  String get donAnonymousHint;

  /// No description provided for @donDonorNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Your name (optional)'**
  String get donDonorNameOptional;

  /// No description provided for @donDonorContactOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone or email (optional)'**
  String get donDonorContactOptional;

  /// No description provided for @donDonorContactHint.
  ///
  /// In en, this message translates to:
  /// **'Only if you want the mosque to contact you.'**
  String get donDonorContactHint;

  /// No description provided for @donMessageOptional.
  ///
  /// In en, this message translates to:
  /// **'Message (optional)'**
  String get donMessageOptional;

  /// No description provided for @donMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get donMethod;

  /// No description provided for @donMethodNote.
  ///
  /// In en, this message translates to:
  /// **'Payment methods are shown for planning only. No payment provider is connected yet.'**
  String get donMethodNote;

  /// No description provided for @donSubmitDemo.
  ///
  /// In en, this message translates to:
  /// **'Submit (demo — not processed)'**
  String get donSubmitDemo;

  /// No description provided for @donSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get donSubmitError;

  /// No description provided for @donAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount, e.g. 20 or 20.50.'**
  String get donAmountInvalid;

  /// No description provided for @donAmountNotPositive.
  ///
  /// In en, this message translates to:
  /// **'The amount must be greater than zero.'**
  String get donAmountNotPositive;

  /// No description provided for @donAmountDecimals.
  ///
  /// In en, this message translates to:
  /// **'Use at most 2 decimal places.'**
  String get donAmountDecimals;

  /// No description provided for @donAmountTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The amount is too large.'**
  String get donAmountTooLarge;

  /// No description provided for @donDemoDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo submission recorded'**
  String get donDemoDoneTitle;

  /// No description provided for @donDemoDoneBody.
  ///
  /// In en, this message translates to:
  /// **'This was NOT a payment. No money was taken, the amount is not counted in any campaign total and no receipt is issued.'**
  String get donDemoDoneBody;

  /// No description provided for @donReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get donReference;

  /// No description provided for @donAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get donAmount;

  /// No description provided for @donPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get donPaymentStatus;

  /// No description provided for @donDemoNotSavedSignedOut.
  ///
  /// In en, this message translates to:
  /// **'You are not signed in, so this demo record will not appear in your donation history.'**
  String get donDemoNotSavedSignedOut;

  /// No description provided for @donBackToDonations.
  ///
  /// In en, this message translates to:
  /// **'Back to donations'**
  String get donBackToDonations;

  /// No description provided for @donHistorySignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your donation history.'**
  String get donHistorySignIn;

  /// No description provided for @donHistorySearch.
  ///
  /// In en, this message translates to:
  /// **'Search by reference or campaign'**
  String get donHistorySearch;

  /// No description provided for @donPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get donPeriodAll;

  /// No description provided for @donPeriod30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get donPeriod30;

  /// No description provided for @donPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get donPeriodYear;

  /// No description provided for @donHistoryPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only your own donation records are shown here. Anonymous donations never show the donor\'s name.'**
  String get donHistoryPrivacy;

  /// No description provided for @donHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No donations'**
  String get donHistoryEmpty;

  /// No description provided for @donHistoryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You have no donation records yet.'**
  String get donHistoryEmptyMessage;

  /// No description provided for @donHistoryNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No donations match these filters.'**
  String get donHistoryNoMatch;

  /// No description provided for @donReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get donReceipt;

  /// No description provided for @donReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation receipt'**
  String get donReceiptTitle;

  /// No description provided for @donReceiptSample.
  ///
  /// In en, this message translates to:
  /// **'SAMPLE — NOT AN OFFICIAL RECEIPT'**
  String get donReceiptSample;

  /// No description provided for @donDonor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get donDonor;

  /// No description provided for @donAnonymousDonor.
  ///
  /// In en, this message translates to:
  /// **'Anonymous donor'**
  String get donAnonymousDonor;

  /// No description provided for @donDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get donDate;

  /// No description provided for @donReceiptNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get donReceiptNotVerified;

  /// No description provided for @donReceiptThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your donation. May Allah accept it and reward you.'**
  String get donReceiptThanks;

  /// No description provided for @donReceiptUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No receipt available'**
  String get donReceiptUnavailable;

  /// No description provided for @donReceiptUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Receipts exist only for donations verified by the mosque. Demo, pending, failed and voided donations have no receipt.'**
  String get donReceiptUnavailableMessage;

  /// No description provided for @donReceiptExportPending.
  ///
  /// In en, this message translates to:
  /// **'PDF download and sharing of receipts will be added later.'**
  String get donReceiptExportPending;

  /// No description provided for @donStaffNotice.
  ///
  /// In en, this message translates to:
  /// **'Staff tools (demo). Access is only checked inside the app for now; the server will enforce Treasurer / Admin permissions later. Changes are kept on this device only and are lost when the app closes.'**
  String get donStaffNotice;

  /// No description provided for @donRecordOffline.
  ///
  /// In en, this message translates to:
  /// **'Record offline donation'**
  String get donRecordOffline;

  /// No description provided for @donExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get donExpensesTitle;

  /// No description provided for @donReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial reports'**
  String get donReportsTitle;

  /// No description provided for @donPendingReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Pending verification} other{Pending verification ({count})}}'**
  String donPendingReview(int count);

  /// No description provided for @donNoPending.
  ///
  /// In en, this message translates to:
  /// **'No donations are waiting for verification.'**
  String get donNoPending;

  /// No description provided for @donAllRecords.
  ///
  /// In en, this message translates to:
  /// **'All records'**
  String get donAllRecords;

  /// No description provided for @donRecordExplain.
  ///
  /// In en, this message translates to:
  /// **'The donation is saved as PENDING. It is counted only after a separate verification.'**
  String get donRecordExplain;

  /// No description provided for @donExternalReference.
  ///
  /// In en, this message translates to:
  /// **'Transaction reference (optional)'**
  String get donExternalReference;

  /// No description provided for @donRecordSave.
  ///
  /// In en, this message translates to:
  /// **'Save as pending'**
  String get donRecordSave;

  /// No description provided for @donRecordedLocal.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device only (temporary).'**
  String get donRecordedLocal;

  /// No description provided for @donRecordDetails.
  ///
  /// In en, this message translates to:
  /// **'Donation record'**
  String get donRecordDetails;

  /// No description provided for @donRecordNotFound.
  ///
  /// In en, this message translates to:
  /// **'This record was not found.'**
  String get donRecordNotFound;

  /// No description provided for @donRecordedBy.
  ///
  /// In en, this message translates to:
  /// **'Recorded by'**
  String get donRecordedBy;

  /// No description provided for @donConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm (verified)'**
  String get donConfirm;

  /// No description provided for @donConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm this donation?'**
  String get donConfirmTitle;

  /// No description provided for @donConfirmExplain.
  ///
  /// In en, this message translates to:
  /// **'Confirm only after you have verified that the money was actually received (cash counted, or the bank / mobile-money transaction checked).'**
  String get donConfirmExplain;

  /// No description provided for @donVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get donVoid;

  /// No description provided for @donVoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Void this record?'**
  String get donVoidTitle;

  /// No description provided for @donVoidExplain.
  ///
  /// In en, this message translates to:
  /// **'Financial records are never deleted. Voiding excludes the record from totals and keeps it in the audit trail.'**
  String get donVoidExplain;

  /// No description provided for @donVoidReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get donVoidReason;

  /// No description provided for @donAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit trail'**
  String get donAudit;

  /// No description provided for @donAuditNote.
  ///
  /// In en, this message translates to:
  /// **'Kept in memory only in this demo. The server will keep a permanent, insert-only audit log.'**
  String get donAuditNote;

  /// No description provided for @donAuditDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo submission'**
  String get donAuditDemo;

  /// No description provided for @donAuditRecorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get donAuditRecorded;

  /// No description provided for @donAuditConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get donAuditConfirmed;

  /// No description provided for @donAuditVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get donAuditVoided;

  /// No description provided for @donAuditExpenseRecorded.
  ///
  /// In en, this message translates to:
  /// **'Expense recorded'**
  String get donAuditExpenseRecorded;

  /// No description provided for @donAuditExpenseApproved.
  ///
  /// In en, this message translates to:
  /// **'Expense approved'**
  String get donAuditExpenseApproved;

  /// No description provided for @donAuditExpenseRejected.
  ///
  /// In en, this message translates to:
  /// **'Expense rejected'**
  String get donAuditExpenseRejected;

  /// No description provided for @donExpensesNotice.
  ///
  /// In en, this message translates to:
  /// **'Staff only. New expenses must be approved before they are counted in reports.'**
  String get donExpensesNotice;

  /// No description provided for @donExpensesApprovedTotal.
  ///
  /// In en, this message translates to:
  /// **'Approved expenses ({code})'**
  String donExpensesApprovedTotal(String code);

  /// No description provided for @donExpensesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded'**
  String get donExpensesEmpty;

  /// No description provided for @donExpenseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get donExpenseAdd;

  /// No description provided for @donExpenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get donExpenseCategory;

  /// No description provided for @donExpenseReason.
  ///
  /// In en, this message translates to:
  /// **'Business reason'**
  String get donExpenseReason;

  /// No description provided for @donExpensePayee.
  ///
  /// In en, this message translates to:
  /// **'Payee / supplier (optional)'**
  String get donExpensePayee;

  /// No description provided for @donExpenseDocument.
  ///
  /// In en, this message translates to:
  /// **'Attach receipt'**
  String get donExpenseDocument;

  /// No description provided for @donExpensePendingNote.
  ///
  /// In en, this message translates to:
  /// **'The expense is saved as pending approval.'**
  String get donExpensePendingNote;

  /// No description provided for @donExpenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get donExpenseDetails;

  /// No description provided for @donExpenseApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get donExpenseApprove;

  /// No description provided for @donExpenseReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get donExpenseReject;

  /// No description provided for @donExpenseApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get donExpenseApproved;

  /// No description provided for @donExpenseRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get donExpenseRejected;

  /// No description provided for @donExpCatMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get donExpCatMaintenance;

  /// No description provided for @donExpCatElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get donExpCatElectricity;

  /// No description provided for @donExpCatWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get donExpCatWater;

  /// No description provided for @donExpCatCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get donExpCatCleaning;

  /// No description provided for @donExpCatSalaries.
  ///
  /// In en, this message translates to:
  /// **'Salaries'**
  String get donExpCatSalaries;

  /// No description provided for @donExpCatEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get donExpCatEducation;

  /// No description provided for @donExpCatCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community support'**
  String get donExpCatCommunity;

  /// No description provided for @donExpCatOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get donExpCatOther;

  /// No description provided for @donReportSample.
  ///
  /// In en, this message translates to:
  /// **'Calculated from sample data — not the mosque\'s real finances.'**
  String get donReportSample;

  /// No description provided for @donReportDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get donReportDay;

  /// No description provided for @donReportMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get donReportMonth;

  /// No description provided for @donReportYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get donReportYear;

  /// No description provided for @donReportPrev.
  ///
  /// In en, this message translates to:
  /// **'Previous period'**
  String get donReportPrev;

  /// No description provided for @donReportNext.
  ///
  /// In en, this message translates to:
  /// **'Next period'**
  String get donReportNext;

  /// No description provided for @donReportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No confirmed records in this period'**
  String get donReportEmpty;

  /// No description provided for @donReportEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose another period.'**
  String get donReportEmptyMessage;

  /// No description provided for @donReportConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed donations'**
  String get donReportConfirmed;

  /// No description provided for @donReportExpenses.
  ///
  /// In en, this message translates to:
  /// **'Approved expenses'**
  String get donReportExpenses;

  /// No description provided for @donReportNet.
  ///
  /// In en, this message translates to:
  /// **'Net for the period'**
  String get donReportNet;

  /// No description provided for @donReportNetNote.
  ///
  /// In en, this message translates to:
  /// **'Net = confirmed donations − approved expenses in this period. It is not the mosque\'s cash balance.'**
  String get donReportNetNote;

  /// No description provided for @donReportByCampaign.
  ///
  /// In en, this message translates to:
  /// **'By campaign'**
  String get donReportByCampaign;

  /// No description provided for @donReportByMethod.
  ///
  /// In en, this message translates to:
  /// **'By payment method'**
  String get donReportByMethod;

  /// No description provided for @donReportProgress.
  ///
  /// In en, this message translates to:
  /// **'Campaign progress'**
  String get donReportProgress;

  /// No description provided for @donReportRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'How the numbers are calculated'**
  String get donReportRulesTitle;

  /// No description provided for @donReportRules.
  ///
  /// In en, this message translates to:
  /// **'• Confirmed donations: verified donations only — pending, failed, refunded, voided and demo records are excluded.\n• Expenses: approved, non-voided expenses.\n• Net: confirmed donations minus expenses for the selected period.\n• Campaign progress: confirmed campaign donations ÷ target, capped at 100%.\n• Currencies are never mixed: each currency has its own totals.'**
  String get donReportRules;

  /// No description provided for @donReportExportPending.
  ///
  /// In en, this message translates to:
  /// **'CSV / PDF export will be added in a later phase.'**
  String get donReportExportPending;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get tabHome;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get tabSettings;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get tabProfile;

  /// No description provided for @tabAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get tabAbout;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsPending.
  ///
  /// In en, this message translates to:
  /// **'Notifications are not available yet.'**
  String get settingsNotificationsPending;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Somali, English or Arabic'**
  String get settingsLanguageHint;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyPending.
  ///
  /// In en, this message translates to:
  /// **'Will be available when accounts are connected to the server.'**
  String get settingsPrivacyPending;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get settingsHelp;

  /// No description provided for @settingsHelpPending.
  ///
  /// In en, this message translates to:
  /// **'Help pages will be added later.'**
  String get settingsHelpPending;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get settingsAbout;

  /// No description provided for @settingsAboutHint.
  ///
  /// In en, this message translates to:
  /// **'App information and developer'**
  String get settingsAboutHint;

  /// No description provided for @profileTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTabTitle;

  /// No description provided for @profileSignedOutTitle.
  ///
  /// In en, this message translates to:
  /// **'You are not signed in'**
  String get profileSignedOutTitle;

  /// No description provided for @profileSignedOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your account information.'**
  String get profileSignedOutMessage;

  /// No description provided for @profileSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get profileSignIn;

  /// No description provided for @profileAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get profileAccountInfo;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get profileFullName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profilePhone;

  /// No description provided for @profileNotProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get profileNotProvided;

  /// No description provided for @profileAccountType.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get profileAccountType;

  /// No description provided for @profileDemoAccount.
  ///
  /// In en, this message translates to:
  /// **'Demo account (not a real account)'**
  String get profileDemoAccount;

  /// No description provided for @profileDemoNote.
  ///
  /// In en, this message translates to:
  /// **'These details are what you typed when signing in. They are kept in memory only and are not saved or sent anywhere.'**
  String get profileDemoNote;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditProfile;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profileChangePassword;

  /// No description provided for @profileNeedsBackend.
  ///
  /// In en, this message translates to:
  /// **'Available when accounts are connected to the server.'**
  String get profileNeedsBackend;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutDescriptionTitle;

  /// No description provided for @aboutDescription1.
  ///
  /// In en, this message translates to:
  /// **'Masjid Management App is a mobile application designed to simplify mosque management and give the community easy access to important information.'**
  String get aboutDescription1;

  /// No description provided for @aboutDescription2.
  ///
  /// In en, this message translates to:
  /// **'The app aims to bring mosque management services together, so that important information and tasks are available in one place.'**
  String get aboutDescription2;

  /// No description provided for @aboutFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Main features'**
  String get aboutFeaturesTitle;

  /// No description provided for @aboutFeaturesNote.
  ///
  /// In en, this message translates to:
  /// **'\"Available (sample data)\" means the screen works with clearly labelled sample data until the server is connected. \"Coming soon\" features are not built yet.'**
  String get aboutFeaturesNote;

  /// No description provided for @aboutStatusDemo.
  ///
  /// In en, this message translates to:
  /// **'Available (sample data)'**
  String get aboutStatusDemo;

  /// No description provided for @aboutFeaturePrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get aboutFeaturePrayer;

  /// No description provided for @aboutFeaturePrayerDesc.
  ///
  /// In en, this message translates to:
  /// **'The times of the five daily prayers.'**
  String get aboutFeaturePrayerDesc;

  /// No description provided for @aboutFeatureDonations.
  ///
  /// In en, this message translates to:
  /// **'Donations'**
  String get aboutFeatureDonations;

  /// No description provided for @aboutFeatureDonationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Recording and tracking donations.'**
  String get aboutFeatureDonationsDesc;

  /// No description provided for @aboutFeatureEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get aboutFeatureEvents;

  /// No description provided for @aboutFeatureEventsDesc.
  ///
  /// In en, this message translates to:
  /// **'Mosque news and occasions.'**
  String get aboutFeatureEventsDesc;

  /// No description provided for @aboutFeatureQuran.
  ///
  /// In en, this message translates to:
  /// **'Quran Classes'**
  String get aboutFeatureQuran;

  /// No description provided for @aboutFeatureQuranDesc.
  ///
  /// In en, this message translates to:
  /// **'Information about Quran lessons.'**
  String get aboutFeatureQuranDesc;

  /// No description provided for @aboutFeatureAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get aboutFeatureAnnouncements;

  /// No description provided for @aboutFeatureAnnouncementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Important announcements.'**
  String get aboutFeatureAnnouncementsDesc;

  /// No description provided for @aboutFeatureNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get aboutFeatureNotifications;

  /// No description provided for @aboutFeatureNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'App notifications.'**
  String get aboutFeatureNotificationsDesc;

  /// No description provided for @aboutFeatureProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get aboutFeatureProfile;

  /// No description provided for @aboutFeatureProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'User and account information.'**
  String get aboutFeatureProfileDesc;

  /// No description provided for @aboutFeatureSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get aboutFeatureSettings;

  /// No description provided for @aboutFeatureSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'App preferences.'**
  String get aboutFeatureSettingsDesc;

  /// No description provided for @aboutDeveloperTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Developer'**
  String get aboutDeveloperTitle;

  /// No description provided for @aboutEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutEmail;

  /// No description provided for @aboutPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get aboutPhone;

  /// No description provided for @aboutLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get aboutLocation;

  /// No description provided for @aboutEmailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email address copied.'**
  String get aboutEmailCopied;

  /// No description provided for @aboutPhoneCopied.
  ///
  /// In en, this message translates to:
  /// **'Phone number copied.'**
  String get aboutPhoneCopied;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Notifications will appear here once push notifications are connected to the server.'**
  String get notificationsEmptyMessage;

  /// No description provided for @themeSwitchToDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get themeSwitchToDark;

  /// No description provided for @themeSwitchToLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get themeSwitchToLight;

  /// No description provided for @themeDarkActive.
  ///
  /// In en, this message translates to:
  /// **'Dark mode is on'**
  String get themeDarkActive;

  /// No description provided for @themeLightActive.
  ///
  /// In en, this message translates to:
  /// **'Light mode is on'**
  String get themeLightActive;

  /// No description provided for @homeMenuProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get homeMenuProjects;

  /// No description provided for @projTitle.
  ///
  /// In en, this message translates to:
  /// **'Mosque Projects'**
  String get projTitle;

  /// No description provided for @projAdd.
  ///
  /// In en, this message translates to:
  /// **'Add project'**
  String get projAdd;

  /// No description provided for @projEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit project'**
  String get projEditTitle;

  /// No description provided for @projDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Project details'**
  String get projDetailsTitle;

  /// No description provided for @projSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search projects by name'**
  String get projSearchHint;

  /// No description provided for @projSampleTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample projects — not real'**
  String get projSampleTitle;

  /// No description provided for @projSampleMessage.
  ///
  /// In en, this message translates to:
  /// **'These projects, amounts and updates are sample (mock) data for testing the design. They are not real projects of the mosque.'**
  String get projSampleMessage;

  /// No description provided for @projEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No projects'**
  String get projEmptyTitle;

  /// No description provided for @projEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Mosque projects will appear here once they are published.'**
  String get projEmptyMessage;

  /// No description provided for @projNoResults.
  ///
  /// In en, this message translates to:
  /// **'No projects found'**
  String get projNoResults;

  /// No description provided for @projFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured projects'**
  String get projFeatured;

  /// No description provided for @projOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing projects'**
  String get projOngoing;

  /// No description provided for @projRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get projRecent;

  /// No description provided for @projNotFound.
  ///
  /// In en, this message translates to:
  /// **'This project was not found.'**
  String get projNotFound;

  /// No description provided for @projStatusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get projStatusPlanned;

  /// No description provided for @projStatusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get projStatusOngoing;

  /// No description provided for @projStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get projStatusPaused;

  /// No description provided for @projStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get projStatusCompleted;

  /// No description provided for @projStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get projStatusCancelled;

  /// No description provided for @projMilestonePending.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get projMilestonePending;

  /// No description provided for @projMilestoneInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get projMilestoneInProgress;

  /// No description provided for @projMilestoneCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get projMilestoneCompleted;

  /// No description provided for @projPhysicalProgress.
  ///
  /// In en, this message translates to:
  /// **'Work progress'**
  String get projPhysicalProgress;

  /// No description provided for @projProgressUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not reported'**
  String get projProgressUnknown;

  /// No description provided for @projExpectedEnd.
  ///
  /// In en, this message translates to:
  /// **'Expected end {date}'**
  String projExpectedEnd(String date);

  /// No description provided for @projStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts {date}'**
  String projStarts(String date);

  /// No description provided for @projInfo.
  ///
  /// In en, this message translates to:
  /// **'Project information'**
  String get projInfo;

  /// No description provided for @projCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get projCategory;

  /// No description provided for @projMosque.
  ///
  /// In en, this message translates to:
  /// **'Mosque'**
  String get projMosque;

  /// No description provided for @projLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get projLocation;

  /// No description provided for @projManager.
  ///
  /// In en, this message translates to:
  /// **'Project manager / department'**
  String get projManager;

  /// No description provided for @projExpectedEndLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected completion'**
  String get projExpectedEndLabel;

  /// No description provided for @projLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get projLastUpdated;

  /// No description provided for @projObjectives.
  ///
  /// In en, this message translates to:
  /// **'Objectives'**
  String get projObjectives;

  /// No description provided for @projBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'Expected beneficiaries'**
  String get projBeneficiaries;

  /// No description provided for @projFunding.
  ///
  /// In en, this message translates to:
  /// **'Funding'**
  String get projFunding;

  /// No description provided for @projBudget.
  ///
  /// In en, this message translates to:
  /// **'Total budget'**
  String get projBudget;

  /// No description provided for @projFundingTarget.
  ///
  /// In en, this message translates to:
  /// **'Funding target'**
  String get projFundingTarget;

  /// No description provided for @projApprovedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Approved project expenses (staff)'**
  String get projApprovedExpenses;

  /// No description provided for @projFundingRule.
  ///
  /// In en, this message translates to:
  /// **'Raised = confirmed donations to this project\'s campaign only. Pending and demo donations are not counted. The remaining target is not the mosque\'s cash balance, and the budget is not money already spent.'**
  String get projFundingRule;

  /// No description provided for @projNoCampaign.
  ///
  /// In en, this message translates to:
  /// **'No fundraising campaign is linked to this project, so donations are not open.'**
  String get projNoCampaign;

  /// No description provided for @projReportsPending.
  ///
  /// In en, this message translates to:
  /// **'Published financial reports for projects will be added when the server is connected.'**
  String get projReportsPending;

  /// No description provided for @projProgress.
  ///
  /// In en, this message translates to:
  /// **'Work progress'**
  String get projProgress;

  /// No description provided for @projProgressSeparate.
  ///
  /// In en, this message translates to:
  /// **'Work progress is reported by the administrator and is separate from funding: raising 60% of the budget does not mean the work is 60% done.'**
  String get projProgressSeparate;

  /// No description provided for @projMilestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get projMilestones;

  /// No description provided for @projDue.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String projDue(String date);

  /// No description provided for @projUpdates.
  ///
  /// In en, this message translates to:
  /// **'Progress updates'**
  String get projUpdates;

  /// No description provided for @projAddUpdate.
  ///
  /// In en, this message translates to:
  /// **'Add update'**
  String get projAddUpdate;

  /// No description provided for @projEditUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit update'**
  String get projEditUpdateTitle;

  /// No description provided for @projNoUpdates.
  ///
  /// In en, this message translates to:
  /// **'No published updates yet.'**
  String get projNoUpdates;

  /// No description provided for @projDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get projDraft;

  /// No description provided for @projEditedTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Edited once (earlier version kept)} other{Edited {count} times (earlier versions kept)}}'**
  String projEditedTimes(int count);

  /// No description provided for @projHistory.
  ///
  /// In en, this message translates to:
  /// **'Change history'**
  String get projHistory;

  /// No description provided for @projDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate to this project'**
  String get projDonate;

  /// No description provided for @projClosedForDonations.
  ///
  /// In en, this message translates to:
  /// **'This project is not accepting donations.'**
  String get projClosedForDonations;

  /// No description provided for @projDonatingTo.
  ///
  /// In en, this message translates to:
  /// **'Donating to the project'**
  String get projDonatingTo;

  /// No description provided for @projErrorAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount, e.g. 5000 or 5000.50.'**
  String get projErrorAmount;

  /// No description provided for @projErrorNegative.
  ///
  /// In en, this message translates to:
  /// **'The amount cannot be negative.'**
  String get projErrorNegative;

  /// No description provided for @projErrorDates.
  ///
  /// In en, this message translates to:
  /// **'The expected completion date cannot be before the start date.'**
  String get projErrorDates;

  /// No description provided for @projErrorPercent.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from 0 to 100.'**
  String get projErrorPercent;

  /// No description provided for @projFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Project title'**
  String get projFieldTitle;

  /// No description provided for @projFieldSummary.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get projFieldSummary;

  /// No description provided for @projBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Total budget ({code})'**
  String projBudgetLabel(String code);

  /// No description provided for @projFundingTargetOptional.
  ///
  /// In en, this message translates to:
  /// **'Funding target ({code}, optional — defaults to the budget)'**
  String projFundingTargetOptional(String code);

  /// No description provided for @projLinkedCampaign.
  ///
  /// In en, this message translates to:
  /// **'Fundraising campaign'**
  String get projLinkedCampaign;

  /// No description provided for @projLinkedCampaignHint.
  ///
  /// In en, this message translates to:
  /// **'Donations to this campaign count as funds for the project. Only campaigns in the same currency are listed.'**
  String get projLinkedCampaignHint;

  /// No description provided for @projNoCampaignOption.
  ///
  /// In en, this message translates to:
  /// **'None (donations not open)'**
  String get projNoCampaignOption;

  /// No description provided for @projPhysicalProgressField.
  ///
  /// In en, this message translates to:
  /// **'Work progress % (optional)'**
  String get projPhysicalProgressField;

  /// No description provided for @projProgressNote.
  ///
  /// In en, this message translates to:
  /// **'Progress description'**
  String get projProgressNote;

  /// No description provided for @projFeaturedSwitch.
  ///
  /// In en, this message translates to:
  /// **'Featured project'**
  String get projFeaturedSwitch;

  /// No description provided for @projUploadImages.
  ///
  /// In en, this message translates to:
  /// **'Add images'**
  String get projUploadImages;

  /// No description provided for @projImagesPending.
  ///
  /// In en, this message translates to:
  /// **'Image upload will work once storage (server) is connected.'**
  String get projImagesPending;

  /// No description provided for @projAddMilestone.
  ///
  /// In en, this message translates to:
  /// **'Add milestone'**
  String get projAddMilestone;

  /// No description provided for @projRemoveMilestone.
  ///
  /// In en, this message translates to:
  /// **'Remove milestone'**
  String get projRemoveMilestone;

  /// No description provided for @projMilestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestone title'**
  String get projMilestoneTitle;

  /// No description provided for @projDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get projDueDate;

  /// No description provided for @projHistoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Project created'**
  String get projHistoryCreated;

  /// No description provided for @projHistoryEdited.
  ///
  /// In en, this message translates to:
  /// **'Project edited'**
  String get projHistoryEdited;

  /// No description provided for @projHistoryBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget {from} → {to}'**
  String projHistoryBudget(String from, String to);

  /// No description provided for @projHistoryStatus.
  ///
  /// In en, this message translates to:
  /// **'Status {from} → {to}'**
  String projHistoryStatus(String from, String to);

  /// No description provided for @projHistoryCampaign.
  ///
  /// In en, this message translates to:
  /// **'Fundraising campaign changed'**
  String get projHistoryCampaign;

  /// No description provided for @projUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update title'**
  String get projUpdateTitle;

  /// No description provided for @projUpdatePercent.
  ///
  /// In en, this message translates to:
  /// **'Progress % (optional)'**
  String get projUpdatePercent;

  /// No description provided for @projUpdateMilestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone achieved (optional)'**
  String get projUpdateMilestone;

  /// No description provided for @projPublishSwitch.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get projPublishSwitch;

  /// No description provided for @projPublishHint.
  ///
  /// In en, this message translates to:
  /// **'Only published updates are visible to members.'**
  String get projPublishHint;

  /// No description provided for @projExpenseProject.
  ///
  /// In en, this message translates to:
  /// **'Project (optional)'**
  String get projExpenseProject;
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
