import 'package:matomo_tracker/matomo_tracker.dart';

class MatomoService {
  // Event names
  static const String onboardingSuccess = "onboardingSuccess";
  static const String loginSuccess = "login_success";
  static const String signupSuccess = "signup_success";
  static const String editProfile = "editProfile";
  static const String accessedGames = "accessedGames";
  static const String likeEvents = "likeEvents";

  /// Initialize Matomo
  static Future<void> initialize({
    required String siteId,
    required String url,
  }) async {
    await MatomoTracker.instance.initialize(
      siteId: siteId,
      url: url,
    );
  }

  /// Set logged-in user ID
  static void setUserId(String userId) {
    MatomoTracker.instance.setVisitorUserId(userId);
  }

  /// Clear user ID on logout
  static void clearUser() {
    MatomoTracker.instance.setVisitorUserId(null);
  }

  /// Generic event tracker
  static void trackEvent({
    required String eventName,
    String category = "app",
    String action = "tap",
    int value = 1,
    Map<String, String>? dimensions,
  }) {
    MatomoTracker.instance.trackEvent(
      eventInfo: EventInfo(
        category: category,
        action: action,
        name: eventName,
        value: value,
      ),
      dimensions: dimensions,
    );
  }

  // Tracking specific events

  static void trackOnboardingSuccess({
    Map<String, String>? dimensions,
  }) {
    trackEvent(
      eventName: onboardingSuccess,
      dimensions: dimensions,
    );
  }

  static void trackLoginSuccess({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);

    trackEvent(
      eventName: loginSuccess,
      dimensions: dimensions,
    );
  }

  static void trackSignupSuccess({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);

    trackEvent(
      eventName: signupSuccess,
      dimensions: dimensions,
    );
  }

  static void trackEditProfile({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);

    trackEvent(
      eventName: editProfile,
      dimensions: dimensions,
    );
  }

  static void trackAccessedGames({
    required String gameId,
    required String gameName,
    Map<String, String>? dimensions,
  }) {
    final eventDimensions = {
      'game_id': gameId,
      'game_name': gameName,
      ...?dimensions,
    };

    trackEvent(
      eventName: accessedGames,
      dimensions: eventDimensions,
    );
  }

  static void trackLikeEvent({
    required String eventId,
    required bool isLiked,
    Map<String, String>? dimensions,
  }) {
    final eventDimensions = {
      'event_id': eventId,
      'liked': isLiked.toString(),
      ...?dimensions,
    };

    trackEvent(
      eventName: likeEvents,
      dimensions: eventDimensions,
    );
  }
}
