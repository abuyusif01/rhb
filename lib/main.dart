// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:rhb/utils/functions.dart';
import 'start_camera.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: const MainBar(),
      routes: {
        '/start_camera': (context) => StartCamera(camera: firstCamera),
      },
    ),
  );
}

class MainBar extends StatefulWidget {
  const MainBar({super.key});

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera)),
              Tab(icon: Icon(Icons.format_align_center)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: <Widget>[
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/start_camera');
                    },
                    child: const Text('Camera'),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // pick a local file and upload it
                      var result = await FilePicker.platform
                          .pickFiles(allowMultiple: false);

                      if (result != null) {
                        String filepath =
                            result.paths.map((path) => File(path!)).toString();
                        var xfile = filepath
                            .split(' ')
                            .last
                            .replaceAll("'", "")
                            .replaceAll(")", "");

                        if (await upload(url, xfile) != null) {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Oh Noicee!',
                              message:
                                  'Image uploaded successfully. Redirecting back to homepage.',
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                          Navigator.pushNamed(context, '/');
                        } else {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Oh Snap!',
                              message:
                                  'Something went wrong. Redirecting back to homepage.',
                              contentType: ContentType.failure,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                          Navigator.pushNamed(context, '/');
                        }
                      }
                    },
                    child: const Text('Local Storage'),
                  ),
                ),
              ],
            ),
            const Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
