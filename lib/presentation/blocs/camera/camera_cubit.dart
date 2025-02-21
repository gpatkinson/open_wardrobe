import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:openwardrobe/presentation/blocs/camera/camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  Future<void> initializeCamera() async {
    try {
      emit(CameraLoading());
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(const CameraError('No cameras available'));
        return;
      }

      final controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );

      await controller.initialize();
      emit(CameraReady(controller, cameras));
    } catch (e) {
      emit(CameraError('Failed to initialize camera: $e'));
    }
  }

  Future<void> captureImage() async {
    final state = this.state;
    if (state is CameraReady) {
      try {
        final image = await state.controller.takePicture();
        emit(CameraCaptureSuccess(image.path));
      } catch (e) {
        emit(CameraError('Failed to capture image: $e'));
      }
    }
  }

  @override
  Future<void> close() {
    final state = this.state;
    if (state is CameraReady) {
      state.controller.dispose();
    }
    return super.close();
  }
}