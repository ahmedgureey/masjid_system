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
}
