// ios Device size from: https://help.apple.com/app-store-connect/#/devd274dd925
const iosDevices = <IosDevice>[
  IosDevice(2778, 1284, '6.5 inch iPhone'),
  IosDevice(2436, 1125, '5.8 inch iPhone'),
  IosDevice(2208, 1242, '5.5 inch iPhone'),
  IosDevice(1334, 750, '4.7 inch iPhone'),
  IosDevice(1096, 640, '4 inch iPhone'),
  IosDevice(920, 640, '3.5 inch iPhone'),
  IosDevice(2732, 2048, '12.9 inch iPad'),
  IosDevice(2388, 1668, '11 inch iPad'),
  IosDevice(2224, 1668, '10.5 inch iPad'),
  IosDevice(2008, 1536, '9.7 inch iPad')
];
const androidDevices = <AndroidDevice>[];

class IosDevice extends Device {
  const IosDevice(int height, int width, String name)
      : super(height, width, name);
}

class AndroidDevice extends Device {
  const AndroidDevice(int height, int width, String name)
      : super(height, width, name);
}

abstract class Device {
  const Device(this.height, this.width, this.name);

  final int height;
  final int width;
  final String name;

  @override
  String toString() => '$name --- $width x $height';
}
