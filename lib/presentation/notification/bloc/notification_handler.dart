import 'package:flutter/cupertino.dart';
import 'package:rmnevents/common/resources/app_colors.dart';
import 'package:rmnevents/common/resources/app_text_styles.dart';

import '../../../common/resources/app_strings.dart';

class NotificationHandler {
  static customizeDescriptionHandler(
      {required String fullMessage, String? keyword, String? keywordValue}) {
    String updateKeyword = keyword ?? AppStrings.global_empty_string;
    String updateKeywordValue = keywordValue ?? AppStrings.global_empty_string;

    if (updateKeyword.isNotEmpty && updateKeywordValue.isNotEmpty) {
      if (fullMessage.contains(updateKeyword)) {
        String message = fullMessage.replaceAll(
          '{$updateKeyword}',
          updateKeywordValue,
        );
        int indexOfKeywordValue = message.indexOf(updateKeywordValue);
        TextSpan firstPart = TextSpan(
            text: message.substring(0, indexOfKeywordValue),
            style: AppTextStyles.regularPrimary(isOutFit: false, color: AppColors.colorPrimaryNeutralText));
        TextSpan coloredPart = TextSpan(
            text: updateKeywordValue,
            style: AppTextStyles.regularPrimary(
                isOutFit: false, color: AppColors.colorPrimaryAccent));
        TextSpan lastPart = TextSpan(
            text: message.substring(indexOfKeywordValue + updateKeywordValue.length),
            style: AppTextStyles.regularPrimary(isOutFit: false, color: AppColors.colorPrimaryNeutralText));
        TextSpan finalText =
            TextSpan(children: [firstPart, coloredPart, lastPart]);
        return RichText(text: finalText);
      }else{
        return Text(fullMessage,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.regularPrimary(isOutFit: false,  color: AppColors.colorPrimaryNeutralText));
      }
    }
    else {
      return Text(fullMessage,
          style: AppTextStyles.regularPrimary(isOutFit: false, color: AppColors.colorPrimaryNeutralText));
    }
  }
}
