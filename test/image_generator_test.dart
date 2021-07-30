import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:storeImageGenerator/devices.dart' as devices;
import 'package:storeImageGenerator/image_generator.dart' as gen;
import 'package:test/test.dart';

Future<void> main() async {
  test('Generate store icons', () async {
    // ensure current path is the project directory while executing this test
    const outputPath = './output/';
    const inputPath = './test';
    const imagesToGenerate = [...devices.androidDevices, ...devices.iosDevices];

    gen.createDirectory(outputPath);
    expect(Directory(outputPath).existsSync(), true);

    final inputImages =
        find('*.jpg', workingDirectory: inputPath, types: [Find.file]).toList();

    await gen.convertImages(imagesToGenerate, inputImages, outputPath);

    final outputImages =
        find('*.*', workingDirectory: outputPath, types: [Find.file]).toList();

    expect(imagesToGenerate.length, outputImages.length);
  });
}
