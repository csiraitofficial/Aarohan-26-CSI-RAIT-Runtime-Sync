class EventModel {
  EventModel({
    required this.id,
    required this.name,
    required this.centerLat,
    required this.centerLng,
    required this.radius,
    required this.startTime,
    required this.endTime,
  });

  final int id;
  final String name;
  final double centerLat;
  final double centerLng;
  final double radius;
  final DateTime? startTime;
  final DateTime? endTime;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      centerLat: (json['centerLat'] as num?)?.toDouble() ?? 0,
      centerLng: (json['centerLng'] as num?)?.toDouble() ?? 0,
      radius: (json['radius'] as num?)?.toDouble() ?? 0,
      startTime: _tryParseDateTime(json['startTime']),
      endTime: _tryParseDateTime(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'centerLat': centerLat,
      'centerLng': centerLng,
      'radius': radius,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  static DateTime? _tryParseDateTime(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
