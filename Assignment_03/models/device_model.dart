// models/device_model.dart
import 'package:flutter/material.dart';

/// Device types enum for categorization
enum DeviceType {
  light,
  fan,
  ac,
  camera,
  tv,
  speaker,
}

/// Device Model Class
/// Represents a smart home device with all its properties
class Device {
  final String id;
  String name;
  DeviceType type;
  String room;
  bool isOn;
  double value; // For brightness, speed, temperature, etc.

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    this.value = 50.0,
  });

  /// Get icon based on device type
  IconData get icon {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb;
      case DeviceType.fan:
        return Icons.wind_power;
      case DeviceType.ac:
        return Icons.ac_unit;
      case DeviceType.camera:
        return Icons.videocam;
      case DeviceType.tv:
        return Icons.tv;
      case DeviceType.speaker:
        return Icons.speaker;
    }
  }

  /// Get color based on device type
  Color get color {
    switch (type) {
      case DeviceType.light:
        return Colors.amber;
      case DeviceType.fan:
        return Colors.blue;
      case DeviceType.ac:
        return Colors.cyan;
      case DeviceType.camera:
        return Colors.red;
      case DeviceType.tv:
        return Colors.purple;
      case DeviceType.speaker:
        return Colors.green;
    }
  }

  /// Get device type name as string
  String get typeName {
    switch (type) {
      case DeviceType.light:
        return 'Light';
      case DeviceType.fan:
        return 'Fan';
      case DeviceType.ac:
        return 'Air Conditioner';
      case DeviceType.camera:
        return 'Camera';
      case DeviceType.tv:
        return 'Television';
      case DeviceType.speaker:
        return 'Speaker';
    }
  }

  /// Get control label (brightness, speed, temperature)
  String get controlLabel {
    switch (type) {
      case DeviceType.light:
        return 'Brightness';
      case DeviceType.fan:
        return 'Speed';
      case DeviceType.ac:
        return 'Temperature';
      case DeviceType.camera:
        return 'Quality';
      case DeviceType.tv:
        return 'Volume';
      case DeviceType.speaker:
        return 'Volume';
    }
  }

  /// Get status text
  String get statusText {
    return isOn ? '$name is ON' : '$name is OFF';
  }

  /// Copy with method for immutable updates
  Device copyWith({
    String? name,
    DeviceType? type,
    String? room,
    bool? isOn,
    double? value,
  }) {
    return Device(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      room: room ?? this.room,
      isOn: isOn ?? this.isOn,
      value: value ?? this.value,
    );
  }
}

/// Helper function to get DeviceType from string
DeviceType getDeviceTypeFromString(String typeStr) {
  switch (typeStr.toLowerCase()) {
    case 'fan':
      return DeviceType.fan;
    case 'air conditioner':
    case 'ac':
      return DeviceType.ac;
    case 'camera':
      return DeviceType.camera;
    case 'television':
    case 'tv':
      return DeviceType.tv;
    case 'speaker':
      return DeviceType.speaker;
    default:
      return DeviceType.light;
  }
}