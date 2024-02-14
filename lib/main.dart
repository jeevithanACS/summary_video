import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_subtitle/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YouTube Subtitle Fetcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SubtitleFetcher(),
    );
  }
}

class SubtitleFetcher extends StatefulWidget {
  @override
  _SubtitleFetcherState createState() => _SubtitleFetcherState();
}

class _SubtitleFetcherState extends State<SubtitleFetcher> {
  final TextEditingController _urlController = TextEditingController();
  RxString videoUrl = ''.obs;
  String videoId = '';

  Future<void> fetchSubtitles() async {
    videoUrl.value = _urlController.text;
    videoId = videoUrl.split('v=')[1];
    if (videoUrl.isNotEmpty && videoId.isNotEmpty) {
      String apiUrl =
          'https://hackathon-j3wt.onrender.com/process_video?video_id=$videoId';
      final response = await http.get(Uri.parse(apiUrl));
      debugPrint(response.body);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SynopSlice',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 4,
        bottomOpacity: 3,
        shadowColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Your video, our expertise. Share the link and let's summarize!",
              style: TextStyle(fontFamily: 'opensans', fontSize: 18),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter YouTube Video URL',
                labelStyle: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchSubtitles,
              child: const Text('Summarize'),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (videoUrl.isNotEmpty) {
                return ElevatedButton(
                  onPressed: () {
                    fetchSubtitles;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerExample(
                          videoUrl: videoUrl.value,
                        ),
                      ),
                    );
                  },
                  child: const Text('Play'),
                );
              } else {
                return const SizedBox
                    .shrink(); // Hide the button if videoUrl is empty
              }
            }),
          ],
        ),
      ),
    );
  }
}
