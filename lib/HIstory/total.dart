import 'package:flutter/material.dart';
import 'package:desktopadmin/Services/responsive.dart';

class Total extends StatefulWidget {
  Total({Key? key, required this.total}) : super(key: key);

  final String total;

  @override
  State<Total> createState() => _TotalState();
}

class _TotalState extends State<Total> {
  String gettotaltampil(String total) {
    String totalhasil = '';
    if (Responsive.isDesktop(context)) {
      totalhasil = 'Total : $total';
    } else {
      totalhasil = total;
    }
    return totalhasil;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      gettotaltampil(widget.total),
      style: const TextStyle(
          fontFamily: 'rsr', fontSize: 15, fontWeight: FontWeight.bold),
    );
  }
}
