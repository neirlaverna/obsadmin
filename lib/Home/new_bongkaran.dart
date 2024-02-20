import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/Home/new_bongkarancard.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class NewBongkaran extends StatefulWidget {
  const NewBongkaran({
    Key? key,
  }) : super(key: key);

  @override
  State<NewBongkaran> createState() => _NewBongkaranState();
}

class _NewBongkaranState extends State<NewBongkaran> {
  late js.JsObject state;
  String title = 'Testing';
  bool isDataChanged = false;
  List<String> previousData = [];

  @override
  void initState() {
    state = js.JsObject.fromBrowserObject(js.context['state']);
    state['counter'] = 0;

    super.initState();
  }

  void _incrementCounter() {
    state['title'] = "Ada Bongkaran baru";
    state['body'] = 'Segera proses Bongkaran';
    state['icon'] = "./icons/Icon-192.png";

    js.context.callMethod('showNotification');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            height: 450,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 5),
                  child: Text(
                    'Bongkaran Perlu Diproses',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Transaction')
                      .orderBy('status')
                      .orderBy('Tanggal', descending: true)
                      .orderBy('jam', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No Bongkaran history available.'),
                      );
                    }

                    var Bongkarans = snapshot.data!.docs;
                    var filteredBongkarans =
                        Bongkarans.where((doc) => doc['status'] != 'Selesai!')
                            .where((doc) => doc['Produk'] == 'Bongkaran')
                            .toList();

                    if (filteredBongkarans.isEmpty) {
                      return const Center(
                        child: Text('Data kosong.'),
                      );
                    }
                    Future.microtask(() {
                      var currentData =
                          Bongkarans.map((doc) => doc.id).toList();

                      if (!listEquals(previousData, currentData)) {
                        for (int i = 0; i < currentData.length; i++) {
                          var document = Bongkarans.firstWhere(
                              (doc) => doc.id == currentData[i]);

                          if (!previousData.contains(currentData[i]) &&
                              document['status'] == 'Belum diproses') {
                            _incrementCounter();

                            break;
                          }
                        }

                        previousData = List<String>.from(currentData);
                      } else {}
                    });

                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: filteredBongkarans.length,
                      itemBuilder: (BuildContext context, int index) {
                        var document = filteredBongkarans[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        return NewBongkaranCard(
                          branch: data['Cabang'] ?? 'N/A',
                          agen: data['Agen'] ?? 'N/A',
                          produk: data['Produk'] ?? 'N/A',
                          idpenerima: data['idPenerima']?.toString() ?? 'N/A',
                          nicknamepelanggan: data['nickname'] ?? 'N/A',
                          totalharga: data['totalHarga'] ?? 'N/A',
                          jam: data['jam'] ?? 'N/A',
                          tanggal: data['Tanggal'] ?? 'N/A',
                          jenistransaksi: data['jenistransaksi'] ?? 'N/A',
                          status: data['status'] ?? 'N/A',
                          hargabongkar: data['hargabongkar'] ?? 0,
                          jumlahbongkar: data['jumlahbongkar'] ?? 0,
                          nickpenerima: data['nickpenerima'] ?? 'N/A',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      
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
}
