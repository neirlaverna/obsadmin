import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/Services/firebase_services.dart';
import 'package:desktopadmin/Services/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactionsCard extends StatefulWidget {
  final String idpelanggan;
  final String nicknamepelanggan;
  final String agen;
  final String branch;
  final String jampembelian;
  final String tanggalpembelian;
  final String produk;
  final String variasi;
  final String jumlahbeli;
  final double totalharga;
  final String jenistransaksi;
  final String status;

  const NewTransactionsCard({
    Key? key,
    required this.produk,
    required this.idpelanggan,
    required this.nicknamepelanggan,
    required this.totalharga,
    required this.jampembelian,
    required this.tanggalpembelian,
    required this.variasi,
    required this.jumlahbeli,
    required this.jenistransaksi,
    required this.agen,
    required this.branch,
    required this.status,
  }) : super(key: key);

  @override
  State<NewTransactionsCard> createState() => _NewTransactionsCardState();
}

class _NewTransactionsCardState extends State<NewTransactionsCard> {
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
            if (!Responsive.isMobile(context))
              Container(width: 65, child: Text(widget.jenistransaksi)),
            if (!Responsive.isMobile(context))
              SizedBox(
                width: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(widget.tanggalpembelian), Text(widget.jampembelian)],
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
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.nicknamepelanggan),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(child: Text(widget.idpelanggan)),
                          IconButton(
                            onPressed: () {
                              FlutterClipboard.copy(widget.idpelanggan).then((value) {
                                _showTopLeftMessage(
                                    context,
                                    'ID disalin ${widget.idpelanggan}',
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                      
                                    ));
                              });
                            },
                            icon: Icon(Icons.copy),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            SizedBox(
              width: 80,
              child: Column(
                children: [
                  Text(widget.variasi),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text('x ${widget.jumlahbeli}'),
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
                    updateTransactionData(context, widget.jampembelian, widget.idpelanggan);
                  } else if (widget.status == 'Diproses') {
                    _handleConfirmation(context, widget.jampembelian, widget.idpelanggan);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context)? 0 : 15),
                  child: Text(
                    widget.status == 'Belum diproses' ? 'Proses' : 'Selesaikan', style: TextStyle(fontFamily: 'Kanit' ,fontSize: Responsive.isMobile(context)? 9 :16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleConfirmation(BuildContext context, String time, String id) async {
    bool? success = await _showConfirmationDialog(context);

    if (success!) {
      // ignore: use_build_context_synchronously
      updateTransactionData2(context, time, id);
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
      BuildContext context, String time, String id) async {
    try {
      CollectionReference transactions =
          FirebaseFirestore.instance.collection('Transaction');

      QuerySnapshot querySnapshot = await transactions
          .where('jam', isEqualTo: time)
          .where('idPelanggan', isEqualTo: id)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await transactions.doc(doc.id).update({
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
      BuildContext context, String time, String id) async {
    try {
      CollectionReference transactions =
          FirebaseFirestore.instance.collection('Transaction');

      QuerySnapshot querySnapshot = await transactions
          .where('jam', isEqualTo: time)
          .where('idPelanggan', isEqualTo: id)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await transactions.doc(doc.id).update({
          'status': 'Selesai!', 'admin' : username
        });

        _showTopLeftMessage(
            context,
            'Transaksi Selesai!',
            Icon(
              Icons.check_circle,
              color: Colors.blue,
            ));
      }
    } catch (error) {

    }
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
          content: Text('Pastikan barang telah dikirim!'),
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
