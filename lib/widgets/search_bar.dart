import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:how_to_use_provider/utilities/color_palettes.dart';

class SearchBarCustom extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  final VoidCallback onSearchChanged;
  const SearchBarCustom(this.searchController, this.onSearchChanged, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends ConsumerState<SearchBarCustom> {
  @override
  void dispose() {
    widget.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Focus(
        onFocusChange: (hasFocus) {},
        child: SearchBar(
        hintText: "Tìm kiếm...",
        hintStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (Set<WidgetState> states) =>
            const TextStyle(color: Colors.grey, fontSize: 15),
        ),
        leading: Icon(FontAwesomeIcons.magnifyingGlass, size: 20,),
        trailing: widget.searchController.text.isNotEmpty
          ? [
            IconButton(
              onPressed: () {
              widget.searchController.clear();
              setState(() {}); // Cập nhật lại để hiện/ẩn trailing
              widget.onSearchChanged();
              },
              icon: Icon(FontAwesomeIcons.deleteLeft, size: 20),
            )
            ]
          : null,
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => AppColors.background,
        ),
        padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (Set<WidgetState> states) =>
            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        ),
        side: WidgetStateBorderSide.resolveWith(
          (Set<WidgetState> states) =>
            BorderSide(color: AppColors.primary, width: 1),
        ),
        controller: widget.searchController,
        onChanged: (_) {
          setState(() {}); // Cập nhật lại để hiện/ẩn trailing
          widget.onSearchChanged();
        },
        elevation: WidgetStateProperty.all(0),
        onSubmitted: (_) => widget.onSearchChanged(),
        ),
      ),
      ),
    );
  }
}
