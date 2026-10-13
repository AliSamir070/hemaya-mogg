import '../../../../core/resources/strings_manager.dart';

abstract final class CameraEventTimeFormatter {
  static String format(DateTime time, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    final day = DateTime(time.year, time.month, time.day);
    final hm = '${_two(time.hour)}:${_two(time.minute)}';
    final diffDays = today.difference(day).inDays;

    if (diffDays == 0) return '${StringsManager.today} · $hm';
    if (diffDays == 1) return '${StringsManager.yesterday} · $hm';

    // Day of week abbreviation e.g. Mon, Tue, etc.
    final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdayNames[(time.weekday - 1).clamp(0, 6)];
    return '$weekday · $hm';
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}
