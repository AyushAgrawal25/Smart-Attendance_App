import 'dart:io';

import 'package:attendance_app/BusinesLogic/AttendanceServices.dart';
import 'package:attendance_app/State/AttendanceResult.dart';
import 'package:attendance_app/UserInterface/AttendancePage.dart';
import 'package:flutter/material.dart';

class ImagePreviewPage extends StatefulWidget {
  final String imagePath;
  const ImagePreviewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  bool isLoading = false;
  uploadImage(String imagePath) async {
    setState(() {
      isLoading = true;
    });
    AttendanceResult? result = await AttendanceServices.uploadImage(imagePath);
    if (result == null) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading image'),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AttendancePage(
            lables: result.lables,
            probabilities: result.probabilities,
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  tempUpload(String imagePath) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AttendancePage(
          lables: ['19115102', '19115103', '19115104'],
          probabilities: [0.65486354, 0.5565, 0.54164646],
        ),
      ),
    );

    setState(() {
      isLoading = false;
    });
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
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Retake'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    uploadImage(widget.imagePath);
                    // tempUpload(widget.imagePath);
                  },
                  child: const Text('Upload'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
