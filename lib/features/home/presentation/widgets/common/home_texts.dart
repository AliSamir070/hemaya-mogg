import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Large bold page title used at the top of each home tab.
class HomeTabTitle extends StatelessWidget {
  const HomeTabTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: ColorManager.pureWhite,
        ),
      ),
    );
  }
}

/// Small uppercase section label, e.g. "CHOOSE A PERSON".
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.66,
          color: ColorManager.slate,
        ),
      ),
    );
  }
}
