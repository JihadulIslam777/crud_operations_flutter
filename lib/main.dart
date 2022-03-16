import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan),
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? studentName, studentId, studyProgramId;
  double? studentGpa;

  getStudentName(name) {
    this.studentName = name;
  }

  getStudentId(id) {
    this.studentId = id;
  }

  getProgramId(programId) {
    this.studyProgramId = programId;
  }

  getStudentGpa(gpa) {
    this.studentGpa = double.parse(gpa);
  }

  createData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students = {
      'studentName': studentName,
      'studentId': studentId,
      'studyProgramId': studyProgramId,
      'studentGpa': studentGpa,
    };

    documentReference.set(students).whenComplete(() {
      print('$studentName created');
    });
  }

  readData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    documentReference.get().then((dataSnapshot) {
      print(dataSnapshot.get('studentName'));
      print(dataSnapshot.get('studentId'));
      print(dataSnapshot.get('studyProgramId'));
      print(dataSnapshot.get('studentGpa'));
    });
  }

  updateData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students = {
      'studentName': studentName,
      'studentId': studentId,
      'studyProgramId': studyProgramId,
      'studentGpa': studentGpa,
    };

    documentReference.set(students).whenComplete(() {
      print('$studentName updated');
    });
  }

  deleteData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    documentReference.delete().whenComplete(() {
      print('$studentName deleted');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flutter College'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (String name) {
                  getStudentName(name);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Student Id',
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (String id) {
                  getStudentId(id);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Study Program Id',
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (String programId) {
                  getProgramId(programId);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'GPA',
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (String gpa) {
                  getStudentGpa(gpa);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    createData();
                  },
                  child: const Text('Create'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () {
                    readData();
                  },
                  child: const Text('Read'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                  onPressed: () {
                    updateData();
                  },
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    deleteData();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                textDirection: TextDirection.ltr,
                children: const [
                  Expanded(
                    child: Text('Student Name'),
                  ),
                  Expanded(
                    child: Text('Student Id'),
                  ),
                  Expanded(
                    child: Text('Program Id'),
                  ),
                  Expanded(
                    child: Text('GPA'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('MyStudents')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(documentSnapshot['studentName']),
                              ),
                              Expanded(
                                child: Text(documentSnapshot['studentId']),
                              ),
                              Expanded(
                                child: Text(documentSnapshot['studyProgramId']),
                              ),
                              Expanded(
                                child: Text(
                                    documentSnapshot['studentGpa'].toString()),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
