import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/pages/home_page.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/theme.dart';

class CongratulationsDialog extends StatefulWidget {
  const CongratulationsDialog({
    Key? key,
    required String name,
    required String author,
    required String imagePath,
    required int movesNumber,
    required String time,
  })  : _name = name,
        _author = author,
        _imagePath = imagePath,
        _movesNumber = movesNumber,
        _time = time,
        super(key: key);

  final String _name;
  final String _author;
  final String _imagePath;
  final int _movesNumber;
  final String _time;

  @override
  State<CongratulationsDialog> createState() => _CongratulationsDialogState();
}

class _CongratulationsDialogState extends State<CongratulationsDialog> with SingleTickerProviderStateMixin {
  late OverlayEntry _floating;
  late String _animationAsset;
  late final _controller = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();

    _animationAsset = _getRandomAsset();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _floating = _createFloating();
      Overlay.of(context)?.insert(_floating);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context).state.currentPuzzleTheme;
    return SafeArea(
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        backgroundColor: theme.congratulationsBackgroundColor,
        elevation: 18,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 30),
                _buildCancelDialogButton(context: context, puzzleTheme: theme),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '🎉',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
                Text(
                  context.l10n.congratulationsTitle,
                  style: AppTextStyles.headline4.copyWith(
                    color: theme.congratulationsTitleColor,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  context.l10n.congratulationsSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.congratulationsSubtitleColor,
                  ),
                ),
                const SizedBox(height: 24),
                OctoImage(
                  image: CachedNetworkImageProvider(
                    widget._imagePath,
                    cacheKey: widget._imagePath,
                  ),
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget._name,
                    style: AppTextStyles.subtitle1.copyWith(
                      fontSize: 16,
                      color: theme.pictureNameColor,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget._author,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.subtitle2.copyWith(
                      fontSize: 16,
                      color: theme.authorColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context: context,
                      title: context.l10n.share,
                      titleColor: theme.shareButtonTitleColor,
                      backgroundColor: theme.shareButtonColor,
                      onPressed: () {
                        _shareImage(context: context);
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildActionButton(
                      context: context,
                      title: context.l10n.newGame,
                      titleColor: theme.newGameButtonTitleColor,
                      backgroundColor: theme.newGameButtonColor,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, _, __) => const HomePage(),
                            transitionsBuilder: (context, animation, _, child) =>
                                FadeTransition(opacity: animation, child: child),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelDialogButton({required BuildContext context, required PuzzleTheme puzzleTheme}) => Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: SvgPicture.asset(puzzleTheme.cancelAsset),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 30,
          onPressed: () {
            _controller.dispose();
            _floating.remove();
            Navigator.pop<void>(context);
          },
        ),
      );

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required Color backgroundColor,
    required Color titleColor,
    required VoidCallback onPressed,
  }) =>
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: backgroundColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 9),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            title,
            style: AppTextStyles.body1.copyWith(
              color: titleColor,
            ),
          ),
        ),
      );

  OverlayEntry _createFloating() => OverlayEntry(
        builder: (_) => Positioned.fill(
          child: IgnorePointer(
            child: Container(
              child: Lottie.asset(
                _animationAsset,
                key: ValueKey(_animationAsset),
                repeat: false,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward().whenComplete(() => _floating.remove());
                },
              ),
            ),
          ),
        ),
      );

  String _getRandomAsset() {
    final random = Random();
    int randomNumber = random.nextInt(4);
    switch (randomNumber) {
      case 0:
        return 'assets/lottie/bottom_confetti.json';
      case 1:
        return 'assets/lottie/sides_confetti.json';
      case 2:
        return 'assets/lottie/stripes.json';
      case 3:
        return 'assets/lottie/top_confetti.json';
      default:
        return 'assets/lottie/bottom_confetti.json';
    }
  }

  Future<void> _shareImage({required BuildContext context}) => Share.shareFiles([widget._imagePath],
      text:
          'I just won in Maria Prymachenko legacy puzzle! My result is ${widget._movesNumber} moves and ${widget._time} seconds for “title” painting.');
}
