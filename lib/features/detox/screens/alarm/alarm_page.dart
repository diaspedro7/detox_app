import 'package:detox_app/data/services/time_storage_hive.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/screens/alarm/widgets/add_time_button.dart';
import 'package:detox_app/features/detox/screens/alarm/widgets/stop_button.dart';
import 'package:detox_app/features/detox/screens/alarm/widgets/title_alarm_page.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key, required this.app});

  final AppModel app;

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = FlutterBackgroundService();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TColors.error.withValues(alpha: 0.9),
              TColors.error.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.lg,
              vertical: TSizes.lg * 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: const TitleAlarmPage(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.app.appIcon.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(TSizes.sm),
                            child: Image.memory(
                              widget.app.appIcon,
                              width: 70,
                              height: 70,
                            ),
                          )
                        : const Icon(Icons.android,
                            size: TSizes.appsImage, color: Colors.grey),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Text(
                      widget.app.appName,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge!
                          .apply(color: TColors.white),
                    ),
                  ],
                ),
                StopButton(service: service),
                const SizedBox(height: TSizes.spaceBtwItems),
                Container(
                  padding: const EdgeInsets.all(TSizes.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Need more time?",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      const SizedBox(height: TSizes.sm),
                      Row(
                        children: [
                          Expanded(
                              child: AddTimeButton(
                            minutes: "2",
                            onPressed: () {
                              setAcrescimActivated();
                              setAcrescimTime(120);
                            },
                          )),
                          const SizedBox(width: TSizes.sm),
                          Expanded(
                              child: AddTimeButton(
                            minutes: "5",
                            onPressed: () {
                              setAcrescimActivated();
                              setAcrescimTime(300);
                            },
                          )),
                        ],
                      ),
                      const SizedBox(height: TSizes.sm),
                      Row(
                        children: [
                          Expanded(
                              child: AddTimeButton(
                            minutes: "10",
                            onPressed: () {
                              setAcrescimActivated();
                              setAcrescimTime(600);
                            },
                          )),
                          const SizedBox(width: TSizes.sm),
                          Expanded(
                              child: AddTimeButton(
                            minutes: "15",
                            onPressed: () {
                              setAcrescimActivated();
                              setAcrescimTime(900);
                            },
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setAcrescimTime(int time) {
    //Reset the acrescim timer
    Map<String, int> mapAcrescimtTimeLimit = getMapAppTimeAcrescimLimit();
    int thisAppAcrescimTimeLimit =
        mapAcrescimtTimeLimit[widget.app.appPackageName] ?? 0;
    mapAcrescimtTimeLimit[widget.app.appPackageName] =
        thisAppAcrescimTimeLimit + time;
    setMapAppTimeAcrescimLimit(mapAcrescimtTimeLimit);
  }

  void setAcrescimActivated() {
    Map<String, bool> mapAppsAcrescimActivaded = getMapAppAcrescimBool();
    bool thisAppAcrescimActivated =
        mapAppsAcrescimActivaded[widget.app.appPackageName] ?? false;
    if (!thisAppAcrescimActivated) {
      mapAppsAcrescimActivaded[widget.app.appPackageName] = true;
      setMapAppAcrescimBool(mapAppsAcrescimActivaded);
    }
  }
}
