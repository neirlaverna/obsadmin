import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/newtransactioncard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NewTransaction extends StatelessWidget {
 final flutterLocalNotificationsPlugin;

  const NewTransaction({
    Key? key, required this.flutterLocalNotificationsPlugin
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaksi Perlu diproses',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(8),
            height: 500,
            decoration: BoxDecoration(
              border: Border.symmetric(vertical: BorderSide(color: Colors.grey)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Transaction')
                  .orderBy('status')
                  .orderBy('Tanggal', descending: true)
                  .orderBy('jam', descending: true)
                  .where('status', isNotEqualTo: 'Selesai!')
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

                if (transactions.isEmpty) {
                  return const Center(
                    child: Text('Data kosong.'),
                  );
                }
                showNotification();

                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    var document = transactions[index];
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

    Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Transaction',
      'There is a new transaction that needs attention!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
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

