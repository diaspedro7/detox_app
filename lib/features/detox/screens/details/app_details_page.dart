// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:detox_app/common/widgets/app_card.dart';
import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/common/widgets/floating_button.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/statecontrollers/circular_slide_statecontroller.dart';
import 'package:detox_app/features/detox/statecontrollers/details_page_statecontroller.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
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
        buttonText: "Save Changes",
        onPressed: () {
          detailsPageStateController.setLimitTime(widget.app.appPackageName,
              circularSlideStateController.radialValue.ceil() * 60);
        },
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                TColors.primary,
                TColors.primary.withValues(alpha: 0.9),
                TColors.backgroundColor,
              ],
              stops: const [0.0, 0.2, 0.4],
            ),
          ),
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: TColors.white, size: 20),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const SizedBox(width: TSizes.md),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'App Settings',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                        ),
                                  ),
                                  SizedBox(
                                    width: 250.0,
                                    child: Text(
                                      widget.app.appName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: TColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: TColors.white,
                                size: 20,
                              ),
                              onPressed: () async {
                                // Adicionar dialog de confirmação
                                detailsPageStateController
                                    .deleteApp(widget.app.appPackageName);

                                Navigator.pop(context, true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Espaço para o AppCard
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
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(
                            TSizes.defaultSpace,
                            TSizes.defaultSpace,
                            TSizes.defaultSpace,
                            TSizes.defaultSpace),
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.all(TSizes.defaultSpace),
                              decoration: BoxDecoration(
                                color: TColors.primary.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: TColors.primary.withValues(alpha: 0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Current Limit",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: TColors.primary
                                              .withValues(alpha: 0.7),
                                        ),
                                  ),
                                  const SizedBox(height: TSizes.sm),
                                  Text(
                                    "${detailsPageStateController.getLimitTime(widget.app.appPackageName)} min",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                          color: TColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            Text(
                              "Adjust Time Limit",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
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
