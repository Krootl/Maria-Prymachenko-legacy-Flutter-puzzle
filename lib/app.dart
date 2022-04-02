import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:very_good_slide_puzzle/presentation/pages/home_page.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_icons.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  void _precacheImages() {
    _timer = Timer(const Duration(milliseconds: 20), () {
      for (int i = 0; i < AppIcons.precacheIcons.length; ++i) {
        precachePicture(
          ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder,
            AppIcons.precacheIcons[i],
          ),
          null,
        );
      }
    });
    precacheImage(Image.asset(AppIcons.sun).image, context);
    precacheImage(Image.asset(AppIcons.bull).image, context);
  }

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomePage(),
      );

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
