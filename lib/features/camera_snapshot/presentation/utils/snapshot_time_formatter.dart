import '../../../../core/resources/strings_manager.dart';

/// Formats the capture time like the Figma chip: "Today 14:32".
abstract final class SnapshotTimeFormatter {
  static String format(DateTime time, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final day = DateTime(time.year, time.month, time.day);
    final hm = '${_two(time.hour)}:${_two(time.minute)}';
    final diffDays = today.difference(day).inDays;
    if (diffDays == 0) return '${StringsManager.today} $hm';
    if (diffDays == 1) return '${StringsManager.yesterday} $hm';
    return '${_two(time.day)}/${_two(time.month)} $hm';
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}
