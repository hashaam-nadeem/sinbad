import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalization{
  final Locale locale;

  DemoLocalization(this.locale);

  static DemoLocalization of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }
   Map<String, String> _localizedValues;
  
  Future load() async {
    String jsonStringValue = await rootBundle.loadString("lib/lang/${locale.languageCode}.json");
    
    Map<String, dynamic> mappedJson = json.decode(jsonStringValue);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key,value.toString()));
    
  }

  String getTranslatedValue(String key){
    return _localizedValues[key];
  }

  ///stats
   static const LocalizationsDelegate<DemoLocalization> delegate = _DemoLocalizationDelegate();

}


class _DemoLocalizationDelegate extends LocalizationsDelegate<DemoLocalization>{

  const _DemoLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en','ar'].contains(locale.languageCode);
    // TODO: implement isSupported
    throw UnimplementedError();
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    DemoLocalization localization = new DemoLocalization(locale);
    await localization.load();
    return localization;
    // TODO: implement load
    throw UnimplementedError();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<DemoLocalization> old) {
    // TODO: implement shouldReload
    throw UnimplementedError();
  }
  
}