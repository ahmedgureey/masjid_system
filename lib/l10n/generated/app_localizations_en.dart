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

  @override
  String get splashTagline => 'Your mosque, in one place';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageSubtitle => 'You can change it later in Settings.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboarding1Title => 'Never miss a prayer';

  @override
  String get onboarding1Body =>
      'Accurate prayer and Iqamah times, reminders and Qibla for your mosque.';

  @override
  String get onboarding2Title => 'Give with trust';

  @override
  String get onboarding2Body =>
      'Support your mosque and see how your donations help.';

  @override
  String get onboarding3Title => 'Learn and stay connected';

  @override
  String get onboarding3Body =>
      'Qur\'an classes, events and announcements in one place.';

  @override
  String onboardingPageLabel(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get welcomeGreeting => 'Assalamu alaikum';

  @override
  String get welcomeTitle => 'Welcome to Masjid Management App';

  @override
  String get welcomeSubtitle =>
      'Prayer times, donations, classes and community news for your mosque.';

  @override
  String get authLogin => 'Log in';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get welcomeTerms =>
      'By continuing, you agree to the Terms of Use and Privacy Policy.';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonMessage =>
      'This screen will be built in the next module.';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Log in to your account';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldEmailHint => 'name@example.com';

  @override
  String get fieldPassword => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'Join your mosque community';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get fieldFullNameHint => 'e.g. Ahmed Abdi Hassan';

  @override
  String get fieldPhone => 'Phone number';

  @override
  String get fieldOptional => '(optional)';

  @override
  String get fieldPhoneHint => '+252 61 234 5678';

  @override
  String get fieldConfirmPassword => 'Confirm password';

  @override
  String get passwordHelper => 'At least 8 characters';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationNameShort => 'Enter your full name';

  @override
  String get termsAgree => 'I agree to the Terms of Use and Privacy Policy';

  @override
  String get validationTerms => 'You must accept the terms to continue';

  @override
  String get registerHaveAccount => 'Already have an account?';

  @override
  String get mockTitle => 'Not available yet';

  @override
  String get mockLoginMessage =>
      'Your details look correct, but signing in will only work after the app is connected to the server. Nothing was saved.';

  @override
  String get mockRegisterMessage =>
      'Your details look correct, but creating an account will only work after the app is connected to the server. Nothing was saved.';

  @override
  String get mockResetMessage =>
      'Password reset emails will be sent once the app is connected to the server. Nothing was sent.';

  @override
  String get forgotTitle => 'Reset your password';

  @override
  String get forgotSubtitle =>
      'Enter the email you registered with. We\'ll send you a link to reset your password.';

  @override
  String get forgotSend => 'Send reset link';

  @override
  String get forgotBackToLogin => 'Back to log in';

  @override
  String get demoBannerTitle => 'Demo mode';

  @override
  String get demoBannerMessage =>
      'You are signed in with sample data. No real account was used and nothing is saved.';

  @override
  String get logout => 'Log out';

  @override
  String homeGreetingName(String name) {
    return 'Assalamu alaikum, $name';
  }

  @override
  String get homeMenuProfile => 'Mosque Profile';

  @override
  String get homeMenuPrayer => 'Prayer Times';

  @override
  String get homeMenuCalendar => 'Mosque Calendar';

  @override
  String get homeMenuNews => 'News & Articles';

  @override
  String get homeMenuDonations => 'Donation Program';

  @override
  String get homeMenuContact => 'Contact Us';

  @override
  String get coverPhotoPending => 'Mosque photo not added yet';

  @override
  String get homeMenuTitle => 'Mosque services';

  @override
  String get profileTitle => 'Mosque Profile';

  @override
  String get profileEdit => 'Edit';

  @override
  String get profileEditTitle => 'Edit mosque profile';

  @override
  String get profileNoDescription => 'No description added yet.';

  @override
  String get profileNoData => 'No information added yet.';

  @override
  String get profileAddInfo => 'Add information';

  @override
  String get profileSectionBasic => 'Mosque details';

  @override
  String get profileSectionLocation => 'Mosque location';

  @override
  String get profileSectionContact => 'Contact details';

  @override
  String get profileSectionLeadership => 'Mosque leadership';

  @override
  String get profileSectionServices => 'Mosque services';

  @override
  String get profileSectionFacilities => 'Mosque facilities';

  @override
  String get profileServicesPending =>
      'Services will appear here as they are added to the app.';

  @override
  String get profileLeadershipPrivacy =>
      'Only names are shown. Personal contact details are never public.';

  @override
  String get profileAuthNotice =>
      'Editing is available because you are signed in (demo). Permissions are checked in the app only for now; the server will enforce them later.';

  @override
  String get fieldMosqueName => 'Mosque name';

  @override
  String get fieldDescription => 'Short description';

  @override
  String get fieldCategory => 'Mosque type';

  @override
  String get categoryJamia => 'Jāmiʿ (Friday mosque)';

  @override
  String get categoryMasjid => 'Mosque';

  @override
  String get categoryMusalla => 'Prayer hall (muṣallā)';

  @override
  String get fieldEstablished => 'Year established';

  @override
  String get fieldRegistration => 'Registration number';

  @override
  String get fieldCountry => 'Country';

  @override
  String get fieldCity => 'City';

  @override
  String get fieldDistrict => 'District / neighbourhood';

  @override
  String get fieldAddress => 'Full address';

  @override
  String get fieldLatitude => 'Latitude';

  @override
  String get fieldLongitude => 'Longitude';

  @override
  String get fieldCoordinates => 'GPS coordinates';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get fieldSocial => 'Social media';

  @override
  String get fieldImam => 'Imam';

  @override
  String get fieldChairman => 'Chairman';

  @override
  String get fieldAdministrator => 'Administrator';

  @override
  String get fieldTreasurer => 'Treasurer';

  @override
  String get fieldLogo => 'Logo';

  @override
  String get logoUploadPending =>
      'Uploading a logo will be possible once storage (Supabase) is connected.';

  @override
  String get logoUpload => 'Upload logo';

  @override
  String get facilityWomen => 'Women\'s prayer area';

  @override
  String get facilityQuranRooms => 'Qur\'an teaching rooms';

  @override
  String get facilityAblution => 'Ablution facilities';

  @override
  String get facilityParking => 'Parking';

  @override
  String get facilityAccessibility => 'Accessibility (wheelchair access)';

  @override
  String get facilitiesHint =>
      'Tick only the facilities the mosque actually has.';

  @override
  String editLanguageNote(String language) {
    return 'Name and description are edited for the current language: $language.';
  }

  @override
  String get profileSave => 'Save';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileSavedLocal =>
      'Changes saved on this device only (temporary). They will be lost when the app is closed until the server is connected.';

  @override
  String get profileSaveError =>
      'Could not save the changes. Please try again.';

  @override
  String get discardTitle => 'Discard changes?';

  @override
  String get discardMessage =>
      'You have unsaved changes. If you leave now, they will be lost.';

  @override
  String get discardConfirm => 'Discard';

  @override
  String get discardKeepEditing => 'Keep editing';

  @override
  String get validationWebsite =>
      'Enter a valid website address (e.g. www.example.com)';

  @override
  String validationYear(int min, int max) {
    return 'Enter a valid year between $min and $max';
  }

  @override
  String get validationLatitude =>
      'Latitude must be a number between -90 and 90';

  @override
  String get validationLongitude =>
      'Longitude must be a number between -180 and 180';

  @override
  String get prayerTitle => 'Prayer Times';

  @override
  String get prayerNextLabel => 'Next prayer';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerSunriseNote => 'Not one of the five obligatory prayers';

  @override
  String get prayerAdhan => 'Adhan';

  @override
  String get prayerIqamah => 'Iqamah';

  @override
  String get prayerIqamahNotSet => 'Not set';

  @override
  String get prayerDailyTitle => 'Five daily prayers';

  @override
  String get prayerNextBadge => 'Next';

  @override
  String get prayerTomorrow => 'Tomorrow';

  @override
  String get prayerCountdownLabel => 'Time remaining';

  @override
  String get prayerNoNext => 'The next prayer time is not available.';

  @override
  String get prayerLocationMissing => 'Mosque location not added yet';

  @override
  String get prayerMockTitle => 'Sample data — not real times';

  @override
  String get prayerMockMessage =>
      'These times are sample (mock) values used to test the design. They are NOT the real prayer times of the mosque. Real times will be shown once the mosque location and calculation method are configured.';

  @override
  String get prayerEmptyTitle => 'No prayer schedule';

  @override
  String get prayerEmptyMessage =>
      'Prayer times for this day have not been set yet.';

  @override
  String get prayerRefresh => 'Refresh';

  @override
  String get calendarTitle => 'Mosque Calendar';

  @override
  String get calendarPrevMonth => 'Previous month';

  @override
  String get calendarNextMonth => 'Next month';

  @override
  String get calendarToday => 'Today';

  @override
  String calendarHijriApprox(String date) {
    return '≈ $date (estimate)';
  }

  @override
  String get calendarHijriNote =>
      'Hijri dates are calculated estimates and may differ by 1–2 days from the local moon-sighting announcement.';

  @override
  String get calendarOccasionsTitle => 'Islamic occasions this month';

  @override
  String get occasionEstimated => 'Estimate';

  @override
  String get occasionConfirmed => 'Confirmed';

  @override
  String get occasionRamadanStart => 'Start of Ramadan';

  @override
  String get occasionEidFitr => 'Eid al-Fitr';

  @override
  String get occasionEidAdha => 'Eid al-Adha';

  @override
  String get occasionArafah => 'Day of Arafah';

  @override
  String get occasionIslamicNewYear => 'Islamic New Year';

  @override
  String get occasionAshura => 'Ashura';

  @override
  String get eventsUpcomingTitle => 'Upcoming events';

  @override
  String get eventsAllTitle => 'All events';

  @override
  String get eventsPastTitle => 'Past events';

  @override
  String eventsOnDate(String date) {
    return 'Events on $date';
  }

  @override
  String get eventsClearDate => 'All dates';

  @override
  String get eventFilterAll => 'All';

  @override
  String get eventFilterUpcoming => 'Upcoming';

  @override
  String get eventFilterPast => 'Past';

  @override
  String get eventFilterOccasions => 'Islamic occasions';

  @override
  String get eventCatQuran => 'Quran classes';

  @override
  String get eventCatLectures => 'Lectures';

  @override
  String get eventCatLessons => 'Religious lessons';

  @override
  String get eventCatCommunity => 'Community meetings';

  @override
  String get eventCatChildren => 'Children’s programmes';

  @override
  String get eventCatYouth => 'Youth programmes';

  @override
  String get eventCatRamadan => 'Ramadan programmes';

  @override
  String get eventCatEid => 'Eid celebrations';

  @override
  String get eventCatOther => 'Other mosque events';

  @override
  String get eventStatusScheduled => 'Scheduled';

  @override
  String get eventStatusPostponed => 'Postponed';

  @override
  String get eventStatusCancelled => 'Cancelled';

  @override
  String get eventTimingUpcoming => 'Upcoming';

  @override
  String get eventTimingOngoing => 'Happening now';

  @override
  String get eventTimingEnded => 'Ended';

  @override
  String get eventsEmptyTitle => 'No events';

  @override
  String get eventsEmptyMessage => 'No events match this selection.';

  @override
  String get eventsMockTitle => 'Sample events — not real';

  @override
  String get eventsMockMessage =>
      'These events are sample (mock) data for testing the design. They are not real events of the mosque.';

  @override
  String get eventsAuthNotice =>
      'You can add and edit events because you signed in (demo). Permission is only checked inside the app for now; the server will enforce it later.';

  @override
  String get eventAdd => 'Add event';

  @override
  String get eventDetailsTitle => 'Event details';

  @override
  String get eventDate => 'Date';

  @override
  String get eventTime => 'Time';

  @override
  String get eventLocation => 'Location';

  @override
  String get eventOrganizer => 'Organizer';

  @override
  String get eventCategory => 'Category';

  @override
  String get eventDescription => 'Description';

  @override
  String get eventRegistrationRequired => 'Registration required';

  @override
  String get eventNotFound => 'This event was not found.';

  @override
  String get eventReminder => 'Remind me';

  @override
  String get eventReminderUnavailable =>
      'Reminders are not available yet. They will be added in a later phase.';

  @override
  String get eventFormNewTitle => 'New event';

  @override
  String get eventFormEditTitle => 'Edit event';

  @override
  String get eventFieldTitle => 'Event title';

  @override
  String get eventFieldStart => 'Start time';

  @override
  String get eventFieldEnd => 'End time';

  @override
  String get eventClearEnd => 'Clear end time';

  @override
  String get eventFieldStatus => 'Status';

  @override
  String get eventFieldImage => 'Image (optional)';

  @override
  String get eventImageUpload => 'Upload image';

  @override
  String get eventImagePending =>
      'Image upload will work once storage (server) is connected.';

  @override
  String get eventFieldRegistrationDetails => 'Registration details';

  @override
  String get eventValidationEndBeforeStart =>
      'The end time must be after the start time.';

  @override
  String get eventValidationPastDate => 'The date cannot be in the past.';

  @override
  String get eventValidationChoose => 'Please choose an option';

  @override
  String get eventSavedLocal =>
      'The event was saved on this device only (temporary). It will be lost when the app closes, until the server is connected.';

  @override
  String get eventSaveError =>
      'The event could not be saved. Please try again.';

  @override
  String get newsTitle => 'News & Articles';

  @override
  String get newsSearchHint => 'Search articles';

  @override
  String get newsClearSearch => 'Clear search';

  @override
  String get newsAllCategories => 'All';

  @override
  String get newsFeatured => 'Featured';

  @override
  String get newsLatest => 'Latest news';

  @override
  String get newsRecommended => 'Recommended';

  @override
  String get newsAllArticles => 'All articles';

  @override
  String get newsSortNewest => 'Newest first';

  @override
  String get newsSortOldest => 'Oldest first';

  @override
  String newsResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get newsClearFilters => 'Clear filters';

  @override
  String get newsNoResultsTitle => 'No articles found';

  @override
  String get newsNoResultsMessage => 'Try other words or another category.';

  @override
  String get newsEmptyTitle => 'No articles yet';

  @override
  String get newsEmptyMessage =>
      'Published news and articles will appear here.';

  @override
  String newsReadingTime(int minutes) {
    return '$minutes min read';
  }

  @override
  String get newsMockTitle => 'Sample articles — not real';

  @override
  String get newsMockMessage =>
      'These articles are sample (mock) data for testing the design. They are not real news of the mosque and contain no religious rulings, verses, hadith or quotations.';

  @override
  String get newsSaved => 'Saved articles';

  @override
  String get newsBookmark => 'Save article';

  @override
  String get newsRemoveBookmark => 'Remove from saved';

  @override
  String get newsBookmarkAdded => 'Saved on this device only.';

  @override
  String get newsBookmarkRemoved => 'Removed from saved articles.';

  @override
  String get newsBookmarkError =>
      'Could not update saved articles. Please try again.';

  @override
  String get newsBookmarkLoginRequired => 'Sign in to save articles.';

  @override
  String get newsSignIn => 'Sign in';

  @override
  String get newsSavedEmptyTitle => 'No saved articles';

  @override
  String get newsSavedEmptyMessage =>
      'Tap the bookmark icon on an article to save it.';

  @override
  String get newsSavedLocalNote =>
      'Saved articles are stored on this device only. They are not synced to other devices yet.';

  @override
  String get newsSavedSignedOut => 'Sign in to see your saved articles.';

  @override
  String get newsUnavailable => 'This article is no longer available.';

  @override
  String get newsShare => 'Share';

  @override
  String get newsShareError => 'Sharing is not available right now.';

  @override
  String get newsNotFound => 'This article was not found.';

  @override
  String newsPublished(String date) {
    return 'Published $date';
  }

  @override
  String newsUpdated(String date) {
    return 'Updated $date';
  }

  @override
  String get newsReferences => 'References';

  @override
  String get newsRelated => 'Related articles';

  @override
  String get donTitle => 'Donations';

  @override
  String get donIntro =>
      'Your donations help maintain the mosque, support Quran education and help families in need. May Allah reward you.';

  @override
  String get donSampleTitle => 'Sample data — not real campaigns or money';

  @override
  String get donSampleMessage =>
      'These campaigns, amounts and records are sample (mock) data for testing the design. No money is collected and no payment is processed.';

  @override
  String get donConfirmedVsPendingTitle => 'Confirmed and pending';

  @override
  String get donConfirmedVsPendingBody =>
      'Only donations verified by the mosque treasurer are counted as confirmed. Pending donations are shown separately and are not added to the totals.';

  @override
  String get donActiveCampaigns => 'Active campaigns';

  @override
  String get donSeeAll => 'See all';

  @override
  String get donNoCampaigns => 'No campaigns';

  @override
  String get donNoCampaignsMessage =>
      'There are no active fundraising campaigns at the moment.';

  @override
  String get donNoCampaignsFilter => 'No campaigns match this filter.';

  @override
  String get donDonate => 'Donate';

  @override
  String get donHistoryTitle => 'Donation history';

  @override
  String get donCampaignsTitle => 'Campaigns';

  @override
  String get donStaffTitle => 'Donation management';

  @override
  String get donFilterAll => 'All';

  @override
  String get donAllCategories => 'All categories';

  @override
  String get donAllMethods => 'All methods';

  @override
  String get donCatConstruction => 'Mosque construction';

  @override
  String get donCatMaintenance => 'Mosque maintenance';

  @override
  String get donCatUtilities => 'Electricity and water';

  @override
  String get donCatQuran => 'Quran education';

  @override
  String get donCatFamilies => 'Support for needy families';

  @override
  String get donCatRamadan => 'Ramadan food distribution';

  @override
  String get donCatGeneral => 'General mosque donations';

  @override
  String get donCampaignDraft => 'Draft';

  @override
  String get donCampaignActive => 'Active';

  @override
  String get donCampaignCompleted => 'Completed';

  @override
  String get donCampaignArchived => 'Archived';

  @override
  String get donMethodCash => 'Cash';

  @override
  String get donMethodBank => 'Bank transfer';

  @override
  String get donMethodMobile => 'Mobile money';

  @override
  String get donMethodOnline => 'Online payment';

  @override
  String get donStatusPending => 'Pending';

  @override
  String get donStatusConfirmed => 'Confirmed';

  @override
  String get donStatusFailed => 'Failed';

  @override
  String get donStatusRefunded => 'Refunded';

  @override
  String get donStatusDemo => 'Demo — not processed';

  @override
  String get donStatusVoided => 'Voided';

  @override
  String donProgressSemantics(String raised, String target, int percent) {
    return '$raised confirmed of $target, $percent percent';
  }

  @override
  String donRaisedOf(String target) {
    return 'of $target';
  }

  @override
  String donRemaining(String amount) {
    return '$amount remaining';
  }

  @override
  String donPendingNotCounted(String amount) {
    return 'Pending verification (not counted): $amount';
  }

  @override
  String get donCampaignDetails => 'Campaign details';

  @override
  String get donCampaignNotFound => 'This campaign was not found.';

  @override
  String get donTarget => 'Target';

  @override
  String get donConfirmedReceived => 'Confirmed donations received';

  @override
  String get donRemainingLabel => 'Remaining';

  @override
  String get donCurrencyLabel => 'Currency';

  @override
  String get donStartDate => 'Start date';

  @override
  String get donEndDate => 'End date';

  @override
  String get donNoConfirmedYet =>
      'No confirmed donations have been recorded for this campaign yet.';

  @override
  String get donCampaignClosed => 'This campaign is not accepting donations.';

  @override
  String get donDemoWarningTitle => 'Demo mode — no payment is processed';

  @override
  String get donDemoWarningBody =>
      'Real donations cannot be made in this version. Submitting creates a demo record only: no money is taken, it is not added to any total and no receipt is issued. Never enter card numbers, PINs or bank passwords.';

  @override
  String get donCampaign => 'Campaign';

  @override
  String get donSuggested => 'Suggested amounts';

  @override
  String donAmountLabel(String code) {
    return 'Amount ($code)';
  }

  @override
  String donCurrencyNote(String code) {
    return 'Currency: $code';
  }

  @override
  String get donAnonymous => 'Donate anonymously';

  @override
  String get donAnonymousHint => 'Your name will not be recorded or shown.';

  @override
  String get donDonorNameOptional => 'Your name (optional)';

  @override
  String get donDonorContactOptional => 'Phone or email (optional)';

  @override
  String get donDonorContactHint =>
      'Only if you want the mosque to contact you.';

  @override
  String get donMessageOptional => 'Message (optional)';

  @override
  String get donMethod => 'Payment method';

  @override
  String get donMethodNote =>
      'Payment methods are shown for planning only. No payment provider is connected yet.';

  @override
  String get donSubmitDemo => 'Submit (demo — not processed)';

  @override
  String get donSubmitError => 'Something went wrong. Please try again.';

  @override
  String get donAmountInvalid => 'Enter a valid amount, e.g. 20 or 20.50.';

  @override
  String get donAmountNotPositive => 'The amount must be greater than zero.';

  @override
  String get donAmountDecimals => 'Use at most 2 decimal places.';

  @override
  String get donAmountTooLarge => 'The amount is too large.';

  @override
  String get donDemoDoneTitle => 'Demo submission recorded';

  @override
  String get donDemoDoneBody =>
      'This was NOT a payment. No money was taken, the amount is not counted in any campaign total and no receipt is issued.';

  @override
  String get donReference => 'Reference';

  @override
  String get donAmount => 'Amount';

  @override
  String get donPaymentStatus => 'Payment status';

  @override
  String get donDemoNotSavedSignedOut =>
      'You are not signed in, so this demo record will not appear in your donation history.';

  @override
  String get donBackToDonations => 'Back to donations';

  @override
  String get donHistorySignIn => 'Sign in to see your donation history.';

  @override
  String get donHistorySearch => 'Search by reference or campaign';

  @override
  String get donPeriodAll => 'All time';

  @override
  String get donPeriod30 => 'Last 30 days';

  @override
  String get donPeriodYear => 'This year';

  @override
  String get donHistoryPrivacy =>
      'Only your own donation records are shown here. Anonymous donations never show the donor\'s name.';

  @override
  String get donHistoryEmpty => 'No donations';

  @override
  String get donHistoryEmptyMessage => 'You have no donation records yet.';

  @override
  String get donHistoryNoMatch => 'No donations match these filters.';

  @override
  String get donReceipt => 'Receipt';

  @override
  String get donReceiptTitle => 'Donation receipt';

  @override
  String get donReceiptSample => 'SAMPLE — NOT AN OFFICIAL RECEIPT';

  @override
  String get donDonor => 'Donor';

  @override
  String get donAnonymousDonor => 'Anonymous donor';

  @override
  String get donDate => 'Date';

  @override
  String get donReceiptNotVerified => 'Not verified';

  @override
  String get donReceiptThanks =>
      'Thank you for your donation. May Allah accept it and reward you.';

  @override
  String get donReceiptUnavailable => 'No receipt available';

  @override
  String get donReceiptUnavailableMessage =>
      'Receipts exist only for donations verified by the mosque. Demo, pending, failed and voided donations have no receipt.';

  @override
  String get donReceiptExportPending =>
      'PDF download and sharing of receipts will be added later.';

  @override
  String get donStaffNotice =>
      'Staff tools (demo). Access is only checked inside the app for now; the server will enforce Treasurer / Admin permissions later. Changes are kept on this device only and are lost when the app closes.';

  @override
  String get donRecordOffline => 'Record offline donation';

  @override
  String get donExpensesTitle => 'Expenses';

  @override
  String get donReportsTitle => 'Financial reports';

  @override
  String donPendingReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pending verification ($count)',
      zero: 'Pending verification',
    );
    return '$_temp0';
  }

  @override
  String get donNoPending => 'No donations are waiting for verification.';

  @override
  String get donAllRecords => 'All records';

  @override
  String get donRecordExplain =>
      'The donation is saved as PENDING. It is counted only after a separate verification.';

  @override
  String get donExternalReference => 'Transaction reference (optional)';

  @override
  String get donRecordSave => 'Save as pending';

  @override
  String get donRecordedLocal => 'Saved on this device only (temporary).';

  @override
  String get donRecordDetails => 'Donation record';

  @override
  String get donRecordNotFound => 'This record was not found.';

  @override
  String get donRecordedBy => 'Recorded by';

  @override
  String get donConfirm => 'Confirm (verified)';

  @override
  String get donConfirmTitle => 'Confirm this donation?';

  @override
  String get donConfirmExplain =>
      'Confirm only after you have verified that the money was actually received (cash counted, or the bank / mobile-money transaction checked).';

  @override
  String get donVoid => 'Void';

  @override
  String get donVoidTitle => 'Void this record?';

  @override
  String get donVoidExplain =>
      'Financial records are never deleted. Voiding excludes the record from totals and keeps it in the audit trail.';

  @override
  String get donVoidReason => 'Reason';

  @override
  String get donAudit => 'Audit trail';

  @override
  String get donAuditNote =>
      'Kept in memory only in this demo. The server will keep a permanent, insert-only audit log.';

  @override
  String get donAuditDemo => 'Demo submission';

  @override
  String get donAuditRecorded => 'Recorded';

  @override
  String get donAuditConfirmed => 'Confirmed';

  @override
  String get donAuditVoided => 'Voided';

  @override
  String get donAuditExpenseRecorded => 'Expense recorded';

  @override
  String get donAuditExpenseApproved => 'Expense approved';

  @override
  String get donAuditExpenseRejected => 'Expense rejected';

  @override
  String get donExpensesNotice =>
      'Staff only. New expenses must be approved before they are counted in reports.';

  @override
  String donExpensesApprovedTotal(String code) {
    return 'Approved expenses ($code)';
  }

  @override
  String get donExpensesEmpty => 'No expenses recorded';

  @override
  String get donExpenseAdd => 'Add expense';

  @override
  String get donExpenseCategory => 'Category';

  @override
  String get donExpenseReason => 'Business reason';

  @override
  String get donExpensePayee => 'Payee / supplier (optional)';

  @override
  String get donExpenseDocument => 'Attach receipt';

  @override
  String get donExpensePendingNote =>
      'The expense is saved as pending approval.';

  @override
  String get donExpenseDetails => 'Expense';

  @override
  String get donExpenseApprove => 'Approve';

  @override
  String get donExpenseReject => 'Reject';

  @override
  String get donExpenseApproved => 'Approved';

  @override
  String get donExpenseRejected => 'Rejected';

  @override
  String get donExpCatMaintenance => 'Maintenance';

  @override
  String get donExpCatElectricity => 'Electricity';

  @override
  String get donExpCatWater => 'Water';

  @override
  String get donExpCatCleaning => 'Cleaning';

  @override
  String get donExpCatSalaries => 'Salaries';

  @override
  String get donExpCatEducation => 'Education';

  @override
  String get donExpCatCommunity => 'Community support';

  @override
  String get donExpCatOther => 'Other';

  @override
  String get donReportSample =>
      'Calculated from sample data — not the mosque\'s real finances.';

  @override
  String get donReportDay => 'Day';

  @override
  String get donReportMonth => 'Month';

  @override
  String get donReportYear => 'Year';

  @override
  String get donReportPrev => 'Previous period';

  @override
  String get donReportNext => 'Next period';

  @override
  String get donReportEmpty => 'No confirmed records in this period';

  @override
  String get donReportEmptyMessage => 'Choose another period.';

  @override
  String get donReportConfirmed => 'Confirmed donations';

  @override
  String get donReportExpenses => 'Approved expenses';

  @override
  String get donReportNet => 'Net for the period';

  @override
  String get donReportNetNote =>
      'Net = confirmed donations − approved expenses in this period. It is not the mosque\'s cash balance.';

  @override
  String get donReportByCampaign => 'By campaign';

  @override
  String get donReportByMethod => 'By payment method';

  @override
  String get donReportProgress => 'Campaign progress';

  @override
  String get donReportRulesTitle => 'How the numbers are calculated';

  @override
  String get donReportRules =>
      '• Confirmed donations: verified donations only — pending, failed, refunded, voided and demo records are excluded.\n• Expenses: approved, non-voided expenses.\n• Net: confirmed donations minus expenses for the selected period.\n• Campaign progress: confirmed campaign donations ÷ target, capped at 100%.\n• Currencies are never mixed: each currency has its own totals.';

  @override
  String get donReportExportPending =>
      'CSV / PDF export will be added in a later phase.';

  @override
  String get tabHome => 'HOME';

  @override
  String get tabSettings => 'SETTINGS';

  @override
  String get tabProfile => 'PROFILE';

  @override
  String get tabAbout => 'ABOUT';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotifications => 'Notification preferences';

  @override
  String get settingsNotificationsPending =>
      'Notifications are not available yet.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageHint => 'Somali, English or Arabic';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsPrivacy => 'Privacy & Security';

  @override
  String get settingsPrivacyPending =>
      'Will be available when accounts are connected to the server.';

  @override
  String get settingsHelp => 'Help & Support';

  @override
  String get settingsHelpPending => 'Help pages will be added later.';

  @override
  String get settingsAbout => 'About App';

  @override
  String get settingsAboutHint => 'App information and developer';

  @override
  String get profileTabTitle => 'Profile';

  @override
  String get profileSignedOutTitle => 'You are not signed in';

  @override
  String get profileSignedOutMessage =>
      'Sign in to see your account information.';

  @override
  String get profileSignIn => 'Sign in';

  @override
  String get profileAccountInfo => 'Account information';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profileEmail => 'Email address';

  @override
  String get profilePhone => 'Phone number';

  @override
  String get profileNotProvided => 'Not provided';

  @override
  String get profileAccountType => 'Account type';

  @override
  String get profileDemoAccount => 'Demo account (not a real account)';

  @override
  String get profileDemoNote =>
      'These details are what you typed when signing in. They are kept in memory only and are not saved or sent anywhere.';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileNeedsBackend =>
      'Available when accounts are connected to the server.';

  @override
  String get aboutTitle => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescriptionTitle => 'About the app';

  @override
  String get aboutDescription1 =>
      'Masjid Management App is a mobile application designed to simplify mosque management and give the community easy access to important information.';

  @override
  String get aboutDescription2 =>
      'The app aims to bring mosque management services together, so that important information and tasks are available in one place.';

  @override
  String get aboutFeaturesTitle => 'Main features';

  @override
  String get aboutFeaturesNote =>
      '\"Available (sample data)\" means the screen works with clearly labelled sample data until the server is connected. \"Coming soon\" features are not built yet.';

  @override
  String get aboutStatusDemo => 'Available (sample data)';

  @override
  String get aboutFeaturePrayer => 'Prayer Times';

  @override
  String get aboutFeaturePrayerDesc => 'The times of the five daily prayers.';

  @override
  String get aboutFeatureDonations => 'Donations';

  @override
  String get aboutFeatureDonationsDesc => 'Recording and tracking donations.';

  @override
  String get aboutFeatureEvents => 'Events';

  @override
  String get aboutFeatureEventsDesc => 'Mosque news and occasions.';

  @override
  String get aboutFeatureQuran => 'Quran Classes';

  @override
  String get aboutFeatureQuranDesc => 'Information about Quran lessons.';

  @override
  String get aboutFeatureAnnouncements => 'Announcements';

  @override
  String get aboutFeatureAnnouncementsDesc => 'Important announcements.';

  @override
  String get aboutFeatureNotifications => 'Notifications';

  @override
  String get aboutFeatureNotificationsDesc => 'App notifications.';

  @override
  String get aboutFeatureProfile => 'Profile';

  @override
  String get aboutFeatureProfileDesc => 'User and account information.';

  @override
  String get aboutFeatureSettings => 'Settings';

  @override
  String get aboutFeatureSettingsDesc => 'App preferences.';

  @override
  String get aboutDeveloperTitle => 'About the Developer';

  @override
  String get aboutEmail => 'Email';

  @override
  String get aboutPhone => 'Phone';

  @override
  String get aboutLocation => 'Location';

  @override
  String get aboutEmailCopied => 'Email address copied.';

  @override
  String get aboutPhoneCopied => 'Phone number copied.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyMessage =>
      'Notifications will appear here once push notifications are connected to the server.';

  @override
  String get themeSwitchToDark => 'Switch to dark mode';

  @override
  String get themeSwitchToLight => 'Switch to light mode';

  @override
  String get themeDarkActive => 'Dark mode is on';

  @override
  String get themeLightActive => 'Light mode is on';

  @override
  String get homeMenuProjects => 'Projects';

  @override
  String get projTitle => 'Mosque Projects';

  @override
  String get projAdd => 'Add project';

  @override
  String get projEditTitle => 'Edit project';

  @override
  String get projDetailsTitle => 'Project details';

  @override
  String get projSearchHint => 'Search projects by name';

  @override
  String get projSampleTitle => 'Sample projects — not real';

  @override
  String get projSampleMessage =>
      'These projects, amounts and updates are sample (mock) data for testing the design. They are not real projects of the mosque.';

  @override
  String get projEmptyTitle => 'No projects';

  @override
  String get projEmptyMessage =>
      'Mosque projects will appear here once they are published.';

  @override
  String get projNoResults => 'No projects found';

  @override
  String get projFeatured => 'Featured projects';

  @override
  String get projOngoing => 'Ongoing projects';

  @override
  String get projRecent => 'Recently added';

  @override
  String get projNotFound => 'This project was not found.';

  @override
  String get projStatusPlanned => 'Planned';

  @override
  String get projStatusOngoing => 'Ongoing';

  @override
  String get projStatusPaused => 'Paused';

  @override
  String get projStatusCompleted => 'Completed';

  @override
  String get projStatusCancelled => 'Cancelled';

  @override
  String get projMilestonePending => 'Not started';

  @override
  String get projMilestoneInProgress => 'In progress';

  @override
  String get projMilestoneCompleted => 'Completed';

  @override
  String get projPhysicalProgress => 'Work progress';

  @override
  String get projProgressUnknown => 'Not reported';

  @override
  String projExpectedEnd(String date) {
    return 'Expected end $date';
  }

  @override
  String projStarts(String date) {
    return 'Starts $date';
  }

  @override
  String get projInfo => 'Project information';

  @override
  String get projCategory => 'Category';

  @override
  String get projMosque => 'Mosque';

  @override
  String get projLocation => 'Location';

  @override
  String get projManager => 'Project manager / department';

  @override
  String get projExpectedEndLabel => 'Expected completion';

  @override
  String get projLastUpdated => 'Last updated';

  @override
  String get projObjectives => 'Objectives';

  @override
  String get projBeneficiaries => 'Expected beneficiaries';

  @override
  String get projFunding => 'Funding';

  @override
  String get projBudget => 'Total budget';

  @override
  String get projFundingTarget => 'Funding target';

  @override
  String get projApprovedExpenses => 'Approved project expenses (staff)';

  @override
  String get projFundingRule =>
      'Raised = confirmed donations to this project\'s campaign only. Pending and demo donations are not counted. The remaining target is not the mosque\'s cash balance, and the budget is not money already spent.';

  @override
  String get projNoCampaign =>
      'No fundraising campaign is linked to this project, so donations are not open.';

  @override
  String get projReportsPending =>
      'Published financial reports for projects will be added when the server is connected.';

  @override
  String get projProgress => 'Work progress';

  @override
  String get projProgressSeparate =>
      'Work progress is reported by the administrator and is separate from funding: raising 60% of the budget does not mean the work is 60% done.';

  @override
  String get projMilestones => 'Milestones';

  @override
  String projDue(String date) {
    return 'Due $date';
  }

  @override
  String get projUpdates => 'Progress updates';

  @override
  String get projAddUpdate => 'Add update';

  @override
  String get projEditUpdateTitle => 'Edit update';

  @override
  String get projNoUpdates => 'No published updates yet.';

  @override
  String get projDraft => 'Draft';

  @override
  String projEditedTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Edited $count times (earlier versions kept)',
      one: 'Edited once (earlier version kept)',
    );
    return '$_temp0';
  }

  @override
  String get projHistory => 'Change history';

  @override
  String get projDonate => 'Donate to this project';

  @override
  String get projClosedForDonations =>
      'This project is not accepting donations.';

  @override
  String get projDonatingTo => 'Donating to the project';

  @override
  String get projErrorAmount => 'Enter a valid amount, e.g. 5000 or 5000.50.';

  @override
  String get projErrorNegative => 'The amount cannot be negative.';

  @override
  String get projErrorDates =>
      'The expected completion date cannot be before the start date.';

  @override
  String get projErrorPercent => 'Enter a whole number from 0 to 100.';

  @override
  String get projFieldTitle => 'Project title';

  @override
  String get projFieldSummary => 'Short description';

  @override
  String projBudgetLabel(String code) {
    return 'Total budget ($code)';
  }

  @override
  String projFundingTargetOptional(String code) {
    return 'Funding target ($code, optional — defaults to the budget)';
  }

  @override
  String get projLinkedCampaign => 'Fundraising campaign';

  @override
  String get projLinkedCampaignHint =>
      'Donations to this campaign count as funds for the project. Only campaigns in the same currency are listed.';

  @override
  String get projNoCampaignOption => 'None (donations not open)';

  @override
  String get projPhysicalProgressField => 'Work progress % (optional)';

  @override
  String get projProgressNote => 'Progress description';

  @override
  String get projFeaturedSwitch => 'Featured project';

  @override
  String get projUploadImages => 'Add images';

  @override
  String get projImagesPending =>
      'Image upload will work once storage (server) is connected.';

  @override
  String get projAddMilestone => 'Add milestone';

  @override
  String get projRemoveMilestone => 'Remove milestone';

  @override
  String get projMilestoneTitle => 'Milestone title';

  @override
  String get projDueDate => 'Due date';

  @override
  String get projHistoryCreated => 'Project created';

  @override
  String get projHistoryEdited => 'Project edited';

  @override
  String projHistoryBudget(String from, String to) {
    return 'Budget $from → $to';
  }

  @override
  String projHistoryStatus(String from, String to) {
    return 'Status $from → $to';
  }

  @override
  String get projHistoryCampaign => 'Fundraising campaign changed';

  @override
  String get projUpdateTitle => 'Update title';

  @override
  String get projUpdatePercent => 'Progress % (optional)';

  @override
  String get projUpdateMilestone => 'Milestone achieved (optional)';

  @override
  String get projPublishSwitch => 'Published';

  @override
  String get projPublishHint =>
      'Only published updates are visible to members.';

  @override
  String get projExpenseProject => 'Project (optional)';
}
