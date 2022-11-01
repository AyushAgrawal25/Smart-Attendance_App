import 'dart:io';

import 'package:attendance_app/BusinesLogic/AttendanceServices.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  final String videoPath;
  final String? thumbnailPath;
  const PreviewPage({
    Key? key,
    required this.thumbnailPath,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool isLoading = false;

  uploadVideo(String videoPath) async {
    setState(() {
      isLoading = true;
    });
    bool uploadStatus = await AttendanceServices.uploadVideo(videoPath);

    setState(() {
      isLoading = false;
    });
    return uploadStatus;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 35,
        ),
        child: Column(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: (widget.thumbnailPath != null)
                    ? Image.file(
                        File(widget.thumbnailPath!),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: const Icon(
                          Icons.video_file,
                        ),
                      )),
            const Expanded(
                child: SizedBox(
              height: 20,
            )),
            Container(
              padding: const EdgeInsets.only(bottom: 0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  uploadVideo(widget.videoPath);
                },
                child: const Text('Upload'),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Retake'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
