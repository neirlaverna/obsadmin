import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataListViewOutcome extends StatefulWidget {
  final double width;
  final String jam;
  final String tanggal;
  final String user;
  final String cabang;
  final String produk;
  final String nicknamepelanggan;
  final String idpenerima;
  final String nicknamepenerima;
  final int jumlah;
  final String jenistransaksi;
  final int total;
  final String status;
  final String admin;

  const DataListViewOutcome({
    super.key,
    required this.jam,
    required this.tanggal,
    required this.user,
    required this.cabang,
    required this.produk,
    required this.jumlah,
    required this.jenistransaksi,
    required this.total,
    required this.status,
    required this.width,
    required this.admin,
    required this.nicknamepelanggan,
    required this.idpenerima,
    required this.nicknamepenerima,
  });

  @override
  State<DataListViewOutcome> createState() => _DataListViewOutcomeState();
}

class _DataListViewOutcomeState extends State<DataListViewOutcome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:
              Border.symmetric(horizontal: BorderSide(color: Colors.white38))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.jam)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.tanggal)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.user)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.admin)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.cabang)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.produk)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.nicknamepelanggan)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.idpenerima)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.nicknamepenerima)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(formatVariasi(widget.jumlah))),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text(widget.jenistransaksi)),
          ),
          SizedBox(
            width: widget.width,
            child: Center(child: Text('Rp. ${formatCurrency(widget.total)}')),
          ),
          SizedBox(
            width: widget.width,
            child: Center(
                child: Text(
              widget.status,
              style: TextStyle(color: _getStatusColor(widget.status)),
            )),
          ),
        ],
      ),
    );
  }

  String formatCurrency(int value) {
    if (value != 0) {
      NumberFormat currencyFormatter =
          NumberFormat.currency(locale: 'id_ID', symbol: '');
      return currencyFormatter.format(value).replaceAll(",00", "");
    } else {
      return 'N/A';
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

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Belum diproses':
        return Color.fromARGB(255, 244, 54, 54);
      case 'Diproses':
        return Color.fromARGB(255, 255, 235, 59);
      case 'Selesai!':
        return Color.fromARGB(255, 43, 128, 255);
      default:
        return Colors.white;
    }
  }
}
