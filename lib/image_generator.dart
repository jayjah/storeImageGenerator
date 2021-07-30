#! /usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:image/image.dart';
import 'package:storeImageGenerator/devices.dart';

Future<void> main(List<String> args) async {
  // check for cli arguments
  final parser = ArgParser();
  parser.addFlag(
    'verbose',
    abbr: 'v',
    negatable: false,
    help: 'Logs additional details to the cli',
  );
  parser.addFlag(
    'android',
    abbr: 'a',
    negatable: false,
    help: 'Convert images only to android play store',
  );
  parser.addFlag(
    'ios',
    abbr: 'i',
    negatable: false,
    help: 'Convert images only to ios app store',
  );
  final parsed = parser.parse(args);
  if (parsed.wasParsed('verbose')) {
    Settings().setVerbose(enabled: true);
  }
  var onlyIosImages = false;
  var onlyAndroidImages = false;
  if (parsed.wasParsed('android')) {
    onlyAndroidImages = true;
  } else if (parsed.wasParsed('ios')) {
    onlyIosImages = true;
  }

  const inputPath = './input/';
  const outputPath = './output/';

  createDirectory(outputPath);

  // get images from input directory
  final images =
      find('*.*', workingDirectory: inputPath, types: [Find.file]).toList();

  if (images.isEmpty) {
    print(red('!ERROR! No files found in $inputPath \n'));
    exit(1);
  } else {
    print(green('Total images found: ${images.length} \n'));
    if (Settings().isVerbose) {
      images.forEach((image) => print(green('$image')));
    }

    //parse images

    if (onlyAndroidImages) {
      await convertImages(androidDevices, images, outputPath);
    } else if (onlyIosImages) {
      await convertImages(iosDevices, images, outputPath);
    } else {
      await convertImages(iosDevices, images, outputPath);
      await convertImages(androidDevices, images, outputPath);
    }
    print(green('\n Work done - all images converted - exit \n'));
    exit(0);
  }
}

// delete dir if exist and creates new one -> removes old images
void createDirectory(String outputPath) {
  final outputDir = Directory(outputPath);
  if (outputDir.existsSync()) {
    outputDir.deleteSync(recursive: true);
  }
  outputDir.createSync();
}

Future<void> convertImages(
    List<Device> devices, List<String> images, String outputPath) async {
  var counter = 0;
  try {
    for (final device in devices) {
      for (final image in images) {
        final img = decodeImage(File(image).readAsBytesSync());
        if (img == null) {
          continue;
        }
        final newImg =
            copyResize(img, width: device.width, height: device.height);
        File('$outputPath${device.name}-$counter.jpg')
            .writeAsBytesSync(encodeJpg(newImg));

        await Future<void>.delayed(const Duration(milliseconds: 20));
        print(green(
            'Image generated: $outputPath${device.name}-$counter.jpg \n'));
        counter++;
      }
    }
  } catch (e) {
    print(red('!ERROR! at converting images \n $e \n'));
  }
  return;
}