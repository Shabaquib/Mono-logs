import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;
import 'package:mono_log/data_models/global_data.dart';

import 'widgets/note_preview.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  FirebaseFirestore cloudInstance = FirebaseFirestore.instance;

  List<String> trashIDs = [];

  _emptyBin() {
    for (var element in trashIDs) {
      cloudInstance.collection(widget.userId).doc(element).delete();
    }
  }

  void _revokeTrashDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(10.0),
            title: const Center(
              child: Text(
                "Empty trash?",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 60.0,
                  color: Colors.amber,
                ),
                SizedBox(height: 10.0),
                Text(
                  "Delete all notes here?",
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              TextButton(
                onPressed: () {
                  _emptyBin();
                  Navigator.pop(context);
                  showToast(context, "Emptying");
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                      color: Color(0xFFE9967A), fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trash",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _revokeTrashDialog(context);
            },
            icon: const Icon(
              Icons.delete_sweep_rounded,
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: cloudInstance
            .collection(widget.userId)
            .orderBy('created-on')
            .where('inTrash', isEqualTo: true)
            .snapshots(),
        builder:
            (BuildContext ctx, AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Center(
              child: spinkit.SpinKitChasingDots(
                color: Colors.greenAccent,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: spinkit.SpinKitChasingDots(
                color: Colors.indigoAccent,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<dynamic>> allDocuments =
                  snapshot.data!.docs.reversed.toList();
              int firstColumnLength = allDocuments.length ~/ 2;
              int secondColumnLength = allDocuments.length - firstColumnLength;

              if (firstColumnLength == 0 && secondColumnLength == 0) {
                return SafeArea(
                    child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_rounded,
                        size: 100.0,
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? Colors.white24
                            : Colors.black26,
                      ),
                      Text(
                        "No items in trash",
                        style: TextStyle(
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? Colors.white24
                                : Colors.black26,
                            fontSize: 16.0),
                      )
                    ],
                  ),
                ));
              } else {
                return SafeArea(
                    child: SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(firstColumnLength, (index) {
                          trashIDs.add(allDocuments[index].id);
                          return NoteWidget(
                              topic: allDocuments[index].data()!['topic'],
                              content: allDocuments[index].data()!['content'],
                              createdOn: allDocuments[index]
                                  .data()!['created-on']
                                  .toDate(),
                              colorMap: allDocuments[index].data()!['colormap'],
                              maxLines: allDocuments[index].data()!['maxLines'],
                              docId: allDocuments[index].id,
                              userId: widget.userId,
                              inTrash: allDocuments[index].data()!['inTrash'],
                              canDelete:
                                  allDocuments[index].data()!['can_delete']);
                        }),
                      ),
                      (secondColumnLength != 0)
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  List.generate(secondColumnLength, (index) {
                                int customIndex = index + firstColumnLength;
                                trashIDs.add(allDocuments[customIndex].id);
                                return NoteWidget(
                                    topic: allDocuments[customIndex]
                                        .data()!['topic'],
                                    content: allDocuments[customIndex]
                                        .data()!['content'],
                                    createdOn: allDocuments[customIndex]
                                        .data()!['created-on']
                                        .toDate(),
                                    colorMap: allDocuments[customIndex]
                                        .data()!['colormap'],
                                    maxLines: allDocuments[customIndex]
                                        .data()!['maxLines'],
                                    docId: allDocuments[customIndex].id,
                                    userId: widget.userId,
                                    inTrash: allDocuments[customIndex]
                                        .data()!['inTrash'],
                                    canDelete: allDocuments[customIndex]
                                        .data()!['can_delete']);
                              }),
                            )
                          : const SizedBox(
                              width: 50.0,
                            )
                    ],
                  ),
                ));
              }
            } else {
              return const Center(
                child: spinkit.SpinKitChasingDots(
                  color: Colors.orangeAccent,
                ),
              );
            }
          } else {
            return const Center(
              child: spinkit.SpinKitChasingDots(
                color: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
