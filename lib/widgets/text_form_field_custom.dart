import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class TextFormFieldCustom extends ConsumerStatefulWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPasswordField;
  final TextEditingController? controller; // Controller giờ là tùy chọn
  final String? initialValue; // Thêm initialValue để hỗ trợ StateNotifier
  final ValueChanged<String>? onChanged; // Thêm onChanged để cập nhật provider

  const TextFormFieldCustom(
    this.labelText,
    this.hintText,
    this.validator,
    this.isPasswordField,
    this.controller, {
    super.key,
    this.initialValue,
    this.onChanged,
  });

  @override
  ConsumerState<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends ConsumerState<TextFormFieldCustom> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 0,
            bottom: widget.isPasswordField ? 5 : 10,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue, // Sử dụng initialValue nếu không có controller
            obscureText: widget.isPasswordField && !_isPasswordVisible,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.always,
            enableSuggestions: false,
            onChanged: widget.onChanged, // Gọi onChanged để cập nhật provider
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: AppColors.textSub),
              border: InputBorder.none,
              suffixIcon: widget.isPasswordField
                  ? IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.textSub,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}