import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowAkun extends StatefulWidget {
  final String nickname;
  final String idakun;

  const ShowAkun({
    Key? key,
    required this.nickname,
    required this.idakun,
  }) : super(key: key);

  @override
  State<ShowAkun> createState() => _ShowAkunState();
}

class _ShowAkunState extends State<ShowAkun> {
  void _showDeleteDialog(BuildContext context, String idakun, String nickname) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Row(
          children: [
            Text(
              'Hapus akun ',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
            Text("$idakun $nickname", style: TextStyle(fontSize: 16),),
            Text(
              ' dari daftar?',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _deleteAkun(idakun);
              Navigator.of(context).pop();
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

  Future<void> _deleteAkun(String idakun) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return BlurryModalProgressHUD(
            inAsyncCall: true,
            blurEffectIntensity: 4,
            progressIndicator: const SpinKitFadingCircle(
              color: Color.fromARGB(255, 151, 154, 170),
              size: 90.0,
            ),
            dismissible: false,
            opacity: 0.4,
            color: Colors.black87,
            child: Container(
              color: Colors.transparent,
            ),
          );
        },
      );

      await FirebaseFirestore.instance
          .collection('DaftarAkunHDI')
          .where('IdAkun', isEqualTo: int.parse(widget.idakun))
          .where('Nickname', isEqualTo: widget.nickname)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      Navigator.of(context).pop();
      // ignore: empty_catches
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(117, 158, 158, 158)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SizedBox(
                width: 180,
                child: Text(
                  widget.nickname,
                ),
              ),
              Text('${widget.idakun}'),
              Spacer(),
              IconButton(
                onPressed: () {
                  _showDeleteDialog(context, widget.idakun, widget.nickname);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
