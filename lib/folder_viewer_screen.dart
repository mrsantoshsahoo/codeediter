import 'dart:io';
import 'package:flutter/material.dart';

class Folder {
  String name;
  bool isFolder;
  List<Folder> subfolders;
  List<File>? files;

  Folder(this.name, this.subfolders,this.isFolder, {this.files});
}

class ListData {
  bool isFolder;
  String path;

  ListData(
      this.isFolder,
      this.path,
      );
}

class FolderViewerScreen extends StatefulWidget {
  final String? initialPath;

  const FolderViewerScreen({this.initialPath, super.key});

  @override
  State<FolderViewerScreen> createState() => _FolderViewerScreenState();
}

class _FolderViewerScreenState extends State<FolderViewerScreen> {
  List<Folder> folderHierarchy = [];

  Set<ListData> dataList = {};

  @override
  void initState() {
    super.initState();
    listOfFiles();
  }

  firstCall() async {
    for (var folderPath in dataList) {
      List<String> pathSegments = folderPath.path.split('/');
      addFolderToHierarchy(folderHierarchy, pathSegments,folderPath.isFolder);
    }
  }

  Future listOfFiles() async {
    var path = widget.initialPath ?? Directory.current.path;
    countFoldersAndFiles(Directory(path));
    setState(() {});
  }

  void countFoldersAndFiles(Directory directory) {
    final List<FileSystemEntity> entities = directory.listSync();
    String folderName = widget.initialPath
    !.split('/')
        .last;
    String removerPath = widget.initialPath
    !.split(folderName)
        .first;
    for (final entity in entities) {
      var selectedFolder = entity.path
          .split(removerPath)
          .last;
      if (entity is Directory) {
        dataList.add(ListData(true, selectedFolder));
        countFoldersAndFiles(entity);
      } else if (entity is File) {
        dataList.add(ListData(true, selectedFolder));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var selectedFolder = widget.initialPath?.split('/').last;
    String filePath = '/path/to/file.txt';
    String folderPath = '/path/to/folder/';
    final separator = Platform.pathSeparator;

    firstCall();
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Folder Hierarchy'),
      ),
      body: FolderListView(folderHierarchy),
    );
  }
}

void addFolderToHierarchy(List<Folder> hierarchy, List<String> pathSegments,bool isFolder ) {
  if (pathSegments.isEmpty) {
    return;
  }

  String folderName = pathSegments.first;

  Folder? existingFolder = hierarchy.firstWhere(
        (folder) => folder.name == folderName,
    orElse: () => Folder(folderName, [],isFolder),
  );

  if (!hierarchy.contains(existingFolder)) {
    hierarchy.add(existingFolder);
  }

  pathSegments.removeAt(0);
  addFolderToHierarchy(existingFolder.subfolders, pathSegments,isFolder);
}

class FolderListView extends StatelessWidget {
  final List<Folder> folderHierarchy;

  FolderListView(this.folderHierarchy);

  @override
  Widget build(BuildContext context) {
    folderHierarchy.sort((a, b) => a.name.compareTo(b.name));
    return SingleChildScrollView(
      child: Column(
        children: folderHierarchy.map<Widget>((folder) {
          return FolderItem(folder);
        }).toList(),
      ),
    );
  }
}

class FolderItem extends StatefulWidget {
  final Folder folder;

  FolderItem(this.folder);

  @override
  _FolderItemState createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            children: [
              if (widget.folder.isFolder)   Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 20,
                color: Colors.white70,
              ),
              if (!widget.folder.isFolder)
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(
                    Icons.file_present_outlined,
                    size: 18,
                    color: Colors.white70,
                  ),
                )
              else
                Icon(
                  Icons.folder,
                  size: 20,
                  color: Colors.white70,
                ),
              SizedBox(width: 5,),
              Text(widget.folder.name, style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: FolderListView(widget.folder.subfolders),
          ),
      ],
    );
  }

}

bool isFileOrFolder(String path) {
  final separator = Platform.pathSeparator;
  return path.endsWith(separator);
}
