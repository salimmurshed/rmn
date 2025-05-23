import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../imports/common.dart';
import '../bloc/event_details_bloc.dart';

class ScheduleTab extends StatefulWidget {
  final String scheduleOverView;
  final List<ScheduleGroupedList> schedules;
  final void Function(bool, int) onExpansionChanged;

  bool isShorten;

  ScheduleTab({
    super.key,
    required this.scheduleOverView,
    required this.schedules,
    this.isShorten = false,
    required this.onExpansionChanged,
  });

  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  ScrollController scrollController = ScrollController();

  @override
  // void initState() {
  //   scrollController.addListener(() {
  //     if (scrollController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       setState(() {
  //         widget.isShorten = true;
  //       });
  //     } else {
  //       setState(() {
  //         widget.isShorten = false;
  //         scrollController.animateTo(0,
  //             duration: const Duration(milliseconds: 200), curve: Curves.ease);
  //       });
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      shrinkWrap: true,
      physics: widget.isShorten
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.generalGapSmall),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.colorSecondary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: buildHtmlWidget(
                    text: widget.scheduleOverView,
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.generalGapSmall),
                child: Column(
                  children: [
                    Text(widget.schedules[index].day,
                        style: AppTextStyles.smallTitle(
                            color: AppColors.colorPrimaryAccent)),
                    Text(widget.schedules[index].monthDate,
                        style: AppTextStyles.smallTitle()),
                    SizedBox(height: 10.h),
                    ...widget.schedules[index].schedules.map((schedule) =>
                        Column(
                          children: [
                            customRegularExpansionTile(
                              isNumZero: true,
                              isParent: true,
                              isSmall: true,
                              isBackDropDarker: false,
                              leading: SizedBox(
                                width: 15.w,
                              ),
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          schedule.description!,
                                          textAlign: TextAlign.left,
                                          maxLines: 20,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.normalNeutral(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                              onExpansionChanged: (val) {
                                setState(() {
                                  schedule.isExpanded = val;
                                  // widget.onExpansionChanged(val, index);
                                });
                              },
                              isExpansionTileOpened: schedule.isExpanded!,
                              title: schedule.title!,
                            ),
                            SizedBox(height: 10.h),
                            // Add spacing between items
                          ],
                        )),
                  ],
                ),
              );
            },
            childCount: widget.schedules.length,
          ),
        ),
      ],
    );
  }
}
