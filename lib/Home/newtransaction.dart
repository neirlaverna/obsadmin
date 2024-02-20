import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/Home/newtransactioncard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class NewTransaction extends StatefulWidget {
  const NewTransaction({
    Key? key,
  }) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
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
    state['title'] = "Ada pesanan baru";
    state['body'] =  'Segera proses pesanan';
    state['icon'] = "./icons/Icon-192.png";

    js.context.callMethod('showNotification');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaksi Perlu diproses',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(5),
            height: 450,
            decoration: BoxDecoration(
              border:
                  Border.symmetric(vertical: BorderSide(color: Colors.grey)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: StreamBuilder<QuerySnapshot>(
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
                    child: Text('No transaction history available.'),
                  );
                }

                var transactions = snapshot.data!.docs;
                var filteredTransactions = transactions
                    .where((doc) => doc['status'] != 'Selesai!')
                    .where((doc) => doc['Produk'] != 'Bongkaran') 
                    .toList();

                if (filteredTransactions.isEmpty) {
                  return const Center(
                    child: Text('Data kosong.'),
                  );
                }
                Future.microtask(() {
                  var currentData = transactions.map((doc) => doc.id).toList();

                  if (!listEquals(previousData, currentData)) {
                    for (int i = 0; i < currentData.length; i++) {
                      var document = transactions
                          .firstWhere((doc) => doc.id == currentData[i]);

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
                  itemCount: filteredTransactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    var document = filteredTransactions[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                        

                    return NewTransactionsCard(
                      branch: data['Cabang'] ?? 'N/A',
                      agen: data['Agen'] ?? 'N/A',
                      produk: data['Produk'] ?? 'N/A',
                      idpelanggan: data['idPelanggan']?.toString() ?? 'N/A',
                      nicknamepelanggan: data['nickname'] ?? 'N/A',
                      totalharga: data['totalHarga'] ?? 'N/A',
                      jampembelian: data['jam'] ?? 'N/A',
                      tanggalpembelian: data['Tanggal'] ?? 'N/A',
                      variasi: formatVariasi(data['Variasi']),
                      jumlahbeli: data['Jumlahbeli'].toString(),
                      jenistransaksi: data['jenistransaksi'] ?? 'N/A',
                      status: data['status'] ?? 'N/A',
                    );
                  },
                );
              },
            ),
          ),
        ],
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
}
