import 'package:diary/diary_details_screen.dart';
import 'package:diary/diary_edit_screen.dart';
import 'package:diary/home.dart';
import 'package:diary/model/diary_model.dart';
import 'package:diary/model/user_model.dart';
import 'package:diary/onboarding_screen.dart';
import 'package:diary/password_screen/confirm_password_screen.dart';
import 'package:diary/password_screen/security_question_screen.dart';
import 'package:diary/setting_screens/backup.dart';
import 'package:diary/setting_screens/deleted.dart';
import 'package:diary/setting_screens/reminder.dart';
import 'package:diary/setting_screens/security.dart';
import 'package:diary/setting_screens/starred.dart';
import 'package:diary/setting_screens/theme.dart';
import 'package:diary/splash_screen.dart';
import 'package:diary/tags_edit_screen.dart';
import 'package:flutter/material.dart';

import '../password_screen/set_password_screen.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: ((context) => const SplashScreen()));

      case '/onboarding_screen':
        return MaterialPageRoute(builder: ((context) => OnboardingScreen()));

      case '/home_screen':
        return MaterialPageRoute(builder: ((context) => const HomeScreen()));

      case '/set_password_screen':
        return MaterialPageRoute(builder: ((context) => const SetPasswordScreen()));

      case '/confirm_password_screen':
        return MaterialPageRoute(builder: ((context) => const ConfirmPasswordScreen()));

      case '/security_question_screen':
        return MaterialPageRoute(builder: ((context) => const SecurityQuestionScreen()));

      case '/theme_screen':
        return MaterialPageRoute(builder: ((context) => const ThemeScreen()));

      case '/reminder_screen':
        return MaterialPageRoute(builder: ((context) => const ReminderScreen()));

      case '/backup_screen':
        return MaterialPageRoute(builder: ((context) => const BackupScreen()));

      case '/security_screen':
        return MaterialPageRoute(builder: ((context) => const SecurityScreen()));

      case '/starred_screen':
        return MaterialPageRoute(builder: ((context) => const StarredScreen()));

      case '/deleted_screen':
        return MaterialPageRoute(builder: ((context) => const DeletedScreen()));

      case '/details_screen':
        return MaterialPageRoute(
            builder: ((context) => DetailsScreen(diaryModel: settings.arguments as DiaryModel)));
      case '/diary_edit_screen':
        return MaterialPageRoute(
            builder: ((context) => DiaryEdit(selectedDm: settings.arguments as DiaryModel)));
      case '/tags_edit_screen':
        return MaterialPageRoute(builder: ((context) => const TagsEditScreen()));
      default:
        return _errorPage();
    }
  }

  static Route<dynamic> _errorPage() {
    return MaterialPageRoute(builder: ((context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error Page'),
        ),
        body: const Center(child: Text('Page not found')),
      );
    }));
  }
}
