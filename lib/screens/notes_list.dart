import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkit;

import 'widgets/note_preview.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  FirebaseFirestore cloudInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: cloudInstance
          .collection(widget.userId)
          .orderBy('created-on')
          .where('inTrash', isEqualTo: false)
          .snapshots(),
      builder:
          (BuildContext ctx, AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              const Center(
                child: spinkit.SpinKitChasingDots(
                  color: Colors.greenAccent,
                ),
              ),
              Text(
                "Probably no items here!",
                style: TextStyle(
                    color: (Theme.of(context).brightness == Brightness.dark)
                        ? Colors.white24
                        : Colors.black26,
                    fontSize: 16.0),
              )
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: spinkit.SpinKitChasingDots(
              color: Colors.indigoAccent,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // List<QueryDocumentSnapshot<dynamic>> allDocuments =
            //     snapshot.data!.docs;
            List<QueryDocumentSnapshot<dynamic>> allDocuments =
                snapshot.data!.docs.reversed.toList();
            int firstColumnLength = (allDocuments.length % 2 == 0)
                ? (allDocuments.length ~/ 2)
                : ((allDocuments.length - 1) ~/ 2);
            firstColumnLength += 1;
            int secondColumnLength = allDocuments.length - firstColumnLength;

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
                      return NoteWidget(
                        topic: allDocuments[index].data()!['topic'],
                        content: allDocuments[index].data()!['content'],
                        createdOn:
                            allDocuments[index].data()!['created-on'].toDate(),
                        colorMap: allDocuments[index].data()!['colormap'],
                        maxLines: allDocuments[index].data()!['maxLines'],
                        docId: allDocuments[index].id,
                        userId: widget.userId,
                        inTrash: allDocuments[index].data()!['inTrash'],
                        canDelete: allDocuments[index].data()!['can_delete'],
                      );
                    }),
                  ),
                  (secondColumnLength != 0)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(secondColumnLength, (index) {
                            int customIndex = index + firstColumnLength;
                            return NoteWidget(
                                topic:
                                    allDocuments[customIndex].data()!['topic'],
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
    );
  }
}
