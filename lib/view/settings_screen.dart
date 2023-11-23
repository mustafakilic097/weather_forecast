import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/core/base/state/base_state.dart';
import 'package:weather_forecast/core/base/view/base_view.dart';
import 'package:weather_forecast/core/components/listtile/custom_list_tile.dart';
import 'package:weather_forecast/core/components/text/locale_text.dart';
import 'package:weather_forecast/core/constants/enum/app_theme_enum.dart';
import 'package:weather_forecast/core/init/lang/language_manager.dart';
import 'package:weather_forecast/core/init/theme/theme_notifier.dart';
import 'package:weather_forecast/core/viewmodel/location_view_model.dart';

import '../core/init/theme/app_theme_dark.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends BaseState<SettingsScreen> {
  late WidgetRef ref;
  late ThemeNotifier themeNotifier;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: "",
      onPageBuilder: (context, value) {
        themeNotifier = ref.watch(themeNotifierProvider);
        return buildBody;
      },
      onModelReady: (model) {
        ref = model;
      },
    );
  }

  Widget get buildBody => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: LocaleText(
              "ayarlar",
              style: themeData.textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: LocaleText(
              "diger_ayarlar",
              style: themeData.textTheme.bodySmall,
            ),
          ),
          CustomListTile(
            title: LocaleText("dili_degistir"),
            type: CustomListTileType.SWITCH,
            onSwitch: (p0) async {
              await LanguageManager.instance.updateLocale(Get.locale == LanguageManager.instance.enLocale
                  ? LanguageManager.instance.trLocale
                  : LanguageManager.instance.enLocale);
            },
            enableSwitch: Get.locale == LanguageManager.instance.enLocale,
          ),
          CustomListTile(
            title: LocaleText("gece_temasi"),
            type: CustomListTileType.SWITCH,
            onSwitch: (p0) {
              if (p0) {
                ref.read(themeNotifierProvider).changeTheme(AppThemes.DARK);
              } else {
                ref.read(themeNotifierProvider).changeTheme(AppThemes.LIGHT);
              }
            },
            enableSwitch: themeNotifier.currentTheme == AppThemeDark.instance.theme,
          ),
          CustomListTile(
            title: LocaleText("konum_sifirla"),
            type: CustomListTileType.ROUTER,
            onRouter: () async {
              await ref.read(locationViewModel).resetLocations().then((value) => value == true
                  ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Başarıyla Sıfırlandı!!"),backgroundColor: Colors.green))
                  : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sıfırlanırken hata oluştu"),backgroundColor: Colors.orange,)));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: LocaleText(
              "hava_durumu_hakkinda",
              style: themeData.textTheme.bodySmall,
            ),
          ),
          CustomListTile(
            title: LocaleText("geri_bildirim"),
            type: CustomListTileType.ROUTER,
            onRouter: () {},
          ),
          CustomListTile(
            title: LocaleText("gizlilik_politikasi"),
            type: CustomListTileType.ROUTER,
            onRouter: () {},
          )
        ],
      );
}
