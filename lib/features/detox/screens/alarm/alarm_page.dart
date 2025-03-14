import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/screens/alarm/widgets/app_card.dart';
import 'package:detox_app/main.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlarmPageTwo extends StatefulWidget {
  const AlarmPageTwo({super.key, required this.app});

  final AppModel app;

  @override
  State<AlarmPageTwo> createState() => _AlarmPageTwoState();
}

class _AlarmPageTwoState extends State<AlarmPageTwo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  int buttonIndex = 5;

  @override
  void initState() {
    super.initState();
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
    Map<String, int> mapAppUsageTime = getMapAppUsageTime();
    int thisAppUsageTime = mapAppUsageTime[widget.app.appPackageName] ?? 0;

    if (thisAppUsageTime == 0) {
      int thisAppCurrentTime =
          getMapAppsCurrentTime()[widget.app.appPackageName] ?? 0;
      thisAppUsageTime = (thisAppCurrentTime / 60).ceil();
      mapAppUsageTime[widget.app.appPackageName] = thisAppUsageTime;
      setMapAppUsageTime(mapAppUsageTime);
    }

    Map<String, int> mapAppAcrescimCurrentTime = getMapAppAcrescimCurrentTime();
    int thisAppAcrescimCurrentTime =
        mapAppAcrescimCurrentTime[widget.app.appPackageName] ?? 0;

    if (thisAppAcrescimCurrentTime != 0) {
      thisAppUsageTime += (thisAppAcrescimCurrentTime / 60).ceil();
      mapAppUsageTime[widget.app.appPackageName] = thisAppUsageTime;
      setMapAppUsageTime(mapAppUsageTime);
    }

    resetCurrentAcrescimTime();

    Map<String, int> mapAppAcrescimTimeLimit = getMapAppTimeAcrescimLimit();
    mapAppAcrescimTimeLimit[widget.app.appPackageName] = 0;
    setMapAppTimeAcrescimLimit(mapAppAcrescimTimeLimit);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TColors.primary,
            TColors.primary.withValues(alpha: 0.8),
            TColors.backgroundColor,
          ],
          stops: const [0.0, 0.3, 0.45],
        ),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: TSizes.md,
                    left: TSizes.twelve,
                    right: TSizes.twelve,
                    bottom: TSizes.xs),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer_off_rounded,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 2),
                      Text(
                        "Time's Up!",
                        style:
                            Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Text(
                        "You've reached your app usage limit.",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: TSizes.ten),
                      Text(
                        "You can choose to stop using this app for today or extend your session.",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
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
                      blurRadius: 10,
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
                        "Usage time: ${getMapAppUsageTime()[widget.app.appPackageName]} minutes",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 21.0),
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
                              "Need more time?",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: TColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: TSizes.sm),
                            _buildTimeExtensionGrid(),
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
                          child: const Text("Ok"),
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

  Widget _buildTimeExtensionGrid() {
    final List<Map<String, dynamic>> timeOptions = [
      {"minutes": "2", "seconds": 120},
      {"minutes": "5", "seconds": 300},
      {"minutes": "10", "seconds": 600},
      {"minutes": "15", "seconds": 900},
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
        return _buildTimeButton(
            minutes: timeOptions[index]["minutes"]!,
            seconds: timeOptions[index]["seconds"]!,
            index: index);
      },
    );
  }

  Widget _buildTimeButton(
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
              "+$minutes min",
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
    Map<String, int> mapAcrescimtTimeLimit = getMapAppTimeAcrescimLimit();
    // int thisAppAcrescimTimeLimit =
    //     mapAcrescimtTimeLimit[widget.app.appPackageName] ?? 0;
    mapAcrescimtTimeLimit[widget.app.appPackageName] = time;
    setMapAppTimeAcrescimLimit(mapAcrescimtTimeLimit);
  }

  void setAcrescimActivated() {
    Map<String, bool> mapAppsAcrescimActivated = getMapAppAcrescimBool();
    bool thisAppAcrescimActivated =
        mapAppsAcrescimActivated[widget.app.appPackageName] ?? false;
    if (!thisAppAcrescimActivated) {
      mapAppsAcrescimActivated[widget.app.appPackageName] = true;
      setMapAppAcrescimBool(mapAppsAcrescimActivated);
    }
  }

  void setAcrescimDesactivated() {
    Map<String, bool> mapAppsAcrescimActivated = getMapAppAcrescimBool();
    mapAppsAcrescimActivated[widget.app.appPackageName] = false;
    setMapAppAcrescimBool(mapAppsAcrescimActivated);
  }

  void resetCurrentAcrescimTime() {
    Map<String, int> mapAppAcrescimCurrentTime = getMapAppAcrescimCurrentTime();
    mapAppAcrescimCurrentTime[widget.app.appPackageName] = 0;
    setMapAppAcrescimCurrentTime(mapAppAcrescimCurrentTime);
  }

  int sumUsageTime() {
    int sumUsageTime = 0;
    Map<String, int> mapAppsCurrentTime = getMapAppsCurrentTime();
    int currentTime = mapAppsCurrentTime[widget.app.appPackageName] ?? 0;

    Map<String, int> mapAppAcrescimCurrentTime = getMapAppAcrescimCurrentTime();
    int thisAppAcrescimCurrentTime =
        mapAppAcrescimCurrentTime[widget.app.appPackageName] ?? 0;
    sumUsageTime = currentTime + thisAppAcrescimCurrentTime;
    sumUsageTime = (sumUsageTime / 60).ceil();
    return sumUsageTime;
  }
}
