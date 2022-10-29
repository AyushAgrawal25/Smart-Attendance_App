import 'package:camera/camera.dart';

late List<CameraDescription> cameras;

Future<List<CameraDescription>> initializeCameras() async {
  cameras = await availableCameras();
  return cameras;
}
