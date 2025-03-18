import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:password_lock_shared_pre/utils/custom_text_style.dart';
import 'package:password_lock_shared_pre/widgets/my_navigation_button.dart';

class FolderScreen extends StatefulWidget {
  final String folderName;

  FolderScreen({required this.folderName});

  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  late Box _folderBox;
  List<String> _files = [];
  Set<String> _selectedFiles = {};
  bool _selectionMode = false;

  @override
  void initState() {
    super.initState();
    _folderBox = Hive.box('folderData');
    _files = List<String>.from(_folderBox.get(widget.folderName) ?? []);
  }

  void _toggleSelection(String fileName) {
    setState(() {
      if (_selectedFiles.contains(fileName)) {
        _selectedFiles.remove(fileName);
      } else {
        _selectedFiles.add(fileName);
      }
      _selectionMode = _selectedFiles.isNotEmpty;
    });
  }

  void _deleteSelectedFiles() {
    if (_selectedFiles.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Are you sure you want to delete the selected files?",
          style: myTextStyle12(fontWeight: FontWeight.bold, fontColor: Color(0xff405D72)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(width: 2, color: Colors.black45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Cancel", style: myTextStyle18(fontColor: Colors.black45)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _files.removeWhere((file) => _selectedFiles.contains(file));
                _folderBox.put(widget.folderName, _files);
                _selectedFiles.clear();
                _selectionMode = false;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Ok", style: myTextStyle18(fontWeight: FontWeight.bold, fontColor: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _files.addAll(result.paths.whereType<String>());
        _folderBox.put(widget.folderName, _files);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectionMode ? "${_selectedFiles.length} Selected" : widget.folderName,
          style: myTextStyle21(fontWeight: FontWeight.bold, fontColor: Colors.white70),
        ),
        backgroundColor: Color(0xff405D72),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyNavigationButton(
            btnIcon: Icons.arrow_back_ios_new_outlined,
            iconColor: Colors.black87,
            btnBackground: Colors.white38,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: _selectionMode
            ? [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade500),
            onPressed: _deleteSelectedFiles,
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white70),
            onPressed: () => setState(() {
              _selectedFiles.clear();
              _selectionMode = false;
            }),
          ),
        ]
            : [],
      ),
      backgroundColor: Color(0xff405D72),
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
          bool isSelected = _selectedFiles.contains(filePath);
          return InkWell(
            onLongPress: () => _toggleSelection(filePath),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: isSelected ? Colors.red : Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? Colors.red.withAlpha(60) : Colors.white10,
              ),
              child: Center(
                child: filePath.endsWith(".pdf")
                    ? FaIcon(FontAwesomeIcons.filePdf, size: 50, color: Colors.red.shade400)
                    : filePath.endsWith(".mp3") || filePath.endsWith(".wav") || filePath.endsWith(".m4a")
                    ? Icon(Icons.audiotrack_rounded, size: 50, color: Colors.blue)
                    : filePath.endsWith(".mp4") || filePath.endsWith(".mkv")
                    ? FaIcon(FontAwesomeIcons.video, size: 50, color: Colors.blue)
                    : filePath.endsWith(".docx")
                    ? FaIcon(FontAwesomeIcons.fileWord, size: 50, color: Colors.blue)
                    : filePath.endsWith(".xlsx")
                    ? FaIcon(FontAwesomeIcons.fileExcel, size: 50, color: Colors.green)
                    : Image.file(File(filePath), fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton.extended(
        onPressed: _addFile,
        elevation: 1,
        icon: Icon(Icons.add, color: Color(0xff405D72)),
        backgroundColor: Color(0xffF7E7DC),
        label: Text("Add files", style: myTextStyle18(fontColor: Color(0xff405D72))),
      ),
    );
  }
}
