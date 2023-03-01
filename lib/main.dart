// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, depend_on_referenced_packages

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:cool_alert/cool_alert.dart";
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper_dart/whisper_dart.dart';
// import 'package:whisper_dart/whisper_dart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Whisper Speech to Text'),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String model = "";
  String audio = "";
  String result = "";
  bool is_procces = false;

  loadModel() async {
    final bytes = await rootBundle.load('assets/ggml-tiny.bin');
    final directory = await getApplicationDocumentsDirectory();
    final modelPath = '${directory.path}/ggml-tiny.bin';
    final file = File(modelPath);
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    setState(() {
      model = modelPath;
    });
  }

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !is_procces,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? resul =
                              await FilePicker.platform.pickFiles();
                          if (resul != null) {
                            File file = File(resul.files.single.path!);
                            if (file.existsSync()) {
                              setState(() {
                                model = file.path;
                              });
                            }
                          }
                        },
                        child: const Text("set model"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? resul =
                              await FilePicker.platform.pickFiles();

                          if (resul != null) {
                            File file = File(resul.files.single.path!);
                            if (file.existsSync()) {
                              setState(() {
                                audio = file.path;
                              });
                            }
                          }
                        },
                        child: const Text("set audio"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (is_procces) {
                            return await CoolAlert.show(
                              context: context,
                              type: CoolAlertType.info,
                              text: "Please wait for the process to finish",
                            );
                          }
                          if (audio.isEmpty) {
                            await CoolAlert.show(
                              context: context,
                              type: CoolAlertType.info,
                              text:
                                  "Sorry, the audio is empty, please set it first",
                            );
                            if (kDebugMode) {
                              print("audio is empty");
                            }
                            return;
                          }
                          if (model.isEmpty) {
                            await CoolAlert.show(
                                context: context,
                                type: CoolAlertType.info,
                                text:
                                    "Sorry, the model is empty, please set it first");
                            if (kDebugMode) {
                              print("model is empty");
                            }
                            return;
                          }

                          Future(() async {
                            print("Started transcribe");

                            Whisper whisper = Whisper(
                              whisperLib: "libwhisper.so",
                            );
                            var res = await whisper.request(
                              whisperLib: "libwhisper.so",
                              whisperRequest: WhisperRequest.fromWavFile(
                                audio: File(audio),
                                model: File(model),
                                language: "en",
                              ),
                            );
                            setState(() {
                              result = res.toString();
                              is_procces = false;
                            });
                          });
                          setState(() {
                            is_procces = true;
                          });
                        },
                        child: const Text("Start"),
                      ),
                    ),
                  ],
                ),
                replacement: const CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("model: ${model}"),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("audio: ${audio}"),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Result: ${result}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
