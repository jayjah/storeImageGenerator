part of 'image_generator.dart';

// ios device size from: https://help.apple.com/app-store-connect/#/devd274dd925
const iosDevices = <IosDevice>[
  IosDevice(
    height: 2778,
    width: 1284,
    name: '6.5 inch iPhone',
  ),
  IosDevice(
    height: 2436,
    width: 1125,
    name: '5.8 inch iPhone',
  ),
  IosDevice(
    height: 2208,
    width: 1242,
    name: '5.5 inch iPhone',
  ),
  IosDevice(
    height: 1334,
    width: 750,
    name: '4.7 inch iPhone',
  ),
  IosDevice(
    height: 1096,
    width: 640,
    name: '4 inch iPhone',
  ),
  IosDevice(
    height: 920,
    width: 640,
    name: '3.5 inch iPhone',
  ),
];

const iosTabletDevices = <IosTabletDevice>[
  IosTabletDevice(
    height: 2732,
    width: 2048,
    name: '12.9 inch iPad',
  ),
  IosTabletDevice(
    height: 2388,
    width: 1668,
    name: '11 inch iPad',
  ),
  IosTabletDevice(
    height: 2224,
    width: 1668,
    name: '10.5 inch iPad',
  ),
  IosTabletDevice(
    height: 2008,
    width: 1536,
    name: '9.7 inch iPad',
  ),
];

class IosDevice extends Device {
  const IosDevice({
    required super.height,
    required super.width,
    required super.name,
  });
}

class IosTabletDevice extends TabletDevice {
  const IosTabletDevice({
    required super.height,
    required super.width,
    required super.name,
  });
}

// android device size from: https://support.google.com/googleplay/android-developer/answer/9866151?hl=en
const androidDevices = <AndroidDevice>[
  AndroidDevice(
    height: 2280,
    width: 1080,
    name: 'android-phone',
  ),
];

const androidTabletDevices = <AndroidTabletDevice>[
  AndroidTabletDevice(
    height: 2732,
    width: 2048,
    name: 'android-tablet',
  ),
];

class AndroidDevice extends Device {
  const AndroidDevice({
    required super.height,
    required super.width,
    required super.name,
  });
}

class AndroidTabletDevice extends TabletDevice {
  const AndroidTabletDevice({
    required super.height,
    required super.width,
    required super.name,
  });
}

abstract class TabletDevice extends Device {
  const TabletDevice(
      {required super.height, required super.width, required super.name});
}

abstract class Device {
  const Device({required this.height, required this.width, required this.name});
  final int height;
  final int width;
  final String name;
  @override
  String toString() => '$name --- width: $width x height:$height';
}
