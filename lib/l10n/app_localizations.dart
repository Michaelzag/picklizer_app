import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('ar'),
    Locale('de'),
    Locale('es'),
    Locale('fil'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('pt'),
    Locale('th'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Pickleizer'**
  String get appTitle;

  /// Bottom navigation tab for live view
  ///
  /// In en, this message translates to:
  /// **'Live View'**
  String get liveView;

  /// Bottom navigation tab for queue
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// Bottom navigation tab for facilities
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// Bottom navigation tab for players
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// Bottom navigation tab for sessions
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Button to create a new facility
  ///
  /// In en, this message translates to:
  /// **'Create Facility'**
  String get createFacility;

  /// Button to add a new court
  ///
  /// In en, this message translates to:
  /// **'Add Court'**
  String get addCourt;

  /// Button to add a new player
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get addPlayer;

  /// Button to create a new session
  ///
  /// In en, this message translates to:
  /// **'Create Session'**
  String get createSession;

  /// Label for facility name field
  ///
  /// In en, this message translates to:
  /// **'Facility Name'**
  String get facilityName;

  /// Label for location field
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Label for player name field
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get playerName;

  /// Label for skill level field
  ///
  /// In en, this message translates to:
  /// **'Skill Level'**
  String get skillLevel;

  /// Beginner skill level
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// Intermediate skill level
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// Advanced skill level
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// Singles game mode
  ///
  /// In en, this message translates to:
  /// **'Singles'**
  String get singles;

  /// Doubles game mode
  ///
  /// In en, this message translates to:
  /// **'Doubles'**
  String get doubles;

  /// King of Hill game mode
  ///
  /// In en, this message translates to:
  /// **'King of Hill'**
  String get kingOfHill;

  /// Round Robin game mode
  ///
  /// In en, this message translates to:
  /// **'Round Robin'**
  String get roundRobin;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Title for setup walkthrough
  ///
  /// In en, this message translates to:
  /// **'Setup Walkthrough'**
  String get setupWalkthrough;

  /// Progress indicator showing current step
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String stepXOfY(int step, int total);

  /// Text shown when facility has no location
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get noLocation;

  /// Text showing number of courts (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} Court'**
  String courtCount(int count);

  /// Text showing number of courts (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} Courts'**
  String courtsCount(int count);

  /// Text showing number of players (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} Player'**
  String playerCount(int count);

  /// Text showing number of players (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} Players'**
  String playersCount(int count);

  /// Text showing additional players count
  ///
  /// In en, this message translates to:
  /// **' +{count} more'**
  String morePlayersIndicator(int count);

  /// Text showing session is currently active
  ///
  /// In en, this message translates to:
  /// **'Session Active'**
  String get sessionActive;

  /// Text showing when session was started
  ///
  /// In en, this message translates to:
  /// **'Started at {time}'**
  String startedAt(String time);

  /// Title for facility creation step
  ///
  /// In en, this message translates to:
  /// **'Create Your Facility'**
  String get createYourFacility;

  /// Description for facility creation step
  ///
  /// In en, this message translates to:
  /// **'A facility represents the location where you play pickleball.'**
  String get facilityDescription;

  /// Title for courts setup step
  ///
  /// In en, this message translates to:
  /// **'Setup Courts'**
  String get setupCourts;

  /// Description for courts setup step
  ///
  /// In en, this message translates to:
  /// **'Add at least one court to {facilityName}.'**
  String courtsDescription(String facilityName);

  /// Title for players setup step
  ///
  /// In en, this message translates to:
  /// **'Add Players'**
  String get addPlayers;

  /// Description for players setup step
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 players to start playing.'**
  String get playersDescription;

  /// Title for session start step
  ///
  /// In en, this message translates to:
  /// **'Start Your Session'**
  String get startYourSession;

  /// Description for session start step
  ///
  /// In en, this message translates to:
  /// **'Ready to start playing at {facilityName} with {playerCount} players and {courtCount} court{courtPlural}.'**
  String sessionDescription(
    String facilityName,
    int playerCount,
    int courtCount,
    String courtPlural,
  );

  /// Button text to start session
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// Title for completion step
  ///
  /// In en, this message translates to:
  /// **'All Set!'**
  String get allSet;

  /// Description for completion step
  ///
  /// In en, this message translates to:
  /// **'Your session is active and ready for play. Players can now join the queue.'**
  String get completedDescription;

  /// Button text to go to live view
  ///
  /// In en, this message translates to:
  /// **'Go to Live View'**
  String get goToLiveView;

  /// Error message when courts fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading courts'**
  String get errorLoadingCourts;

  /// Error message when trying to start session without enough players
  ///
  /// In en, this message translates to:
  /// **'Need at least 2 players to start a session'**
  String get needAtLeastTwoPlayers;

  /// Success message when session starts
  ///
  /// In en, this message translates to:
  /// **'Session started successfully!'**
  String get sessionStartedSuccessfully;

  /// Error message when session fails to start
  ///
  /// In en, this message translates to:
  /// **'Error starting session: {error}'**
  String errorStartingSession(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fil',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'ms',
    'pt',
    'th',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
