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
  Future<String?> getUsernameByEmail(String email) async {
    try {
      QuerySnapshot usernameQuery = await FirebaseFirestore.instance
          .collection('DataKaryawan')
          .where('email', isEqualTo: email)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        Map<String, dynamic> data =
            usernameQuery.docs.first.data() as Map<String, dynamic>;

        if (data.containsKey('username')) {
          return data['username'] as String?;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class FirebaseServiceAdmin {
  Future<String?> getadminByEmail(String email) async {
    try {
      QuerySnapshot usernameQuery = await FirebaseFirestore.instance
          .collection('DataKaryawan')
          .where('email', isEqualTo: email)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        Map<String, dynamic> data =
            usernameQuery.docs.first.data() as Map<String, dynamic>;

        if (data.containsKey('admin')) {
          return data['admin'].toString();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

class FirebaseServiceSuperAdmin {
  Future<String?> getSuperadminByEmail(String email) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('SuperAdmin')
          .where('email', isEqualTo: email)
          .get();

      if (query.docs.isNotEmpty) {
        Map<String, dynamic> data = query.docs.first.data() as Map<String, dynamic>;

        if (data.containsKey('superadmin')) {
          String superadminValue = data['superadmin'].toString();
          return superadminValue;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}



