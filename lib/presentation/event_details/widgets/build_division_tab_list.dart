import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/data/models/response_models/event_details_response_model.dart';

import '../../../imports/common.dart';

class DivisionTabList extends StatefulWidget {
  final bool isSmall;
  bool isShorten;
  final void Function(int, bool) onExpansionChangedParent;
  final void Function(int, int, bool) onExpansionChangedChild;
  final List<DivisionTypes> divisionsTypes;

  DivisionTabList({
    super.key,
    this.isSmall = false,
    this.isShorten = false,
    required this.onExpansionChangedParent,
    required this.onExpansionChangedChild,
    required this.divisionsTypes,
  });

  @override
  _DivisionTabListState createState() => _DivisionTabListState();
}

class _DivisionTabListState extends State<DivisionTabList> {
  ScrollController scrollController = ScrollController();

  // @override
  // initState() {
  //   scrollController.addListener(() {
  //     if (scrollController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       setState(() {
  //         widget.isShorten = true;
  //       });
  //     } else {
  //       setState(() {
  //         widget.isShorten = false;
  //         scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
  //       });
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      shrinkWrap: true,
      physics: widget.isShorten? const AlwaysScrollableScrollPhysics() : const
      NeverScrollableScrollPhysics(),
      itemBuilder: (context, divisionIndex) {
        return customRegularExpansionTile(
          isSmall: widget.isSmall,
          isParent: true,
          isAppSettingsView: false,
          isBackDropDarker: true,
          isNumZero: widget.divisionsTypes[divisionIndex]
                  .numberOfSelectedRegisteredAthlete ==
              0,
          children: [
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, childIndex) {
                return customRegularExpansionTile(
                  isSmall: widget.isSmall,
                  isParent: false,
                  isNumZero: widget.divisionsTypes[divisionIndex]
                      .ageGroups![childIndex].athletes!.isEmpty,
                  leading: buildLeadingForDivisionTile(
                    isSmall: widget.isSmall,
                    isParent: false,
                    isExpanded: widget.divisionsTypes[divisionIndex]
                        .ageGroups![childIndex].isExpanded!,
                    number: widget
                        .divisionsTypes[divisionIndex]
                        .ageGroups![childIndex]
                        .registeredAthletesForCount!
                        .length,
                  ),
                  isAppSettingsView: false,
                  isBackDropDarker: false,
                  children: [
                    SizedBox(
                      width: Dimensions.getScreenWidth(),
                      child: Wrap(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 0;
                              i <
                                  widget
                                      .divisionsTypes[divisionIndex]
                                      .ageGroups![childIndex]
                                      .ageGroupWithWeightsJoined!
                                      .split(', ')
                                      .length;
                              i++)
                            IntrinsicHeight(
                              child: Text(
                                i <
                                        widget
                                                .divisionsTypes[divisionIndex]
                                                .ageGroups![childIndex]
                                                .ageGroupWithWeightsJoined!
                                                .split(', ')
                                                .length -
                                            1
                                    ? '${widget.divisionsTypes[divisionIndex].ageGroups![childIndex].ageGroupWithWeightsJoined!.split(', ')[i]}, '
                                    : widget
                                        .divisionsTypes[divisionIndex]
                                        .ageGroups![childIndex]
                                        .ageGroupWithWeightsJoined!
                                        .split(', ')[i],
                                textAlign: TextAlign.left,
                                maxLines: 20,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.regularNeutralOrAccented(
                                  color:
                                  // widget
                                  //         .divisionsTypes[divisionIndex]
                                  //         .ageGroups![childIndex]
                                  //         .registeredWeights!
                                  //         .contains(widget
                                  //             .divisionsTypes[divisionIndex]
                                  //             .ageGroups![childIndex]
                                  //             .ageGroupWithWeightsJoined!
                                  //             .split(', ')[i])
                                  //     ? AppColors.colorPrimaryAccent
                                  //     :
                                  AppColors.colorPrimaryInverseText,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  onExpansionChanged: (value) {
                    widget.onExpansionChangedChild(
                        divisionIndex, childIndex, value);
                  },
                  isExpansionTileOpened: widget.divisionsTypes[divisionIndex]
                      .ageGroups![childIndex].isExpanded!,
                  title: widget.divisionsTypes[divisionIndex]
                      .ageGroups![childIndex].title!,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10.h);
              },
              itemCount:
                  widget.divisionsTypes[divisionIndex].ageGroups!.length,
            ),
          ],
          onExpansionChanged: (value) {
            widget.onExpansionChangedParent(divisionIndex, value);
          },
          leading: buildLeadingForDivisionTile(
            isSmall: widget.isSmall,
            isParent: true,
            isExpanded: widget.divisionsTypes[divisionIndex].isExpanded!,
            number: widget.divisionsTypes[divisionIndex]
                    .numberOfSelectedRegisteredAthlete! +
                widget.divisionsTypes[divisionIndex].ageGroups!.fold<int>(
                    0,
                    (previousValue, element) =>
                        previousValue +
                        element.registeredAthletesForCount!.length),
          ),
          isExpansionTileOpened:
              widget.divisionsTypes[divisionIndex].isExpanded!,
          title: widget.divisionsTypes[divisionIndex].divisionType!,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10.h);
      },
      itemCount: widget.divisionsTypes.length,
    );
  }
}
