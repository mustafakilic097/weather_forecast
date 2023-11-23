import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/core/init/cache/locale_manager.dart';

class LanguageManager extends Translations {
  static final LanguageManager _instance = LanguageManager();
  static LanguageManager get instance => _instance;
  LanguageManager();

  Locale get enLocale => const Locale("en", "US");
  Locale get trLocale => const Locale("tr", "TR");

  List<Locale> get supportedLocales => [enLocale, trLocale];

  Future<void> updateLocale(Locale locale) async {
    await Get.updateLocale(locale);
    await LocaleManager.instance.setStringValue("locale", locale.languageCode);
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'tr_TR': {
          "app_name": "Weather Forecast",
          "hava_durumu": "Hava Durumu",
          "konum": "Konum",
          "ayarlar": "Ayarlar",
          "gunluk_hava_durumu": "Günlük Hava Durumu",
          "yagis_olasiligi": "Yağmur yağma olasılığı",
          "hissedilen": "Hissedilen",
          "ruzgar": "Rüzgar",
          "nem": "Nem",
          "kaldir": "Kaldır",
          "hava_durumu_hakkinda": "HAVA DURUMU HAKKINDA",
          "geri_bildirim": "Geri bildirim",
          "gizlilik_politikasi": "Gizlilik Politikası",
          "dili_degistir": "Dili değiştir [TR -> EN]",
          "gece_temasi": "Gece teması",
          "diger_ayarlar": "DİĞER AYARLAR",
          "konum_sifirla":"Tüm konumları sıfırla",
          "7_gunluk":"Haftalık hava durumu",
          "gorus_mesafesi":"Görüş Mesafesi",
          "konum_ekle":"Konum ekle",
          "konum_yukleniyor":"Konumunuz yükleniyor. Lütfen bekleyin...",
          "hata":"Bir hata ile karşılaşıldı!!"
        },
        'en_US': {
          "app_name": "Weather Forecast",
          "hava_durumu": "Weather",
          "konum": "Location",
          "ayarlar": "Settings",
          "gunluk_hava_durumu": "Daily weather",
          "yagis_olasiligi": "Chance of rain",
          "hissedilen": "Realfeel",
          "ruzgar": "Wind",
          "nem": "Humidity",
          "kaldir": "Remove",
          "hava_durumu_hakkinda": "ABOUT WEATHER",
          "geri_bildirim": "Feedback",
          "gizlilik_politikasi": "Privacy Policy",
          "dili_degistir": "Change language [EN -> TR]",
          "gece_temasi": "Night theme",
          "diger_ayarlar": "OTHER SETTİNGS",
          "konum_sifirla":"Reset all locations",
          "7_gunluk":"Weekly weather",
          "gorus_mesafesi":"Visibility",
          "konum_ekle":"Add location",
          "konum_yukleniyor":"Your location is loading. Please wait...",
          "hata":"An error has been encountered !!"
        },
      };
}
