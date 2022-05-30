library image_generator;

import 'dart:io' show File, Directory, exit;

import 'package:dcli/dcli.dart';
import 'package:image/image.dart';
part 'devices.dart';

Future<void> main(List<String> args) async {
  // input & output directories are used for this script
  const inputPath = './input/';
  const outputPath = './output/';

  // create argument parser and parse given arguments
  final parser = ArgParser()
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Logs additional details',
    )
    ..addFlag(
      'android',
      abbr: 'a',
      negatable: false,
      help: 'Convert images only to android devices',
    )
    ..addFlag(
      'androidtablet',
      //abbr: 'at',
      negatable: false,
      help: 'Convert images only to android tablet devices',
    )
    ..addFlag(
      'ios',
      abbr: 'i',
      negatable: false,
      help: 'Convert images only to ios devices',
    )
    ..addFlag(
      'iostablet',
      //abbr: 'it',
      negatable: false,
      help: 'Convert images only to ios tablet devices',
    );
  final parsedArgs = parser.parse(args);

  // check for passed flags
  Settings().setVerbose(enabled: parsedArgs.wasParsed('verbose'));
  final onlyIosImages = parsedArgs.wasParsed('ios');
  final onlyIosTabletImages = parsedArgs.wasParsed('iostablet');
  final onlyAndroidImages = parsedArgs.wasParsed('android');
  final onlyAndroidTabletImages = parsedArgs.wasParsed('androidtablet');

  // create output directory
  createDirectory(outputPath);

  // get images from input directory
  final images = find(
    '*.*',
    workingDirectory: inputPath,
    types: [Find.file],
  ).toList();
  if (images.isEmpty) {
    print(
      red('!ERROR! No files found in $inputPath \n'),
    );
    exit(1);
  }

  // print some debug stuff
  print(
    green('Total images found: ${images.length} \n'),
  );
  if (Settings().isVerbose) {
    images.forEach(print);
  }

  // convert images
  await generateImages(
    <Device>[
      if (!onlyAndroidImages && !onlyAndroidTabletImages) ...[
        if (onlyIosTabletImages)
          ...iosTabletDevices
        else ...[...iosDevices, ...iosTabletDevices],
      ],
      if (!onlyIosImages && !onlyIosTabletImages) ...[
        if (onlyAndroidTabletImages)
          ...androidTabletDevices
        else ...[...androidDevices, ...androidTabletDevices],
      ],
    ],
    images,
    outputPath,
  );

  // finish
  print(
    green('\n Work done - exit \n'),
  );
  exit(0);
}

// delete dir if exist and creates new one -> removes old images
void createDirectory(String outputPath) {
  final outputDir = Directory(outputPath);
  if (outputDir.existsSync()) {
    print('Deleting $outputPath directory ...');
    outputDir.deleteSync(recursive: true);
  }
  outputDir.createSync();
}

// converts images each image to each device
Future<void> generateImages(
  List<Device> devices,
  List<String> images,
  String outputPath,
) async {
  const waitingTime = Duration(milliseconds: 20);
  var counter = 0;
  try {
    for (final device in devices) {
      for (final image in images) {
        final img = decodeImage(
          File(image).readAsBytesSync(),
        );
        if (img == null) {
          print(
            '!ERROR! at decoding image :: $image could not be decoded - SKIPPING',
          );
          continue;
        }
        final newImg = copyResize(
          img,
          width: device.width,
          height: device.height,
        );
        File('$outputPath${device.name}-$counter.jpg').writeAsBytesSync(
          encodeJpg(newImg),
        );

        await Future<void>.delayed(waitingTime);

        print(
          green('Image generated: $outputPath${device.name}-$counter.jpg'),
        );
        counter++;
      }
    }
  } catch (e) {
    print(
      red('!ERROR! at converting images: $e \n'),
    );
  }
  print(
    'Images to convert: ${devices.length * images.length} :: Converted images: $counter',
  );
}
