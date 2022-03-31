import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_colors.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_icons.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.brightSun,
        body: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildCancelButton(context: context),
                    Image.asset(
                      AppIcons.sun,
                      width: 64,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      context.l10n.mariaPrymachenko,
                      style: AppTextStyles.headline5.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.subtitle2.copyWith(
                                            fontSize: 16,
                                            color: AppColors.blackPearl,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: context.l10n.mariaPrymachenko,
                                              style: AppTextStyles.subtitle1.copyWith(fontSize: 16),
                                            ),
                                            TextSpan(
                                              text: context.l10n.prymachenkoBiographyFirstPart,
                                            ),
                                            TextSpan(
                                              text: context.l10n.prymachenkoBiographySecondPart,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      Image.asset(
                                        AppIcons.bull,
                                        height: 179,
                                        fit: BoxFit.fill,
                                      ),
                                      const SizedBox(height: 32),
                                      RichText(
                                        text: TextSpan(
                                          style: AppTextStyles.subtitle2.copyWith(
                                            fontSize: 16,
                                            color: AppColors.blackPearl,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: context.l10n.loosOfWork,
                                              style: AppTextStyles.subtitle1.copyWith(fontSize: 16),
                                            ),
                                            TextSpan(
                                              text: context.l10n.prymachenkoBiographyThirdPart,
                                            ),
                                            TextSpan(
                                              text: context.l10n.war,
                                              style: AppTextStyles.subtitle1.copyWith(
                                                fontSize: 16,
                                                color: AppColors.mariner,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launch(
                                                      'https://en.wikipedia.org/wiki/2022_Russian_invasion_of_Ukraine');
                                                },
                                            ),
                                            TextSpan(
                                              text: context.l10n.prymachenkoBiographyFourthPart,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildCancelButton({required BuildContext context}) => Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: SvgPicture.asset(AppIcons.lightCancelGetInfo),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minHeight: 50, minWidth: 50),
                splashRadius: 30,
                onPressed: () => Navigator.pop<void>(context),
              ),
            ),
          ),
        ),
      );
}
