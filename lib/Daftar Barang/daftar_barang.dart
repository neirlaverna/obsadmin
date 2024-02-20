
import 'package:desktopadmin/Daftar%20Barang/daftar_akun.dart';

import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Main/header.dart';
import 'package:flutter/material.dart';


class ProductScreen extends StatefulWidget {
  

  const ProductScreen({super.key,});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultpadding),
          child: Column(
            children: [
              Header(
                title: 'Daftar Barang',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: Row(
                  children: [
                    const DaftarAkunHiggs(),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 548,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      
    );
  }
}


