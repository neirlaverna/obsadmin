import 'package:desktopadmin/Login/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
    required this.onPageSelected,
  }) : super(key: key);

  final void Function(String) onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(child: Text('Admin App')),
            ),
            DrawerListTile(
              title: 'Dashboard',
              icon: Icons.dashboard,
              press: () {
                onPageSelected('dashboard');
              },
            ),
            DrawerListTile(
              title: 'Daftar Barang',
              icon: Icons.shopping_cart,
              press: () {
                onPageSelected('cart');
              },
            ),
            DrawerListTile(
              title: 'Karyawan',
              icon: Icons.family_restroom,
              press: () {
                onPageSelected('register');
              },
            ),
            DrawerListTile(
              title: 'Transaction History',
              icon: Icons.currency_exchange,
              press: () {
                onPageSelected('History');
              },
            ),
            
            DrawerListTile(
              title: 'Daftar Cabang',
              icon: Icons.business,
              press: () {
                onPageSelected('branch');
              },
            ),
            DrawerListTile(
              title: 'Absensi Karyawan',
              icon: Icons.attachment_rounded,
              press: () {
                onPageSelected('presence');
              },
            ),
            Divider(
              color: Colors.white10,
            ),
            DrawerListTile(
              title: 'LogOut',
              icon: Icons.logout_rounded,
              press: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Handle logout error if needed
    }
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 15.0,
      leading: Icon(
        icon,
      ),
      title: Text(title),
    );
  }
}
