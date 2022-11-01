import 'dart:io';

import 'package:attendance_app/constants.dart';
import 'package:http/http.dart' as http;

class AttendanceServices {
  static Future<bool> uploadVideo(String videoPath) async {
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse('${get_API_HOST()}/videoAttendance'),
    );

    print(request.url);

    request.files.add(
      http.MultipartFile(
        'video',
        File(videoPath).readAsBytes().asStream(),
        File(videoPath).lengthSync(),
        filename: videoPath.split('/').last,
      ),
    );

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print(responseBody);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
