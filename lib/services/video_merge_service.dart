import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:http/http.dart' as http;

class VideoMergeService {
  static Future<bool> mergeVideoWithAudio({
    required String videoPath,
    required String audioUrl,
    required String outputPath,
  }) async {
    try {
      final audioFile = File('${Directory.systemTemp.path}/temp_audio.mp3');
      final audioBytes = await http.readBytes(Uri.parse(audioUrl));
      await audioFile.writeAsBytes(audioBytes);

      final outDir = Directory(outputPath).parent;
      if (!await outDir.exists()) {
        await outDir.create(recursive: true);
      }

      final command =
          "-i \"$videoPath\" -i \"${audioFile.path}\" -map 0:v -map 1:a -c:v copy -shortest \"$outputPath\"";

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      return returnCode?.isValueSuccess() ?? false;
    } catch (e) {
      print("Merge error: $e");
      throw Exception(e.toString());
    }
  }
}
