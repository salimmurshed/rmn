// // import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// //
// // import '../../../imports/common.dart';
// //
// // HtmlWidget buildHtmlWidget({required String text}) {
// //   return HtmlWidget(
// //     text,
// //     textStyle: AppTextStyles.regularNeutralOrAccented(
// //         isBold: false,
// //         isOutfit: true
// //     ),
// //     customStylesBuilder: (element) {
// //       if (element.localName!.contains("h1") ||
// //           element.localName!.contains("h3") ||
// //           element.localName!.contains("h2") ||
// //           element.localName!.contains("li")) {
// //         return {'text-align': 'justify', 'color': '#FFFFFF'};
// //       } else if (element.localName == "p") {
// //         return {
// //           'text-align': 'justify',  'color': '#FFFFFF',
// //         };
// //       } else if (element.localName == "a") { // Style hyperlinks
// //         return {'color': '#FF0000'}; // Red color for hyperlinks
// //       }
// //
// //       return null;
// //     },
// //   );
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// HtmlWidget buildHtmlWidget({required String text}) {
//   print('text: $text');
//   return HtmlWidget(
//     text,
//     textStyle: const TextStyle(
//       fontSize: 16,
//       color: Colors.white,
//     ),
//     customStylesBuilder: (element) {
//       if (element.localName!.contains("h1") ||
//           element.localName!.contains("h3") ||
//           element.localName!.contains("h2") ||
//           element.localName!.contains("li")) {
//         return {'text-align': 'justify', 'color': '#FFFFFF'};
//       } else if (element.localName == "p") {
//         return {
//           'text-align': 'justify',
//           'color': '#FFFFFF',
//         };
//       } else if (element.localName == "a") {
//         return {'color': '#FF0000'}; // Red for hyperlinks
//       }
//       return null;
//     },
//     customWidgetBuilder: (element) {
//       if (element.localName == 'iframe' &&
//           element.attributes['src'] != null) {
//         // final videoUrl = element.attributes['src']!;
//         final videoId = extractVideoId(text);
//         return YoutubePlayer(aspectRatio: 3 / 4,
//           controller: YoutubePlayerController(
//             initialVideoId: videoId,
//             flags: const YoutubePlayerFlags(
//               autoPlay: false,
//               mute: false,
//             ),
//           ),
//           showVideoProgressIndicator: true,
//         );
//       } else if (element.localName == 'video') {
//         final videoSource = element.attributes['src'];
//         if (videoSource != null) {
//           return VideoWidget(videoUrl: videoSource);
//         }
//       }
//       return null;
//     },
//   );
// }
//
// class VideoWidget extends StatelessWidget {
//   final String videoUrl;
//
//   const VideoWidget({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: VideoPlayerScreen(videoUrl: videoUrl),
//     );
//   }
// }
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? VideoPlayer(_controller)
//         : const Center(child: CircularProgressIndicator());
//   }
// }
//
// String extractVideoId(String content) {
//   final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');
//   final match = urlRegex.firstMatch(content);
//   if (match != null) {
//     final url = match.group(0) ?? '';
//     return YoutubePlayer.convertUrlToId(url) ?? '';
//   }
//   return '';
// }

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Widget buildHtmlWidget({required String text}) {


  if (text.contains('iframe') && text.contains('src')) {
    final videoId = extractVideoId(text);
    return Center(
      child: YoutubePlayer(
        aspectRatio: 16 / 9,
        controller: YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),

        ),
        showVideoProgressIndicator: true,
      ),
    );
  }
  else if(text.contains('video') && text.contains('src')) {
    final videoSource = extractVideoId(text);
    return Center(child: VideoWidget(videoUrl: videoSource));
  }
  else {
    return HtmlWidget(
      text,
      textStyle: const TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      customStylesBuilder: (element) {
        if (element.localName!.contains("h1") ||
            element.localName!.contains("h3") ||
            element.localName!.contains("h2") ||
            element.localName!.contains("li")) {
          return {'text-align': 'justify', 'color': '#FFFFFF'};
        } else if (element.localName == "p") {
          return {
            'text-align': 'justify',
            'color': '#FFFFFF',
          };
        } else if (element.localName == "a") {
          return {'color': '#FF0000'}; // Red for hyperlinks
        }
        return null;
      },
    );
  }
}

class VideoWidget extends StatelessWidget {
  final String videoUrl;

  const VideoWidget({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: VideoPlayerScreen(videoUrl: videoUrl),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? VideoPlayer(_controller)
        : const Center(child: CircularProgressIndicator());
  }
}

String extractVideoId(String content) {
  final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');
  final match = urlRegex.firstMatch(content);
  if (match != null) {
    final url = match.group(0) ?? '';
    return YoutubePlayer.convertUrlToId(url) ?? '';
  }
  return '';
}