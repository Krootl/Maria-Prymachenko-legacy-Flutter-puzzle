import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:very_good_slide_puzzle/presentation/blocs/home_bloc/bloc.dart';
import 'package:very_good_slide_puzzle/presentation/pages/about_page.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_colors.dart';
import 'package:very_good_slide_puzzle/presentation/resources/app_text_styles.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/home_page/home_image_item.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/presentation/widgets/response_layout_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _appBarElevated = ValueNotifier(false);
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _appBarElevated.value = _controller.position.pixels != _controller.position.minScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => HomeBloc()..add(InitHome()),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is PaginationErrorState) {
              showFlash<void>(
                context: context,
                duration: const Duration(seconds: 4),
                persistent: true,
                builder: (context, controller) => Flash(
                  controller: controller,
                  position: FlashPosition.top,
                  behavior: FlashBehavior.floating,
                  brightness: Brightness.light,
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadows: kElevationToShadow[8],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () => controller.dismiss(),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      context.l10n.unknownErrorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2?.apply(color: Colors.black),
                    ),
                  ),
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: _buildAboutButton(context: context),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) => Column(
                children: [
                  Material(
                    color: Colors.white,
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 30),
                          Center(
                            child: Text(
                              context.l10n.puzzleTitle,
                              style: AppTextStyles.headline6.copyWith(fontSize: 22),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: context.l10n.chooseArtBy,
                                style: AppTextStyles.subtitle2.copyWith(
                                  fontSize: 16,
                                  color: AppColors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: context.l10n.mariaPrymachenko,
                                    style: AppTextStyles.subtitle1.copyWith(fontSize: 16),
                                  ),
                                  TextSpan(text: context.l10n.artPainter),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ValueListenableBuilder<bool>(
                            valueListenable: _appBarElevated,
                            builder: (context, showDivider, _) => showDivider
                                ? Divider(
                                    height: 0,
                                    color: Colors.grey[30],
                                    thickness: 2,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: state is InitialHomeState
                          ? const SpinKitRipple(
                              color: AppColors.brightSun,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (state is GotPaintingsErrorState)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(context.l10n.unknownErrorMessage),
                                      const SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: () {
                                          BlocProvider.of<HomeBloc>(context).add(GetPaintings());
                                        },
                                        child: Text(context.l10n.peaseTryAgain),
                                      )
                                    ],
                                  )
                                else if (state is GotPaintings || state is PaginationErrorState)
                                  Expanded(
                                    child: LayoutBuilder(
                                        builder: (context, constraints) => MasonryGridView.count(
                                              crossAxisCount: _getGridCrossAxisCount(constraints: constraints),
                                              mainAxisSpacing: 12,
                                              crossAxisSpacing: 12,
                                              itemCount: state.paintings.length,
                                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
                                              controller: _controller,
                                              itemBuilder: (context, index) => HomeImageItem(
                                                paintingEntity: state.paintings[index],
                                              ),
                                            )),
                                  ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildAboutButton({required BuildContext context}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SizedBox(
            width: double.infinity,
            child: RawMaterialButton(
              padding: const EdgeInsets.symmetric(vertical: 10),
              fillColor: AppColors.brightSun,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () => _navigateToAboutPage(context: context),
              child: Text(
                context.l10n.aboutButtonTitle,
                style: AppTextStyles.subtitle1.copyWith(fontSize: 16),
              ),
            ),
          ),
        ),
      );

  Future<void> _navigateToAboutPage({required BuildContext context}) => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => const AboutPage(),
          transitionsBuilder: (context, animation, _, child) => FadeTransition(opacity: animation, child: child),
        ),
      );

  int _getGridCrossAxisCount({required BoxConstraints constraints}) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= PuzzleBreakpoints.extraSmall || screenWidth <= PuzzleBreakpoints.small) {
      return 2;
    } else if (screenWidth <= PuzzleBreakpoints.medium) {
      return 3;
    }
    return 5;
  }
}
