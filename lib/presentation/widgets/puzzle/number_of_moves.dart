import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';

class NumberOfMoves extends StatelessWidget {
  const NumberOfMoves({
    Key? key,
    required int numberOfMoves,
  })  : _numberOfMoves = numberOfMoves,
        super(key: key);

  final int _numberOfMoves;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context).state.currentPuzzleTheme;
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: AppTextStyles.headline5.copyWith(
        color: theme.movesTitleColor,
      ),
      child: RichText(
        key: ValueKey(_numberOfMoves),
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$_numberOfMoves ',
              style: AppTextStyles.headline5.copyWith(
                color: theme.movesTitleColor,
              ),
            ),
            TextSpan(
              text: context.l10n.numberOfPuzzleMoves,
              style: AppTextStyles.subtitle1.copyWith(
                color: theme.movesTitleColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
