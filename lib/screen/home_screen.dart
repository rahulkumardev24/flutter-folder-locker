import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:password_lock_shared_pre/utils/custom_text_style.dart';
import 'folder_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box _folderBox = Hive.box('folderData');
  Set<String> _selectedFolders = {}; // Selected folders set
  bool _selectionMode = false; // Selection mode state

  ///--- folder create function --- ///
  void _createFolder() {
    TextEditingController folderNameController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Create New Folder"),
            content: TextField(
              controller: folderNameController,
              decoration: InputDecoration(hintText: "Enter folder name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  String folderName = folderNameController.text.trim();
                  if (folderName.isNotEmpty &&
                      !_folderBox.containsKey(folderName)) {
                    _folderBox.put(folderName, []); // Save in Hive
                    setState(() {});
                  }
                  Navigator.pop(context);
                },
                child: Text("Create"),
              ),
            ],
          ),
    );
  }

  /// folder selection function
  void _toggleSelection(String folderName) {
    setState(() {
      if (_selectedFolders.contains(folderName)) {
        _selectedFolders.remove(folderName);
      } else {
        _selectedFolders.add(folderName);
      }
      _selectionMode = _selectedFolders.isNotEmpty;
    });
  }

  /// folder delete function
  void _deleteSelectedFolders() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            icon: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever , size: 200, color: Colors.red.shade400,),
              ],
            ),

            title: Text(
              "Are you sure you want to delete the folder?",
              style: myTextStyle12(
                fontWeight: FontWeight.bold,
                fontColor: Color(0xff405D72),
              ),
            ),
            actions: [
              ///--- Cancel button ---///
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedFolders.clear();
                    _selectionMode = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(width: 2, color: Colors.black45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Cancel",
                  style: myTextStyle18(fontColor: Colors.black45),
                ),
              ),

              /// --- OK  button ---///
              ElevatedButton(
                onPressed: () {
                  for (var folder in _selectedFolders) {
                    _folderBox.delete(folder);
                  }
                  setState(() {
                    _selectedFolders.clear();
                    _selectionMode = false;
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: myTextStyle18(fontWeight: FontWeight.bold , fontColor: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> folders = _folderBox.keys.cast<String>().toList();
    return Scaffold(
      ///--- Appbar --- ///
      appBar: AppBar(
        backgroundColor: Color(0xff405D72),
        title: Text(
          _selectionMode
              ? "${_selectedFolders.length} Selected"
              : "Folder Locker",
          style: myTextStyle21(fontColor: Colors.white),
        ),
        actions:
            _selectionMode
                ? [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: _deleteSelectedFolders,
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white70),
                    onPressed:
                        () => setState(() {
                          _selectedFolders.clear();
                          _selectionMode = false;
                        }),
                  ),
                ]
                : [],
      ),
      backgroundColor: Color(0xff0758694),

      ///--- Body ---///
      body: GridView.builder(
        itemCount: folders.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0, // Adjust aspect ratio if needed
        ),
        itemBuilder: (context, index) {
          String folderName = folders[index];
          bool isSelected = _selectedFolders.contains(folderName);

          return InkWell(
            onTap:
                _selectionMode
                    ? () => _toggleSelection(folderName)
                    : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => FolderScreen(folderName: folderName),
                      ),
                    ),
            onLongPress: () => _toggleSelection(folderName),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.red.withOpacity(0.2) : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder,
                    size: 100,
                    color: isSelected ? Colors.red : Colors.amber,
                  ),
                  SizedBox(height: 10),
                  Text(
                    folderName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: Colors.red, size: 20),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton:
          _selectionMode
              ? null
              : FloatingActionButton(
                onPressed: _createFolder,
                child: Icon(Icons.create_new_folder),
              ),
    );
  }
}
