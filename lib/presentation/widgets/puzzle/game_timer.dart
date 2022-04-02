import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';

class GameTimer extends StatelessWidget {
  const GameTimer({
    Key? key,
    required int secondsElapsed,
  })  : _secondsElapsed = secondsElapsed,
        super(key: key);

  final int _secondsElapsed;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context).state.currentPuzzleTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(theme.timerAsset),
        ),
        const SizedBox(width: 12),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTextStyles.headline6.copyWith(
            color: theme.timerColor,
          ),
          child: Text(
            _formatDuration(Duration(seconds: _secondsElapsed)),
            key: ValueKey(_secondsElapsed),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(digit) => digit.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
