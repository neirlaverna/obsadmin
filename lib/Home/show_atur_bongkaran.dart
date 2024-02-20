
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowAturBongkaran extends StatefulWidget {
  final String idakun;
  final String nickname;
  final bool bongkaran1;
  final bool bongkaran2;

  const ShowAturBongkaran({
    Key? key,
    required this.idakun,
    required this.nickname,
    required this.bongkaran1,
    required this.bongkaran2,
  }) : super(key: key);

  @override
  State<ShowAturBongkaran> createState() => _ShowAturBongkaranState();
}

class _ShowAturBongkaranState extends State<ShowAturBongkaran> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _updateBongkaran1(bool newValue) async {
    try {
      var documents = await _firestore
          .collection('DaftarAkunHDI')
          .where('Bongkaran1', isEqualTo: true)
          .get();

      for (var document in documents.docs) {
        await document.reference.update({'Bongkaran1': false});
      }

      await _firestore
          .collection('DaftarAkunHDI')
          .where('Nickname', isEqualTo: widget.nickname)
          .where('IdAkun', isEqualTo: int.parse(widget.idakun))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          document.reference.update({'Bongkaran1': true});
        });
      });
    } catch (error) {}
  }

  void _updateBongkaran2(bool newValue) async {
    try {
      var documents = await _firestore
          .collection('DaftarAkunHDI')
          .where('Bongkaran2', isEqualTo: true)
          .get();

      for (var document in documents.docs) {
        await document.reference.update({'Bongkaran2': false});
      }

      await _firestore
          .collection('DaftarAkunHDI')
          .where('Nickname', isEqualTo: widget.nickname)
          .where('IdAkun', isEqualTo: int.parse(widget.idakun))
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          document.reference.update({'Bongkaran2': true});
        });
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 85,
                child: Column(
                  children: [Text(widget.idakun), Text(widget.nickname)],
                ),
              ),
              
              Container(
                width: 112,
                decoration: BoxDecoration(
                  gradient: widget.bongkaran1
                      ? null // Jika widget.bongkaran1 true, maka gradient null (transparan)
                      : const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 63, 34, 129),
                            Color.fromARGB(255, 26, 80, 82),
                            Color.fromARGB(255, 76, 29, 90),
                          ],
                        ),
                ),
                child: widget.bongkaran1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: 120,
                          child: Center(
                            child: Text(
                              'Bongkaran 1',
                              style: TextStyle(fontSize: 15 ,color: Colors.amberAccent),
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          _updateBongkaran1(false);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Push ID',
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              'Bongkaran 1',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
              ),
             
              Container(
                decoration: BoxDecoration(
                  gradient: widget.bongkaran2
                      ? null
                      : const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 63, 34, 129),
                            Color.fromARGB(255, 26, 80, 82),
                            Color.fromARGB(255, 76, 29, 90),
                          ],
                        ),
                ),
                child: widget.bongkaran2
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: 110,
                          child: Center(
                            child: Text(
                              'Bongkaran 2',
                              style: TextStyle(fontSize: 15 ,color: Colors.amberAccent),
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          _updateBongkaran2(false);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Push ID',
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              'Bongkaran 2',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
