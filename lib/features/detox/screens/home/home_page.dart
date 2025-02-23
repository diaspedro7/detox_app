// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../data/services/permission_storage_hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (getPermission() == false) {
      setPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(TSizes.lg),
        child: Column(
          children: [
            Consumer<AppViewModel>(
              builder: (context, viewmodel, child) => Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        viewmodel.getAppsList();
                        debugPrint("Apps: ${viewmodel.appsList}");
                      },
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: TSizes.xl,
                      )),
                  IconButton(
                      onPressed: () {
                        viewmodel.toggleAppsListViewVisibility();
                        if (viewmodel.appsListViewVisibility == false) {
                          viewmodel.setSelectedAppsLocalDatabase();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_left_outlined,
                        size: TSizes.xl,
                      ))
                ],
              ),
            ),
            Consumer<AppViewModel>(
              builder: (context, viewmodel, child) => Visibility(
                visible: viewmodel.appsListViewVisibility,
                child: SizedBox(
                  width: double.infinity,
                  height: TSizes.listViewHeight,
                  child: ListView.builder(
                    itemCount: viewmodel.appsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: TSizes.twelve),
                        child: Container(
                          height: TSizes.selectAppsTileHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: TColors.white,
                              borderRadius: BorderRadius.circular(TSizes.md)),
                          child: Row(
                            children: [
                              viewmodel.appsList[index].appIcon.isNotEmpty
                                  ? Image.memory(
                                      viewmodel.appsList[index].appIcon,
                                      width: TSizes.appsImage,
                                      height: TSizes.appsImage)
                                  : Icon(Icons.android, size: TSizes.appsImage),
                              SizedBox(
                                width: TSizes.selectAppsTileTextWidth,
                                child: Text(
                                  viewmodel.appsList[index].appName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .apply(color: TColors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Checkbox(
                                value: viewmodel.selectedAppsMap[viewmodel
                                        .appsList[index].appPackageName] ??
                                    false,
                                onChanged: (value) {
                                  viewmodel.selectApp(
                                      viewmodel.appsList[index].appPackageName);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
