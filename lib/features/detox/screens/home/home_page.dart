// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<AppViewModel>(
                  builder: (context, viewmodel, child) => Card(
                    elevation: TSizes.sm,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TSizes.md),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor:
                            Colors.transparent, // Remove a linha padrão
                        splashColor:
                            Colors.transparent, // Remove splash quadrado
                        highlightColor:
                            Colors.transparent, // Remove highlight feio
                      ),
                      child: ExpansionTile(
                        collapsedBackgroundColor: TColors.white,
                        backgroundColor: TColors.white,
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TSizes.md),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TSizes.md),
                        ),
                        title: Text("Select Apps",
                            style: Theme.of(context).textTheme.titleMedium),
                        onExpansionChanged: (value) {
                          viewmodel.getAppsList();
                          if (!value) {
                            viewmodel.setSelectedAppsLocalDatabase();
                          }
                        },
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: TColors.backgroundColor,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(TSizes.md)),
                            ),
                            child: viewmodel.appsList.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(TSizes.xl),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(TSizes.twelve),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                TSizes.md),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: TSizes.ten,
                                                offset: Offset(2, 2),
                                              ),
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                blurRadius: TSizes.sm,
                                                offset: Offset(-2, -2),
                                              ),
                                            ],
                                          ),
                                          child: CircularProgressIndicator(
                                            color: Colors.blueAccent,
                                            strokeWidth: TSizes.xs,
                                          ),
                                        ),
                                        SizedBox(height: TSizes.spaceBtwItems),
                                        Text("Loading...",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: viewmodel.appsList.length,
                                    itemBuilder: (context, index) {
                                      final app = viewmodel.appsList[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: TSizes.sm,
                                            horizontal: TSizes.md),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: TSizes.twelve,
                                              horizontal: TSizes.md),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                TSizes.twelve),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: TSizes.sm,
                                                offset: Offset(
                                                    0, TSizes.appsImage / 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              app.appIcon.isNotEmpty
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              TSizes.sm),
                                                      child: Image.memory(
                                                        app.appIcon,
                                                        width: TSizes.appsImage,
                                                        height:
                                                            TSizes.appsImage,
                                                      ),
                                                    )
                                                  : Icon(Icons.android,
                                                      size: TSizes.appsImage,
                                                      color: Colors.grey),
                                              SizedBox(width: TSizes.twelve),
                                              Expanded(
                                                child: Text(
                                                  app.appName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              Checkbox(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          TSizes.xs),
                                                ),
                                                activeColor: Colors.blueAccent,
                                                value: viewmodel
                                                            .selectedAppsMap[
                                                        app.appPackageName] ??
                                                    false,
                                                onChanged: (value) {
                                                  viewmodel.selectApp(
                                                      app.appPackageName);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
