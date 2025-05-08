import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/navigation/navigation.dart';

import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';

class VirtualTownHallScreen extends ConsumerStatefulWidget {
  const VirtualTownHallScreen({super.key});

  @override
  ConsumerState<VirtualTownHallScreen> createState() =>
      _VirtualTownHallScreenState();
}

class _VirtualTownHallScreenState extends ConsumerState<VirtualTownHallScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [_buildClipper(context)],
    );
  }

  _buildClipper(context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image at the top
              Positioned(
                top: 0.h,
                child: ClipPath(
                  clipper: UpstreamWaveClipper(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      imagePath['background_image'] ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Blurred overlay
              Positioned(
                top: 0.h,
                child: ClipPath(
                  clipper: UpstreamWaveClipper(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                      child: Container(
                        color: Theme.of(context).cardColor.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0.r,
                top: 15.h,
                child: Row(
                  children: [
                    IconButton(onPressed: () {
                      ref.read(navigationProvider).removeTopPage(context: context);
                    }, icon: Icon(Icons.arrow_back)),
                    16.horizontalSpace,
                    textBoldPoppins(
                        color: Theme.of(context).textTheme.labelLarge?.color,
                        fontSize: 18.sp,
                        text: AppLocalizations.of(context).virtual_town_hall),
                  ],
                ),
              ),

              Positioned(
                  top: MediaQuery.of(context).size.height * .15,
                  left: 0.w,
                  right: 0.w,
                  child: Container(
                    height: 120.h,
                    width: 70.w,
                    decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Colors.red),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
