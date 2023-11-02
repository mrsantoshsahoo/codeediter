import 'package:codeediter/new_project.dart';
import 'package:codeediter/utils/image_paths.dart';
import 'package:flutter/material.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<TemplateScreen> {
  List<Category> categoryList = [
    Category(name: "OnBoarding", isSelected: true,  imageList: [
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
  int index = 0;

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
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
              height: 35,
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    color: Colors.grey.shade900,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...categoryList.asMap().entries.map(
                              (e) => InkWell(
                                onHover: (v) {
                                  setState(() {
                                    e.value.isHover = v;
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    categoryList.forEach((element) {
                                      element.isSelected = false;
                                    });
                                    e.value.isSelected = true;
                                    index = e.key;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 15),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  width: 150,
                                  color: !e.value.isSelected && !e.value.isHover
                                      ? Colors.transparent
                                      : Colors.white12,
                                  child: Text(
                                    e.value.name,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Container(
                      color: Colors.black54,
                      child: IndexedStack(index: index, children: [
                        ...categoryList.map(
                          (e) => SingleChildScrollView(
                            child: Column(
                              children: [
                                ...e.imageList.map(
                                    (e) => Image.asset(e, fit: BoxFit.fill))
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Category {
  String name;
  List<String> imageList;
  bool isSelected;
  bool isHover;

  Category(
      {required this.name,
      this.imageList = const [],
      this.isSelected = false,
      this.isHover = false});
}
