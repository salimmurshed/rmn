import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/data/models/response_models/event_list_chat.dart';
import 'package:rmnevents/imports/common.dart';


Widget buildEventChatCard({EventListEventData? eventData, String? baseUrl}) {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.colorTertiary,
        borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                height: 68.0,
                width: 68.0,
                imageUrl: '$baseUrl${eventData?.coverImage ?? ''}',
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded( // Ensures text does not overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    eventData?.title ?? '',
                    style: AppTextStyles.smallTitle(
                      isOutFit: false,
                      isLinedThrough: false,
                      isBold: false,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Text(
                      'Number of Chats',
                      style: AppTextStyles.regularForMap(
                          color: AppColors.colorPrimaryNeutralText,
                          isBold: false),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      eventData!.totalChats.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                        color: AppColors.colorPrimaryInverse,
                        fontFamily: AppFontFamilies.outfit,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    children: [
                      if (eventData.totalChats != 0)...[
                        Text(
                          'Last Message Received',
                          style: AppTextStyles.regularForMap(
                              color: AppColors.colorPrimaryNeutralText,
                              isBold: false),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          DateFunctions.formatChatTimestamp(DateTime.parse(eventData.messageTime ?? '')),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                            color: AppColors.colorPrimaryInverse,
                            fontFamily: AppFontFamilies.outfit,
                          ),
                        ),
                      ]else...[
                        Text('No messages received yet.', style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                          color: AppColors.colorPrimaryInverse,
                          fontFamily: AppFontFamilies.outfit,
                        ))
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ), // Pushes the unread count widget to the right
          if (eventData.unreadCount?.toInt() != 0)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 26.0,
                width: 26.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.colorPrimaryAccent,
                ),
                child: Center(
                  child: Text(
                    eventData.unreadCount.toString(),
                    style: TextStyle(
                      fontFamily: AppFontFamilies.outfit,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorPrimaryInverse,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

