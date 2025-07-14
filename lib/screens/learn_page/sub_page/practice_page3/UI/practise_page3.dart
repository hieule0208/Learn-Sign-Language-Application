import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';

class PractisePage3 extends StatefulWidget {
  const PractisePage3({super.key});

  // final DataLearnModel dataLearnModel;

  @override
  State<PractisePage3> createState() => PractisePage3State();
}

class PractisePage3State extends State<PractisePage3> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _error;
  XFile? image;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = "No camera available.");
        return;
      }

      _controller = CameraController(
        cameras[0], // Camera sau hoặc trước tùy theo vị trí
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = _controller!.initialize();
      setState(() {}); // để FutureBuilder cập nhật
    } catch (e) {
      setState(() => _error = "Failed to initialize camera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _disposeCamera() {
    _controller?.dispose();
    _controller = null;
    _initializeControllerFuture = null;
    setState(() {});
  }

  void takePhoto() async {
    try {
      await _initializeControllerFuture;
      final capturedImage = await _controller!.takePicture();
      _disposeCamera(); // Dispose camera sau khi chụp
      setState(() {
        image = capturedImage;
      });
    } catch (e) {
      log("Error taking picture: $e");
    }
  }

  void retry() {
    setState(() {
      image = null;
    });
    _initCamera(); // Khởi động lại camera
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // khung ảnh
            // Khi ảnh chưa được chụp thì hiện khung chụp
            image == null
                ? _initializeControllerFuture == null
                    ? AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 28,
                              offset: Offset(0, 12),
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: LoadingState(
                            imagePath: "lib/assets/image/gestura_logo.png",
                            size: 150,
                          ),
                        ),
                      ),
                    )
                    : FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(27),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 28,
                                  offset: Offset(0, 12),
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // 👈 Bo góc ở đây
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.center,
                                  heightFactor: 0.75, // crop từ 4:3 về 1:1
                                  child: CameraPreview(_controller!),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 28,
                                    offset: Offset(0, 12),
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withAlpha(50),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: LoadingState(
                                  imagePath:
                                      "lib/assets/image/gestura_logo.png",
                                  size: 150,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    )
                // Khi ảnh đã chụp thì hiện ảnh đã chụp
                : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 28,
                        offset: Offset(0, 12),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // 👈 Bo góc ở đây
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 0.75, // crop từ 4:3 về 1:1
                        child: Image.file(File(image!.path)),
                      ),
                    ),
                  ),
                ),
            // Nội dung câu hỏi
            Text(
              "Xe máy",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Hệ thống nút điểu khiển
            image == null
                // Nút chụp ảnh
                ? Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  height: 100,
                  width: 220,
                  child: ElevatedButton(
                    onPressed: () => takePhoto(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.primary,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.camera,
                          size: 30,
                          color: AppColors.background,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Chụp ảnh",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.background,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Nút thử lại
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      height: 100,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () => retry(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.primary,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.rotateRight,
                              size: 25,
                              color: AppColors.background,
                            ),
                            SizedBox(width: 20),
                            Text(
                              "Thử lại",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Nút xác nhận
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      height: 100,
                      width: 175,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.primary,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.check,
                              size: 25,
                              color: AppColors.background,
                            ),
                            SizedBox(width: 20),

                            Text(
                              "Xác nhận",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
