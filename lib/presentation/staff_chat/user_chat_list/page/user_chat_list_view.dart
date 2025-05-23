import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:paginable/paginable.dart';

import '../../../../common/resources/app_assets.dart';
import '../../../../common/resources/app_colors.dart';
import '../../../../common/resources/app_enums.dart';
import '../../../../common/resources/app_routes.dart';
import '../../../../common/resources/app_strings.dart';
import '../../../../common/resources/app_text_styles.dart';
import '../../../../common/widgets/bottomsheets/bottom_sheet_with_body_text.dart';
import '../../../../common/widgets/loader/custom_loader.dart';
import '../../../../common/widgets/toast/custom_toast.dart';
import '../../../../data/models/arguments/chat_arguments.dart';
import '../../../../data/models/response_models/general_chat_list_response_model.dart';
import '../../event_general_view/widget/bild_catagory_for_chat.dart';
import '../../event_general_view/widget/build_empty_list_message.dart';
import '../../event_general_view/widget/build_general_chat_container.dart';
import '../../event_general_view/widget/build_unarchive_all_view.dart';
import '../../event_general_view/widget/slidable_widget/src/action_pane_motions.dart';
import '../../event_general_view/widget/slidable_widget/src/actions.dart';
import '../../event_general_view/widget/slidable_widget/src/slidable.dart';
import '../bloc/user_chat_list_bloc.dart';

class UserChatListView extends StatefulWidget {
  final String eventId; // Use 'final' here
  const UserChatListView({super.key, required this.eventId});

  @override
  State<UserChatListView> createState() => _UserChatListViewState();
}

class _UserChatListViewState extends State<UserChatListView> {
  late UserChatListBloc _chatBloc;

  @override
  void initState() {
    final myBloc = context.read<UserChatListBloc>();
    final currentState = myBloc.state;
    BlocProvider.of<UserChatListBloc>(context).add(TriggerAssignDataToState(eventId: widget.eventId));
    BlocProvider.of<UserChatListBloc>(context).add(TriggerFetchChatList(
        page: 1,
        status: currentState.selectedCatagory,
        isRefreshRequeired: true));

    _chatBloc = BlocProvider.of<UserChatListBloc>(context);
    _chatBloc.initSocket(widget.eventId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<UserChatListBloc, UserChatListState>(
      listener: (context, state) {
        if (state.message.isNotEmpty && !state.isLoading) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
        if (state.shouldUndoVisible ?? true && state.selectedCatagory == ChatType.All) {
          showPersistentBottomSheet(context, state);
        }
      },
      child: BlocBuilder<UserChatListBloc, UserChatListState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ChatTypeView(
                  categories: state.chatCatagories,
                  archivedCount: state.archiveCount ?? 0,
                  unreadCount: state.unreadCount ?? 0,
                  selectedCatagory: state.selectedCatagory == ChatType.All
                      ? 0
                      : state.selectedCatagory == ChatType.Unread
                          ? 1
                          : 2,
                  onTabSelected: (type) {
                    if (!state.isLoading) {
                      BlocProvider.of<UserChatListBloc>(context).add(
                          TriggerChangeFillter(
                              selectedType: type));
                    }

                  },
                ),
              ),
              if (state.selectedCatagory == ChatType.Archived &&
                  state.chatListData!.generalChatData!.isNotEmpty &&
                  !state.isLoading)
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: SizedBox(
                    child: BuildUnArchivedAll(
                      isUndo: true,
                      onUnarchiveAll: () {
                        BlocProvider.of<UserChatListBloc>(context)
                            .add(TriggerUnArchivedAll());
                      },
                    ),
                  ),
                ),
              state.isLoading
                  ? Flexible(child: CustomLoader(child: const Center()))
                  : state.chatListData?.generalChatData?.isNotEmpty ?? false
                      ? Flexible(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              BlocProvider.of<UserChatListBloc>(context).add(
                                  TriggerRefreshData());
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              itemCount:
                                  state.chatListData?.generalChatData?.length ??
                                      0,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if(index == (state.chatListData?.generalChatData?.length ?? 0) - 1 && !state.isLoadingMore && state.chatListData!.page! < (state.chatListData!.totalPage ?? 0)){
                                  BlocProvider.of<UserChatListBloc>(context).add(
                                           TriggerPagginationForGenralChatList());
                                  return  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: CircularProgressIndicator(
                                      color: AppColors.colorPrimaryAccent,
                                    )),
                                  );
                                }
                                final chatData =
                                    state.chatListData?.generalChatData?[index];
                                final imageBaseUrl =
                                    state.chatListData?.assetsUrl ?? '';
                                return Slidable(
                                  key: ValueKey(chatData?.id ?? index),
                                  // Ensure a unique key for each item
                                  direction: Axis.horizontal,
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        flex: 1,
                                        padding: const EdgeInsets.all(0),
                                        onPressed: (context) {
                                          final navigator =
                                              Navigator.of(context);
                                          final staffChatBloc =
                                              BlocProvider.of<UserChatListBloc>(
                                                  context);
                                          buildBottomSheetWithBodyText(
                                            context: context,
                                            title: AppStrings
                                                .bottomSheet_delete_chat_title,
                                            subtitle: AppStrings
                                                .bottomSheet_delete_chat_subTitle,
                                            isSingeButtonPresent: false,
                                            leftButtonText: AppStrings.btn_yes,
                                            rightButtonText: AppStrings.btn_no,
                                            onLeftButtonPressed: () {
                                              staffChatBloc.add(
                                                TriggerGeneralChatDelete(
                                                    roomId:
                                                        chatData?.roomId ?? ''),
                                              );
                                              navigator.pop();
                                            },
                                            onRightButtonPressed: () {
                                              navigator.pop();
                                            },
                                          );
                                        },
                                        backgroundColor:
                                            AppColors.colorPrimaryAccent,
                                        icon: AppAssets.icDelete,
                                        label: Text('Delete',
                                            style:
                                                AppTextStyles.componentLabels(
                                                    isOutFit: true)),
                                      ),
                                      SlidableAction(
                                        flex: 1,
                                        padding: const EdgeInsets.all(0),
                                        onPressed: (context) {
                                          if (state.selectedCatagory ==
                                              ChatType.Archived) {
                                            setState(() {
                                              BlocProvider.of<UserChatListBloc>(
                                                      context)
                                                  .add(
                                                TriggerUnArchiveOnly(
                                                    roomId:
                                                        chatData?.roomId ?? '',
                                                    shouldRemoveFromList:
                                                        true), // Use chatData?.id or any other identifier
                                              );
                                            });
                                          } else {
                                            if (chatData?.status ==
                                                'archived') {
                                              setState(() {

                                                BlocProvider.of<
                                                            UserChatListBloc>(
                                                        context)
                                                    .add(
                                                  TriggerUnArchiveOnly(
                                                      roomId:
                                                          chatData?.roomId ??
                                                              '',
                                                      shouldRemoveFromList:
                                                          false), // Use chatData?.id or any other identifier
                                                );
                                              });
                                            } else {
                                              setState(() {
                                                BlocProvider.of<
                                                            UserChatListBloc>(
                                                        context)
                                                    .add(
                                                  TriggerAddToArchive(
                                                      roomId: chatData
                                                              ?.roomId ??
                                                          ''), // Use chatData?.id or any other identifier
                                                );
                                              });
                                            }
                                          }
                                        },
                                        backgroundColor:
                                            AppColors.colorSecondaryAccent,
                                        icon: AppAssets.icAchieve,
                                        label: Text(
                                            chatData?.status == 'archived'
                                                ? 'Unarchive'
                                                : 'Achieve',
                                            style:
                                                AppTextStyles.componentLabels(
                                                    isOutFit: true)),
                                      ),
                                    ],
                                  ),
                                  child: BuildGeneralChatContainer(
                                    onTap: () async {
                                      BlocProvider.of<UserChatListBloc>(context)
                                          .add(TriggerUnreadAllMesssage(
                                              index: index));
                                      await Future.delayed(
                                          const Duration(milliseconds: 200));
                                      Navigator.pushNamed(
                                          context, AppRouteNames.routeChat,
                                          arguments: ChatArguments(
                                            eventId: widget.eventId ?? '',
                                            recevierId: chatData?.user?.id ??
                                                state
                                                    .chatListData
                                                    ?.generalChatData?[index]
                                                    .roomId ??
                                                '',
                                            profileImage: chatData!.user!.profile!.contains('http') ? chatData.user!.profile! :
                                                '${state.chatListData?.assetsUrl}${chatData.user?.profile}',
                                            roomId: state
                                                    .chatListData
                                                    ?.generalChatData?[index]
                                                    .roomId ??
                                                '',
                                            isFromDetailView: false,
                                            isForGeneralChat: true,
                                            userName:
                                                '${chatData.user?.firstName ?? ''} ${chatData.user?.lastName ?? ''}',
                                          ));
                                    },
                                    chatData: chatData ?? GeneralChatData(),
                                    imageBaseUrl: imageBaseUrl,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                    height:
                                        10); // Space of 10 between list items
                              },
                            ),
                          ),
                        )
                      : Flexible(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: RefreshIndicator(
                                        onRefresh: () async {
                                          BlocProvider.of<UserChatListBloc>(
                                                  context)
                                              .add(TriggerRefreshData());
                                        },
                                        child: buildEmptyListMessage(
                                            description:
                                                'It looks like there are no conversations yet.'))),
                              ],
                            ),
                          ),
                        ),
            ],
          );
        },
      ),
    );
  }

  void showPersistentBottomSheet(BuildContext context, UserChatListState state) {
    final scaffold = Scaffold.of(context);
    bool isDismissed = false;

    /// ✅ Get controller to track bottom sheet status
    PersistentBottomSheetController controller = scaffold.showBottomSheet(
          (context) => Container(
        height: 110.h,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Center(
          child: BuildUnArchivedAll(
            onUnarchiveAll: () {
              BlocProvider.of<UserChatListBloc>(context).add(
                TriggerUnArchiveOnly(
                  roomId: state.recentlyArchivedChat?.roomId ?? '',
                  shouldRemoveFromList: false,
                ),
              );
              BlocProvider.of<UserChatListBloc>(context).add(
                  TriggerAddbacktoList()
              );
              if (state.selectedCatagory == ChatType.Archived){
                BlocProvider.of<UserChatListBloc>(context).add(
                  TriggerFetchChatList(page: 1, status: ChatType.Archived, isRefreshRequeired: true)
                );
              }
              isDismissed = true;
              Navigator.pop(context); // ✅ Close bottom sheet manually
            },
            isUndo: false,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );

    /// ✅ Listen for bottom sheet being closed (by user or programmatically)
    controller.closed.then((_) {
      isDismissed = true; // ✅ Track dismissal status
    });

    /// ✅ Auto-dismiss after 5 seconds if not manually dismissed
    Future.delayed(const Duration(seconds: 5), () {
      if (!isDismissed) {
        Navigator.pop(context);
      }
    });
  }
}
