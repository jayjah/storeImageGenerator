import 'dart:io' show Directory;

import 'package:dcli/dcli.dart';
import 'package:storeImageGenerator/image_generator.dart' as gen;
import 'package:test/test.dart';

Future<void> main() async {
  test('Generate output directory', () async {
    const outputPath = './output/';
    gen.createDirectory(outputPath);
    expect(true, Directory(outputPath).existsSync());
  });
  test('Generate store icons', () async {
    // ensure current path is the project directory while executing this test
    const outputPath = './output/';
    const inputPath = './test';
    const imagesToGenerate = [...gen.androidDevices, ...gen.iosDevices];

    gen.createDirectory(outputPath);

    final inputImages = find(
      '*.jpg',
      workingDirectory: inputPath,
      types: [Find.file],
    ).toList();

    await gen.generateImages(imagesToGenerate, inputImages, outputPath);

    final outputImages = find(
      '*.*',
      workingDirectory: outputPath,
      types: [Find.file],
    ).toList();

    expect(imagesToGenerate.length, outputImages.length);
  });
}
