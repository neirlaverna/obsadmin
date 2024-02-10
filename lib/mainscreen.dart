import 'package:desktopadmin/branchscreen.dart';
import 'package:desktopadmin/dashboardscreen.dart';
import 'package:desktopadmin/historyscreen.dart';
import 'package:desktopadmin/menucontroller.dart';
import 'package:desktopadmin/presencescreen.dart';
import 'package:desktopadmin/registerscreen.dart';
import 'package:desktopadmin/responsive.dart';
import 'package:desktopadmin/sidemenu.dart';
import 'package:desktopadmin/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

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
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(onPageSelected: (page) {}),
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
  
      case 'transaction':
        return TransactionScreen(); 
      case 'register':
        return RegisterScreen(); 
      case 'history':
        return HistoryScreen();
      case 'branch':
        return BranchScreen(); 
      case 'pesence':
        return PresenceScreen(); 
      default:
        return DashboardScreen(); 
    }
  }
}
