// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rmnevents/data/models/response_models/event_details_response_model.dart';
// import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
// import 'package:rmnevents/root_app.dart';
//
// import '../../../data/models/response_models/registration_list_model.dart';
// import '../../../imports/common.dart';
// import '../../my_athletes/widgets/build_search_section.dart';
//
// Widget buildHTMLTabView(
//     {required String text,
//     RegistrationTab? registrationTabList,
//     required EventDetailsWithInitialState state,
//     required EventDetailTab eventDetailTab,
//     bool isBottomPaddingNeeded = false}) {
//   return text.isEmpty
//       ? Padding(
//           padding: EdgeInsets.only(
//               left: 25.w,
//               right: 10.w,
//               bottom: isBottomPaddingNeeded ? 10.h : 0.0),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: Dimensions.getScreenHeight() * 0.12,
//               ),
//               if (eventDetailTab != EventDetailTab.registration)
//                 Center(
//                   child: Container(
//                     width: Dimensions.getScreenWidth() * 0.7,
//                     child: Text(
//                       eventDetailTab == EventDetailTab.eventInformation
//                           ? AppStrings.eventDetailView_information_empty
//                           : AppStrings.eventDetailView_divisionsTab_empty,
//                       style: AppTextStyles.smallTitleForEmptyList(),
//                     ),
//                   ),
//                 ),
//               if (eventDetailTab == EventDetailTab.registration)
//                 Center(
//                   child: Container(
//                     width: Dimensions.getScreenWidth() * 0.7,
//                     child: Column(
//                       children: [
//                         Text(
//                           AppStrings.eventDetailView_registrationListTab_empty,
//                           style: AppTextStyles.smallTitleForEmptyList(),
//                         ),
//                         Text(
//                           AppStrings
//                               .eventDetailView_registrationListSubTab_empty,
//                           style: AppTextStyles.subtitle(isOutFit: false),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         )
//       : StatefulBuilder(builder: (context, setState) {
//         bool showSearchIcon = false;
//           return Expanded(
//             child: ListView(
//               padding: EdgeInsets.only(
//                   left: 20.w,
//                   right: 20.w,
//                   bottom: isBottomPaddingNeeded ? 10.h : 0.0),
//               children: [
//                 if (eventDetailTab == EventDetailTab.registration) ...[
//                   buildHtmlWidget(
//                       text: registrationTabList?.title ??
//                           AppStrings.global_empty_string),
//                   buildHtmlWidget(
//                       text: registrationTabList?.description ??
//                           AppStrings.global_empty_string),
//                   if (registrationTabList!.isAvailable!) ...[
//                     SizedBox(height: 10.h),
//                     buildSearchSection(
//                       showSearchIcon: true,
//                       searchText: state.searchController.text,
//                       searchController: state.searchController,
//                       searchFocusNode: state.focusNode,
//                       onFieldSubmitted: (value) {
//                         BlocProvider.of<EventDetailsBloc>(
//                                 navigatorKey.currentContext!)
//                             .add(TriggerOnChangeSearchEvent(
//                                 searchValue: state.searchController.text));
//                       },
//                       onChanged: (value) {
//                         // setState(() {
//                         //   showSearchIcon = value.isNotEmpty;
//                         // });
//                       },
//                       onTapToSearch:  () {
//                               BlocProvider.of<EventDetailsBloc>(
//                                       navigatorKey.currentContext!)
//                                   .add(TriggerOnChangeSearchEvent(
//                                       searchValue:
//                                           state.searchController.text));
//                               FocusManager.instance.primaryFocus?.unfocus();
//                             }
//                           ,
//                       onTapToEraseSearchText:
//                           state.searchController.text.isNotEmpty
//                               ? () {
//                                   BlocProvider.of<EventDetailsBloc>(
//                                           navigatorKey.currentContext!)
//                                       .add(const TriggerEraseSearchValue());
//                                 }
//                               : () {},
//                     ),
//                     // buildCustomEventSearchField(
//                     //   focusNode: state.focusNode,
//                     //   searchFunction: () {
//                     //     BlocProvider.of<EventDetailsBloc>(
//                     //             navigatorKey.currentContext!)
//                     //         .add(TriggerSearchReg(
//                     //             searchValue: state.searchController.text));
//                     //   },
//                     //   onChangeSearchFunction: (value) {
//                     //     BlocProvider.of<EventDetailsBloc>(
//                     //             navigatorKey.currentContext!)
//                     //         .add(TriggerOnChangeSearchEvent(searchValue: value));
//                     //   },
//                     //   eraserFunction: () {
//                     //     BlocProvider.of<EventDetailsBloc>(
//                     //             navigatorKey.currentContext!)
//                     //         .add(const TriggerEraseSearchValue());
//                     //   },
//                     //   showEraser: state.showEraser,
//                     //   searchController: state.searchController,
//                     // ),
//                     if (state.searchController.text.isNotEmpty) ...[
//                       SizedBox(
//                         height: Dimensions.getScreenHeight(),
//                         child: state.searchedData.isNotEmpty
//                             ? SingleChildScrollView(
//                                 padding: EdgeInsets.only(top: 20.h),
//                                 scrollDirection: Axis.horizontal,
//                                 child: SingleChildScrollView(
//                                   child: DataTable(
//                                     border: TableBorder.all(
//                                         color: AppColors.colorPrimaryNeutral),
//                                     columns: buildDataColumns(),
//                                     rows:
//                                         state.searchedData.map((registration) {
//                                       return buildDataRow(registration);
//                                     }).toList(),
//                                   ),
//                                 ),
//                               )
//                             : Column(
//                                 children: [
//                                   SizedBox(
//                                     height: Dimensions.getScreenHeight() * 0.15,
//                                   ),
//                                   Center(
//                                     child: Text(
//                                       'No match found.',
//                                       style: AppTextStyles
//                                           .smallTitleForEmptyList(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                       )
//                     ] else ...[
//                       if (state.data.isNotEmpty)
//                         SizedBox(
//                           height: Dimensions.getScreenHeight(),
//                           child: SingleChildScrollView(
//                             padding: EdgeInsets.only(top: 20.h),
//                             scrollDirection: Axis.horizontal,
//                             child: SingleChildScrollView(
//                               child: DataTable(
//                                 border: TableBorder.all(
//                                     color: AppColors.colorPrimaryNeutral),
//                                 columns: buildDataColumns(),
//                                 rows: state.data.map((registration) {
//                                   return buildDataRow(registration);
//                                 }).toList(),
//                               ),
//                             ),
//                           ),
//                         )
//                     ],
//                   ]
//                 ] else ...[
//                   buildHtmlWidget(text: text),
//                 ]
//               ],
//             ),
//           );
//         });
// }
//
// DataRow buildDataRow(RegistrationListData registration) {
//   return DataRow(
//     cells: [
//       buildDataCell(
//         registration.firstName!,
//       ),
//       buildDataCell(
//         registration.lastName!,
//       ),
//       buildDataCell(
//         registration.team!,
//       ),
//       buildDataCell(
//         registration.state!,
//       ),
//       buildDataCell(
//         registration.style!,
//       ),
//       buildDataCell(
//         registration.division!,
//       ),
//       buildDataCell(
//         registration.weightClass!,
//       ),
//     ],
//   );
// }
//
// DataCell buildDataCell(String title) {
//   return DataCell(Text(
//     title,
//     style: AppTextStyles.regularNeutralOrAccented(),
//   ));
// }
//
// List<DataColumn> buildDataColumns() {
//   return [
//     buildDataColumn('First Name'),
//     buildDataColumn('Last Name'),
//     buildDataColumn('Team'),
//     buildDataColumn('State'),
//     buildDataColumn('Style'),
//     buildDataColumn('Division'),
//     buildDataColumn(
//       'Weight Class',
//     ),
//   ];
// }
//
// DataColumn buildDataColumn(String title) {
//   return DataColumn(
//       label: Text(
//     title,
//     style: AppTextStyles.regularNeutralOrAccented(),
//   ));
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/data/models/response_models/event_details_response_model.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:rmnevents/root_app.dart';

import '../../../data/models/response_models/registration_list_model.dart';
import '../../../imports/common.dart';
import '../../my_athletes/widgets/build_search_section.dart';

class HTMLTabView extends StatefulWidget {
  final String text;
  final RegistrationTab? registrationTabList;
  final EventDetailsWithInitialState state;
  final EventDetailTab eventDetailTab;
  final bool isBottomPaddingNeeded;
  bool isShorten;
  bool isRegistrationAvailable = true;

  HTMLTabView({
    required this.text,
    this.registrationTabList,
    required this.state,
    required this.eventDetailTab,
    this.isBottomPaddingNeeded = false,
    this.isShorten = false,
    this.isRegistrationAvailable = false,
    super.key,
  });

  @override
  _HTMLTabViewState createState() => _HTMLTabViewState();
}

class _HTMLTabViewState extends State<HTMLTabView> {
  ScrollController scrollController = ScrollController();
  @override
  // initState() {
  //   scrollController.addListener((){
  //     if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
  //       setState(() {
  //         widget.isShorten = true;
  //       });
  //   }
  //     else{
  //       setState(() {
  //         widget.isShorten = false;
  //         scrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.ease);
  //       });
  //     }
  //   }
  //
  //   );
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {

    return widget.text.isEmpty
        ? Padding(
            padding: EdgeInsets.only(
                left: 25.w,
                right: 10.w,
                bottom: widget.isBottomPaddingNeeded ? 10.h : 0.0),
            child: Column(
              children: [
                SizedBox(
                  height: Dimensions.getScreenHeight() * 0.12,
                ),
                if (widget.eventDetailTab != EventDetailTab.registration)
                  Center(
                    child: SizedBox(
                      width: Dimensions.getScreenWidth() * 0.7,
                      child: Text(
                        widget.eventDetailTab == EventDetailTab.eventInformation
                            ? AppStrings.eventDetailView_information_empty
                            : AppStrings.eventDetailView_divisionsTab_empty,
                        style: AppTextStyles.smallTitleForEmptyList(),
                      ),
                    ),
                  ),
                if (widget.eventDetailTab == EventDetailTab.registration)
                  Center(
                    child: SizedBox(
                      width: Dimensions.getScreenWidth() * 0.7,
                      child: Column(
                        children: [
                          Text(
                            AppStrings
                                .eventDetailView_registrationListTab_empty,
                            style: AppTextStyles.smallTitleForEmptyList(),
                          ),
                          Text(
                            AppStrings
                                .eventDetailView_registrationListSubTab_empty,
                            style: AppTextStyles.subtitle(isOutFit: false),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )
        : Flex(
          direction:Axis.vertical,
          children: [
            ListView.builder(
              controller: scrollController,
              physics: widget.isShorten
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  bottom: widget.isBottomPaddingNeeded ? 10.h : 0.0),
              itemBuilder: (context, index) {
                return widget.eventDetailTab == EventDetailTab.registration
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    if (widget.eventDetailTab == EventDetailTab.registration) ...[
                      buildHtmlWidget(
                          text: widget.registrationTabList?.title ??
                              AppStrings.global_empty_string),
                      buildHtmlWidget(
                          text: widget.registrationTabList?.description ??
                              AppStrings.global_empty_string),
                      if (widget.registrationTabList!.isAvailable!) ...[
                        SizedBox(height: 10.h),
                        buildSearchSection(
                          showSearchIcon: true,
                          searchText: widget.state.searchController.text,
                          searchController: widget.state.searchController,
                          searchFocusNode: widget.state.focusNode,
                          onFieldSubmitted: (value) {
                            BlocProvider.of<EventDetailsBloc>(
                                navigatorKey.currentContext!)
                                .add(TriggerOnChangeSearchEvent(
                                searchValue:
                                widget.state.searchController.text));
                          },
                          onChanged: (value) {},
                          onTapToSearch: () {
                            BlocProvider.of<EventDetailsBloc>(
                                navigatorKey.currentContext!)
                                .add(TriggerOnChangeSearchEvent(
                                searchValue:
                                widget.state.searchController.text));
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onTapToEraseSearchText:
                          widget.state.searchController.text.isNotEmpty
                              ? () {
                            BlocProvider.of<EventDetailsBloc>(
                                navigatorKey.currentContext!)
                                .add(const TriggerEraseSearchValue());
                          }
                              : () {},
                        ),
                        if (widget.state.searchController.text.isNotEmpty) ...[
                          SizedBox(
                            height: Dimensions.getScreenHeight(),
                            child: widget.state.searchedData.isNotEmpty
                                ? SingleChildScrollView(
                              padding: EdgeInsets.only(top: 20.h),
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: DataTable(
                                  border: TableBorder.all(
                                      color: AppColors.colorPrimaryNeutral),
                                  columns: buildDataColumns(),
                                  rows: widget.state.searchedData
                                      .map((registration) {
                                    return buildDataRow(registration);
                                  }).toList(),
                                ),
                              ),
                            )
                                : Column(
                              children: [
                                SizedBox(
                                  height: Dimensions.getScreenHeight() * 0.15,
                                ),
                                Center(
                                  child: Text(
                                    'No match found.',
                                    style: AppTextStyles
                                        .smallTitleForEmptyList(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ] else ...[
                          if (widget.state.data.isNotEmpty)
                            SingleChildScrollView(
                              padding: EdgeInsets.only(top: 20.h, ),
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: DataTable(
                                  border: TableBorder.all(
                                      color: AppColors.colorPrimaryNeutral),
                                  columns: buildDataColumns(),
                                  rows: widget.state.data.map((registration) {
                                    return buildDataRow(registration);
                                  }).toList(),
                                ),
                              ),
                            )
                        ],
                      ]
                    ]
                    else ...[
                      buildHtmlWidget(text: widget.text),
                    ]
                  ],)
                    : buildHtmlWidget(text: widget.text);
              },
            ),
          ],
        );
  }
}

DataRow buildDataRow(RegistrationListData registration) {
  return DataRow(
    cells: [
      buildDataCell(StringManipulation.capitalizeTheInitial(value: registration.firstName!)),
      buildDataCell(StringManipulation.capitalizeTheInitial(value: registration.lastName!)),
      buildDataCell(StringManipulation.capitalizeTheInitial(value: registration.team!)),
      buildDataCell(StringManipulation.capitalizeTheInitial(value: registration.state!)),
      buildDataCell(StringManipulation.capitalizeFirstLetterOfEachWord(value: registration.style!)),
      buildDataCell(StringManipulation.capitalizeFirstLetterOfEachWord(value: registration.division!)),
      buildDataCell(registration.weightClass!),
    ],
  );
}

DataCell buildDataCell(String title) {
  return DataCell(Text(
    title,
    style: AppTextStyles.regularNeutralOrAccented(),
  ));
}

List<DataColumn> buildDataColumns() {
  return [
    buildDataColumn('First Name'),
    buildDataColumn('Last Name'),
    buildDataColumn('Team'),
    buildDataColumn('State'),
    buildDataColumn('Style'),
    buildDataColumn('Division'),
    buildDataColumn('Weight Class'),
  ];
}

DataColumn buildDataColumn(String title) {
  return DataColumn(
      label: Text(
    title,
    style: AppTextStyles.regularNeutralOrAccented(),
  ));
}
