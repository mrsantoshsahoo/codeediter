import 'dart:io';

import 'package:codeediter/new_project.dart';
import 'package:codeediter/template_screen.dart';
import 'package:codeediter/utils/image_paths.dart';
import 'package:device_frame/device_frame.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

enum Calendar { day, week, month, year }

class AiProjectCreateScreen extends StatefulWidget {
  const AiProjectCreateScreen({super.key});

  @override
  State<AiProjectCreateScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<AiProjectCreateScreen> {
  TextEditingController controller= TextEditingController();
  List<Category> array = [
    Category(name: "OnBoarding", isSelected: true, imageList: [
      ImagesPath.onboard1,
      ImagesPath.onboard2,
      ImagesPath.onboard3,
      ImagesPath.onboard4,
      ImagesPath.onboard5,
      ImagesPath.onboard6,
      ImagesPath.onboard7,
      ImagesPath.onboard8,
    ]),
    Category(name: "Login", imageList: [
      ImagesPath.login1,
      ImagesPath.login2,
      ImagesPath.login3,
      ImagesPath.login4,
      ImagesPath.login5,
      ImagesPath.login6,
      ImagesPath.login7,
      ImagesPath.login8,
    ]),
    Category(name: "Sign-up"),
    Category(name: "Dashboard"),
    Category(name: "Profile"),
    Category(name: "Search"),
    Category(name: "Chat"),
    Category(name: "Menu")
  ];

  void _update(old, ew) {
    setState(() {
      var el = array[old];
      array.removeAt(old);
      array.insert(ew, el);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Calendar calendarView = Calendar.day;

    return Scaffold(
      body: Container(
        color: Colors.grey.shade900,
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Container(
              height: 100,
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                // prototypeItem:  Container(height: 10,width: 50,color: Colors.red,),
                // footer: Container(height: 10,width: 50,color: Colors.red,),
                onReorder: _update,
                children: [
                  for (final item in array)
                    Container(
                      key: ValueKey(item),
                      width: 100,
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 4,
                            ),
                          ]),
                      child: Center(
                        child: Text(item.name),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: DeviceFrame(
                      device: Devices.ios.iPhone13ProMax,
                      isFrameVisible: true,
                      orientation: Orientation.portrait,
                      screen: LoginPage(),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.black54,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: controller,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            // cursorHeight: 16,
                            cursorColor: Colors.white,
                            onChanged: (v) {
                              // print(v);
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    print(controller.text);
                                 bool isLogin=   controller.text.contains("login");
                                 print(isLogin);

                                  },
                                  icon: Icon(Icons.send),
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade800, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                isDense: true,
                                hintStyle:
                                    const TextStyle(color: Colors.white12),
                                hintText: "Generate your Screen...."),
                          ),
                          // Text(
                          //   "SCREENS",
                          //   style: TextStyle(color: Colors.white, fontSize: 20),
                          // ),
                          // Wrap(
                          //   children: [
                          //     for (final item in array)
                          //       Padding(
                          //         padding: const EdgeInsets.only(
                          //             right: 4.0, bottom: 4),
                          //         child: Chip(
                          //           label: Text(
                          //             item.name,
                          //             style: TextStyle(fontSize: 20),
                          //           ),
                          //           padding: EdgeInsets.all(5),
                          //         ),
                          //       ),
                          //   ],
                          // ),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     // final filePath = 'lib/demo.dart';
                          //     // final lineToInsertAt = 1;
                          //     // insertCodeInFile(
                          //     //     filePath, codeToInsert, lineToInsertAt);
                          //
                          //     createDartFileInFolder("profile");
                          //   },
                          //   child: Text('Login'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 2,
                  //   child: Column(
                  //     children: [],
                  //   )
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void insertCodeInFile(
      String filePath, String codeToInsert, int lineToInsertAt) {
    final file = File(filePath);

    // Read the file content into a list of lines.
    final lines = file.readAsLinesSync();

    // Insert the code at the specified line.
    lines.insert(lineToInsertAt - 1, codeToInsert);

    // Write the modified content back to the file.
    file.writeAsStringSync(lines.join('\n'));
  }

  void createDartFileInFolder(String name) {
    // final folderPath = 'lib/modules';
    final folderPath = 'projects/example/lib/modules/$name';

    Map filePathScreen = {
      '$folderPath/${name}_screen.dart': '''
import 'package:flutter/material.dart';

void main() {
//   '${name}_screen.dart'
}
    '''
    };
    Map filePathWidgets = {
      '$folderPath/${name}_widgets.dart': '''
import 'package:flutter/material.dart';

void main() {
//   '${name}_widgets.dart'
}
    '''
    };
    Map filePathBloc = {
      '$folderPath/bloc/${name}_bloc.dart': '''
import 'package:flutter/material.dart';

void main() {
//   '${name}_bloc.dart'
}
    '''
    };
    Map filePathEvent = {
      '$folderPath/bloc/${name}_event.dart': '''
import 'package:flutter/material.dart';

void main() {
//   '${name}_event.dart'
}
    '''
    };
    Map filePathState = {
      '$folderPath/bloc/${name}_state.dart': '''
import 'package:flutter/material.dart';

void main() {
//   '${name}_state.dart'
}
    '''
    };
    List<Map> fileList = [
      filePathBloc,
      filePathEvent,
      filePathState,
      filePathScreen,
      filePathWidgets,
    ];
    for (Map files in fileList) {
      final file = File(files.keys.first);
      file.createSync(recursive: true);
      file.writeAsStringSync(files.values.first);
    }

    // file.writeAsStringSync(fileContent);
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
                String email = _emailController.text;
                String password = _passwordController.text;
                // You can add your authentication logic here
                if (email.isNotEmpty && password.isNotEmpty) {
                  // Navigate to the next screen or perform authentication
                  // For now, just print the email and password
                  print('Email: $email');
                  print('Password: $password');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
