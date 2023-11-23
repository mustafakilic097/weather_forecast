import 'package:flutter/material.dart' show BuildContext, Widget, WidgetsFlutterBinding, runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, ProviderScope, WidgetRef;
import 'package:get/get.dart' show GetMaterialApp;
import 'core/init/cache/locale_manager.dart';
import 'core/init/lang/language_manager.dart';
import 'core/init/navigation/navigation_manager.dart';
import 'core/init/theme/theme_notifier.dart';
import 'view/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleManager.preferencesInit();
  runApp(const ProviderScope(child: HomePage()));
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeNotifier themeNotifier = ref.watch(themeNotifierProvider);
    final langInstance = LanguageManager.instance;
    return GetMaterialApp(
      translations: LanguageManager.instance,
      locale: LocaleManager.instance.getStringValue("locale") == "en" ? langInstance.enLocale : langInstance.trLocale,
      // supportedLocales: LanguageManager.instance.supportedLocales,
      fallbackLocale: langInstance.trLocale,
      theme: themeNotifier.currentTheme,
      title: "Weather Forecast",
      initialRoute: NavigationManager.getHomeRoute,
      getPages: NavigationManager.routes,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
