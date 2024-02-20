
import 'package:desktopadmin/HIstory/data_list_outcome.dart';
import 'package:desktopadmin/HIstory/header_history.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:tuple/tuple.dart';
import 'package:desktopadmin/Services/constans.dart';

class OutcomeHistoryListPage extends StatefulWidget {
  final DateTime? selectedDate;

  const OutcomeHistoryListPage({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _OutcomeHistoryListPageState createState() => _OutcomeHistoryListPageState();
}

class _OutcomeHistoryListPageState extends State<OutcomeHistoryListPage> {
  bool sortAscending = true;
  bool isSearching = false;
  String searchText = '';
  bool isDragging = false;
  double totalPenghasilan = 0.0;

  @override
  void initState() {
    super.initState();
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Outcome History',
              style: TextStyle(
                  fontFamily: 'rsr', fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  height: 40,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari data...',
                      hintStyle: const TextStyle(fontSize: 12),
                      fillColor: secondaryColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _showSortDialog,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.sort_by_alpha_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Urutkan Data',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onVerticalDragDown: (_) {
              setState(() {
                isDragging = true;
              });
            },
            onVerticalDragEnd: (_) {
              setState(() {
                isDragging = false;
              });
            },
            onVerticalDragUpdate: (details) {
              double delta = details.primaryDelta ?? 0;

              _scrollController.jumpTo(
                _scrollController.position.pixels - delta,
              );
            },
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 12,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 680,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Transaction')
                          .where('Produk', isEqualTo: 'Bongkaran')
                          .where('Tanggal', isEqualTo: _getFormattedDate())
                          .orderBy('jam', descending: sortAscending)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text('No Outcome history available.'),
                          );
                        }

                        var Outcomes = snapshot.data!.docs;

                        if (Outcomes.isEmpty) {
                          return const Center(
                            child: Text('Data kosong.'),
                          );
                        }

                        var filteredData = Outcomes.where((doc) {
                          var docData = doc.data() as Map<String, dynamic>;
                          return docData.toString().contains(searchText);
                        }).toList();

                        var result = calculateTotalAndData(filteredData);

                        int totalHarga =
                            filteredData.fold(0, (int previousValue, doc) {
                          var docData = doc.data() as Map<String, dynamic>;
                          return int.parse(
                              (previousValue + (docData['totalHarga'] ?? 0))
                                  .toString());
                        });

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Total Outcome : ${formatCurrency2(totalHarga.toDouble())}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'rsr',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const HeaderHistoryOutcome(),
                                  const Divider(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: result.item2.map(
                                          (doc) {
                                            var docData = doc.data()
                                                as Map<String, dynamic>;

                                            return DataListViewOutcome(
                                              jam: docData['jam'] ?? 'kosong',
                                              tanggal: docData['Tanggal'] ??
                                                  'kosong',
                                              user: docData['Agen'] ?? 'kosong',
                                              cabang:
                                                  docData['branch'] ?? 'kosong',
                                              produk:
                                                  docData['Produk'] ?? 'kosong',
                                              jumlah:
                                                  docData['jumlahbongkar'] ?? 0,
                                              jenistransaksi:
                                                  docData['jenistransaksi'] ??
                                                      'kosong',
                                              total: docData['totalHarga'] ?? 0,
                                              status:
                                                  docData['status'] ?? 'kosong',
                                              width: 140.0,
                                              admin:
                                                  docData['admin'] ?? 'kosong',
                                              nicknamepelanggan:
                                                  docData['nickname'] ??
                                                      'kosong',
                                              idpenerima:
                                                  docData['idPenerima'] ??
                                                      'kosong',
                                              nicknamepenerima:
                                                  docData['nickpenerima'] ??
                                                      'kosong',
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Tuple2<double, List<DocumentSnapshot>> calculateTotalAndData(
      List<DocumentSnapshot> data) {
    double total = 0.0;
    List<DocumentSnapshot> filteredData = [];

    for (var doc in data) {
      var docData = doc.data() as Map<String, dynamic>;
      if (docData.toString().contains(searchText)) {
        filteredData.add(doc);
        total += docData['totalHarga'] ?? 0.0;
      }
    }

    return Tuple2(total, filteredData);
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih urutan data'),
          children: [
            _buildSortDialogOption('Terbaru', true),
            _buildSortDialogOption('Terlama', false),
          ],
        );
      },
    );
  }

  Widget _buildSortDialogOption(String order, bool ascending) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          sortAscending = ascending;
        });
      },
      child: Text(order),
    );
  }

  double calculateTotal(List<DocumentSnapshot> data) {
    double total = 0.0;

    for (var doc in data) {
      var docData = doc.data() as Map<String, dynamic>;
      total += docData['totalHarga'] ?? 0.0;
    }

    return total;
  }

  String formatCurrency2(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );

    return formatter.format(amount).replaceAll(",00", "");
  }

  String _getFormattedDate() {
    return widget.selectedDate != null
        ? '${widget.selectedDate!.day.toString().padLeft(2, '0')}-${widget.selectedDate!.month.toString().padLeft(2, '0')}-${widget.selectedDate!.year}'
        : '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';
  }
}
