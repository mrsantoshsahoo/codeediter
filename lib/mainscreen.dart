import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black54, // Set the top border color here
                  width: 2.0, // Set the border width
                ),
              ),
            ),
            height: 35,
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    border: Border(
                      right: BorderSide(
                        color: Colors.black54,
                        width: 2.0, // Set the border width
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      border: Border(
                        right: BorderSide(
                          color: Colors.black54,
                          width: 2.0, // Set the border width
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  border: Border(
                                    right: BorderSide(
                                      color: Colors.black54,
                                      width: 2.0, // Set the border width
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  child: LineNumberedTextField(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            border: Border(
                              top: BorderSide(
                                color: Colors.black54,
                                width: 2.0, // Set the border width
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 35,
            decoration: const BoxDecoration(
              color: Colors.black54,
              border: Border(
                top: BorderSide(
                  color: Colors.black54, // Set the top border color here
                  width: 2.0, // Set the border width
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineNumberedTextField extends StatefulWidget {
  @override
  _LineNumberedTextFieldState createState() => _LineNumberedTextFieldState();
}

class _LineNumberedTextFieldState extends State<LineNumberedTextField> {
  late TextEditingController _controller;
  int _lineCount = 1;
  int lineCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateLineCount);
  }

  void _updateLineCount() {
    final text = _controller.text;
    final lines = text.split('\n');
    setState(() {
      _lineCount = lines.length;
    });
  }

  @override
  Widget build(BuildContext context) {
var size=MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        height:size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            lineCount,
                (index) => Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    (index + 1).toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    child: TextFormField(
                      cursorHeight: 20,
                      minLines: 1,
                      style: TextStyle(fontSize: 15),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      onFieldSubmitted: (v){
                        setState(() {
                          lineCount++;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
