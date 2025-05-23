

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/common.dart';

import '../../../../data/models/response_models/general_chat_list_response_model.dart';



class BuildGeneralChatContainer extends StatefulWidget {
  final GeneralChatData chatData;
  final String? imageBaseUrl;
  final Function() onTap;
  const BuildGeneralChatContainer({super.key, required this.chatData, this.imageBaseUrl, required this.onTap});

  @override
  State<BuildGeneralChatContainer> createState() => _BuildGeneralChatContainerState();
}

class _BuildGeneralChatContainerState extends State<BuildGeneralChatContainer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: (){
          widget.onTap();
        },
        child: Container(
            decoration: BoxDecoration(
              color: AppColors.colorTertiary,
              borderRadius: BorderRadius.circular(Dimensions.generalSmallRadius),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      height: 64.0, // Set height
                      width: 64.0,  // Set width to the same value
                      imageUrl: widget.chatData.user!.profile!.contains('http') ? widget.chatData.user!.profile! : '${widget.imageBaseUrl}${widget.chatData.user?.profile ?? ''}',
                      fit: BoxFit.cover, // Ensures the image covers the circular area
                      placeholder: (context, url) => const CircularProgressIndicator(), // Optional: Placeholder while loading
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.chatData.user?.firstName ?? ''} ${widget.chatData.user?.lastName ?? ''}',
                      style: AppTextStyles.landingTitle(fontSize: 18, fontWeight: AppFontWeight.titleLargeWeightedSquada),
                    ),
                    SizedBox(height: 4.h), // Adds spacing
                    SizedBox(
                      width: 150.w, // Add fixed width if needed, or use Expanded
                      child: Text(
                        widget.chatData.lastMessage ?? '',
                        style: AppTextStyles.regularPrimary(isBold: false, isOutFit: true),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(DateFunctions.formatChatTimestamp(DateTime.parse(widget.chatData.messageTime ?? '')), style: AppTextStyles.smallTitle(isBold: false, isOutFit: true, fontSize: AppFontSizes.component),),
                      if (widget.chatData.unreadCount != 0)...[
                        const SizedBox(height: 5),
                        Container(
                          height: 24.h,
                          width: 24.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.colorPrimaryAccent
                          ),
                          child: Center(child: Text(widget.chatData.unreadCount.toString(), style: AppTextStyles.componentLabels(),)),
                        ),
                      ]
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
