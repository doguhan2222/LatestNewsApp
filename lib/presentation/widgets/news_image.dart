import 'package:flutter/material.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/screen_sizes.dart';

class NewsImage extends StatelessWidget {
  final String? imageUrl;
  const NewsImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl!,
              height: ScreenSizes.height * 0.18,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint("Image load error: $error");
                return Container(
                  color: AppColors.greyColor,
                  height: ScreenSizes.height * 0.15,
                  width: double.infinity,
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      color: AppColors.errorColor,
                      size: ScreenSizes.width * 0.1,
                    ),
                  ),
                );
              },
            ),
          )
        : const SizedBox();
  }
}
