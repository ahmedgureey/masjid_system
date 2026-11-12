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
  String get heroSalahTitle => 'الصلاة ومواقيتها';

  @override
  String get heroSalahSubtitle => 'ابقَ على صلة بالصلوات اليومية.';

  @override
  String get heroQuranTitle => 'القرآن والتعليم الإسلامي';

  @override
  String get heroQuranSubtitle => 'تعلّم القرآن الكريم والعلوم الإسلامية.';

  @override
  String get heroProjectsTitle => 'مشاريع المسجد';

  @override
  String get heroProjectsSubtitle => 'تعرّف على مشاريعنا ومبادرات المجتمع.';

  @override
  String get heroDonationsTitle => 'التبرعات والصدقات';

  @override
  String get heroDonationsSubtitle => 'ادعم مسجدك وساعد المحتاجين.';

  @override
  String get heroEventsTitle => 'المناسبات الإسلامية';

  @override
  String get heroEventsSubtitle => 'تابع مناسبات المسجد وأنشطته.';

  @override
  String get heroCommunityTitle => 'خدمات المجتمع';

  @override
  String get heroCommunitySubtitle => 'نخدم مجتمعنا بالإيمان والوحدة.';

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

  @override
  String get newsTitle => 'الأخبار والمقالات';

  @override
  String get newsSearchHint => 'ابحث في المقالات';

  @override
  String get newsClearSearch => 'مسح البحث';

  @override
  String get newsAllCategories => 'الكل';

  @override
  String get newsFeatured => 'مميز';

  @override
  String get newsLatest => 'آخر الأخبار';

  @override
  String get newsRecommended => 'مقترحة';

  @override
  String get newsAllArticles => 'جميع المقالات';

  @override
  String get newsSortNewest => 'الأحدث أولًا';

  @override
  String get newsSortOldest => 'الأقدم أولًا';

  @override
  String newsResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة',
      one: 'نتيجة واحدة',
      zero: 'لا توجد نتائج',
    );
    return '$_temp0';
  }

  @override
  String get newsClearFilters => 'مسح التصفية';

  @override
  String get newsNoResultsTitle => 'لم يتم العثور على مقالات';

  @override
  String get newsNoResultsMessage => 'جرّب كلمات أخرى أو فئة أخرى.';

  @override
  String get newsEmptyTitle => 'لا توجد مقالات بعد';

  @override
  String get newsEmptyMessage => 'ستظهر هنا الأخبار والمقالات المنشورة.';

  @override
  String newsReadingTime(int minutes) {
    return '$minutes د قراءة';
  }

  @override
  String get newsMockTitle => 'مقالات تجريبية — ليست حقيقية';

  @override
  String get newsMockMessage =>
      'هذه المقالات بيانات تجريبية لاختبار التصميم، وليست أخبارًا حقيقية للمسجد، ولا تتضمن أحكامًا شرعية أو آيات أو أحاديث أو اقتباسات.';

  @override
  String get newsSaved => 'المقالات المحفوظة';

  @override
  String get newsBookmark => 'حفظ المقالة';

  @override
  String get newsRemoveBookmark => 'إزالة من المحفوظات';

  @override
  String get newsBookmarkAdded => 'حُفظت على هذا الجهاز فقط.';

  @override
  String get newsBookmarkRemoved => 'أُزيلت من المقالات المحفوظة.';

  @override
  String get newsBookmarkError =>
      'تعذّر تحديث المحفوظات. يرجى المحاولة مرة أخرى.';

  @override
  String get newsBookmarkLoginRequired => 'سجّل الدخول لحفظ المقالات.';

  @override
  String get newsSignIn => 'تسجيل الدخول';

  @override
  String get newsSavedEmptyTitle => 'لا توجد مقالات محفوظة';

  @override
  String get newsSavedEmptyMessage =>
      'اضغط على أيقونة الحفظ في المقالة لحفظها.';

  @override
  String get newsSavedLocalNote =>
      'تُحفظ المقالات على هذا الجهاز فقط ولا تتم مزامنتها مع الأجهزة الأخرى بعد.';

  @override
  String get newsSavedSignedOut => 'سجّل الدخول لعرض مقالاتك المحفوظة.';

  @override
  String get newsUnavailable => 'هذه المقالة لم تعد متاحة.';

  @override
  String get newsShare => 'مشاركة';

  @override
  String get newsShareError => 'المشاركة غير متاحة حاليًا.';

  @override
  String get newsNotFound => 'لم يتم العثور على هذه المقالة.';

  @override
  String newsPublished(String date) {
    return 'نُشرت $date';
  }

  @override
  String newsUpdated(String date) {
    return 'حُدّثت $date';
  }

  @override
  String get newsReferences => 'المراجع';

  @override
  String get newsRelated => 'مقالات ذات صلة';

  @override
  String get donTitle => 'التبرعات';

  @override
  String get donIntro =>
      'تساعد تبرعاتك في صيانة المسجد ودعم تعليم القرآن ومساعدة الأسر المحتاجة. جزاك الله خيرًا.';

  @override
  String get donSampleTitle => 'بيانات تجريبية — ليست حملات أو أموالًا حقيقية';

  @override
  String get donSampleMessage =>
      'هذه الحملات والمبالغ والسجلات بيانات تجريبية لاختبار التصميم. لا تُجمع أي أموال ولا تتم معالجة أي دفع.';

  @override
  String get donConfirmedVsPendingTitle => 'المؤكدة والمعلّقة';

  @override
  String get donConfirmedVsPendingBody =>
      'لا تُحتسب كمؤكدة إلا التبرعات التي تحقق منها أمين صندوق المسجد. تُعرض التبرعات المعلّقة بشكل منفصل ولا تُضاف إلى المجاميع.';

  @override
  String get donActiveCampaigns => 'الحملات النشطة';

  @override
  String get donSeeAll => 'عرض الكل';

  @override
  String get donNoCampaigns => 'لا توجد حملات';

  @override
  String get donNoCampaignsMessage => 'لا توجد حملات تبرع نشطة حاليًا.';

  @override
  String get donNoCampaignsFilter => 'لا توجد حملات تطابق هذا التصفية.';

  @override
  String get donDonate => 'تبرّع';

  @override
  String get donHistoryTitle => 'سجل التبرعات';

  @override
  String get donCampaignsTitle => 'الحملات';

  @override
  String get donStaffTitle => 'إدارة التبرعات';

  @override
  String get donFilterAll => 'الكل';

  @override
  String get donAllCategories => 'كل الفئات';

  @override
  String get donAllMethods => 'كل الطرق';

  @override
  String get donCatConstruction => 'بناء المسجد';

  @override
  String get donCatMaintenance => 'صيانة المسجد';

  @override
  String get donCatUtilities => 'الكهرباء والماء';

  @override
  String get donCatQuran => 'تعليم القرآن';

  @override
  String get donCatFamilies => 'دعم الأسر المحتاجة';

  @override
  String get donCatRamadan => 'توزيع الطعام في رمضان';

  @override
  String get donCatGeneral => 'تبرعات عامة للمسجد';

  @override
  String get donCampaignDraft => 'مسودة';

  @override
  String get donCampaignActive => 'نشطة';

  @override
  String get donCampaignCompleted => 'مكتملة';

  @override
  String get donCampaignArchived => 'مؤرشفة';

  @override
  String get donMethodCash => 'نقدًا';

  @override
  String get donMethodBank => 'تحويل بنكي';

  @override
  String get donMethodMobile => 'محفظة هاتف';

  @override
  String get donMethodOnline => 'دفع إلكتروني';

  @override
  String get donStatusPending => 'معلّقة';

  @override
  String get donStatusConfirmed => 'مؤكدة';

  @override
  String get donStatusFailed => 'فشلت';

  @override
  String get donStatusRefunded => 'مستردة';

  @override
  String get donStatusDemo => 'تجريبي — لم يُعالج';

  @override
  String get donStatusVoided => 'ملغاة';

  @override
  String donProgressSemantics(String raised, String target, int percent) {
    return '$raised مؤكدة من $target، $percent بالمئة';
  }

  @override
  String donRaisedOf(String target) {
    return 'من $target';
  }

  @override
  String donRemaining(String amount) {
    return 'المتبقي $amount';
  }

  @override
  String donPendingNotCounted(String amount) {
    return 'بانتظار التحقق (غير محتسب): $amount';
  }

  @override
  String get donCampaignDetails => 'تفاصيل الحملة';

  @override
  String get donCampaignNotFound => 'لم يتم العثور على هذه الحملة.';

  @override
  String get donTarget => 'الهدف';

  @override
  String get donConfirmedReceived => 'التبرعات المؤكدة المستلمة';

  @override
  String get donRemainingLabel => 'المتبقي';

  @override
  String get donCurrencyLabel => 'العملة';

  @override
  String get donStartDate => 'تاريخ البدء';

  @override
  String get donEndDate => 'تاريخ الانتهاء';

  @override
  String get donNoConfirmedYet => 'لم تُسجل بعد تبرعات مؤكدة لهذه الحملة.';

  @override
  String get donCampaignClosed => 'هذه الحملة لا تقبل التبرعات حاليًا.';

  @override
  String get donDemoWarningTitle => 'وضع تجريبي — لا تتم معالجة أي دفع';

  @override
  String get donDemoWarningBody =>
      'لا يمكن التبرع فعليًا في هذا الإصدار. الإرسال ينشئ سجلًا تجريبيًا فقط: لا تُؤخذ أي أموال، ولا يُضاف إلى أي مجموع، ولا يصدر إيصال. لا تُدخل أبدًا أرقام البطاقات أو الرموز السرية أو كلمات مرور البنك.';

  @override
  String get donCampaign => 'الحملة';

  @override
  String get donSuggested => 'مبالغ مقترحة';

  @override
  String donAmountLabel(String code) {
    return 'المبلغ ($code)';
  }

  @override
  String donCurrencyNote(String code) {
    return 'العملة: $code';
  }

  @override
  String get donAnonymous => 'تبرّع دون ذكر الاسم';

  @override
  String get donAnonymousHint => 'لن يُسجل اسمك ولن يُعرض.';

  @override
  String get donDonorNameOptional => 'اسمك (اختياري)';

  @override
  String get donDonorContactOptional => 'الهاتف أو البريد (اختياري)';

  @override
  String get donDonorContactHint => 'فقط إذا أردت أن يتواصل معك المسجد.';

  @override
  String get donMessageOptional => 'رسالة (اختياري)';

  @override
  String get donMethod => 'طريقة الدفع';

  @override
  String get donMethodNote =>
      'طرق الدفع معروضة للتخطيط فقط. لم يتم ربط أي مزوّد دفع بعد.';

  @override
  String get donSubmitDemo => 'إرسال (تجريبي — لن يُعالج)';

  @override
  String get donSubmitError => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get donAmountInvalid => 'أدخل مبلغًا صحيحًا، مثل 20 أو 20.50.';

  @override
  String get donAmountNotPositive => 'يجب أن يكون المبلغ أكبر من صفر.';

  @override
  String get donAmountDecimals => 'استخدم منزلتين عشريتين على الأكثر.';

  @override
  String get donAmountTooLarge => 'المبلغ كبير جدًا.';

  @override
  String get donDemoDoneTitle => 'تم تسجيل الإرسال التجريبي';

  @override
  String get donDemoDoneBody =>
      'لم يكن هذا دفعًا. لم تُؤخذ أي أموال، ولا يُحتسب المبلغ في أي حملة، ولا يصدر إيصال.';

  @override
  String get donReference => 'المرجع';

  @override
  String get donAmount => 'المبلغ';

  @override
  String get donPaymentStatus => 'حالة الدفع';

  @override
  String get donDemoNotSavedSignedOut =>
      'لم تسجّل الدخول، لذلك لن يظهر هذا السجل التجريبي في سجل تبرعاتك.';

  @override
  String get donBackToDonations => 'العودة إلى التبرعات';

  @override
  String get donHistorySignIn => 'سجّل الدخول لعرض سجل تبرعاتك.';

  @override
  String get donHistorySearch => 'ابحث بالمرجع أو الحملة';

  @override
  String get donPeriodAll => 'كل الأوقات';

  @override
  String get donPeriod30 => 'آخر 30 يومًا';

  @override
  String get donPeriodYear => 'هذا العام';

  @override
  String get donHistoryPrivacy =>
      'تُعرض هنا سجلات تبرعاتك فقط. التبرعات المجهولة لا تُظهر اسم المتبرع أبدًا.';

  @override
  String get donHistoryEmpty => 'لا توجد تبرعات';

  @override
  String get donHistoryEmptyMessage => 'لا توجد لديك سجلات تبرع بعد.';

  @override
  String get donHistoryNoMatch => 'لا توجد تبرعات تطابق هذه التصفية.';

  @override
  String get donReceipt => 'إيصال';

  @override
  String get donReceiptTitle => 'إيصال التبرع';

  @override
  String get donReceiptSample => 'نموذج — ليس إيصالًا رسميًا';

  @override
  String get donDonor => 'المتبرع';

  @override
  String get donAnonymousDonor => 'متبرع مجهول';

  @override
  String get donDate => 'التاريخ';

  @override
  String get donReceiptNotVerified => 'غير مؤكد';

  @override
  String get donReceiptThanks => 'شكرًا لتبرعك. تقبّل الله منك وجزاك خيرًا.';

  @override
  String get donReceiptUnavailable => 'لا يوجد إيصال';

  @override
  String get donReceiptUnavailableMessage =>
      'تصدر الإيصالات فقط للتبرعات التي تحقق منها المسجد. التبرعات التجريبية والمعلّقة والفاشلة والملغاة ليس لها إيصال.';

  @override
  String get donReceiptExportPending =>
      'سيُضاف تنزيل الإيصال بصيغة PDF ومشاركته لاحقًا.';

  @override
  String get donStaffNotice =>
      'أدوات الموظفين (تجريبية). يتم التحقق من الصلاحية داخل التطبيق فقط حاليًا، وسيفرض الخادم صلاحيات أمين الصندوق / المسؤول لاحقًا. التغييرات محفوظة على هذا الجهاز فقط وتُفقد عند إغلاق التطبيق.';

  @override
  String get donRecordOffline => 'تسجيل تبرع خارج التطبيق';

  @override
  String get donExpensesTitle => 'المصروفات';

  @override
  String get donReportsTitle => 'التقارير المالية';

  @override
  String donPendingReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بانتظار التحقق ($count)',
      zero: 'بانتظار التحقق',
    );
    return '$_temp0';
  }

  @override
  String get donNoPending => 'لا توجد تبرعات بانتظار التحقق.';

  @override
  String get donAllRecords => 'كل السجلات';

  @override
  String get donRecordExplain =>
      'يُحفظ التبرع كمعلّق، ولا يُحتسب إلا بعد تحقق منفصل.';

  @override
  String get donExternalReference => 'مرجع المعاملة (اختياري)';

  @override
  String get donRecordSave => 'حفظ كمعلّق';

  @override
  String get donRecordedLocal => 'حُفظ على هذا الجهاز فقط (مؤقتًا).';

  @override
  String get donRecordDetails => 'سجل التبرع';

  @override
  String get donRecordNotFound => 'لم يتم العثور على هذا السجل.';

  @override
  String get donRecordedBy => 'سجّله';

  @override
  String get donConfirm => 'تأكيد (تم التحقق)';

  @override
  String get donConfirmTitle => 'تأكيد هذا التبرع؟';

  @override
  String get donConfirmExplain =>
      'أكّد فقط بعد التحقق من استلام المال فعليًا (عدّ النقد، أو مراجعة المعاملة البنكية / الهاتفية).';

  @override
  String get donVoid => 'إلغاء';

  @override
  String get donVoidTitle => 'إلغاء هذا السجل؟';

  @override
  String get donVoidExplain =>
      'لا تُحذف السجلات المالية أبدًا. الإلغاء يستبعد السجل من المجاميع ويبقيه في سجل التدقيق.';

  @override
  String get donVoidReason => 'السبب';

  @override
  String get donAudit => 'سجل التدقيق';

  @override
  String get donAuditNote =>
      'محفوظ في الذاكرة فقط في هذا النموذج. سيحتفظ الخادم بسجل تدقيق دائم لا يمكن حذفه.';

  @override
  String get donAuditDemo => 'إرسال تجريبي';

  @override
  String get donAuditRecorded => 'تم التسجيل';

  @override
  String get donAuditConfirmed => 'تم التأكيد';

  @override
  String get donAuditVoided => 'تم الإلغاء';

  @override
  String get donAuditExpenseRecorded => 'تسجيل مصروف';

  @override
  String get donAuditExpenseApproved => 'اعتماد مصروف';

  @override
  String get donAuditExpenseRejected => 'رفض مصروف';

  @override
  String get donExpensesNotice =>
      'للموظفين فقط. يجب اعتماد المصروفات الجديدة قبل احتسابها في التقارير.';

  @override
  String donExpensesApprovedTotal(String code) {
    return 'المصروفات المعتمدة ($code)';
  }

  @override
  String get donExpensesEmpty => 'لا توجد مصروفات مسجلة';

  @override
  String get donExpenseAdd => 'إضافة مصروف';

  @override
  String get donExpenseCategory => 'الفئة';

  @override
  String get donExpenseReason => 'سبب المصروف';

  @override
  String get donExpensePayee => 'المستفيد / المورّد (اختياري)';

  @override
  String get donExpenseDocument => 'إرفاق إيصال';

  @override
  String get donExpensePendingNote => 'يُحفظ المصروف بانتظار الاعتماد.';

  @override
  String get donExpenseDetails => 'مصروف';

  @override
  String get donExpenseApprove => 'اعتماد';

  @override
  String get donExpenseReject => 'رفض';

  @override
  String get donExpenseApproved => 'معتمد';

  @override
  String get donExpenseRejected => 'مرفوض';

  @override
  String get donExpCatMaintenance => 'صيانة';

  @override
  String get donExpCatElectricity => 'كهرباء';

  @override
  String get donExpCatWater => 'ماء';

  @override
  String get donExpCatCleaning => 'تنظيف';

  @override
  String get donExpCatSalaries => 'رواتب';

  @override
  String get donExpCatEducation => 'تعليم';

  @override
  String get donExpCatCommunity => 'دعم المجتمع';

  @override
  String get donExpCatOther => 'أخرى';

  @override
  String get donReportSample =>
      'محسوب من بيانات تجريبية — ليست المالية الحقيقية للمسجد.';

  @override
  String get donReportDay => 'يوم';

  @override
  String get donReportMonth => 'شهر';

  @override
  String get donReportYear => 'سنة';

  @override
  String get donReportPrev => 'الفترة السابقة';

  @override
  String get donReportNext => 'الفترة التالية';

  @override
  String get donReportEmpty => 'لا توجد سجلات مؤكدة في هذه الفترة';

  @override
  String get donReportEmptyMessage => 'اختر فترة أخرى.';

  @override
  String get donReportConfirmed => 'التبرعات المؤكدة';

  @override
  String get donReportExpenses => 'المصروفات المعتمدة';

  @override
  String get donReportNet => 'صافي الفترة';

  @override
  String get donReportNetNote =>
      'الصافي = التبرعات المؤكدة − المصروفات المعتمدة في هذه الفترة. وليس رصيد المسجد النقدي.';

  @override
  String get donReportByCampaign => 'حسب الحملة';

  @override
  String get donReportByMethod => 'حسب طريقة الدفع';

  @override
  String get donReportProgress => 'تقدم الحملات';

  @override
  String get donReportRulesTitle => 'كيف تُحسب الأرقام';

  @override
  String get donReportRules =>
      '• التبرعات المؤكدة: التبرعات التي تم التحقق منها فقط — تُستبعد المعلّقة والفاشلة والمستردة والملغاة والتجريبية.\n• المصروفات: المعتمدة وغير الملغاة.\n• الصافي: التبرعات المؤكدة ناقص المصروفات للفترة المختارة.\n• تقدم الحملة: التبرعات المؤكدة ÷ الهدف، بحد أقصى 100%.\n• لا تُخلط العملات: لكل عملة مجاميعها الخاصة.';

  @override
  String get donReportExportPending =>
      'سيُضاف التصدير بصيغة CSV / PDF في مرحلة لاحقة.';

  @override
  String get tabHome => 'HOME';

  @override
  String get tabSettings => 'SETTINGS';

  @override
  String get tabProfile => 'PROFILE';

  @override
  String get tabAbout => 'ABOUT';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsNotifications => 'تفضيلات الإشعارات';

  @override
  String get settingsNotificationsPending => 'الإشعارات غير متاحة بعد.';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageHint => 'الصومالية أو الإنجليزية أو العربية';

  @override
  String get settingsAppearance => 'المظهر';

  @override
  String get settingsPrivacy => 'الخصوصية والأمان';

  @override
  String get settingsPrivacyPending => 'ستتوفر بعد ربط الحسابات بالخادم.';

  @override
  String get settingsHelp => 'المساعدة والدعم';

  @override
  String get settingsHelpPending => 'ستُضاف صفحات المساعدة لاحقًا.';

  @override
  String get settingsAbout => 'عن التطبيق';

  @override
  String get settingsAboutHint => 'معلومات التطبيق والمطوّر';

  @override
  String get profileTabTitle => 'الملف الشخصي';

  @override
  String get profileSignedOutTitle => 'لم تسجّل الدخول';

  @override
  String get profileSignedOutMessage => 'سجّل الدخول لعرض معلومات حسابك.';

  @override
  String get profileSignIn => 'تسجيل الدخول';

  @override
  String get profileAccountInfo => 'معلومات الحساب';

  @override
  String get profileFullName => 'الاسم الكامل';

  @override
  String get profileEmail => 'البريد الإلكتروني';

  @override
  String get profilePhone => 'رقم الهاتف';

  @override
  String get profileNotProvided => 'غير مُدخل';

  @override
  String get profileAccountType => 'نوع الحساب';

  @override
  String get profileDemoAccount => 'حساب تجريبي (ليس حسابًا حقيقيًا)';

  @override
  String get profileDemoNote =>
      'هذه البيانات هي ما كتبته عند تسجيل الدخول. تُحفظ في الذاكرة فقط ولا تُخزَّن أو تُرسل إلى أي مكان.';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileChangePassword => 'تغيير كلمة المرور';

  @override
  String get profileNeedsBackend => 'سيتوفر بعد ربط الحسابات بالخادم.';

  @override
  String get aboutTitle => 'حول';

  @override
  String aboutVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get aboutDescriptionTitle => 'عن التطبيق';

  @override
  String get aboutDescription1 =>
      'تطبيق إدارة المساجد تطبيق جوال صُمم لتسهيل إدارة المساجد ووصول الجماعة إلى المعلومات المهمة.';

  @override
  String get aboutDescription2 =>
      'يهدف التطبيق إلى جمع خدمات إدارة المسجد في مكان واحد، لتكون البيانات والمهام المهمة متاحة بسهولة.';

  @override
  String get aboutFeaturesTitle => 'الميزات الرئيسية';

  @override
  String get aboutFeaturesNote =>
      '\"متاح (بيانات تجريبية)\" يعني أن الشاشة تعمل ببيانات تجريبية واضحة حتى يتم ربط الخادم. الميزات \"قريبًا\" لم تُبنَ بعد.';

  @override
  String get aboutStatusDemo => 'متاح (بيانات تجريبية)';

  @override
  String get aboutFeaturePrayer => 'مواقيت الصلاة';

  @override
  String get aboutFeaturePrayerDesc => 'مواقيت الصلوات الخمس.';

  @override
  String get aboutFeatureDonations => 'التبرعات';

  @override
  String get aboutFeatureDonationsDesc => 'تسجيل التبرعات ومتابعتها.';

  @override
  String get aboutFeatureEvents => 'الفعاليات';

  @override
  String get aboutFeatureEventsDesc => 'أخبار المسجد ومناسباته.';

  @override
  String get aboutFeatureQuran => 'حلقات القرآن';

  @override
  String get aboutFeatureQuranDesc => 'معلومات دروس القرآن.';

  @override
  String get aboutFeatureAnnouncements => 'الإعلانات';

  @override
  String get aboutFeatureAnnouncementsDesc => 'الإعلانات المهمة.';

  @override
  String get aboutFeatureNotifications => 'الإشعارات';

  @override
  String get aboutFeatureNotificationsDesc => 'إشعارات التطبيق.';

  @override
  String get aboutFeatureProfile => 'الملف الشخصي';

  @override
  String get aboutFeatureProfileDesc => 'معلومات المستخدم وحسابه.';

  @override
  String get aboutFeatureSettings => 'الإعدادات';

  @override
  String get aboutFeatureSettingsDesc => 'تفضيلات التطبيق.';

  @override
  String get aboutDeveloperTitle => 'About the Developer';

  @override
  String get aboutEmail => 'البريد الإلكتروني';

  @override
  String get aboutPhone => 'الهاتف';

  @override
  String get aboutLocation => 'الموقع';

  @override
  String get aboutEmailCopied => 'تم نسخ البريد الإلكتروني.';

  @override
  String get aboutPhoneCopied => 'تم نسخ رقم الهاتف.';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات بعد';

  @override
  String get notificationsEmptyMessage =>
      'ستظهر الإشعارات هنا بعد ربط الإشعارات الفورية بالخادم.';

  @override
  String get themeSwitchToDark => 'التبديل إلى الوضع الليلي';

  @override
  String get themeSwitchToLight => 'التبديل إلى الوضع النهاري';

  @override
  String get themeDarkActive => 'الوضع الليلي مفعّل';

  @override
  String get themeLightActive => 'الوضع النهاري مفعّل';

  @override
  String get homeMenuProjects => 'المشاريع';

  @override
  String get projTitle => 'مشاريع المسجد';

  @override
  String get projAdd => 'إضافة مشروع';

  @override
  String get projEditTitle => 'تعديل المشروع';

  @override
  String get projDetailsTitle => 'تفاصيل المشروع';

  @override
  String get projSearchHint => 'ابحث عن مشروع بالاسم';

  @override
  String get projSampleTitle => 'مشاريع تجريبية — ليست حقيقية';

  @override
  String get projSampleMessage =>
      'هذه المشاريع والمبالغ والتحديثات بيانات تجريبية لاختبار التصميم، وليست مشاريع حقيقية للمسجد.';

  @override
  String get projEmptyTitle => 'لا توجد مشاريع';

  @override
  String get projEmptyMessage => 'ستظهر مشاريع المسجد هنا بعد نشرها.';

  @override
  String get projNoResults => 'لم يتم العثور على مشاريع';

  @override
  String get projFeatured => 'مشاريع مميزة';

  @override
  String get projOngoing => 'مشاريع جارية';

  @override
  String get projRecent => 'أضيفت مؤخرًا';

  @override
  String get projNotFound => 'لم يتم العثور على هذا المشروع.';

  @override
  String get projStatusPlanned => 'مخطط';

  @override
  String get projStatusOngoing => 'جارٍ';

  @override
  String get projStatusPaused => 'متوقف مؤقتًا';

  @override
  String get projStatusCompleted => 'مكتمل';

  @override
  String get projStatusCancelled => 'ملغى';

  @override
  String get projMilestonePending => 'لم يبدأ';

  @override
  String get projMilestoneInProgress => 'قيد التنفيذ';

  @override
  String get projMilestoneCompleted => 'مكتمل';

  @override
  String get projPhysicalProgress => 'تقدم العمل';

  @override
  String get projProgressUnknown => 'غير مُبلغ';

  @override
  String projExpectedEnd(String date) {
    return 'الانتهاء المتوقع $date';
  }

  @override
  String projStarts(String date) {
    return 'يبدأ $date';
  }

  @override
  String get projInfo => 'معلومات المشروع';

  @override
  String get projCategory => 'الفئة';

  @override
  String get projMosque => 'المسجد';

  @override
  String get projLocation => 'الموقع';

  @override
  String get projManager => 'مدير المشروع / القسم';

  @override
  String get projExpectedEndLabel => 'الإنجاز المتوقع';

  @override
  String get projLastUpdated => 'آخر تحديث';

  @override
  String get projObjectives => 'الأهداف';

  @override
  String get projBeneficiaries => 'المستفيدون المتوقعون';

  @override
  String get projFunding => 'التمويل';

  @override
  String get projBudget => 'الميزانية الإجمالية';

  @override
  String get projFundingTarget => 'هدف جمع التبرعات';

  @override
  String get projApprovedExpenses => 'مصروفات المشروع المعتمدة (للموظفين)';

  @override
  String get projFundingRule =>
      'المُجمَّع = التبرعات المؤكدة لحملة هذا المشروع فقط. لا تُحتسب التبرعات المعلّقة والتجريبية. المتبقي ليس رصيد المسجد النقدي، والميزانية ليست مبلغًا تم صرفه.';

  @override
  String get projNoCampaign =>
      'لا توجد حملة تبرعات مرتبطة بهذا المشروع، لذا التبرعات غير مفتوحة.';

  @override
  String get projReportsPending =>
      'ستُضاف التقارير المالية المنشورة للمشاريع بعد ربط الخادم.';

  @override
  String get projProgress => 'تقدم العمل';

  @override
  String get projProgressSeparate =>
      'يُبلغ المسؤول عن تقدم العمل وهو منفصل عن التمويل: جمع 60% من الميزانية لا يعني إنجاز 60% من العمل.';

  @override
  String get projMilestones => 'المراحل الرئيسية';

  @override
  String projDue(String date) {
    return 'الموعد $date';
  }

  @override
  String get projUpdates => 'تحديثات التقدم';

  @override
  String get projAddUpdate => 'إضافة تحديث';

  @override
  String get projEditUpdateTitle => 'تعديل التحديث';

  @override
  String get projNoUpdates => 'لا توجد تحديثات منشورة بعد.';

  @override
  String get projDraft => 'مسودة';

  @override
  String projEditedTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عُدّل $count مرات (النسخ السابقة محفوظة)',
      one: 'عُدّل مرة واحدة (النسخة السابقة محفوظة)',
    );
    return '$_temp0';
  }

  @override
  String get projHistory => 'سجل التغييرات';

  @override
  String get projDonate => 'تبرّع لهذا المشروع';

  @override
  String get projClosedForDonations => 'هذا المشروع لا يقبل التبرعات حاليًا.';

  @override
  String get projDonatingTo => 'أنت تتبرع للمشروع';

  @override
  String get projErrorAmount => 'أدخل مبلغًا صحيحًا، مثل 5000 أو 5000.50.';

  @override
  String get projErrorNegative => 'لا يمكن أن يكون المبلغ سالبًا.';

  @override
  String get projErrorDates =>
      'لا يمكن أن يكون تاريخ الإنجاز المتوقع قبل تاريخ البدء.';

  @override
  String get projErrorPercent => 'أدخل عددًا صحيحًا من 0 إلى 100.';

  @override
  String get projFieldTitle => 'عنوان المشروع';

  @override
  String get projFieldSummary => 'وصف مختصر';

  @override
  String projBudgetLabel(String code) {
    return 'الميزانية الإجمالية ($code)';
  }

  @override
  String projFundingTargetOptional(String code) {
    return 'هدف جمع التبرعات ($code، اختياري — يساوي الميزانية إن تُرك فارغًا)';
  }

  @override
  String get projLinkedCampaign => 'حملة جمع التبرعات';

  @override
  String get projLinkedCampaignHint =>
      'تُحتسب تبرعات هذه الحملة كأموال للمشروع. تظهر فقط الحملات بنفس العملة.';

  @override
  String get projNoCampaignOption => 'لا شيء (التبرعات غير مفتوحة)';

  @override
  String get projPhysicalProgressField => 'تقدم العمل % (اختياري)';

  @override
  String get projProgressNote => 'وصف التقدم';

  @override
  String get projFeaturedSwitch => 'مشروع مميز';

  @override
  String get projUploadImages => 'إضافة صور';

  @override
  String get projImagesPending => 'سيعمل رفع الصور بعد ربط التخزين (الخادم).';

  @override
  String get projAddMilestone => 'إضافة مرحلة';

  @override
  String get projRemoveMilestone => 'حذف المرحلة';

  @override
  String get projMilestoneTitle => 'عنوان المرحلة';

  @override
  String get projDueDate => 'الموعد المحدد';

  @override
  String get projHistoryCreated => 'تم إنشاء المشروع';

  @override
  String get projHistoryEdited => 'تم تعديل المشروع';

  @override
  String projHistoryBudget(String from, String to) {
    return 'الميزانية $from ← $to';
  }

  @override
  String projHistoryStatus(String from, String to) {
    return 'الحالة $from ← $to';
  }

  @override
  String get projHistoryCampaign => 'تم تغيير حملة التبرعات';

  @override
  String get projUpdateTitle => 'عنوان التحديث';

  @override
  String get projUpdatePercent => 'التقدم % (اختياري)';

  @override
  String get projUpdateMilestone => 'المرحلة المنجزة (اختياري)';

  @override
  String get projPublishSwitch => 'منشور';

  @override
  String get projPublishHint => 'يرى الأعضاء التحديثات المنشورة فقط.';

  @override
  String get projExpenseProject => 'المشروع (اختياري)';
}
