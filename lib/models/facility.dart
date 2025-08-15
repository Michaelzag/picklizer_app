import 'package:uuid/uuid.dart';
import 'enums.dart';

class Facility {
  final String id;
  final String name;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final SyncStatus syncStatus;

  Facility({
    String? id,
    required this.name,
    this.location,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
    this.syncStatus = SyncStatus.local,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
    'is_active': isActive ? 1 : 0,
    'sync_status': syncStatus.name,
  };

  static Facility fromJson(Map<String, dynamic> json) => Facility(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
    isActive: json['is_active'] == 1,
    syncStatus: SyncStatus.values.firstWhere(
      (status) => status.name == json['sync_status'],
      orElse: () => SyncStatus.local,
    ),
  );

  Facility copyWith({
    String? id,
    String? name,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    SyncStatus? syncStatus,
  }) {
    return Facility(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(), // Always update timestamp on changes
      isActive: isActive ?? this.isActive,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Facility &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Facility(id: $id, name: $name, location: $location)';
}