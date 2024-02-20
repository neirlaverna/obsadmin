
import 'package:desktopadmin/HIstory/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desktopadmin/Branch/branchscreen.dart';
import 'package:desktopadmin/Home/dashboardscreen.dart';

import 'package:desktopadmin/Services/menucontroller.dart';
import 'package:desktopadmin/Precense/presencescreen.dart';
import 'package:desktopadmin/Register/register_screen.dart';
import 'package:desktopadmin/Services/responsive.dart';
import 'package:desktopadmin/Main/sidemenu.dart';
import 'package:desktopadmin/Daftar%20Barang/daftar_barang.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentPage = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        onPageSelected: (page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(onPageSelected: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                }),
              ),
            Expanded(
              flex: 5,
              child: _buildCurrentPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case 'dashboard':
        return DashboardScreen();
      case 'cart':
        return ProductScreen(); 
      case 'register':
        return RegisterScreen(); 
      case 'History':
        return HistoryScreen(); 
      case 'branch':
        return BranchScreen(); 
      case 'presence':
        return PresenceScreen(); 
      default:
        return DashboardScreen();
    }
  }
}
