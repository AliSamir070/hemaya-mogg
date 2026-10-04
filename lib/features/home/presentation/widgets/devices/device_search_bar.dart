import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';

/// Rounded search field for filtering devices.
class DeviceSearchBar extends StatefulWidget {
  const DeviceSearchBar({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<DeviceSearchBar> createState() => _DeviceSearchBarState();
}

class _DeviceSearchBarState extends State<DeviceSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24.r);

    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color),
        );

    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      textInputAction: TextInputAction.search,
      cursorColor: ColorManager.sky,
      style: TextStyle(fontSize: 13.sp, color: ColorManager.pureWhite),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: ColorManager.surface,
        hintText: StringsManager.searchDevices,
        hintStyle: TextStyle(fontSize: 13.sp, color: ColorManager.slate),
        contentPadding: EdgeInsets.symmetric(vertical: 15.r),
        prefixIcon: Padding(
          padding: EdgeInsetsDirectional.only(start: 18.r, end: 8.r),
          child: Icon(
            Icons.search_rounded,
            size: 18.r,
            color: ColorManager.slate,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: _clear,
                  tooltip: MaterialLocalizations.of(context)
                      .deleteButtonTooltip,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.r,
                    color: ColorManager.slate,
                  ),
                ),
        ),
        border: border(ColorManager.pureWhite.withValues(alpha: 0.07)),
        enabledBorder: border(ColorManager.pureWhite.withValues(alpha: 0.07)),
        focusedBorder: border(ColorManager.sky.withValues(alpha: 0.45)),
      ),
    );
  }
}
