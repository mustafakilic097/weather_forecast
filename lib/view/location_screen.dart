import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/core/base/state/base_state.dart';
import 'package:weather_forecast/core/base/view/base_view.dart';
import 'package:weather_forecast/core/init/location/location_manager.dart';
import 'package:weather_forecast/core/init/theme/app_theme_light.dart';
import 'package:weather_forecast/core/viewmodel/location_view_model.dart';
import '../core/components/text/locale_text.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends BaseState<LocationScreen> {
  late WidgetRef ref;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locationViewModel,
      onPageBuilder: (context, value) {
        final LocationViewModel viewModel = ref.watch(locationViewModel);
        return buildBody(viewModel);
      },
      onModelReady: (model) {
        ref = model;
        Future.delayed(
          Duration.zero,
          () => model.read(locationViewModel).getLocations(),
        );
      },
    );
  }

  Widget buildBody(LocationViewModel viewModel) => Column(
        children: [
          locationAddArea,
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.locations.length,
              itemBuilder: (context, i) {
                return locationCard(viewModel, i);
              },
            ),
          )
        ],
      );

  Widget get locationAddArea => SizedBox(
      height: dynamicHeight(0.05),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async => await locationAddPress(),
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: themeData.chipTheme.backgroundColor),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.add,
                        size: 14,
                        color: Color.fromRGBO(33, 33, 33, 1),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      LocaleText(
                        "konum_ekle",
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

  Padding locationCard(LocationViewModel viewModel, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: Key(viewModel.locations[i].hashCode.toString()),
        onDismissed: (direction) async {
          await ref.read(locationViewModel).removeLocation(viewModel.locations[i].cityName).then((value) {
            ref.read(locationViewModel).getLocations();
          });
        },
        resizeDuration: const Duration(milliseconds: 700),
        background: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.shade200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LocaleText("kaldir"),
              LocaleText("kaldir"),
            ],
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: themeData.scaffoldBackgroundColor == AppThemeLight.instance.theme.scaffoldBackgroundColor
              ? Colors.blue.shade50
              : Colors.grey.shade600,
          title: Row(
            children: [
              Text(
                "${viewModel.locations[i].cityName},${viewModel.locations[i].districtName}",
                style: TextStyle(color: Colors.blue.shade900),
              ),
              Icon(
                Icons.location_on,
                color: Colors.blue.shade800,
              )
            ],
          ),
          trailing: const Text(
            "23°",
            textScaleFactor: 2,
            style: TextStyle(color: Color.fromRGBO(33, 150, 243, 1)),
          ),
        ),
      ),
    );
  }

  Future<void> locationAddPress() async {
    try {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: LocaleText("konum_yukleniyor"),
        showCloseIcon: true,
        backgroundColor: Colors.blue.shade300,
      ));
      await LocationManager.instance.getCurrentLocation().then((location) async {
        if (location == null ||
            location["city"] == null ||
            location["district"] == null ||
            location["city"]!.startsWith("Thrott")) {
          throw Exception("Konum bilgisi alınamadı");
        }
        await ref.read(locationViewModel).addLocation(location["city"]!).then((value) {
          ref.read(locationViewModel).getLocations();
        });
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [LocaleText("hata"), Text(e.toString())],
        ),
        backgroundColor: Colors.orange,
      ));
      ref.read(locationViewModel).getLocations();
    }
  }
}
