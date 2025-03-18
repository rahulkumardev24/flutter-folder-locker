import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FolderScreen extends StatefulWidget {
  final String folderName;

  FolderScreen({required this.folderName});

  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  late Box _folderBox;
  List<String> _files = [];

  @override
  void initState() {
    super.initState();
    _folderBox = Hive.box('folderData');
    _files = List<String>.from(_folderBox.get(widget.folderName) ?? []);
  }

  Future<void> _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _files.addAll(result.paths.map((path) => path!).toList());
        _folderBox.put(widget.folderName, _files); // Save in Hive
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.folderName)),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _files.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          String filePath = _files[index];
          return filePath.endsWith(".mp3") || filePath.endsWith(".wav") || filePath.endsWith(".m4a")
              ? Icon(Icons.music_note, size: 50, color: Colors.blue)
              : filePath.endsWith(".mp4") || filePath.endsWith(".mkv")
              ? Icon(Icons.video_file, size: 50, color: Colors.red)
              : filePath.endsWith(".pdf")
              ? Icon(Icons.picture_as_pdf, size: 50, color: Colors.green)
              : Image.file(File(filePath), fit: BoxFit.cover);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFile,
        child: Icon(Icons.add),
      ),
    );
  }
}
