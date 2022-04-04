import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/theme_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/enums/menu_id.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_colors.dart';
import 'package:very_good_slide_puzzle/presentation/themes/puzzle/theme.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required String iconPath,
    required String? tooltipMessage,
    required MenuId? menuId,
    bool isSelected = false,
    bool isDisabled = false,
    required VoidCallback onPressed,
  })  : _iconPath = iconPath,
        _tooltipMessage = tooltipMessage,
        _menuId = menuId,
        _isSelected = isSelected,
        _isDisabled = isDisabled,
        _onPressed = onPressed,
        super(key: key);

  final String _iconPath;
  final String? _tooltipMessage;
  final MenuId? _menuId;
  final bool _isSelected;
  final bool _isDisabled;
  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeBloc>(context).state.currentPuzzleTheme;
    return IgnorePointer(
      ignoring: _isDisabled,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _onPressed,
          child: Tooltip(
            message: _tooltipMessage ?? '',
            child: Stack(
              children: [
                AnimatedContainer(
                  width: 44,
                  height: 44,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _getColor(theme: theme),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: SvgPicture.asset(
                      _iconPath,
                      key: ValueKey(_iconPath),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _isDisabled
                      ? Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColors.montage.withOpacity(0.8),
                          ),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor({required PuzzleTheme theme}) {
    if (_isSelected && _menuId == MenuId.getInfo) {
      return theme.menuActiveColor;
    } else if (_menuId == MenuId.turnOnExtremeMode) {
      return theme.activeExtremeModeColor;
    }
    return theme.menuColor;
  }
}
