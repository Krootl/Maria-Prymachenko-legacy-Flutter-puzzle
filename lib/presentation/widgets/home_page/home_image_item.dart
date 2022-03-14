import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:very_good_slide_puzzle/domain/entities/painting_entity.dart';
import 'package:very_good_slide_puzzle/presentation/pages/puzzle_page.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_colors.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/home_page/on_hover.dart';

class HomeImageItem extends StatelessWidget {
  const HomeImageItem({
    Key? key,
    required PaintingEntity paintingEntity,
  })  : _paintingEntity = paintingEntity,
        super(key: key);

  final PaintingEntity _paintingEntity;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _navigateToPuzzlePage(context: context),
        child: kIsWeb
            ? OnHover(
                builder: (isHovered) => PhysicalModel(
                  color: Colors.white,
                  elevation: isHovered ? 16 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OctoImage(
                          image: CachedNetworkImageProvider(
                            _paintingEntity.image,
                            cacheKey: _paintingEntity.id,
                          ),
                          fit: BoxFit.cover,
                          placeholderFadeInDuration: const Duration(milliseconds: 300),
                          placeholderBuilder: (context) => AspectRatio(
                            aspectRatio: 1.6,
                            child: Container(
                              color: AppColors.athensGray,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _paintingEntity.title,
                          style: AppTextStyles.subtitle1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _paintingEntity.completitionYear.toString(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.montage,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OctoImage(
                    image: CachedNetworkImageProvider(
                      _paintingEntity.image,
                      cacheKey: _paintingEntity.id,
                    ),
                    fit: BoxFit.cover,
                    placeholderFadeInDuration: const Duration(milliseconds: 300),
                    placeholderBuilder: (context) => AspectRatio(
                      aspectRatio: 1.6,
                      child: Container(
                        color: AppColors.athensGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _paintingEntity.title,
                      style: AppTextStyles.subtitle1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _paintingEntity.completitionYear.toString(),
                      textAlign: TextAlign.left,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.montage,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
      );

  Future<void> _navigateToPuzzlePage({required BuildContext context}) => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => PuzzlePage(
            paintingEntity: _paintingEntity,
          ),
          transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
}
