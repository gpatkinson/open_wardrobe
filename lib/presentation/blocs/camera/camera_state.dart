import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

sealed class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  final List<CameraDescription> cameras;

  const CameraReady(this.controller, this.cameras);

  @override
  List<Object?> get props => [controller, cameras];
}

class CameraCaptureSuccess extends CameraState {
  final String imagePath;

  const CameraCaptureSuccess(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class CameraError extends CameraState {
  final String message;

  const CameraError(this.message);

  @override
  List<Object?> get props => [message];
}