import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/controller/result_page_provider.dart';
import 'package:how_to_use_provider/services/api_services.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:how_to_use_provider/utilities/score.dart';
import 'package:how_to_use_provider/widgets/loading_state.dart';

class PractisePage3 extends StatefulHookConsumerWidget {
  const PractisePage3({super.key, required this.dataLearnModel});

  final DataLearnModel dataLearnModel;

  @override
  ConsumerState<PractisePage3> createState() => PractisePage3State();
}

class PractisePage3State extends ConsumerState<PractisePage3> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  String? _error;
  XFile? image;
  int replayTime = 0;
  bool? isCorrect = true;
  bool isLoading = false; // New flag to track API loading state

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

      _controller = CameraController(cameras[0], ResolutionPreset.medium);

      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
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
      _disposeCamera();
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
      isLoading = false; // Reset loading state
    });
    _initCamera();
  }

  void confirmLogic(XFile imageCaptured) async {
    setState(() {
      isLoading = true; // Start loading
    });

    final apiService = ApiServices();
    String? answer;
    try {
      answer = await apiService
          .postCapturedImage(imageCaptured)
          .timeout(const Duration(seconds: 7), onTimeout: () => null);
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      return;
    }

    if (answer == null) {
      retry();
      setState(() {
        isCorrect = null;
        replayTime++;
        isLoading = false; // Stop loading
      });
      return;
    }

    if (answer.toLowerCase() == widget.dataLearnModel.word.word.toLowerCase()) {
      print("Đúng rồi thằng ML");

      _disposeCamera();
      image = null;
      replayTime = 0;
      isCorrect = true;
      setState(() {
        isLoading = false; // Stop loading
      });

      ref.read(amountScoreGainedProvider.notifier).increment(Score.practise);
      ref
          .read(listWordUpdatedProvider.notifier)
          .add(widget.dataLearnModel.word);

      ref.read(indexQuestionProvider.notifier).increment();
    } else {
      if (replayTime > 2) {
        _disposeCamera();
      } else {
        setState(() {
          retry();
          isCorrect = false;
          replayTime++;
          isLoading = false; // Stop loading
        });
      }
    }
  }

  void skipPractise() {
    image = null;
    replayTime = 0;
    isCorrect = true;
    setState(() {
      isLoading = false; // Reset loading state
    });

    ref.read(indexQuestionProvider.notifier).increment();
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
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Error or incorrect answer message
                isCorrect == null
                    ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.watchBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.watchPrimary,
                          width: 2,
                        ),
                      ),
                      child: const Center(
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.watchBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.watchPrimary,
                          width: 2,
                        ),
                      ),
                      child: const Center(
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
                // Camera preview or captured image
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
                                  offset: const Offset(0, 12),
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Colors.black.withAlpha(50),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
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
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(27),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(50),
                                      blurRadius: 28,
                                      offset: const Offset(0, 12),
                                      spreadRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withAlpha(50),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.center,
                                      heightFactor: 0.75,
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
                                        offset: const Offset(0, 12),
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withAlpha(50),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
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
                    : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.center,
                            heightFactor: 0.75,
                            child: Image.file(File(image!.path)),
                          ),
                        ),
                      ),
                    ),
                // Question text
                Text(
                  widget.dataLearnModel.word.word,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Button controls
                replayTime <= 2
                    ? image == null
                        ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          height: 100,
                          width: 220,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : () => takePhoto(),
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
                                const SizedBox(width: 20),
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
                            // Retry button
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              height: 100,
                              width: 150,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () => retry(),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                    isLoading
                                        ? AppColors.textSub.withAlpha(
                                          90,
                                        )
                                        : null,
                                  ),
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
                                    const SizedBox(width: 20),
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
                            // Confirm button
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              height: 100,
                              width: 175,
                              child: ElevatedButton(
                                onPressed:
                                    isLoading
                                        ? null
                                        : () => confirmLogic(image!),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                    isLoading
                                        ? AppColors.textSub.withAlpha(
                                          90,
                                        )
                                        : null,
                                  ),
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
                                    const SizedBox(width: 20),
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
                        )
                    : Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      height: 100,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => skipPractise(),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.watchPrimary,
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
                            Text(
                              "Bỏ qua",
                              style: TextStyle(
                                fontSize: 20,
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
          ),
        ],
      ),
    );
  }
}
