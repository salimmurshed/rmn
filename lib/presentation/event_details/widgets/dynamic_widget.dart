import 'package:flutter/material.dart';

import '../../../common/widgets/html_widget/build_html_widget.dart';
import '../bloc/event_details_bloc.dart';

class DynamicWidget extends StatefulWidget {
   DynamicWidget({
    super.key,
    required this.i,
    required this.state,
    this.isShorten = false
  });
  final EventDetailsWithInitialState state;
  final int i;
  bool isShorten;

  @override
  State<DynamicWidget> createState() => _DynamicWidgetState();
}

class _DynamicWidgetState extends State<DynamicWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return buildHtmlWidget(
        text: widget.state.eventResponseData!.event!
            .additionalData![widget.i].content!);
  }
}