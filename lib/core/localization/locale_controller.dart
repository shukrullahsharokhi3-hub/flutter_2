import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Owns the user-selected locale and persists it between app launches.
class LocaleController extends ChangeNotifier {
  static const _preferenceKey = 'gfms_locale';
  Locale _locale = const Locale('en');
  bool _userSelectedLocale = false;
  Locale get locale => _locale;
  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_preferenceKey);
    if (_userSelectedLocale) return;
    final restored = saved == 'fa-AF' ? const Locale('fa', 'AF') : const Locale('en');
    if (_locale != restored) {
      _locale = restored;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    final selected = locale.languageCode == 'fa'
        ? const Locale('fa', 'AF')
        : const Locale('en');
    _userSelectedLocale = true;
    // Update the whole app immediately; persistence completes in the background.
    if (_locale != selected) {
      _locale = selected;
      notifyListeners();
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, selected.toLanguageTag());
  }
}
