// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Somali (`so`).
class AppLocalizationsSo extends AppLocalizations {
  AppLocalizationsSo([String locale = 'so']) : super(locale);

  @override
  String get appName => 'Maamulka Masjidka';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSomali => 'Soomaali';

  @override
  String get languageArabic => 'العربية';

  @override
  String get language => 'Luqadda';

  @override
  String get commonOk => 'Haye';

  @override
  String get commonCancel => 'Jooji';

  @override
  String get commonSave => 'Kaydi';

  @override
  String get commonContinue => 'Sii wad';

  @override
  String get commonRetry => 'Isku day mar kale';

  @override
  String get commonSeeAll => 'Dhammaan';

  @override
  String get commonLoading => 'Waa la soo rarayaa…';

  @override
  String get commonClose => 'Xir';

  @override
  String get commonBack => 'Dib u noqo';

  @override
  String get errorGenericTitle => 'Wax baa khaldamay';

  @override
  String get errorGenericMessage =>
      'Hadda lama soo rari karo. Fadlan hubi internetkaaga oo isku day mar kale.';

  @override
  String get errorOfflineTitle => 'Internet ma lihid';

  @override
  String get errorOfflineMessage =>
      'Waxaa la tusayaa xogta la kaydiyey. Qaar ka mid ah ficillada waxay u baahan yihiin internet.';

  @override
  String get emptyGenericTitle => 'Weli wax ma jiraan';

  @override
  String get emptyGenericMessage =>
      'Marka wax la muujin karo jiraan, halkan ayay ka soo muuqan doonaan.';

  @override
  String get validationRequired => 'Meeshan waa in la buuxiyaa';

  @override
  String get validationEmail => 'Geli email sax ah';

  @override
  String get validationPhone => 'Geli lambar taleefan oo sax ah';

  @override
  String validationPasswordLength(int min) {
    return 'Furaha sirta ahi waa inuu ka koobnaadaa ugu yaraan $min xaraf';
  }

  @override
  String get showPassword => 'Muuji furaha sirta';

  @override
  String get hidePassword => 'Qari furaha sirta';

  @override
  String get statusApproved => 'La oggolaaday';

  @override
  String get statusPending => 'Sugaya';

  @override
  String get statusRejected => 'La diiday';

  @override
  String get statusPresent => 'Joogay';

  @override
  String get statusAbsent => 'Maqnaa';

  @override
  String get statusLate => 'Daahay';

  @override
  String get statusExcused => 'Fasax';

  @override
  String get galleryTitle => 'Qaybaha naqshadda';

  @override
  String get galleryButtons => 'Badhamada';

  @override
  String get galleryInputs => 'Meelaha qoraalka';

  @override
  String get galleryCards => 'Kaararka';

  @override
  String get galleryStates => 'Xaaladaha';

  @override
  String get galleryChips => 'Calaamadaha xaaladda';

  @override
  String get galleryOpen => 'Eeg qaybaha naqshadda';

  @override
  String get galleryPrimary => 'Diiwaangeli deeq';

  @override
  String get gallerySecondary => 'Eeg rasiidka';

  @override
  String get galleryAccent => 'Hadda deeq bixi';

  @override
  String get galleryTextButton => 'Ka bood';

  @override
  String get galleryDestructive => 'Buri';

  @override
  String get galleryFullName => 'Magaca oo buuxa';

  @override
  String get galleryFullNameHint => 'tusaale: Axmed Cabdi';

  @override
  String get galleryPassword => 'Furaha sirta';

  @override
  String get galleryAmount => 'Lacagta';

  @override
  String get galleryNextPrayer => 'Salaadda xigta';

  @override
  String get galleryCardTitle => 'Xalqadda habeenka Jimcaha';

  @override
  String get galleryCardBody => 'Hoolka weyn · 7:30 fiidnimo';

  @override
  String get galleryTintedBody =>
      'Deeqdaadu waxay gacan ka geysataa dayactirka masjidka.';
}
