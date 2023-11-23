import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show WidgetRef;
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../core/base/state/base_state.dart';
import '../core/base/view/base_view.dart';
import '../core/components/text/locale_text.dart';
import 'location_screen.dart';
import 'settings_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: "",
      onPageBuilder: (BuildContext context, String value) {
        return Scaffold(
          appBar: appBar,
          drawer: drawer,
          bottomNavigationBar: bottomNavigationBar,
          body: PageView.builder(
            controller: pageController,
            itemCount: 3,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const WeatherScreen();
                case 1:
                  return const LocationScreen();
                case 2:
                  return const SettingsScreen();
                default:
                  return const WeatherScreen();
              }
            },
          ),
        );
      },
      onModelReady: (WidgetRef model) {},
    );
  }

  AppBar get appBar => AppBar(
        title: LocaleText("app_name"),
      );

  Drawer get drawer => Drawer(
        width: dynamicWidth(0.4),
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(227, 242, 253, 1),
                  gradient: LinearGradient(colors: [
                    Color(0xFF4D57F0),
                    Color.fromARGB(185, 77, 88, 240),
                    Color(0xFF4D57F0),
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight,
                  )
                  ),
              child: Center(
                  child: LocaleText(
                "app_name",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,color: Colors.white70),
              )),
            ),
            ListTile(
              title: LocaleText(
                "hava_durumu",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                setState(() {
                  currentIndex = 0;
                });
                await pageController
                    ?.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease)
                    .then((value) => Navigator.pop(context));
              },
            ),
            ListTile(
              title: LocaleText(
                "konum",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                setState(() {
                  currentIndex = 1;
                });
                await pageController
                    ?.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease)
                    .then((value) => Navigator.pop(context));
              },
            ),
            ListTile(
              title: LocaleText(
                "ayarlar",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () async {
                setState(() {
                  currentIndex = 2;
                });
                await pageController
                    ?.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease)
                    .then((value) => Navigator.pop(context));
              },
            ),
          ],
        ),
      );

  BottomNavigationBar get bottomNavigationBar => BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.cloud),
            label: "hava_durumu".tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.location),
            label: "konum".tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'ayarlar'.tr,
          ),
        ],
        currentIndex: currentIndex,
        onTap: bottomNavbarOnPress,
      );

  Future<void> bottomNavbarOnPress(int itemIndex) async {
    setState(() {
      currentIndex = itemIndex;
    });
    await pageController?.animateToPage(itemIndex, duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }
}
