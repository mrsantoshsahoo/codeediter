import 'package:codeediter/ai_project_create_screen.dart';
import 'package:codeediter/new_project.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<StartScreen> {
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
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.grey.shade900,
                      child: const Column(
                        children: [],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Colors.black54,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              children: [
                                const Icon(
                                  Icons.search_sharp,
                                  color: Colors.white12,
                                  size: 25,
                                ),
                                SizedBox(
                                    width: 200,
                                    child: TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                          // prefix: Icon(Icons.search,),
                                          border: InputBorder.none,
                                          isDense: true,
                                          hintStyle:
                                              TextStyle(color: Colors.white12),
                                          hintText: "Search projects"),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AiProjectCreateScreen()));
                                      },
                                      hoverColor: Colors.grey.shade800,
                                      elevation: 2,
                                      color: Colors.grey.shade900,
                                      child: const Text(
                                        "AI Project",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NewProjectScreen()));
                                    },
                                    hoverColor: Colors.grey.shade800,
                                    elevation: 2,
                                    color: Colors.grey.shade900,
                                    child: const Text(
                                      "New Project",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    hoverColor: Colors.grey.shade800,
                                    elevation: 2,
                                    color: Colors.grey.shade900,
                                    child: const Text(
                                      "Open",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ...[1, 2, 3].map(
                          //   (e) => ListTile(
                          //     leading: Icon(Icons.person),
                          //     title: Text(
                          //       "Project $e",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     subtitle: Text(
                          //       "path$e",
                          //       style: TextStyle(color: Colors.white24),
                          //     ),
                          //   ),
                          // ),
                          // ...[1].map(
                          //   (e) => ListTile(
                          //     leading: Icon(Icons.arrow_drop_down_sharp),
                          //     title: Text(
                          //       "Project $e",
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //     // trailing: Icon(Icons.arrow_drop_down_sharp),
                          //   ),
                          // ),
                          // ExpansionPanelList(
                          //   elevation: 0,
                          //   materialGapSize: 5,
                          //   expandedHeaderPadding: EdgeInsets.zero,
                          //   expansionCallback: (index, isExpanded) {},
                          //   animationDuration: Duration(milliseconds: 600),
                          //   children: _items
                          //       .map(
                          //         (item) => ExpansionPanel(
                          //           canTapOnHeader: true,
                          //           backgroundColor: Colors.white,
                          //           headerBuilder: (_, isExpanded) => Container(
                          //               padding: EdgeInsets.symmetric(
                          //                   vertical: 15, horizontal: 30),
                          //               child: Text(
                          //                 item.toString(),
                          //                 style: TextStyle(fontSize: 20),
                          //               )),
                          //           body: ExpansionPanelList(
                          //             elevation: 0,
                          //             expansionCallback: (index, isExpanded) {},
                          //             children: _items1
                          //                 .map(
                          //                   (item) => ExpansionPanel(
                          //                     canTapOnHeader: true,
                          //                     backgroundColor: Colors.white,
                          //                     headerBuilder: (_, isExpanded) =>
                          //                         Container(
                          //                             padding:
                          //                                 EdgeInsets.symmetric(
                          //                                     vertical: 15,
                          //                                     horizontal: 30),
                          //                             child: Text(
                          //                               item.toString(),
                          //                               style: TextStyle(
                          //                                   fontSize: 20),
                          //                             )),
                          //
                          //                     body: ExpansionPanelList(
                          //                       elevation: 0,
                          //                       expansionCallback:
                          //                           (index, isExpanded) {},
                          //                     ),
                          //                     // isExpanded:true,
                          //                   ),
                          //                 )
                          //                 .toList(),
                          //           ),
                          //           isExpanded: true,
                          //         ),
                          //       )
                          //       .toList(),
                          // ),
                        ],
                      ),
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
