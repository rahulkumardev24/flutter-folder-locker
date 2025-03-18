import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:password_lock_shared_pre/screen/video_player_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:password_lock_shared_pre/utils/custom_text_style.dart';
import 'package:password_lock_shared_pre/widgets/my_navigation_button.dart';

class FolderScreen extends StatefulWidget {
  final String folderName;

  FolderScreen({required this.folderName});

  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  Box? _folderBox;
  List<String> _files = [];
  final Set<String> _selectedFiles = {};
  bool _selectionMode = false;
  bool _isLoading = true;

  Future<void> _initializeHive() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      _folderBox = await Hive.openBox('folderData');

      setState(() {
        _files = List<String>.from(_folderBox?.get(widget.folderName) ?? []);
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing Hive: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
      builder:
          (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Are you sure you want to delete the selected files?",
          style: myTextStyle12(
            fontWeight: FontWeight.bold,
            fontColor: Color(0xff405D72),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: myTextStyle18(fontColor: Colors.black45),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (String file in _selectedFiles) {
                  try {
                    File(file).deleteSync(); // Physically delete file
                  } catch (e) {
                    print("Error deleting file: $e");
                  }
                }
                _files.removeWhere((file) => _selectedFiles.contains(file));
                _folderBox?.put(widget.folderName, _files);
                _selectedFiles.clear();
                _selectionMode = false;
              });
              Navigator.pop(context);
            },
            child: Text(
              "Ok",
              style: myTextStyle18(
                fontWeight: FontWeight.bold,
                fontColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final folderDir = Directory('${appDir.path}/${widget.folderName}');
        if (!await folderDir.exists()) {
          await folderDir.create(recursive: true);
        }

        List<String> newFiles = [];
        for (var file in result.files) {
          if (file.path != null) {
            final fileName = file.name;
            final newPath = '${folderDir.path}/$fileName';
            await File(file.path!).copy(newPath);
            newFiles.add(newPath);
          }
        }

        if (newFiles.isNotEmpty) {
          setState(() {
            _files.addAll(newFiles);
            _folderBox?.put(widget.folderName, _files);
          });
        }
      }
    } catch (e) {
      print('Error adding files: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding files: $e')),
        );
      }
    }
  }

  /// --- open file --- ///
  void _openFile(String filePath) {
    if (filePath.endsWith('.jpg') || filePath.endsWith('.png')) {
      // Show image in a dialog
      showDialog(
        context: context,
        builder: (context) => Dialog(child: Image.file(File(filePath))),
      );
    } else if (filePath.endsWith('.mp4') || filePath.endsWith('.mkv')) {
      // Open video player
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoPath: filePath),
        ),
      );
    } else if (filePath.endsWith('.mp3') || filePath.endsWith('.wav')) {
      // Play audio
      AudioPlayer().play(DeviceFileSource(filePath));
    } else if (filePath.endsWith('.pdf') ||
        filePath.endsWith('.docx') ||
        filePath.endsWith('.xlsx')) {
      // Open file with default viewer
      OpenFile.open(filePath);
    } else {
      // Show unsupported file type message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unsupported file type')));
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.folderName),
          backgroundColor: Color(0xff405D72),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectionMode
              ? "${_selectedFiles.length} Selected"
              : widget.folderName,
          style: myTextStyle21(
            fontWeight: FontWeight.bold,
            fontColor: Colors.white70,
          ),
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
        actions:
        _selectionMode
            ? [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade500),
            onPressed: _deleteSelectedFiles,
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white70),
            onPressed:
                () => setState(() {
              _selectedFiles.clear();
              _selectionMode = false;
            }),
          ),
        ]
            : [],
      ),
      backgroundColor: Color(0xff405D72),
      body:
      _folderBox?.isEmpty ?? true
          ? Center(
        child: Text("first create folder", style: myTextStyle21()),
      )
          : GridView.builder(
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
            onTap: () {
              _openFile(filePath);
            },
            onLongPress: () => _toggleSelection(filePath),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color:
                isSelected
                    ? Colors.red.withAlpha(60)
                    : Colors.white10,
              ),
              child: Center(child: _buildFileIcon(filePath)),
            ),
          );
        },
      ),
      floatingActionButton:
      _selectionMode
          ? null
          : FloatingActionButton.extended(
        onPressed: _addFile,
        elevation: 1,
        icon: Icon(Icons.add, color: Color(0xff405D72)),
        backgroundColor: Color(0xffF7E7DC),
        label: Text(
          "Add files",
          style: myTextStyle18(fontColor: Color(0xff405D72)),
        ),
      ),
    );
  }

  Widget _buildFileIcon(String filePath) {
    if (filePath.endsWith(".pdf")) {
      return FaIcon(
        FontAwesomeIcons.filePdf,
        size: 50,
        color: Colors.red.shade400,
      );
    } else if (filePath.endsWith(".mp3") ||
        filePath.endsWith(".wav") ||
        filePath.endsWith(".m4a")) {
      return Icon(Icons.audiotrack_rounded, size: 50, color: Colors.blue);
    } else if (filePath.endsWith(".mp4") || filePath.endsWith(".mkv")) {
      return FaIcon(FontAwesomeIcons.video, size: 50, color: Colors.blue);
    } else if (filePath.endsWith(".docx")) {
      return FaIcon(FontAwesomeIcons.fileWord, size: 50, color: Colors.blue);
    } else if (filePath.endsWith(".xlsx")) {
      return FaIcon(FontAwesomeIcons.fileExcel, size: 50, color: Colors.green);
    } else if (File(filePath).existsSync()) {
      return Image.file(File(filePath), fit: BoxFit.cover);
    } else {
      return Icon(Icons.insert_drive_file, size: 50, color: Colors.grey);
    }
  }

  @override
  void dispose() {
    _folderBox?.close();
    super.dispose();
  }
}
