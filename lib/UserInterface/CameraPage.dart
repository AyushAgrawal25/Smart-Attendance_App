import 'dart:io';

import 'package:attendance_app/State/CameraState.dart';
import 'package:attendance_app/UserInterface/ImagePreviewPage.dart';
import 'package:attendance_app/UserInterface/PreviewPage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vid;

// TODO: Once recorded navigate it to other page.
// Give a feature to re-record the video.

// TODO: Try creating contour around the face.

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // TODO: throw error.
            break;
          default:
            // TODO: throw error.
            break;
        }
      }
    });
  }

  void startRecording() {
    _controller.startVideoRecording();
  }

  Future<String> getExternalStoragePath() async {
    PermissionStatus permissionStatus = PermissionStatus.denied;
    while (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await Permission.storage.request();
    }

    final Directory extDir = (await getExternalStorageDirectory())!;
    final String dirPath = '${extDir.path}/Movies';
    Directory(dirPath).createSync(recursive: true);

    return dirPath;
  }

  Future<String?> createThumbnail(String videoPath, String dirPath) async {
    String? thumbnailPath = await vid.VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: dirPath,
      imageFormat: vid.ImageFormat.JPEG,
      maxHeight: 128,
      quality: 75,
    );

    return thumbnailPath;
  }

  Future<void> stopRecording() async {
    XFile videoPath = await _controller.stopVideoRecording();
    String path = videoPath.path;

    // Save this video to external directory
    String extDirPath = await getExternalStoragePath();
    String fileName = path.split('/').last;
    String newPath = '$extDirPath/$fileName';
    File(path).copySync(newPath);

    // Delete the video from internal storage
    File(path).deleteSync();

    // Create a thumbnail of the video
    String? thumbnailPath = await createThumbnail(newPath, extDirPath);

    // Navigate to the preview page
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PreviewPage(videoPath: newPath, thumbnailPath: thumbnailPath);
    }));
  }

  onCaptureButtonPressed() async {
    // Code for capturing image
    XFile imagePath = await _controller.takePicture();
    String path = imagePath.path;

    // Save this image to external directory
    String extDirPath = await getExternalStoragePath();
    String fileName = path.split('/').last;
    String newPath = '$extDirPath/$fileName';
    File(path).copySync(newPath);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ImagePreviewPage(imagePath: newPath);
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Attendance App'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Video'),
      ),
      body: Stack(
        children: [
          CameraPreview(_controller),
          // Container(
          //   // Create a cirular button to take a picture
          //   alignment: Alignment.bottomCenter,
          //   padding: const EdgeInsets.only(bottom: 20),
          //   child: VideoRecordButton(
          //     onTapDown: startRecording,
          //     onTapUp: stopRecording,
          //   ),
          // ),

          // TODO: Print a recording gesture at top.

          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: CaptureButton(
              onTap: onCaptureButtonPressed,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class VideoRecordButton extends StatefulWidget {
  final Function onTapDown;
  final Function onTapUp;
  const VideoRecordButton({
    Key? key,
    required this.onTapDown,
    required this.onTapUp,
  }) : super(key: key);

  @override
  State<VideoRecordButton> createState() => _VideoRecordButtonState();
}

class _VideoRecordButtonState extends State<VideoRecordButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
        widget.onTapDown();
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
        widget.onTapUp();
      },
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all((isPressed) ? 10 : 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}

class CaptureButton extends StatefulWidget {
  final Function onTap;
  const CaptureButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
