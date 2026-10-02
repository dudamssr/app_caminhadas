import 'dart:convert';
import 'package:latlong2/latlong.dart';

class Walk {
  final String id;
  final String title;
  final LatLng startPoint;
  final LatLng endPoint;
  final double distanceInMeters;
  final int estimatedCalories;
  final int estimatedMinutes;
  String? photoPath;

  Walk({
    required this.id,
    required this.title,
    required this.startPoint,
    required this.endPoint,
    required this.distanceInMeters,
    required this.estimatedCalories,
    required this.estimatedMinutes,
    this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startLat': startPoint.latitude,
      'startLng': startPoint.longitude,
      'endLat': endPoint.latitude,
      'endLng': endPoint.longitude,
      'distanceInMeters': distanceInMeters,
      'estimatedCalories': estimatedCalories,
      'estimatedMinutes': estimatedMinutes,
      'photoPath': photoPath,
    };
  }

  factory Walk.fromMap(Map<String, dynamic> map) {
    return Walk(
      id: map['id'],
      title: map['title'],
      startPoint: LatLng(map['startLat'], map['startLng']),
      endPoint: LatLng(map['endLat'], map['endLng']),
      distanceInMeters: (map['distanceInMeters'] as num).toDouble(),
      estimatedCalories: map['estimatedCalories'],
      estimatedMinutes: map['estimatedMinutes'],
      photoPath: map['photoPath'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Walk.fromJson(String source) => Walk.fromMap(json.decode(source));
}