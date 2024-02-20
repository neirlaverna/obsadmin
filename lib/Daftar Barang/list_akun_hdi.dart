import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/Daftar%20Barang/show_akun_list.dart';
import 'package:desktopadmin/Services/constans.dart';
import 'package:flutter/material.dart';

class ListAkun extends StatefulWidget {
  const ListAkun({
    Key? key,
  });

  @override
  State<ListAkun> createState() => _ListAkunState();
}

class _ListAkunState extends State<ListAkun> {
  String searchText = '';
  bool isSearching = false;

  // Tambahkan method _searchData
  void _searchData() {
    setState(() {
      isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(
          height: 350,
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('DaftarAkunHDI').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                // Ganti Akun dengan filteredData
                var filteredData = Akun.where((doc) {
                  var docData = doc.data() as Map<String, dynamic>;
                  return docData.toString().contains(searchText);
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: filteredData.length,  // Ganti Akun.length dengan filteredData.length
                  itemBuilder: (BuildContext context, int index) {
                    var document = filteredData[index];  // Ganti Akun dengan filteredData
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    return ShowAkun(
                      nickname: data['Nickname'] ?? 'Null',
                      idakun: data['IdAkun'].toString(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
