import 'package:flutter/material.dart';

class HeaderHistoryIncome extends StatelessWidget {
  const HeaderHistoryIncome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Jam',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Tanggal',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('User',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text(
            'Admin',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Cabang',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Produk',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Variasi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('ID Pelanggan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Nickname',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Jumlah',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Jenis Transaksi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text('Total Harga',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 130,
          child: Center(
              child: Text(
            'Status',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
        ),
      ],
    );
  }
}

class HeaderHistoryOutcome extends StatelessWidget {
  const HeaderHistoryOutcome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Jam',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Tanggal',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('User',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text(
            'Admin',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Cabang',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Produk',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Nick Pelanggan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('ID Penerima',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Nick Penerima',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Jumlah Bongkar',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Jenis Transaksi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text('Total Harga',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ),
        SizedBox(
          width: 140,
          child: Center(
              child: Text(
            'Status',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
        ),
      ],
    );
  }
}
