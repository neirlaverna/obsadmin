import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService {
  final CollectionReference hargaCollection =
      FirebaseFirestore.instance.collection('harga');

  Future<int> getPrice(String jenisChip, int totalChip) async {
    try {
      DocumentSnapshot docSnapshot = await hargaCollection.doc(jenisChip).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        int harga = 0;

        while (totalChip > 0) {
          if (data.containsKey(totalChip.toString())) {
            harga += (data[totalChip.toString()] as int);
            break;
          } else {
            int lowerKey = 0;

            for (var key in data.keys) {
              int currentKey = int.parse(key);
              if (currentKey < totalChip && currentKey > lowerKey) {
                lowerKey = currentKey;
              }
            }

            if (lowerKey > 0) {
              harga += (data[lowerKey.toString()] as int);
              totalChip -= lowerKey;
            } else {
              break;
            }
          }
        }


        return harga;
      } else {

        return 0;
      }
    } catch (e) {

      return 0;
    }
  }
}


class FirebaseServiceAuth {
  final CollectionReference karyawanCollection =
      FirebaseFirestore.instance.collection('DataKaryawan');

  Future<String?> getUsernameByEmail(String email) async {
    try {
      DocumentSnapshot docSnapshot = await karyawanCollection.doc(email).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        return data['username'];
      } else {
        
        return null;
      }
    } catch (e) {
      

      return null;
    }
  }
}

