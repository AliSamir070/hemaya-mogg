/// Presentation model for a person that alerts can be delegated to.
class DelegateUserUiModel {
  const DelegateUserUiModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  final String id;
  final String fullName;
  final String email;

  /// Up to two initials, e.g. "Sarah Ahmed" -> "SA".
  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
