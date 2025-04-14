import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:detox_app/common/widgets/gradient_background_container.dart';
import 'package:detox_app/data/repositories/time_storage_repository.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/common/widgets/app_card.dart';
import 'package:detox_app/features/detox/screens/alarm/widgets/title_alarm_page.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key, required this.app});

  final AppModel app;

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  int buttonIndex = 5;

  @override
  void initState() {
    super.initState();
    final timeStorage = context.read<TimeStorageRepository>();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
    Map<String, int> mapAppUsageTime = timeStorage.getMapAppUsageTime();
    int thisAppUsageTime = mapAppUsageTime[widget.app.appPackageName] ?? 0;

    if (thisAppUsageTime == 0) {
      int thisAppCurrentTime =
          timeStorage.getMapAppsCurrentTime()[widget.app.appPackageName] ?? 0;
      thisAppUsageTime = (thisAppCurrentTime / 60).ceil();
      mapAppUsageTime[widget.app.appPackageName] = thisAppUsageTime;
      timeStorage.setMapAppUsageTime(mapAppUsageTime);
    }

    Map<String, int> mapAppAcrescimCurrentTime =
        timeStorage.getMapAppAcrescimCurrentTime();
    int thisAppAcrescimCurrentTime =
        mapAppAcrescimCurrentTime[widget.app.appPackageName] ?? 0;

    if (thisAppAcrescimCurrentTime != 0) {
      thisAppUsageTime += (thisAppAcrescimCurrentTime / 60).ceil();
      mapAppUsageTime[widget.app.appPackageName] = thisAppUsageTime;
      timeStorage.setMapAppUsageTime(mapAppUsageTime);
    }

    resetCurrentAcrescimTime();

    Map<String, int> mapAppAcrescimTimeLimit =
        timeStorage.getMapAppTimeAcrescimLimit();
    mapAppAcrescimTimeLimit[widget.app.appPackageName] = 0;
    timeStorage.setMapAppTimeAcrescimLimit(mapAppAcrescimTimeLimit);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeStorage = context.read<TimeStorageRepository>();

    return Scaffold(
        body: GradientBackgroundContainer(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    top: TSizes.md,
                    left: TSizes.twelve,
                    right: TSizes.twelve,
                    bottom: TSizes.xs),
                child: TitleAlarmPage(),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: TSizes.spaceBtwItems),
                decoration: BoxDecoration(
                  color: TColors.backgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(TSizes.cardRadiusLg),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: TSizes.ten,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  // padding: EdgeInsets.zero,
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppCard(
                        appIcon: widget.app.appIcon,
                        appName: widget.app.appName,
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Text(
                        "${TTexts.usageTime} ${timeStorage.getMapAppUsageTime()[widget.app.appPackageName]} ${TTexts.minutes}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: TSizes.usageFontSize),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Container(
                        padding: const EdgeInsets.all(TSizes.md),
                        decoration: BoxDecoration(
                            color: TColors.primary.withValues(alpha: 0.05),
                            borderRadius:
                                BorderRadius.circular(TSizes.cardRadiusLg)),
                        child: Column(
                          children: [
                            Text(
                              TTexts.needMoreTime,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: TColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: TSizes.sm),
                            buildTimeExtensionGrid(),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            const intent = AndroidIntent(
                              package: "com.example.detox_app",
                              action: 'android.intent.action.MAIN',
                              category: 'android.intent.category.HOME',
                              flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
                            );
                            await intent.launch();
                          },
                          child: const Text(TTexts.ok),
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
    ));
  }

  Widget buildTimeExtensionGrid() {
    final List<Map<String, dynamic>> timeOptions = [
      {TTexts.minutes: TTexts.two, TTexts.seconds: TSizes.twoMin},
      {TTexts.minutes: TTexts.five, TTexts.seconds: TSizes.fiveMin},
      {TTexts.minutes: TTexts.ten, TTexts.seconds: TSizes.tenMin},
      {TTexts.minutes: TTexts.fifteen, TTexts.seconds: TSizes.fifteenMin},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: TSizes.gridViewSpacing,
        mainAxisSpacing: TSizes.gridViewSpacing,
        childAspectRatio: 2,
      ),
      itemCount: timeOptions.length,
      itemBuilder: (context, index) {
        return buildTimeButton(
            minutes: timeOptions[index][TTexts.minutes]!,
            seconds: timeOptions[index][TTexts.seconds]!,
            index: index);
      },
    );
  }

  Widget buildTimeButton(
      {required String minutes, required int seconds, required int index}) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: buttonIndex == index
            ? TColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(TSizes.buttonRadius),
        border: Border.all(color: TColors.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          overlayColor:
              WidgetStateProperty.all(TColors.primary.withValues(alpha: 0.1)),
          onTap: () {
            setState(() {
              if (buttonIndex == index) {
                buttonIndex = -1;
                setAcrescimDesactivated();
                setAcrescimTime(0);
              } else {
                buttonIndex = index;
                resetCurrentAcrescimTime();
                setAcrescimActivated();
                setAcrescimTime(seconds);
              }
            });
          },
          borderRadius: BorderRadius.circular(TSizes.buttonRadius),
          child: Center(
            child: Text(
              "+$minutes ${TTexts.minAbv}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  void setAcrescimTime(int time) {
    final timeStorage = context.read<TimeStorageRepository>();

    Map<String, int> mapAcrescimtTimeLimit =
        timeStorage.getMapAppTimeAcrescimLimit();
    // int thisAppAcrescimTimeLimit =
    //     mapAcrescimtTimeLimit[widget.app.appPackageName] ?? 0;
    mapAcrescimtTimeLimit[widget.app.appPackageName] = time;
    timeStorage.setMapAppTimeAcrescimLimit(mapAcrescimtTimeLimit);
  }

  void setAcrescimActivated() {
    final timeStorage = context.read<TimeStorageRepository>();

    Map<String, bool> mapAppsAcrescimActivated =
        timeStorage.getMapAppAcrescimBool();
    bool thisAppAcrescimActivated =
        mapAppsAcrescimActivated[widget.app.appPackageName] ?? false;
    if (!thisAppAcrescimActivated) {
      mapAppsAcrescimActivated[widget.app.appPackageName] = true;
      timeStorage.setMapAppAcrescimBool(mapAppsAcrescimActivated);
    }
  }

  void setAcrescimDesactivated() {
    final timeStorage = context.read<TimeStorageRepository>();

    Map<String, bool> mapAppsAcrescimActivated =
        timeStorage.getMapAppAcrescimBool();
    mapAppsAcrescimActivated[widget.app.appPackageName] = false;
    timeStorage.setMapAppAcrescimBool(mapAppsAcrescimActivated);
  }

  void resetCurrentAcrescimTime() {
    final timeStorage = context.read<TimeStorageRepository>();

    Map<String, int> mapAppAcrescimCurrentTime =
        timeStorage.getMapAppAcrescimCurrentTime();
    mapAppAcrescimCurrentTime[widget.app.appPackageName] = 0;
    timeStorage.setMapAppAcrescimCurrentTime(mapAppAcrescimCurrentTime);
  }

  int sumUsageTime() {
    final timeStorage = context.read<TimeStorageRepository>();

    int sumUsageTime = 0;
    Map<String, int> mapAppsCurrentTime = timeStorage.getMapAppsCurrentTime();
    int currentTime = mapAppsCurrentTime[widget.app.appPackageName] ?? 0;

    Map<String, int> mapAppAcrescimCurrentTime =
        timeStorage.getMapAppAcrescimCurrentTime();
    int thisAppAcrescimCurrentTime =
        mapAppAcrescimCurrentTime[widget.app.appPackageName] ?? 0;
    sumUsageTime = currentTime + thisAppAcrescimCurrentTime;
    sumUsageTime = (sumUsageTime / 60).ceil();
    return sumUsageTime;
  }
}
