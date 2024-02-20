import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktopadmin/Daftar%20Barang/list_akun_hdi.dart';
import 'package:desktopadmin/Services/api_games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DaftarAkunHiggs extends StatefulWidget {
  const DaftarAkunHiggs({
    Key? key,
  }) : super(key: key);

  @override
  State<DaftarAkunHiggs> createState() => _DaftarAkunHiggsState();
}

class _DaftarAkunHiggsState extends State<DaftarAkunHiggs> {
  late bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 550,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(97, 255, 255, 255)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  const Text(
                    'Daftar Akun HDI',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 1,
                    width: double.maxFinite,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            ListAkun(),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.maxFinite,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 63, 34, 129),
                    Color.fromARGB(255, 26, 80, 82),
                    Color.fromARGB(255, 76, 29, 90),
                  ]),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _showAddAkun(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Tambahkan Akun'),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.add_circle_rounded)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addAkunToFirestore(
      String nickname, int idAkun, BuildContext context) async {
    try {
      CollectionReference akunCollection =
          FirebaseFirestore.instance.collection('DaftarAkunHDI');

      await akunCollection.add({
        'Nickname': nickname,
        'IdAkun': idAkun,
        'Bongkaran1': false,
        'Bongkaran2': false,
      });

      // ignore: use_build_context_synchronously
      _showTopLeftMessage(
          context,
          'Akun Berhasil Ditambahkan',
          const Icon(
            Icons.check_circle,
            color: Colors.blue,
          ));
    } catch (error) {
      // ignore: use_build_context_synchronously
      _showTopLeftMessage(
          context,
          'Terjadi Kesalahan ',
          const Icon(
            Icons.dangerous,
            color: Colors.red,
          ));
    }
  }

  void _showAddAkun(BuildContext context) {
    TextEditingController idController = TextEditingController();
    TextEditingController nicknameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: <Widget>[
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Tambah Akun',
                          style: TextStyle(
                              fontFamily: 'Libre',
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: idController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Masukkan ID',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: showError ? 'ID tidak boleh kosong' : null,
                          errorStyle: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: nicknameController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () async {
                              String userId = idController.text;
                              ApiGamesHiggs api = ApiGamesHiggs();
                              String username = await api.getUsername(userId);
                              nicknameController.text = username;
                              setState(() {
                                nicknameController.text = username;
                              });
                            },
                            icon: const Column(
                              children: [
                                Text(
                                  'Auto',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Icon(Icons.settings_backup_restore_outlined),
                              ],
                            ),
                          ),
                          labelText: 'Masukkan Nickname',
                          labelStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText:
                              showError ? 'Nickname tidak boleh kosong' : null,
                          errorStyle: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 63, 34, 129),
                            Color.fromARGB(255, 26, 80, 82),
                            Color.fromARGB(255, 76, 29, 90),
                          ]),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (idController.text.isNotEmpty &&
                                nicknameController.text.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BlurryModalProgressHUD(
                                    inAsyncCall: true,
                                    blurEffectIntensity: 4,
                                    progressIndicator:
                                        const SpinKitFadingCircle(
                                      color: Color.fromARGB(255, 151, 154, 170),
                                      size: 90.0,
                                    ),
                                    dismissible: false,
                                    opacity: 0.4,
                                    color: Colors.black87,
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  );
                                },
                                barrierDismissible: false,
                              );

                              await _addAkunToFirestore(
                                nicknameController.text,
                                int.parse(idController.text),
                                context,
                              );

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                showError = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Tambah'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.check_circle_outline)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color.fromARGB(131, 36, 16, 73),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white38)),
            child: Row(
              children: [
                icon,
                const SizedBox(
                  width: 10,
                ),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

