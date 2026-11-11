// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Masjid Management App';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSomali => 'Soomaali';

  @override
  String get languageArabic => 'العربية';

  @override
  String get language => 'Language';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage =>
      'We couldn\'t load this right now. Please check your connection and try again.';

  @override
  String get errorOfflineTitle => 'You\'re offline';

  @override
  String get errorOfflineMessage =>
      'Showing saved data. Some actions need an internet connection.';

  @override
  String get emptyGenericTitle => 'Nothing here yet';

  @override
  String get emptyGenericMessage =>
      'When there is something to show, it will appear here.';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Enter a valid email address';

  @override
  String get validationPhone => 'Enter a valid phone number';

  @override
  String validationPasswordLength(int min) {
    return 'Password must be at least $min characters';
  }

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusPresent => 'Present';

  @override
  String get statusAbsent => 'Absent';

  @override
  String get statusLate => 'Late';

  @override
  String get statusExcused => 'Excused';

  @override
  String get galleryTitle => 'Components';

  @override
  String get galleryButtons => 'Buttons';

  @override
  String get galleryInputs => 'Input fields';

  @override
  String get galleryCards => 'Cards';

  @override
  String get galleryStates => 'States';

  @override
  String get galleryChips => 'Status chips';

  @override
  String get galleryOpen => 'View components';

  @override
  String get galleryPrimary => 'Record donation';

  @override
  String get gallerySecondary => 'View receipt';

  @override
  String get galleryAccent => 'Donate now';

  @override
  String get galleryTextButton => 'Skip';

  @override
  String get galleryDestructive => 'Void';

  @override
  String get galleryFullName => 'Full name';

  @override
  String get galleryFullNameHint => 'e.g. Ahmed Abdi';

  @override
  String get galleryPassword => 'Password';

  @override
  String get galleryAmount => 'Amount';

  @override
  String get galleryNextPrayer => 'Next prayer';

  @override
  String get galleryCardTitle => 'Friday Night Halaqa';

  @override
  String get galleryCardBody => 'Main hall · 7:30 PM';

  @override
  String get galleryTintedBody => 'Your donation helps maintain the mosque.';
}
