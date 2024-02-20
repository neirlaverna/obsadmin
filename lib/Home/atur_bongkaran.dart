import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/Home/show_atur_bongkaran.dart';
import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Services/responsive.dart';

import 'package:flutter/material.dart';

class AturBongkaran extends StatefulWidget {
  const AturBongkaran({
    super.key,
  });

  @override
  State<AturBongkaran> createState() => _AturBongkaranState();
}

class _AturBongkaranState extends State<AturBongkaran> {
  String searchText = '';
  bool isSearching = false;

  void _searchData() {
    setState(() {
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: Responsive.isDesktop(context)?2:3,
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white38),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Atur akun Bongkaran'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari ID atau Nickname...',
                    hintStyle: const TextStyle(fontSize: 12),
                    fillColor: secondaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('DaftarAkunHDI')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(
                        child: Text('No HDI Account available.'),
                      );
                    }

                    var Akun = snapshot.data!.docs;

                    if (Akun.isEmpty) {
                      return const Center(
                        child: Text('Data kosong.'),
                      );
                    }

                    var filteredData = Akun.where((doc) {
                      var docData = doc.data() as Map<String, dynamic>;
                      return docData.toString().contains(searchText);
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: filteredData
                          .length, // Ganti Akun.length dengan filteredData.length
                      itemBuilder: (BuildContext context, int index) {
                        var document = filteredData[
                            index]; // Ganti Akun dengan filteredData
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        return ShowAturBongkaran(
                          nickname: data['Nickname'] ?? 'Null',
                          idakun: data['IdAkun'].toString(),
                          bongkaran1: data['Bongkaran1'] ?? false,
                          bongkaran2: data['Bongkaran2'] ?? false,
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
