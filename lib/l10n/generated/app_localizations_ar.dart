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

  @override
  String get splashTagline => 'مسجدك في مكان واحد';

  @override
  String get languageTitle => 'اختر لغتك';

  @override
  String get languageSubtitle => 'يمكنك تغييرها لاحقًا من الإعدادات.';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ';

  @override
  String get onboarding1Title => 'لا تفوّتك صلاة';

  @override
  String get onboarding1Body =>
      'مواقيت دقيقة للصلاة والإقامة، وتذكيرات، واتجاه القبلة لمسجدك.';

  @override
  String get onboarding2Title => 'تبرّع بثقة';

  @override
  String get onboarding2Body => 'ادعم مسجدك وشاهد أثر تبرعاتك.';

  @override
  String get onboarding3Title => 'تعلّم وابقَ على تواصل';

  @override
  String get onboarding3Body =>
      'حلقات القرآن والفعاليات والإعلانات في مكان واحد.';

  @override
  String onboardingPageLabel(int current, int total) {
    return 'الصفحة $current من $total';
  }

  @override
  String get welcomeGreeting => 'السلام عليكم';

  @override
  String get welcomeTitle => 'مرحبًا بك في إدارة المسجد';

  @override
  String get welcomeSubtitle =>
      'مواقيت الصلاة والتبرعات والحلقات وأخبار المجتمع لمسجدك.';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get welcomeTerms =>
      'بالمتابعة، فإنك توافق على شروط الاستخدام وسياسة الخصوصية.';

  @override
  String get comingSoonTitle => 'قريبًا';

  @override
  String get comingSoonMessage => 'ستُبنى هذه الشاشة في الوحدة التالية.';

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول إلى حسابك';

  @override
  String get fieldEmail => 'البريد الإلكتروني';

  @override
  String get fieldEmailHint => 'name@example.com';

  @override
  String get fieldPassword => 'كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginNoAccount => 'ليس لديك حساب؟';

  @override
  String get registerTitle => 'أنشئ حسابك';

  @override
  String get registerSubtitle => 'انضم إلى مجتمع مسجدك';

  @override
  String get fieldFullName => 'الاسم الكامل';

  @override
  String get fieldFullNameHint => 'مثال: أحمد عبدي حسن';

  @override
  String get fieldPhone => 'رقم الهاتف';

  @override
  String get fieldOptional => '(اختياري)';

  @override
  String get fieldPhoneHint => '+252 61 234 5678';

  @override
  String get fieldConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordHelper => '8 أحرف على الأقل';

  @override
  String get validationPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get validationNameShort => 'أدخل اسمك الكامل';

  @override
  String get termsAgree => 'أوافق على شروط الاستخدام وسياسة الخصوصية';

  @override
  String get validationTerms => 'يجب الموافقة على الشروط للمتابعة';

  @override
  String get registerHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get mockTitle => 'غير متاح بعد';

  @override
  String get mockLoginMessage =>
      'بياناتك تبدو صحيحة، لكن تسجيل الدخول سيعمل فقط بعد ربط التطبيق بالخادم. لم يتم حفظ أي شيء.';

  @override
  String get mockRegisterMessage =>
      'بياناتك تبدو صحيحة، لكن إنشاء الحساب سيعمل فقط بعد ربط التطبيق بالخادم. لم يتم حفظ أي شيء.';

  @override
  String get mockResetMessage =>
      'سيتم إرسال رسائل إعادة تعيين كلمة المرور بعد ربط التطبيق بالخادم. لم يتم إرسال أي شيء.';

  @override
  String get forgotTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotSubtitle =>
      'أدخل البريد الإلكتروني الذي سجلت به. سنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get forgotSend => 'إرسال الرابط';

  @override
  String get forgotBackToLogin => 'العودة لتسجيل الدخول';

  @override
  String get demoBannerTitle => 'الوضع التجريبي';

  @override
  String get demoBannerMessage =>
      'لقد سجلت الدخول ببيانات تجريبية. لم يُستخدم حساب حقيقي ولم يتم حفظ أي شيء.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String homeGreetingName(String name) {
    return 'السلام عليكم، $name';
  }

  @override
  String get homeMenuProfile => 'عن المسجد';

  @override
  String get homeMenuPrayer => 'مواقيت الصلاة';

  @override
  String get homeMenuCalendar => 'تقويم المسجد';

  @override
  String get homeMenuNews => 'الأخبار والمقالات';

  @override
  String get homeMenuDonations => 'برنامج التبرعات';

  @override
  String get homeMenuContact => 'اتصل بنا';

  @override
  String get coverPhotoPending => 'لم تتم إضافة صورة المسجد بعد';

  @override
  String get homeMenuTitle => 'خدمات المسجد';

  @override
  String get profileTitle => 'معلومات المسجد';

  @override
  String get profileEdit => 'تعديل';

  @override
  String get profileEditTitle => 'تعديل معلومات المسجد';

  @override
  String get profileNoDescription => 'لم يُضف وصف بعد.';

  @override
  String get profileNoData => 'لم تُضف معلومات بعد.';

  @override
  String get profileAddInfo => 'إضافة معلومات';

  @override
  String get profileSectionBasic => 'بيانات المسجد';

  @override
  String get profileSectionLocation => 'موقع المسجد';

  @override
  String get profileSectionContact => 'معلومات الاتصال';

  @override
  String get profileSectionLeadership => 'إدارة المسجد';

  @override
  String get profileSectionServices => 'خدمات المسجد';

  @override
  String get profileSectionFacilities => 'مرافق المسجد';

  @override
  String get profileServicesPending =>
      'ستظهر الخدمات هنا عند إضافتها إلى التطبيق.';

  @override
  String get profileLeadershipPrivacy =>
      'تُعرض الأسماء فقط. لا تُنشر بيانات الاتصال الشخصية أبدًا.';

  @override
  String get profileAuthNotice =>
      'التعديل متاح لأنك سجلت الدخول (تجريبي). تُفحص الصلاحيات داخل التطبيق فقط حاليًا، وسيفرضها الخادم لاحقًا.';

  @override
  String get fieldMosqueName => 'اسم المسجد';

  @override
  String get fieldDescription => 'وصف مختصر';

  @override
  String get fieldCategory => 'نوع المسجد';

  @override
  String get categoryJamia => 'جامع (مسجد الجمعة)';

  @override
  String get categoryMasjid => 'مسجد';

  @override
  String get categoryMusalla => 'مصلى';

  @override
  String get fieldEstablished => 'سنة التأسيس';

  @override
  String get fieldRegistration => 'رقم التسجيل';

  @override
  String get fieldCountry => 'الدولة';

  @override
  String get fieldCity => 'المدينة';

  @override
  String get fieldDistrict => 'الحي / المنطقة';

  @override
  String get fieldAddress => 'العنوان الكامل';

  @override
  String get fieldLatitude => 'خط العرض';

  @override
  String get fieldLongitude => 'خط الطول';

  @override
  String get fieldCoordinates => 'إحداثيات GPS';

  @override
  String get fieldWebsite => 'الموقع الإلكتروني';

  @override
  String get fieldSocial => 'وسائل التواصل الاجتماعي';

  @override
  String get fieldImam => 'الإمام';

  @override
  String get fieldChairman => 'رئيس المسجد';

  @override
  String get fieldAdministrator => 'مدير المسجد';

  @override
  String get fieldTreasurer => 'أمين الصندوق';

  @override
  String get fieldLogo => 'الشعار';

  @override
  String get logoUploadPending =>
      'سيكون رفع الشعار ممكنًا بعد ربط التخزين (Supabase).';

  @override
  String get logoUpload => 'رفع الشعار';

  @override
  String get facilityWomen => 'مصلى النساء';

  @override
  String get facilityQuranRooms => 'قاعات تعليم القرآن';

  @override
  String get facilityAblution => 'أماكن الوضوء';

  @override
  String get facilityParking => 'موقف سيارات';

  @override
  String get facilityAccessibility => 'تسهيلات لذوي الإعاقة';

  @override
  String get facilitiesHint => 'اختر فقط المرافق الموجودة فعلًا في المسجد.';

  @override
  String editLanguageNote(String language) {
    return 'يُعدَّل الاسم والوصف للغة الحالية: $language.';
  }

  @override
  String get profileSave => 'حفظ';

  @override
  String get profileCancel => 'إلغاء';

  @override
  String get profileSavedLocal =>
      'حُفظت التغييرات على هذا الجهاز فقط (مؤقتًا). ستُفقد عند إغلاق التطبيق حتى يتم ربط الخادم.';

  @override
  String get profileSaveError => 'تعذّر حفظ التغييرات. يرجى المحاولة مرة أخرى.';

  @override
  String get discardTitle => 'تجاهل التغييرات؟';

  @override
  String get discardMessage =>
      'لديك تغييرات غير محفوظة. إذا غادرت الآن فستُفقد.';

  @override
  String get discardConfirm => 'تجاهل';

  @override
  String get discardKeepEditing => 'متابعة التعديل';

  @override
  String get validationWebsite =>
      'أدخل عنوان موقع صحيحًا (مثل www.example.com)';

  @override
  String validationYear(int min, int max) {
    return 'أدخل سنة صحيحة بين $min و$max';
  }

  @override
  String get validationLatitude => 'يجب أن يكون خط العرض رقمًا بين -90 و90';

  @override
  String get validationLongitude => 'يجب أن يكون خط الطول رقمًا بين -180 و180';

  @override
  String get prayerTitle => 'مواقيت الصلاة';

  @override
  String get prayerNextLabel => 'الصلاة القادمة';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerSunriseNote => 'ليس من الصلوات الخمس المفروضة';

  @override
  String get prayerAdhan => 'الأذان';

  @override
  String get prayerIqamah => 'الإقامة';

  @override
  String get prayerIqamahNotSet => 'لم تُحدَّد';

  @override
  String get prayerDailyTitle => 'الصلوات الخمس';

  @override
  String get prayerNextBadge => 'القادمة';

  @override
  String get prayerTomorrow => 'غدًا';

  @override
  String get prayerCountdownLabel => 'الوقت المتبقي';

  @override
  String get prayerNoNext => 'وقت الصلاة القادمة غير متوفر.';

  @override
  String get prayerLocationMissing => 'لم يُضَف موقع المسجد بعد';

  @override
  String get prayerMockTitle => 'بيانات تجريبية — ليست مواقيت حقيقية';

  @override
  String get prayerMockMessage =>
      'هذه المواقيت قيم تجريبية لاختبار التصميم، وليست مواقيت الصلاة الحقيقية للمسجد. ستظهر المواقيت الحقيقية بعد ضبط موقع المسجد وطريقة الحساب.';

  @override
  String get prayerEmptyTitle => 'لا يوجد جدول للصلاة';

  @override
  String get prayerEmptyMessage => 'لم تُحدَّد مواقيت الصلاة لهذا اليوم بعد.';

  @override
  String get prayerRefresh => 'تحديث';

  @override
  String get calendarTitle => 'تقويم المسجد';

  @override
  String get calendarPrevMonth => 'الشهر السابق';

  @override
  String get calendarNextMonth => 'الشهر التالي';

  @override
  String get calendarToday => 'اليوم';

  @override
  String calendarHijriApprox(String date) {
    return '≈ $date (تقديري)';
  }

  @override
  String get calendarHijriNote =>
      'التواريخ الهجرية تقديرية محسوبة وقد تختلف بيوم أو يومين عن إعلان رؤية الهلال المحلي.';

  @override
  String get calendarOccasionsTitle => 'المناسبات الإسلامية هذا الشهر';

  @override
  String get occasionEstimated => 'تقديري';

  @override
  String get occasionConfirmed => 'مؤكد';

  @override
  String get occasionRamadanStart => 'بداية رمضان';

  @override
  String get occasionEidFitr => 'عيد الفطر';

  @override
  String get occasionEidAdha => 'عيد الأضحى';

  @override
  String get occasionArafah => 'يوم عرفة';

  @override
  String get occasionIslamicNewYear => 'رأس السنة الهجرية';

  @override
  String get occasionAshura => 'عاشوراء';

  @override
  String get eventsUpcomingTitle => 'الفعاليات القادمة';

  @override
  String get eventsAllTitle => 'جميع الفعاليات';

  @override
  String get eventsPastTitle => 'الفعاليات السابقة';

  @override
  String eventsOnDate(String date) {
    return 'فعاليات $date';
  }

  @override
  String get eventsClearDate => 'كل التواريخ';

  @override
  String get eventFilterAll => 'الكل';

  @override
  String get eventFilterUpcoming => 'القادمة';

  @override
  String get eventFilterPast => 'السابقة';

  @override
  String get eventFilterOccasions => 'المناسبات الإسلامية';

  @override
  String get eventCatQuran => 'حلقات القرآن';

  @override
  String get eventCatLectures => 'محاضرات';

  @override
  String get eventCatLessons => 'دروس دينية';

  @override
  String get eventCatCommunity => 'لقاءات الجماعة';

  @override
  String get eventCatChildren => 'برامج الأطفال';

  @override
  String get eventCatYouth => 'برامج الشباب';

  @override
  String get eventCatRamadan => 'برامج رمضان';

  @override
  String get eventCatEid => 'احتفالات العيد';

  @override
  String get eventCatOther => 'فعاليات أخرى';

  @override
  String get eventStatusScheduled => 'مجدولة';

  @override
  String get eventStatusPostponed => 'مؤجلة';

  @override
  String get eventStatusCancelled => 'ملغاة';

  @override
  String get eventTimingUpcoming => 'قادمة';

  @override
  String get eventTimingOngoing => 'جارية الآن';

  @override
  String get eventTimingEnded => 'انتهت';

  @override
  String get eventsEmptyTitle => 'لا توجد فعاليات';

  @override
  String get eventsEmptyMessage => 'لا توجد فعاليات تطابق هذا الاختيار.';

  @override
  String get eventsMockTitle => 'فعاليات تجريبية — ليست حقيقية';

  @override
  String get eventsMockMessage =>
      'هذه الفعاليات بيانات تجريبية لاختبار التصميم، وليست فعاليات حقيقية للمسجد.';

  @override
  String get eventsAuthNotice =>
      'يمكنك إضافة الفعاليات وتعديلها لأنك سجلت الدخول (تجريبي). يتم التحقق من الصلاحية داخل التطبيق فقط حاليًا، وسيتحقق منها الخادم لاحقًا.';

  @override
  String get eventAdd => 'إضافة فعالية';

  @override
  String get eventDetailsTitle => 'تفاصيل الفعالية';

  @override
  String get eventDate => 'التاريخ';

  @override
  String get eventTime => 'الوقت';

  @override
  String get eventLocation => 'المكان';

  @override
  String get eventOrganizer => 'المنظِّم';

  @override
  String get eventCategory => 'الفئة';

  @override
  String get eventDescription => 'الوصف';

  @override
  String get eventRegistrationRequired => 'التسجيل مطلوب';

  @override
  String get eventNotFound => 'لم يتم العثور على هذه الفعالية.';

  @override
  String get eventReminder => 'ذكّرني';

  @override
  String get eventReminderUnavailable =>
      'التذكيرات غير متاحة بعد، وستضاف في مرحلة لاحقة.';

  @override
  String get eventFormNewTitle => 'فعالية جديدة';

  @override
  String get eventFormEditTitle => 'تعديل الفعالية';

  @override
  String get eventFieldTitle => 'عنوان الفعالية';

  @override
  String get eventFieldStart => 'وقت البدء';

  @override
  String get eventFieldEnd => 'وقت الانتهاء';

  @override
  String get eventClearEnd => 'مسح وقت الانتهاء';

  @override
  String get eventFieldStatus => 'الحالة';

  @override
  String get eventFieldImage => 'صورة (اختياري)';

  @override
  String get eventImageUpload => 'رفع صورة';

  @override
  String get eventImagePending => 'سيعمل رفع الصور بعد ربط التخزين (الخادم).';

  @override
  String get eventFieldRegistrationDetails => 'تفاصيل التسجيل';

  @override
  String get eventValidationEndBeforeStart =>
      'يجب أن يكون وقت الانتهاء بعد وقت البدء.';

  @override
  String get eventValidationPastDate => 'لا يمكن أن يكون التاريخ في الماضي.';

  @override
  String get eventValidationChoose => 'يرجى الاختيار';

  @override
  String get eventSavedLocal =>
      'حُفظت الفعالية على هذا الجهاز فقط (مؤقتًا) وستُفقد عند إغلاق التطبيق إلى أن يتم ربط الخادم.';

  @override
  String get eventSaveError => 'تعذّر حفظ الفعالية. يرجى المحاولة مرة أخرى.';
}
