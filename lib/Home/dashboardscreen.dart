import 'package:desktopadmin/Home/atur_bongkaran.dart';
import 'package:desktopadmin/Home/new_bongkaran.dart';
import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Main/header.dart';
import 'package:desktopadmin/Home/newtransaction.dart';
import 'package:flutter/material.dart';
import 'package:desktopadmin/Services/responsive.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultpadding / 2),
        child: Column(
          children: [
            Header(title: 'Home'),
            const NewTransaction(),
            SizedBox(
              height: 10,
            ),
            if (!Responsive.isDesktop(context))
              
                NewBongkaran(),
              
            Row(
              children: [
                AturBongkaran(),
                SizedBox(width: 5,),
                if (Responsive.isDesktop(context))
                  Expanded(
                    flex: Responsive.isTablet(context)? 6 : 4,
                    child: NewBongkaran(),
                  )
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
