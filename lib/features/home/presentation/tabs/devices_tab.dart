import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../models/device_ui_model.dart';
import '../utils/home_layout.dart';
import '../widgets/common/home_texts.dart';
import '../widgets/devices/device_card.dart';
import '../widgets/devices/device_search_bar.dart';

/// Figma: "00a · eWeLink Home — Devices Tab".
///
/// Searchable list of the user's devices. Switches to a multi-column layout
/// on wide windows (tablets / foldables / desktop).
class DevicesTab extends StatefulWidget {
  const DevicesTab({
    super.key,
    required this.devices,
    required this.onDeviceTap,
  });

  final List<DeviceUiModel> devices;
  final ValueChanged<DeviceUiModel> onDeviceTap;

  @override
  State<DevicesTab> createState() => _DevicesTabState();
}

class _DevicesTabState extends State<DevicesTab> {
  String _query = '';

  List<DeviceUiModel> get _filteredDevices {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.devices;
    return widget.devices
        .where(
          (device) =>
              device.name.toLowerCase().contains(query) ||
              device.description.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final devices = _filteredDevices;
    // Includes the floating tab bar height (Scaffold.extendBody = true).
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = HomeLayout.horizontalPadding(
          constraints.maxWidth,
          HomeLayout.devicesMaxContentWidth,
        );
        final contentWidth = constraints.maxWidth - horizontal * 2;

        return CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontal, 14.r, horizontal, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeTabTitle(StringsManager.myDevices),
                    SizedBox(height: 24.r),
                    DeviceSearchBar(
                      onChanged: (value) => setState(() => _query = value),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontal,
                14.r,
                horizontal,
                bottomInset + 16.r,
              ),
              sliver: devices.isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyDevices(),
                    )
                  : _DevicesGrid(
                      devices: devices,
                      columns: HomeLayout.deviceColumns(contentWidth),
                      contentWidth: contentWidth,
                      onDeviceTap: widget.onDeviceTap,
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _DevicesGrid extends StatelessWidget {
  const _DevicesGrid({
    required this.devices,
    required this.columns,
    required this.contentWidth,
    required this.onDeviceTap,
  });

  final List<DeviceUiModel> devices;
  final int columns;
  final double contentWidth;
  final ValueChanged<DeviceUiModel> onDeviceTap;

  @override
  Widget build(BuildContext context) {
    final spacing = 14.r;

    // Phones: lazily-built list.
    if (columns == 1) {
      return SliverList.separated(
        itemCount: devices.length,
        separatorBuilder: (_, _) => SizedBox(height: spacing),
        itemBuilder: (context, index) => _buildCard(devices[index]),
      );
    }

    // Wide windows: intrinsic-height cards laid out in N columns.
    final itemWidth =
        ((contentWidth - spacing * (columns - 1)) / columns).floorToDouble();
    return SliverToBoxAdapter(
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final device in devices)
            SizedBox(width: itemWidth, child: _buildCard(device)),
        ],
      ),
    );
  }

  Widget _buildCard(DeviceUiModel device) => DeviceCard(
        key: ValueKey(device.id),
        device: device,
        onTap: () => onDeviceTap(device),
      );
}

class _EmptyDevices extends StatelessWidget {
  const _EmptyDevices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48.r),
      child: Column(
        children: [
          Icon(
            Icons.devices_other_rounded,
            size: 40.r,
            color: ColorManager.slate,
          ),
          SizedBox(height: 12.r),
          Text(
            StringsManager.noDevicesFound,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: ColorManager.slate),
          ),
        ],
      ),
    );
  }
}
