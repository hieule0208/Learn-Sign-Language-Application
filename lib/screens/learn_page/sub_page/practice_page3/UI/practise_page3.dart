import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page3/Controller/practise_page3_controller.dart';
import 'package:how_to_use_provider/services/api_services.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';

class PractisePage3 extends StatefulWidget {
  const PractisePage3({super.key, required this.dataLearnModel});

  final DataLearnModel dataLearnModel;

  @override
  State<PractisePage3> createState() => PractisePage3State();
}

class PractisePage3State extends State<PractisePage3> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _error;
  XFile? image;
  int replayTime = 0;
  bool? isCorrect = true;

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

  void confirmLogic(XFile image) async {
    final apiService = ApiServices();
    String? answer;
    try {
      answer = await apiService
          .postCapturedImage(image)
          .timeout(const Duration(seconds: 7), onTimeout: () => null);
    } catch (e) {
      return null;
    }

    print(answer); 

    if (answer == null) {
      retry();
      setState(() {
        isCorrect = null;
        replayTime++;
      });
      return;
    }

    if (answer.toLowerCase() == widget.dataLearnModel.word.word.toLowerCase()) {
      print("Đúng rồi thằng ML");
    } else {
      setState(() {
        retry();
        isCorrect = false;
        replayTime++;
      });
    }
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
      backgroundColor: AppColors.background,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // thông báo lỗi
            isCorrect == null
                ? Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.watchBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.watchPrimary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "Gửi dữ liệu lỗi, vui lòng thử lại!",
                      style: TextStyle(
                        color: AppColors.watchPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                : isCorrect == false
                ? Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.watchBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.watchPrimary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "Đáp án sai, vui lòng thử lại!",
                      style: TextStyle(
                        color: AppColors.watchPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                : Container(),
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
              widget.dataLearnModel.word.word,
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
                        onPressed: () => confirmLogic(image!),
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
