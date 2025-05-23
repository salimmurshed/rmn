import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rmnevents/imports/common.dart';
import 'package:rmnevents/presentation/staff_chat/user_chat_list/bloc/user_chat_list_bloc.dart';
import 'package:rmnevents/presentation/staff_chat/user_chat_list/page/user_chat_list_view.dart';

import '../../../../root_app.dart';
import '../../../notification/bloc/notification_bloc.dart';
import '../bloc/staff_chat_bloc.dart';
import '../widget/build_event_chat_container.dart';

class StaffChatView extends StatefulWidget {
  const StaffChatView({super.key});

  @override
  State<StaffChatView> createState() => _StaffChatViewState();
}

class _StaffChatViewState extends State<StaffChatView> {
  // Local page controller
  late StaffChatBloc _chatBloc;

  @override
  void initState() {
    BlocProvider.of<StaffChatBloc>(context).add(
      const TriggerPickDivision(divIndex: 0),
    );
    _chatBloc = BlocProvider.of<StaffChatBloc>(context);
    _chatBloc.initSocket();
    super.initState(); // Initialize PageController
  }

  @override
  dispose() {
    //_chatBloc.add(TiriggerDisconnectSocket());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StaffChatBloc, StaffChatState>(
      listener: (context, state) {
        if (state.message.isNotEmpty && !state.isLoading) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: BlocBuilder<StaffChatBloc, StaffChatState>(
        builder: (context, state) {
          return customScaffold(
            customAppBar: CustomAppBar(
                title: AppStrings.staff_chat_title, isLeadingPresent: false),
            hasForm: false,
            formOrColumnInsideSingleChildScrollView: null,
            anyWidgetWithoutSingleChildScrollView: Column(
              children: [
                buildTabBar(state),
                Expanded(
                  child: PageView(
                    controller: state.pageController, // Local page controller
                    onPageChanged: (index) {
                      if (index != state.selectedTabIndex) {
                        BlocProvider.of<StaffChatBloc>(context)
                            .add(TriggerPickDivision(divIndex: index));
                      }
                    },
                    children: [
                      buildEventChatList(state),
                      const UserChatListView(eventId: '')
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildEventChatList(StaffChatState state) {
    return Stack(
      children: [
        customBuildSearchAndFilterButton(
          isFilterAvailable: false,
          formKey: state.formKey,
          searchFunction: () {
            setState(() {
              BlocProvider.of<StaffChatBloc>(context).add(
                  TriggerSearchEvent(searchText: state.searchController.text));
            });
          },
          eraserFunction: () {
            print('erase');
          },
          isFilterOn: false,
          onChangeSearchFunction: (value) {
            setState(() {
              BlocProvider.of<StaffChatBloc>(context)
                  .add(TriggerSearchEvent(searchText: value));
            });
          },
          filterOnFunction: () {},
          searchController: state.searchController,
          focusNode: state.focusNode,
          showEraser: state.showEraser,
        ),
        Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<StaffChatBloc>(context)
                  .add(TriggerRefreshDataOfEvent());
            },
            child: state.isLoading
                ? CustomLoader(child: const Center())
                : ListView.separated(
                    itemCount: state.eventListResponseData?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final eventData =
                          state.eventListResponseData?.data?[index];
                      final imageBaseUrl =
                          state.eventListResponseData?.assetsUrl ?? '';
                      return GestureDetector(
                          onTap: () {
                            BlocProvider.of<UserChatListBloc>(context)
                                .add(TriggerAddClearData());
                            BlocProvider.of<StaffChatBloc>(context).add(
                                TriggerMoveToEventChatList(
                                    eventId: state.eventListResponseData
                                            ?.data?[index].id ??
                                        '',
                                    coverImage: imageBaseUrl +
                                        (state.eventListResponseData
                                                ?.data?[index].coverImage ??
                                            '')));
                          },
                          child: buildEventChatCard(
                              eventData: eventData, baseUrl: imageBaseUrl));
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                          height: 10); // Space of 10 between list items
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildTabBar(StaffChatState state) {
    return BlocBuilder<StaffChatBloc, StaffChatState>(
      builder: (context, state) {
        return buildCustomTabBar(
          isScrollRequired: false,
          isRequestTab: true,
          tabElements: [
            TabElements(
              title: state.tabs[0],
              onTap: () {
                if (state.pageController.page != 0) {
                  state.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    // Smooth duration
                    curve: Curves.easeInOut, // Smooth curve
                  );
                  BlocProvider.of<StaffChatBloc>(context).add(
                    const TriggerPickDivision(divIndex: 0),
                  );
                }
              },
              isSelected: state.selectedTabIndex == 0 ? true : false,
            ),
            TabElements(
              title: state.tabs[1],
              onTap: () {
                setState(() {
                  if (state.pageController.page != 1) {
                    state.pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      // Smooth duration
                      curve: Curves.easeInOut, // Smooth curve
                    );
                    BlocProvider.of<StaffChatBloc>(context).add(
                      const TriggerPickDivision(divIndex: 1),
                    );
                  }
                });
                state.focusNode.unfocus();
              },
              isSelected: state.selectedTabIndex == 1 ? true : false,
            ),
          ],
        );
      },
    );
  }
}
