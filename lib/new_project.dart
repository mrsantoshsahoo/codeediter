import 'dart:io';

import 'package:codeediter/folder_viewer_screen.dart';
import 'package:codeediter/template_screen.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';
import 'package:process_runner/process_runner.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final projectName = TextEditingController();
  final projectLocation = TextEditingController();
  final projectDescription = TextEditingController();
  final projectOrganisation = TextEditingController();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  final _fileExtensionController = TextEditingController();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _lockParentWindow = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  @override
  void initState() {
    setScreen();
    projectName.text = "example";
    projectDescription.text = "A new Flutter project.";
    projectOrganisation.text = "com.example";
    _directoryPath = "${Directory.current.path}/projects/${projectName.text}";
    super.initState();
  }
setScreen()async{
  if (!kIsWeb) {
    await DesktopWindow.setWindowSize(const Size(1440.0, 809.0));
    await DesktopWindow.setMinWindowSize(const Size(800, 500));
  }
}
  setPath() {
    setState(() {
      String originalText = _directoryPath!;
      List<String> words = originalText.split('/');

      if (words.isNotEmpty) {
        words.removeLast();
        String modifiedText = words.join('/');
        // _directoryPath="$modifiedText${projectName.text}";
        print(modifiedText); // Output: "This is some text with the last"
      } else {
        print(originalText); // No words to remove, so keep the original text
      }
      // String? data=_directoryPath?.split('/').last;
      //  _directoryPath?.replaceAll(data.toString(), '');
      _directoryPath = "$_directoryPath${projectName.text}";
      print(_directoryPath);
    });
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath(
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: true,
      );

      setState(() {
        _directoryPath = "$path/";
        _userAborted = path == null;
      });
      setPath();
    } on PlatformException catch (e) {
      // _logException('Unsupported operation' + e.toString());
    } catch (e) {
      // _logException(e.toString());
    } finally {
      // setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.grey.shade900,
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                  ),
                  height: 35,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "Project name: ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 8,
                        child: appTextFiled(
                            controller: projectName,
                            onChanged: (v) {
                              // setPath();
                            }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "Project location: ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 7,
                        child: appTextFiled(
                            controller:
                                TextEditingController(text: _directoryPath)),
                      ),
                      Expanded(
                        flex: 1,
                        child: MaterialButton(
                          onPressed: () {
                            _selectFolder();
                          },
                          child: Text(
                            "Choose",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "Description: ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 8,
                        child: appTextFiled(controller: projectDescription),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "Organisation: ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 8,
                        child: appTextFiled(controller: projectOrganisation),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "Androd language: ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Radio(
                                    value: 1,
                                    groupValue: 0,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Java  ",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Radio(
                                    value: 1,
                                    groupValue: 1,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Kotlin ",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "IOS language: ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Radio(
                                    value: 1,
                                    groupValue: 0,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Objective-c  ",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Radio(
                                    value: 1,
                                    groupValue: 1,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Swift  ",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "Platfrom : ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Android",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" IOS",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Web",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" MacOS",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Windowa",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Linux",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: const Text(
                          "State management:",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 8,
                        child: Row(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Radio(
                                    value: 1,
                                    groupValue: 0,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Provider  ",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Radio(
                                    value: 1,
                                    groupValue: 1,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" BLoC  ",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Radio(
                                    value: 1,
                                    groupValue: 0,
                                    onChanged: (v) {},
                                  ),
                                ),
                                Text(" Get-X  ",
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              // color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text("Back"),
                    color: Colors.white,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      String data =
                          _directoryPath!.replaceAll(projectName.text, '');
                      var shell = Shell();
                      // shell = shell.cd(data);
                      // await shell.run('flutter create ${projectName.text}');
                      // shell = shell.cd("${projectName.text}/");
                      // await shell.run('flutter pub add flutter_bloc');
                      // shell.run('ls');
                      // shell = shell.pushd('projects');
                      // shell.run('mkdir projects');
                      // shell=shell.cd('projects/long');
                      // shell.run('mkdir projects');
                      // shell=shell.cd('..');
                      // shell.run('flutter create long');
                      // shell.run('flutter pub add bloc');

                      // ProcessRunner processRunner = ProcessRunner();
                      // var path = await getApplicationSupportDirectory();
                      // debugPrint( Directory.current.path);
                      // processRunner.runProcess(['cd libprojects']);
                      // processRunner.processManager.run(['cd libprojects']);
                      // debugPrint(processRunner.defaultWorkingDirectory.path);
                      // shell = shell.pushd('labprojects');
                      // await shell.run(' touch demo.dart ');
                      // await shell.run('rm -rf  king');
                      // await shell.run('flutter create ${projectName.text}');
                      // await shell.run('cd ios');
                      // print(shell.path);
                      // await shell.run('ls');
                      // shell.pushd(shell.cd('ios').path);
                      // shell.cloneWithOptions(ShellOptions());
                      //   runCmd(cmd);
                      // shell.cd('lib');
                      // await shell.run('flutter create demo');
                      // print(shell.cd('lib').path);
                      // await shell.run('ls');
                      // await shell.run('ls');
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => FolderViewerScreen(
                      //               initialPath:
                      //                   "${_directoryPath}",
                      //             )));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TemplateScreen()));
                    },
                    child: Text("Create"),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

appTextFiled({TextEditingController? controller, Function(String)? onChanged}) {
  return TextFormField(
    controller: controller,
    style: const TextStyle(color: Colors.white, fontSize: 14),
    cursorHeight: 14,
    onChanged: onChanged,
    decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade800, width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
        isDense: true,
        hintStyle: const TextStyle(color: Colors.white12),
        hintText: "Name"),
  );
}
