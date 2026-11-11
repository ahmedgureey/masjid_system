// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'إدارة المسجد';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSomali => 'Soomaali';

  @override
  String get languageArabic => 'العربية';

  @override
  String get language => 'اللغة';

  @override
  String get commonOk => 'حسنًا';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonRetry => 'أعد المحاولة';

  @override
  String get commonSeeAll => 'عرض الكل';

  @override
  String get commonLoading => 'جارٍ التحميل…';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonBack => 'رجوع';

  @override
  String get errorGenericTitle => 'حدث خطأ ما';

  @override
  String get errorGenericMessage =>
      'تعذّر التحميل الآن. يرجى التحقق من الاتصال والمحاولة مرة أخرى.';

  @override
  String get errorOfflineTitle => 'أنت غير متصل';

  @override
  String get errorOfflineMessage =>
      'يتم عرض البيانات المحفوظة. بعض الإجراءات تتطلب اتصالًا بالإنترنت.';

  @override
  String get emptyGenericTitle => 'لا يوجد شيء بعد';

  @override
  String get emptyGenericMessage => 'عندما يتوفر محتوى سيظهر هنا.';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get validationPhone => 'أدخل رقم هاتف صحيحًا';

  @override
  String validationPasswordLength(int min) {
    return 'يجب ألا تقل كلمة المرور عن $min أحرف';
  }

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get statusApproved => 'مقبول';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusRejected => 'مرفوض';

  @override
  String get statusPresent => 'حاضر';

  @override
  String get statusAbsent => 'غائب';

  @override
  String get statusLate => 'متأخر';

  @override
  String get statusExcused => 'معذور';

  @override
  String get galleryTitle => 'المكونات';

  @override
  String get galleryButtons => 'الأزرار';

  @override
  String get galleryInputs => 'حقول الإدخال';

  @override
  String get galleryCards => 'البطاقات';

  @override
  String get galleryStates => 'الحالات';

  @override
  String get galleryChips => 'شارات الحالة';

  @override
  String get galleryOpen => 'عرض المكونات';

  @override
  String get galleryPrimary => 'تسجيل تبرع';

  @override
  String get gallerySecondary => 'عرض الإيصال';

  @override
  String get galleryAccent => 'تبرّع الآن';

  @override
  String get galleryTextButton => 'تخطي';

  @override
  String get galleryDestructive => 'إلغاء القيد';

  @override
  String get galleryFullName => 'الاسم الكامل';

  @override
  String get galleryFullNameHint => 'مثال: أحمد عبدي';

  @override
  String get galleryPassword => 'كلمة المرور';

  @override
  String get galleryAmount => 'المبلغ';

  @override
  String get galleryNextPrayer => 'الصلاة القادمة';

  @override
  String get galleryCardTitle => 'حلقة ليلة الجمعة';

  @override
  String get galleryCardBody => 'القاعة الرئيسية · 7:30 م';

  @override
  String get galleryTintedBody => 'تبرعك يساعد في صيانة المسجد.';
}
