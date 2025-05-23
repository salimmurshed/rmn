import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginable/paginable.dart';
import 'package:rmnevents/imports/common.dart';
import 'package:rmnevents/presentation/staff_chat/specific_event_chat_list_view/widget/build_navigation.dart';
import 'package:rmnevents/presentation/staff_chat/user_chat_list/page/user_chat_list_view.dart';

import '../../../../data/models/arguments/chat_arguments.dart';
import '../bloc/event_chat_list_bloc.dart';

class EventChatListView extends StatefulWidget {
  final ChatArguments arguments;
  const EventChatListView({super.key, required this.arguments});

  @override
  State<EventChatListView> createState() => _EventChatListViewState();
}

class _EventChatListViewState extends State<EventChatListView> {
  @override
  Widget build(BuildContext context) {
    return customScaffold(
      anyWidgetWithoutSingleChildScrollView:
          EventChatListBody(arguments: widget.arguments,),
      hasForm: false,
      formOrColumnInsideSingleChildScrollView: null,
      isPaddingOn: false,
    );
  }
}

class EventChatListBody extends StatefulWidget {
  final ChatArguments arguments;

  const EventChatListBody({super.key, required this.arguments});

  @override
  State<EventChatListBody> createState() => _EventChatListBodyState();
}

class _EventChatListBodyState extends State<EventChatListBody> {
  @override
  void initState() {
    BlocProvider.of<EventChatListBloc>(context).add(
       TriggerFetchEventListData(eventId: widget.arguments.eventId, page: 1, type: ChatType.All)
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<EventChatListBloc, EventChatListState>(
  listener: (context, state) {

  },
  child: BlocBuilder<EventChatListBloc, EventChatListState>(
      builder: (context, state) {
        return customScaffoldForImageBehind(
            appBar: customAppBarForImageBehind(context: context),
            body: Column(
              children: [
                  EventHeaderView(
                    date:  state.eventChatListData?.eventData
                        ?.startDateTime != null ?DateFunctions.getddMMMyyyyFormat(
                        date: state.eventChatListData?.eventData
                            ?.startDateTime ??
                            '') : '',
                    imageUrl:widget.arguments.profileImage ?? '',
                    location:
                    state.eventChatListData?.eventData?.address ?? '',
                    title: state.eventChatListData?.eventData?.title ?? '',
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Flexible(child: UserChatListView(eventId: widget.arguments.eventId)),
              ],
            ),
        );
      },
    ),
);
  }
}
