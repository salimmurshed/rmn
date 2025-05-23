
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/common.dart';

class BuildUnArchivedAll extends StatelessWidget {
  final VoidCallback onUnarchiveAll;
  final bool isUndo;

  const BuildUnArchivedAll({
    super.key,
    required this.onUnarchiveAll,
    required this.isUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.colorSecondary,
        border: Border.all(color: AppColors.colorPrimaryInverse, width: 1.0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ Align text to top
        children: [
          /// **Left Text Section (Wrap in Expanded)**
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isUndo) ...[
                  Text(
                    "These chats are unarchived when new messages are received.",
                    style: AppTextStyles.tabTitle(color: AppColors.colorPrimaryNeutralText),
                    softWrap: true, // ✅ Ensures text wraps properly
                  ),
                ] else ...[
                  Text(
                    "Chat Archived",
                    style: AppTextStyles.tabTitle(color: AppColors.colorPrimaryNeutralText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "You can unarchive chats from the Archived tab to restore them to your main chat list.",
                    style: AppTextStyles.tabTitle(color: AppColors.colorPrimaryNeutralText),
                    softWrap: true, // ✅ Ensures text wraps properly
                  ),
                ]
              ],
            ),
          ),

          /// **Right Button**
          GestureDetector(
            onTap: onUnarchiveAll,
            child: Text(
              isUndo ? "Unarchive All" : "Undo",
              style: TextStyle(
                fontWeight: AppFontWeight.subtitleWeightedOutFit,
                fontSize: 16.sp,
                decoration: TextDecoration.underline,
                color: AppColors.colorPrimaryInverseText,
                fontFamily: AppFontFamilies.squada,
                decorationColor: AppColors.colorPrimaryInverseText,
                decorationThickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}