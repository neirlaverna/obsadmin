import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/Services/firebase_services.dart';
import 'package:desktopadmin/Services/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewBongkaranCard extends StatefulWidget {
  final String agen;
  final String produk;
  final String tanggal;
  final int hargabongkar;
  final String idpenerima;
  final String jam;
  final String jenistransaksi;
  final int jumlahbongkar;
  final String nicknamepelanggan;
  final String nickpenerima;
  final String status;
  final String branch;
  final int totalharga;

  const NewBongkaranCard({
    Key? key,
    required this.agen,
    required this.produk,
    required this.tanggal,
    required this.hargabongkar,
    required this.idpenerima,
    required this.jam,
    required this.jenistransaksi,
    required this.jumlahbongkar,
    required this.nicknamepelanggan,
    required this.nickpenerima,
    required this.status,
    required this.totalharga,
    required this.branch,
  }) : super(key: key);

  @override
  State<NewBongkaranCard> createState() => _NewBongkaranCardState();
}

class _NewBongkaranCardState extends State<NewBongkaranCard> {

    late String username; 
  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    FirebaseServiceAuth firebaseServiceAuth = FirebaseServiceAuth();
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email != null) {
      String? retrievedUsername = await firebaseServiceAuth.getUsernameByEmail(email);
      setState(() {
        username = retrievedUsername ?? 'user';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (Responsive.isDesktop(context))
              Container(width: 70, child: Text(widget.jenistransaksi)),
            if (!Responsive.isMobile(context))
              SizedBox(
                width: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(widget.tanggal), Text(widget.jam)],
                ),
              ),
            if (!Responsive.isMobile(context))
              SizedBox(
                width: 100,
                child: Column(
                  children: [Text(widget.agen), Text(widget.branch)],
                ),
              ),
            SizedBox(
                width: 100,
                child: Text(
                  widget.produk,
                  textAlign: TextAlign.center,
                )),
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Ke Akun'),
                      Icon(Icons.arrow_downward, size: 15,)
                    ],
                  ),
                  Text(widget.nickpenerima),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Center(child: Text(widget.idpenerima)),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text('Pengirim'),
                    Icon(Icons.arrow_downward, size: 15,)
                  ],

                ),
                Text(widget.nicknamepelanggan)
              ],

            ),
            SizedBox(
              width: 80,
              child: Column(
                children: [
                  Text(formatVariasi(widget.jumlahbongkar)),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text('x ${formatCurrency(widget.hargabongkar)}'),
                ],
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(
                  width: 120, child: Text('Rp. ${formatCurrency(widget.totalharga)}')),
            Container(
              width: Responsive.isMobile(context) ? 95 : 130,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(widget.status),
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  if (widget.status == 'Belum diproses') {
                    updateTransactionData(context, widget.jam, widget.nicknamepelanggan, widget.jumlahbongkar);
                  } else if (widget.status == 'Diproses') {
                    _handleConfirmation(context, widget.jam, widget.nicknamepelanggan, widget.jumlahbongkar);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Responsive.isMobile(context) ? 0 : 15),
                  child: Text(
                    widget.status == 'Belum diproses' ? 'Proses' : 'Selesaikan',
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: Responsive.isMobile(context) ? 9 : 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    String formatVariasi(dynamic variasi) {
    if (variasi is int) {
      if (variasi >= 1000) {
        double billion = variasi / 1000.0;
        String formattedValue = billion.toStringAsFixed(1);
        return formattedValue.endsWith('.0')
            ? '${billion.toInt()} B'
            : '$formattedValue B';
      } else {
        return '$variasi M';
      }
    } else {
      return 'N/A';
    }
  }

  void _handleConfirmation(BuildContext context, String time, String nickname, int jumlahbongkar) async {
    bool? success = await _showConfirmationDialog(context);

    if (success!) {
      // ignore: use_build_context_synchronously
      updateTransactionData2(context, time, nickname, jumlahbongkar);
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Belum diproses':
        return const Color.fromARGB(179, 244, 67, 54);
      case 'Diproses':
        return const Color.fromARGB(141, 255, 235, 59);
      default:
        return Colors.black;
    }
  }

  void updateTransactionData(
      BuildContext context, String time, String nick, int jumlahbongkar) async {
    try {
      CollectionReference Bongkaran =
          FirebaseFirestore.instance.collection('Transaction');

      QuerySnapshot querySnapshot =
          await Bongkaran.where('jam', isEqualTo: time)
              .where('nickname', isEqualTo: nick)
              .where('jumlahbongkar', isEqualTo: jumlahbongkar)
              .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await Bongkaran.doc(doc.id).update({
          'status': 'Diproses',
          'admin' : username,
        });

        _showTopLeftMessage(
            context,
            'Segera proses transaksi!',
            Icon(
              Icons.error_outlined,
              color: Colors.yellow,
            ));
      }
    } catch (error) {
      _showTopLeftMessage(
          context,
          'Segera proses transaksi!',
          Icon(
            Icons.error_outlined,
            color: Colors.red,
          ));
    }
  }

  void updateTransactionData2(
      BuildContext context, String time, String nickname, int jumlahbongkar) async {
    try {
      CollectionReference Bongkaran =
          FirebaseFirestore.instance.collection('Transaction');

      QuerySnapshot querySnapshot =
          await Bongkaran.where('jam', isEqualTo: time)
              .where('nickname', isEqualTo: nickname)
              .where('jumlahbongkar', isEqualTo: jumlahbongkar)
              .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await Bongkaran.doc(doc.id)
            .update({'status': 'Selesai!', 'admin': username});

        _showTopLeftMessage(
            context,
            'Transaksi Selesai!',
            Icon(
              Icons.check_circle,
              color: Colors.blue,
            ));
      }
    } catch (error) {}
  }

  String formatCurrency(dynamic value) {
    if (value is num) {
      NumberFormat currencyFormatter =
          NumberFormat.currency(locale: 'id_ID', symbol: '');
      return currencyFormatter.format(value).replaceAll(",00", "");
    } else {
      return 'N/A';
    }
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Pastikan barang telah diterima!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Selesaikan!'),
            ),
          ],
        );
      },
    );
  }

  void _showTopLeftMessage(BuildContext context, String message, Icon icon) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 130,
        right: 30,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Color.fromARGB(131, 36, 16, 73),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white38)),
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: 10,
                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
