import 'package:flutter/material.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/screen_sizes.dart';

class NewsDetails extends StatelessWidget {
  final String title;
  final String description;
  final String publishedAt;

  const NewsDetails({
    Key? key,
    required this.title,
    required this.description,
    required this.publishedAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenSizes.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ScreenSizes.width * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ScreenSizes.height * 0.01),
          Text(
            description,
            style: TextStyle(
              fontSize: ScreenSizes.width * 0.035,
              color: AppColors.greyColor,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ScreenSizes.height * 0.02),
          Text(
            publishedAt,
            style: TextStyle(
              fontSize: ScreenSizes.width * 0.03,
              color: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}
