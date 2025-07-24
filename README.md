# how_to_use_provider

## Giới thiệu

**how_to_use_provider** là ứng dụng di động Flutter được phát triển nhằm hỗ trợ người câm điếc học ngôn ngữ ký hiệu một cách hiệu quả, hiện đại và thân thiện. Ứng dụng sử dụng các công nghệ quản lý trạng thái tiên tiến như Riverpod, tích hợp Firebase, và nhiều tính năng học tập thông minh.

## Tính năng nổi bật

- **Học từ vựng ngôn ngữ ký hiệu**: Quản lý, luyện tập và kiểm tra từ vựng cá nhân.
- **Luyện tập cùng AI**: Tích hợp các bài thực hành, nhận diện hình ảnh và video.
- **Theo dõi tiến trình học tập**: Thống kê điểm số, số từ đã học, số từ thành thạo, và các thành tích cá nhân.
- **Đăng nhập, đăng ký, bảo mật**: Tích hợp Firebase Auth, hỗ trợ đăng nhập bằng email, Google, Facebook, Apple.
- **Giao diện thân thiện, dễ sử dụng**: Sử dụng font Montserrat, màu sắc tối ưu cho người khiếm thính.
- **Hỗ trợ đa nền tảng**: Chạy tốt trên cả Android và iOS.

## Cấu trúc thư mục

- `lib/screens/`: Các màn hình chính (home, overview, learn_page, result_page, study_page, introduce, scenario, login, sign_up, setting, dictionary, video, conversation)
- `lib/models/`: Các model dữ liệu (user, topic, word, metric, ...)
- `lib/widgets/`: Các widget tuỳ chỉnh (nút, danh sách, ô nhập, ...)
- `lib/services/`: Các dịch vụ API, launch app, ...
- `lib/utilities/`: Tiện ích màu sắc, điểm số, cấp độ, ...
- `lib/assets/`: Hình ảnh, font chữ

## Công nghệ sử dụng

- **Flutter**: Framework phát triển ứng dụng di động đa nền tảng.
- **Riverpod & Provider**: Quản lý trạng thái hiện đại, dễ mở rộng.
- **Firebase**: Đăng nhập, lưu trữ dữ liệu người dùng.
- **Carousel Slider, Chewie, Video Player**: Trình chiếu slide, video học tập.
- **Camera, Photo View**: Nhận diện hình ảnh, hỗ trợ luyện tập thực tế.
- **Shared Preferences**: Lưu trạng thái đăng nhập, thông tin người dùng.

## Hướng dẫn cài đặt

1. **Clone repo:**
   ```bash
   git clone <repo-url>
   cd how_to_use_provider
   ```

2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

3. **Cấu hình Firebase:**
   - Thêm file `google-services.json` vào `android/app`
   - Thêm file `GoogleService-Info.plist` vào `ios/Runner`
   - Làm theo hướng dẫn tại [Firebase for Flutter](https://firebase.flutter.dev/docs/overview)

4. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```

## Đóng góp

- Fork repo, tạo pull request hoặc mở issue nếu bạn muốn đóng góp hoặc phát hiện lỗi.
- Mọi ý kiến đóng góp đều giúp ứng dụng phục vụ cộng đồng người câm điếc tốt hơn!

## Tài nguyên tham khảo

- [Riverpod documentation](https://riverpod.dev/docs/getting_started)
- [Firebase for Flutter](https://firebase.flutter.dev/docs/overview)
- [Chewie video player](https://pub.dev/packages/chewie)
- [Carousel Slider](https://pub.dev/packages/carousel_slider)

---

**Ứng dụng này dành cho cộng đồng người câm điếc Việt Nam, giúp học ngôn ngữ ký hiệu dễ dàng hơn. Cảm ơn bạn đã sử dụng và đóng góp!**