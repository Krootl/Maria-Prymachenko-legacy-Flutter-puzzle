import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octo_image/octo_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/theme.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';

class GetInfoDialog extends StatelessWidget {
  const GetInfoDialog({
    Key? key,
    required String name,
    required String author,
    required String imagePath,
    required String url,
    required VoidCallback onCloseDialog,
  })  : _name = name,
        _author = author,
        _imagePath = imagePath,
        _url = url,
        _onCloseDialog = onCloseDialog,
        super(key: key);

  final String _name;
  final String _author;
  final String _imagePath;
  final String _url;
  final VoidCallback _onCloseDialog;

  @override
  Widget build(BuildContext context) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) => Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: () {
                _onCloseDialog();
              },
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.transparent,
              ),
            ),
            SafeArea(
              child: Dialog(
                alignment: Alignment.topCenter,
                elevation: 18,
                insetPadding: const EdgeInsets.only(left: 16, right: 16, top: 50),
                backgroundColor: state.currentPuzzleTheme.getInfoDialogBackground,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: AnimatedContainer(
                  constraints: const BoxConstraints(maxWidth: 680),
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  color: state.currentPuzzleTheme.getInfoDialogBackground,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: AppTextStyles.subtitle1.copyWith(
                                    fontSize: 16,
                                    color: state.currentPuzzleTheme.titleColor,
                                  ),
                                  child: Text(_name),
                                ),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: AppTextStyles.subtitle2.copyWith(
                                    color: state.currentPuzzleTheme.infoSubtitleColor,
                                  ),
                                  child: Text(_author),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          _buildCancelDialogButton(context: context, puzzleTheme: state.currentPuzzleTheme),
                        ],
                      ),
                      const SizedBox(height: 24),
                      OctoImage(
                        image: CachedNetworkImageProvider(
                          _imagePath,
                          cacheKey: _imagePath,
                        ),
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 24),
                      _buildLearnMoreButton(context: context, puzzleTheme: state.currentPuzzleTheme),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildCancelDialogButton({required BuildContext context, required PuzzleTheme puzzleTheme}) => Align(
        alignment: Alignment.topRight,
        child: ClipOval(
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: SvgPicture.asset(puzzleTheme.cancelAsset),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minHeight: 50, minWidth: 50),
              splashRadius: 30,
              onPressed: _onCloseDialog,
            ),
          ),
        ),
      );

  Widget _buildLearnMoreButton({required BuildContext context, required PuzzleTheme puzzleTheme}) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 42,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: puzzleTheme.learnMoreButtonColor,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              launch('https://www.wikiart.org/en/maria-primachenko/$_url');
            },
            child: Text(
              context.l10n.learnMorePuzzleArt,
              style: AppTextStyles.body1.copyWith(color: puzzleTheme.learnMoreTitleColor),
            ),
          ),
        ),
      );
}
