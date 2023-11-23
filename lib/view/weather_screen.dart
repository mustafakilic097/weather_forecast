import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/base/state/base_state.dart';
import '../core/base/view/base_view.dart';
import '../core/components/text/locale_text.dart';
import '../core/extension/color_extension.dart';
import '../core/init/cache/locale_manager.dart';
import '../core/init/theme/app_theme_light.dart';
import '../core/viewmodel/weather_view_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends BaseState<WeatherScreen> {
  late WidgetRef ref;
  late WeatherViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      onPageBuilder: (context, value) {
        viewModel = ref.watch(weatherViewModel);
        return scaffoldBody;
      },
      viewModel: weatherViewModel,
      onModelReady: (model) {
        ref = model;
        ref.read(weatherViewModel).getWeatherData();
      },
    );
  }

  Widget get scaffoldBody => SingleChildScrollView(
        child: Column(
          children: [
            locationArea,
            degreeArea,
            hoursWeatherArea,
            detailsWeatherArea,
            weeklyWeatherArea,
          ],
        ),
      );

  Widget get locationArea => SizedBox(
      height: dynamicHeight(0.05),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    currentIndex = 1;
                  });

                  await pageController?.animateToPage(1,
                      duration: const Duration(milliseconds: 500), curve: Curves.ease);
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: themeData.chipTheme.backgroundColor),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.location,
                        size: 14,
                        color: Color.fromRGBO(33, 33, 33, 1),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${LocaleManager.instance.getStringValue("cities")?.split(",")[0] ?? "İstanbul"},Merkez",
                        style: themeData.chipTheme.labelStyle,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ));

  Widget get degreeArea => SizedBox(
        height: dynamicHeight(0.25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${double.parse(viewModel.currentWeatherData[DateTime.now().weekday].degree ?? "").round()}°C",
                  textScaleFactor: 3),
              CachedNetworkImage(
                imageUrl: viewModel.currentWeatherData[DateTime.now().weekday].icon ?? "",
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(
                  Icons.sunny,
                  size: 47,
                  color: HexColor.fromHex("#4D57F0"),
                ),
                width: 47,
                height: 47,
                // color: HexColor.fromHex("#4D57F0"),
              ),
              Text(viewModel.currentWeatherData[DateTime.now().weekday].description?.toUpperCase() ?? "",
                  style: TextStyle(color: HexColor.fromHex("#4D57F0")))
            ],
          ),
        ),
      );

  Widget get hoursWeatherArea => SizedBox(
        height: dynamicHeight(0.20),
        child: Column(
          children: [
            Divider(
              color: Colors.grey.shade100,
              indent: 14,
              endIndent: 14,
              height: 1,
            ),
            SizedBox(
              height: dynamicHeight(0.19),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: viewModel.currentWeatherData.length,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 30),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${(DateTime.now().hour + index) > 23 ? (DateTime.now().hour + index) - 24 : (DateTime.now().hour + index)}:00",
                        style: index == 0 ? TextStyle(color: HexColor.fromHex("#4D57F0")) : null,
                      ),
                      Text(
                        "${double.tryParse(viewModel.currentWeatherData[index].degree ?? "")?.round() ?? ""}°",
                        style: index == 0 ? TextStyle(color: HexColor.fromHex("#4D57F0")) : null,
                      ),
                      CachedNetworkImage(
                        imageUrl: viewModel.currentWeatherData[index].icon ?? "",
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.sunny,
                          size: 20,
                          color: Colors.yellow,
                        ),
                        width: 20,
                        height: 20,
                        // color: HexColor.fromHex("#4D57F0"),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => index == 6
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        width: 30,
                      ),
              ),
            ),
            Divider(
              color: Colors.grey.shade100,
              indent: 14,
              endIndent: 14,
              height: 1,
            ),
          ],
        ),
      );

  Widget get detailsWeatherArea => SizedBox(
        height: dynamicHeight(0.28),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50, top: 30),
              child: SizedBox(
                height: dynamicHeight(0.1),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: oneDetail(
                        text: "yagis_olasiligi",
                        content: "${(Random().nextDouble() * 100).round()}%",
                        value: Random().nextDouble(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      // EN SON DETAYLARDAKİ VERİLERİ GERÇEK VERİLER EŞLİYORDUK. DATETİME.NOW() VERİSİNİ STATE'DE TUT
                      child: oneDetail(
                          text: "hissedilen",
                          content: "${viewModel.currentWeatherData[DateTime.now().weekday].degree ?? ""}°",
                          value:
                              double.parse(viewModel.currentWeatherData[DateTime.now().weekday].degree ?? "0") * 0.02),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade100,
              indent: 50,
              endIndent: 50,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 47, top: 30),
              child: SizedBox(
                height: dynamicHeight(0.1),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: oneDetail(
                          text: "ruzgar", content: "${Random().nextInt(25)} km/h", value: Random().nextDouble()),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: oneDetail(
                          text: "nem",
                          content: "${viewModel.currentWeatherData[DateTime.now().weekday].humidity ?? ""}%",
                          value:
                              (double.tryParse(viewModel.currentWeatherData[DateTime.now().weekday].humidity ?? "") ??
                                      0) /
                                  100),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget oneDetail({required String text, required String content, required double value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: RotatedBox(
            quarterTurns: -1,
            child: SizedBox(
              width: 40,
              height: 2,
              child: LinearProgressIndicator(
                value: value,
                valueColor: AlwaysStoppedAnimation(HexColor.fromHex("#4D57F0")),
                backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 20),
              child: LocaleText(
                text,
                style: themeData.textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                content,
                style: themeData.textTheme.headlineMedium,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget get weeklyWeatherArea => Column(
        children: [
          SizedBox(
            height: dynamicHeight(0.02),
            child: const Center(
              child: Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ),
          weeklyHeader,
          todayWeatherCard,
          const SizedBox(
            height: 50,
          ),
          weeklyWeatherDetail,
          const SizedBox(
            height: 150,
          ),
        ],
      );

  Padding get weeklyHeader => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 36),
        child: Align(
            alignment: Alignment.centerLeft,
            child: LocaleText(
              "7_gunluk",
              style: const TextStyle(
                color: Color(0xFF4D57F0),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            )),
      );

  Widget get todayWeatherCard => Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          height: dynamicHeight(0.15),
          width: double.maxFinite,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeData.scaffoldBackgroundColor == AppThemeLight.instance.theme.scaffoldBackgroundColor
                ? Colors.white
                : Colors.grey.shade500,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 48,
                offset: Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        viewModel.currentWeatherData[DateTime.now().weekday].day ?? "",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      CachedNetworkImage(
                        imageUrl: viewModel.currentWeatherData[DateTime.now().weekday].icon ?? "",
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.sunny,
                          size: 21,
                          color: Colors.yellow,
                        ),
                        width: 21,
                        height: 21,
                        // color: HexColor.fromHex("#4D57F0"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${double.parse(viewModel.currentWeatherData[DateTime.now().weekday].max ?? "0").round()}°C",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${double.parse(viewModel.currentWeatherData[DateTime.now().weekday].min ?? "0").round()}°C",
                        style: const TextStyle(color: Color(0xFF77838F)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
                width: double.infinity,
              ),
              Wrap(
                runSpacing: 26,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: dynamicWidth(0.35)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LocaleText(
                          "ruzgar",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          "10 m/h",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF77838F),
                          ),
                        )
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: dynamicWidth(0.35)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LocaleText(
                          "gorus_mesafesi",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          "20 km",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF77838F),
                          ),
                        )
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: dynamicWidth(0.35)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LocaleText(
                          "nem",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${viewModel.currentWeatherData[DateTime.now().weekday].humidity ?? ""}%",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF77838F),
                          ),
                        )
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: dynamicWidth(0.35)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "UV",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "1",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF77838F),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  Widget get weeklyWeatherDetail => Column(
      children: List.generate(
          viewModel.currentWeatherData.length,
          (i) => Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: dynamicWidth(0.6 / 2.8),
                            child: Text(
                              (viewModel.currentWeatherData[i].day ?? "").toUpperCase().substring(0, 3),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          width: dynamicWidth(1.5 / 2.8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${double.parse(viewModel.currentWeatherData[i].min ?? "0").round()}°C",
                                style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF77838F)),
                              ),
                              Container(
                                width: 90,
                                height: 23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: LinearProgressIndicator(
                                  backgroundColor: const Color(0xFFF74513),
                                  color: const Color(0xFFCDD0FF),
                                  value: (100 /
                                          (double.parse(viewModel.currentWeatherData[i].max ?? "0") +
                                              double.parse(viewModel.currentWeatherData[i].min ?? "0"))) *
                                      (double.parse(viewModel.currentWeatherData[i].max ?? "0")) /
                                      100,
                                ),
                              ),
                              Text(
                                "${double.parse(viewModel.currentWeatherData[i].max ?? "0").round()}°C",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: dynamicWidth(0.5 / 2.8),
                          child: CachedNetworkImage(
                            imageUrl: viewModel.currentWeatherData[i].icon ?? "",
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.sunny,
                              size: 21,
                              color: Colors.yellow,
                            ),
                            width: 21,
                            height: 24,
                            // color: HexColor.fromHex("#4D57F0"),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 238, 238, 241),
                    )
                  ],
                ),
              )));
}
