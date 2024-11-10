import 'package:db_practise/data/local/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;
  final _formKey = GlobalKey<FormState>();

  //controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: const Text('Notes'),
        centerTitle: true,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    "${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}",
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  title: Text(
                    allNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  subtitle: Text(
                    "${allNotes[index][DBHelper.COLUMN_NOTE_DESC]}",
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            isDismissible: false,
                            enableDrag: false,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              titleController.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_TITLE];
                              descController.text =
                                  allNotes[index][DBHelper.COLUMN_NOTE_DESC];
                              return getBottomSheet(
                                'Update Note',
                                id: allNotes[index][DBHelper.COLUMN_NOTE_SNO],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text(
                                  'Are you sure to delete?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () async {
                                      bool check = await dbRef!.deleteNote(
                                        id: allNotes[index]
                                            [DBHelper.COLUMN_NOTE_SNO],
                                      );
                                      if (check) {
                                        getNotes();
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No Notes Available',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            isDismissible: false,
            enableDrag: false,
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return getBottomSheet('Add Note');
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheet(String value, {int? id}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10.0),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Title is empty';
                }
                return null;
              },
              controller: titleController,
              decoration: InputDecoration(
                label: const Text("Title"),
                hintText: "Enter title here",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Description is empty';
                }
                return null;
              },
              maxLines: 4,
              controller: descController,
              decoration: InputDecoration(
                label: const Text("Description"),
                hintText: "Enter Description here",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.blue.shade500,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool check;
                        if (value.contains('Update')) {
                          check = await dbRef!.updateNote(
                            title: titleController.text,
                            desc: descController.text,
                            id: id!,
                          );
                        } else {
                          check = await dbRef!.addNote(
                            title: titleController.text,
                            desc: descController.text,
                          );
                        }
                        if (check) {
                          getNotes();
                        }
                        titleController.clear();
                        descController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                OutlinedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
