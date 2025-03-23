// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:detox_app/common/widgets/app_card.dart';
import 'package:detox_app/common/widgets/body_background_container.dart';
import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/common/widgets/floating_button.dart';
import 'package:detox_app/common/widgets/goback_button.dart';
import 'package:detox_app/common/widgets/gradient_background_container.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/screens/details/widgets/app_current_time.dart';
import 'package:detox_app/features/detox/screens/details/widgets/delete_button.dart';
import 'package:detox_app/features/detox/screens/details/widgets/details_title.dart';
import 'package:detox_app/features/detox/statecontrollers/circular_slide_statecontroller.dart';
import 'package:detox_app/features/detox/statecontrollers/details_page_statecontroller.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDetailsPage extends StatefulWidget {
  const AppDetailsPage({super.key, required this.app});

  final AppModel app;

  @override
  State<AppDetailsPage> createState() => _AppDetailsPageState();
}

class _AppDetailsPageState extends State<AppDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final detailsPageStateController =
        Provider.of<AppDetailsPageStateController>(context, listen: true);

    final circularSlideStateController =
        Provider.of<CircularSlideStateController>(context, listen: true);

    // detailsPageStateController.getLimitTime(widget.app.appPackageName);

    return Scaffold(
      floatingActionButton: FloatingButton(
        fadeAnimation: _fadeAnimation,
        buttonText: TTexts.saveChanges,
        onPressed: () {
          detailsPageStateController.setLimitTime(widget.app.appPackageName,
              circularSlideStateController.radialValue.ceil() * TSizes.oneMin);
        },
      ),
      body: GradientBackgroundContainer(
          child: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GoBackButton(onPressed: () {
                            circularSlideStateController.valueReset();
                            Navigator.pop(context);
                          }),
                          const SizedBox(width: TSizes.md),
                          TitleDetailsPage(appName: widget.app.appName),
                        ],
                      ),
                      DeleteButton(
                        onPressed: () {
                          // TODO: Add a confirmation dialog
                          detailsPageStateController
                              .deleteApp(widget.app.appPackageName);

                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height: TSizes.spaceBtwAppCard), // Espaço para o AppCard
              Expanded(
                child: BodyBackgroundContainer(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                        TSizes.defaultSpace,
                        TSizes.defaultSpace,
                        TSizes.defaultSpace,
                        TSizes.defaultSpace),
                    child: Column(
                      children: [
                        AppCurrentTimeDisplay(
                            time: detailsPageStateController
                                .getLimitTime(widget.app.appPackageName)),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        Text(
                          TTexts.adjustTimeLimit,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: TColors.black,
                                  ),
                        ),
                        CircularSlide(
                          controller: circularSlideStateController,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: AppCard(
              appIcon: widget.app.appIcon,
              appName: widget.app.appName,
            ),
          ),
        ],
      )),
    );
  }
}
