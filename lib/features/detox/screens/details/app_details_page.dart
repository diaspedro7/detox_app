// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable

import 'package:detox_app/common/widgets/app_card.dart';
import 'package:detox_app/common/widgets/body_background_container.dart';
import 'package:detox_app/common/widgets/circular_slide_widget.dart';
import 'package:detox_app/common/widgets/custom_icon_button.dart';
import 'package:detox_app/common/widgets/floating_button.dart';
import 'package:detox_app/features/detox/models/app_model.dart';
import 'package:detox_app/features/detox/screens/details/widgets/app_current_time.dart';
import 'package:detox_app/features/detox/screens/details/widgets/details_title.dart';
import 'package:detox_app/features/detox/viewmodels/app_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/circular_slide_viewmodel.dart';
import 'package:detox_app/features/detox/viewmodels/details_page_viewmodel.dart';
import 'package:detox_app/utils/constants/colors.dart';
import 'package:detox_app/utils/constants/sizes.dart';
import 'package:detox_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
    final detailsPageviewmodel =
        Provider.of<AppDetailsPageViewModel>(context, listen: true);

    final circularSlideviewmodel =
        Provider.of<CircularSlideViewModel>(context, listen: true);

    // final appViewModel = Provider.of<AppViewModel>(context, listen: false);
    final appViewModel = context.read<AppViewModel>();

    // detailsPageviewmodel.getLimitTime(widget.app.appPackageName);

    return Scaffold(
      floatingActionButton: FloatingButton(
        fadeAnimation: _fadeAnimation,
        buttonText: TTexts.saveChanges,
        onPressed: () {
          detailsPageviewmodel.setLimitTime(widget.app.appPackageName,
              circularSlideviewmodel.radialValue.ceil() * TSizes.oneMin);
        },
      ),
      body: Container(
          color: TColors.neoBackground,
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
                              CustomIconButton(
                                  icon: PhosphorIcons.caretLeft(),
                                  // icon: Icons.arrow_back_ios_new,
                                  // iconSize: TSizes.buttonHeight,
                                  onPressed: () {
                                    circularSlideviewmodel.valueReset();
                                    Navigator.pop(context);
                                  }),
                              const SizedBox(width: TSizes.md),
                              TitleDetailsPage(appName: widget.app.appName),
                            ],
                          ),
                          CustomIconButton(
                            icon: PhosphorIcons.trash(),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        backgroundColor: TColors.neoBackground,
                                        content: Text(
                                          "Are you sure you want to stop monitoring this app?",
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          Center(
                                            child: SizedBox(
                                              width: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  //YES BUTTON
                                                  Consumer<AppViewModel>(
                                                    builder: (context,
                                                            viewmodel, child) =>
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              await viewmodel
                                                                  .deleteApp(
                                                                      widget.app
                                                                          .appPackageName,
                                                                      context);

                                                              await viewmodel
                                                                  .loadMonitoredApps(
                                                                      context);

                                                              Navigator.pop(
                                                                  context,
                                                                  true);
                                                              Navigator.pop(
                                                                  context,
                                                                  true);
                                                            },
                                                            icon: Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                  ),
                                                  //NOT BUTTON
                                                  IconButton(
                                                      onPressed: () {
                                                        //aparece outra vez para voltar para a tela
                                                        Navigator.pop(context);
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: TColors.primary,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                              // detailsPageviewmodel
                              //     .deleteApp(widget.app.appPackageName);

                              // Navigator.pop(context, true);
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
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          children: [
                            Text(
                              TTexts.adjustTimeLimit,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: TColors.light,
                                  ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),
                            AppCurrentTimeDisplay(
                                time: detailsPageviewmodel
                                    .getLimitTime(widget.app.appPackageName)),
                            CircularSlide(
                              controller: circularSlideviewmodel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                left: 0,
                right: 0,
                child: AppCard(
                  appIcon: widget.app.appIcon,
                  appName: widget.app.appName,
                  color: TColors.dark,
                ),
              ),
            ],
          )),
    );
  }
}
