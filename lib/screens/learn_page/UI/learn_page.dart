import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_controller.dart';
import 'package:how_to_use_provider/screens/learn_page/controller/learn_page_provider.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page1/UI/practise_page1.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page2/UI/practise_page2.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/practice_page3/UI/practise_page3.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/result_page/UI/result_page.dart';
import 'package:how_to_use_provider/screens/learn_page/sub_page/study_page/UI/study_page.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';
import 'package:video_player/video_player.dart';

class LearnPage extends StatefulHookConsumerWidget {
  const LearnPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LearnPageState();
}

class _LearnPageState extends ConsumerState<LearnPage> {
  @override
  Widget build(BuildContext context) {
    // Theo dõi trạng thái dữ liệu học tập.
    final learnDataAsync = ref.watch(learnDataStateProvider);
    // Chỉ cần theo dõi `learnDataAsync` để hiển thị trạng thái tải.
    // Các provider khác sẽ được sử dụng bên trong các khối logic.

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // Chỉ hiển thị nút thoát khi đang trong quá trình học.
        leading:
            learnDataAsync.isNotEmpty &&
                    ref.watch(indexQuestionProvider) < learnDataAsync.length
                ? IconButton(
                  onPressed:
                      () => LearnPageController(ref, context).exitLearn(),
                  icon: const Icon(FontAwesomeIcons.arrowLeft),
                )
                : null, // Ẩn nút khi ở trang kết quả
        surfaceTintColor: AppColors.background,
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
      ),
      // Xử lý trạng thái tải ở đây
      body:
          learnDataAsync.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _buildPageContent(learnDataAsync),
    );
  }

  Widget _buildPageContent(List<DataLearnModel> learnData) {
    final questionIndex = ref.watch(indexQuestionProvider);

    // Kiểm tra xem bài học đã kết thúc chưa
    if (questionIndex >= learnData.length) {
      return const ResultPage();
    }

    // Lấy trạng thái preloading
    final preloadState = ref.watch(preloadStateProvider);

    // Lấy dữ liệu cho câu hỏi hiện tại
    final currentQuestion = learnData[questionIndex];

    // Lấy controller cho index hiện tại. Nó có thể là null!
    final VideoPlayerController? currentController =
        preloadState.controllers[questionIndex];

    // TẠO MỘT KEY DUY NHẤT CHO MỖI CÂU HỎI
    // Sử dụng ID của từ để đảm bảo nó là duy nhất và ổn định.
    final Key uniqueKey = ValueKey(currentQuestion.word.id);

    switch (currentQuestion.type) {
      case 'study':
      case 'practise1':
      case 'practise2':
        // Đối với các loại cần video, hãy kiểm tra xem controller đã sẵn sàng chưa.
        if (currentController != null) {
          // Phân luồng đến đúng trang với controller đã được xác nhận là không null.
          if (currentQuestion.type == 'study') {
            return StudyPage(
              key: uniqueKey, // <-- THÊM KEY VÀO ĐÂY
              dataLearnModel: currentQuestion,
              videoPlayerController: currentController,
            );
          } else if (currentQuestion.type == 'practise1') {
            return PractisePage1(
              key: uniqueKey, // <-- THÊM KEY VÀO ĐÂY
              dataLearnModel: currentQuestion,
              videoPlayerController: currentController,
            );
          } else {
            // practise2
            return PractisePage2(
              key: uniqueKey, // <-- THÊM KEY VÀO ĐÂY
              dataLearnModel: currentQuestion,
              videoPlayerController: currentController,
            );
          }
        } else {
          // Hiển thị một chỉ báo tải nếu controller chưa sẵn sàng.
          return const Center(child: CircularProgressIndicator());
        }

      case 'practise3':
        // Loại này cũng nên có một key để đảm bảo tính nhất quán.
        return PractisePage3(
          key: uniqueKey, // <-- THÊM KEY VÀO ĐÂY
          dataLearnModel: currentQuestion,
        );

      default:
        // Xử lý các loại không xác định một cách an toàn.
        return Center(
          child: Text('Loại câu hỏi không hợp lệ: ${currentQuestion.type}'),
        );
    }
  }
}
