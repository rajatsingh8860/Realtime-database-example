import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final referenceDatabase = FirebaseDatabase.instance;
  final movieName = TextEditingController();
  var _moviesReference;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase();
    _moviesReference = database.reference().child('Movies');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final ref = referenceDatabase.reference();
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.04),
              child: TextFormField(
                controller: movieName,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  ref
                      .child("Movies")
                      .push()
                      .child("moviesName")
                      .set(movieName.text)
                      .asStream();
                  movieName.clear();
                },
                child: Text("Add")),
            Container(
              child: Flexible(
                  child: FirebaseAnimatedList(
                      shrinkWrap: true,
                      query: _moviesReference,
                      itemBuilder: ((BuildContext context,
                          DataSnapshot snapshot,
                          Animation<double> animation,
                          int index) {
                        return ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                _moviesReference.child(snapshot.key!).remove();
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          title: Text(snapshot.value['moviesName']),
                        );
                      }))),
            )
          ],
        ),
      ),
    ));
  }
}
