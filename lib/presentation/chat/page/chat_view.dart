import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:rmnevents/data/models/response_models/chat_response_model.dart';
import 'package:rmnevents/presentation/base/bloc/base_bloc.dart';
import 'package:rmnevents/presentation/event_details/bloc/event_details_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/arguments/chat_arguments.dart';
import '../../../imports/common.dart';
import '../../../root_app.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/no_support_pop_up_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    required this.arguments,
  });

  final ChatArguments arguments;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatBloc _chatBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  initState() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.add(TriggerOpenChat(roomId: widget.arguments.roomId));
    _chatBloc.initSocket(
        widget.arguments.eventId,
        widget.arguments.roomId,
        widget.arguments.isFromDetailView,
        widget.arguments.isForGeneralChat,
        widget.arguments.isFromPush ?? false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(); // Scroll to bottom on initial load
    });

    super.initState();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  dispose() {
    if (!widget.arguments.isForGeneralChat) {
      socket?.emit('leaveRoom', {"room_id": widget.arguments.roomId});
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatWithInitialState>(
      listener: (context, state) {
        if (state.moveToBottom) {
          Future.delayed(const Duration(milliseconds: 50), () {
            _scrollToBottom();
          });
        }
      },
      child: BlocBuilder<ChatBloc, ChatWithInitialState>(
        builder: (context, state) {
          return state.isLoading
              ? CustomLoader(
                  child: buildChatLayout(context, state),
                )
              : buildChatLayout(context, state);
        },
      ),
    );
  }

  GestureDetector buildChatLayout(
      BuildContext context, ChatWithInitialState state) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.colorPrimary,
        appBar: widget.arguments.isForGeneralChat
            ? CustomAppBar(
                title: widget.arguments.userName,
                isLeadingPresent: true,
                isMoreButtonVisible: false,
                goBack: () {
                  if (widget.arguments.isForGeneralChat) {
                    BlocProvider.of<BaseBloc>(context)
                        .add(TriggergetUnreadCount());
                    _chatBloc.add(TriggerCloseChatView());
                    Navigator.popUntil(context, (route) {
                      return route.settings.name !=
                          ModalRoute.of(context)?.settings.name;
                    });
                  }
                },
                onAction: () {},
              )
            : AppBar(
                backgroundColor: Colors.transparent,
                toolbarHeight: isTablet ? 120.h : 100.h,
                leadingWidth: Dimensions.getScreenWidth(),
                leading: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 44.w,
                        height: 40.h,
                        margin: EdgeInsets.only(
                            right: Dimensions.appBarToolVerticalGap,
                            left: Dimensions.appBarToolHorizontalGap,
                            top: 30.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Dimensions.appBarToolRadius),
                          color: AppColors.colorSecondary,
                        ),
                        child: Center(
                          child: SvgPicture.asset(AppAssets.icAppbarBackButton,
                              height: 18.h, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!state.isLoading) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      context
                                          .read<EventDetailsBloc>()
                                          .state
                                          .eventTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.subtitle(
                                          isOutFit: false),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                context
                                    .read<EventDetailsBloc>()
                                    .state
                                    .eventStatusMessage,
                                style: AppTextStyles.regularNeutralOrAccented(
                                  color: AppColors.colorPrimaryAccent,
                                ),
                              ),
                            ],
                            Container(
                              padding: EdgeInsets.only(right: 10.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        AppStrings.chat_appBar_info_text,
                                        maxLines: 4,
                                        style: AppTextStyles.componentLabels(
                                            color: AppColors
                                                .colorPrimaryNeutralText,
                                            isNormal: false)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        body: GestureDetector(
          onTap: () {
            state.messageFocus.unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: GroupedListView<Chats, DateTime>(
                      shrinkWrap: true,
                      reverse: false,
                      elements: state.chats,
                      order: GroupedListOrder.DESC,
                      controller: _scrollController,
                      groupBy: (chatData) {
                        final dateTime = DateTime.parse(chatData.createdAt!);
                        return DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                        );
                      },
                      sort: false,
                      groupHeaderBuilder: (Chats message) =>
                          ChatDateGroupingHeader(
                              dateTime: message.dateTimeForGroupingChat!),
                      padding: const EdgeInsets.only(top: 12, bottom: 20) +
                          const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, chat) {
                        LinkHighlightingController controller =
                            LinkHighlightingController();
                        controller.text = chat.message!;
                        return Row(
                          mainAxisAlignment:
                              chat.chatMessageType == ChatMessageType.received
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (chat.chatMessageType ==
                                ChatMessageType.received)
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.arguments.profileImage == null
                                        ? state.eventImage
                                        : widget.arguments.profileImage ?? ''),
                                backgroundColor: AppColors.colorPrimary,
                              ),
                            Column(
                              crossAxisAlignment: chat.chatMessageType ==
                                      ChatMessageType.received
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // _chatBloc
                                    //     .add(TriggerShowChatTime(
                                    //   chat: chat,
                                    //
                                    // ));
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10.w, top: 15.h),
                                    child: PhysicalShape(
                                      clipper: chat.chatMessageType ==
                                              ChatMessageType.received
                                          ? ChatBubbleClipper5(
                                              type: BubbleType.receiverBubble)
                                          : ChatBubbleClipper5(
                                              type: BubbleType.sendBubble),
                                      elevation: 2,
                                      color: chat.chatMessageType ==
                                              ChatMessageType.received
                                          ? AppColors.colorTertiary
                                          : AppColors.colorPrimaryAccent,
                                      shadowColor: Colors.grey.shade200,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                        ),
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 5.h,
                                            left: 15.w,
                                            right: 15.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              chat.chatMessageType ==
                                                      ChatMessageType.received
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.end,
                                          children: [
                                            RichText(
                                              text: controller.buildTextSpan(
                                                  context: context,
                                                  style:
                                                      AppTextStyles.subtitle(),
                                                  withComposing: false),
                                            ),
                                            SizedBox(
                                              height: 6.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: chat.showTime!,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 5.h,
                                        left: chat.chatMessageType ==
                                                ChatMessageType.received
                                            ? 10.w
                                            : 0,
                                        right: 0),
                                    child: Text(
                                      chat.chatTimeInAgoFormat!,
                                      style: AppTextStyles.normalNeutral(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: 10.w, vertical: Platform.isIOS ? 25.h : 10.h),
                child: Column(
                  children: [
                    if (!widget.arguments.isForGeneralChat &&
                        !state.isSupportAgentAvialable)
                      NoSupportAgentAvailabel(onDismiss: () {
                        _chatBloc.add(TirggerDismissNoAgentAvailablePopup());
                      }),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFormFields(
                      textEditingController: state.messageController,
                      focusNode: state.messageFocus,
                      textInputAction: TextInputAction.newline,
                      label: AppStrings.global_empty_string,
                      hint: AppStrings.textfield_addMessage_hint,
                      textInputType: TextInputType.multiline,
                      maxLines: 100000,
                      minLines: 1,
                      onTap: () {
                        _scrollToBottom();
                      },
                      suffixIcon: GestureDetector(
                        onTap: state.isLoading
                            ? () {}
                            : () {
                                if (state.messageController.text.isNotEmpty) {
                                  _chatBloc.add(TriggerSendMessage(
                                      roomId: widget.arguments.roomId,
                                      eventId: widget.arguments.eventId,
                                      reciverId: widget.arguments.recevierId,
                                      isFromGeneralChat:
                                          widget.arguments.isForGeneralChat));
                                }
                              },
                        child: Opacity(
                          opacity: state.isLoading ? 0.5 : 1,
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            child: SvgPicture.asset(
                              AppAssets.icSendMessage,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatDateGroupingHeader extends StatelessWidget {
  const ChatDateGroupingHeader({super.key, required this.dateTime});

  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Card(
          color: AppColors.colorSecondary,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
            child: Text(
              dateTime.toString(),
              style: AppTextStyles.subtitle(isOutFit: false),
            ),
          ),
        ),
      ),
    );
  }
}

class LinkHighlightingController extends TextEditingController {
  static final urlRegex = RegExp(
    r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})',
    caseSensitive: false,
  );

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<InlineSpan> children = [];
    final String text = value.text;
    int lastMatchEnd = 0;

    for (final match in urlRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        children.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: style,
        ));
      }

      final url = match.group(0)!;
      children.add(
        TextSpan(
          text: url,
          style: style?.copyWith(
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.solid,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _launchURL(url);
            },
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      children.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: style,
      ));
    }

    return TextSpan(children: children, style: style);
  }

  void _launchURL(String url) async {
    String refinedUrl = url.contains('http') ? url : 'https://$url';
    Uri uri = Uri.parse(refinedUrl);
    await launchUrl(uri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
