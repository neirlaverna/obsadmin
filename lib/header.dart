import 'package:desktopadmin/constans.dart';
import 'package:desktopadmin/firebase_services.dart';
import 'package:desktopadmin/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desktopadmin/menucontroller.dart';


class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Home",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
       
        ProfileCard(),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultpadding),
      decoration: BoxDecoration(
          color: secondaryColor,
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.symmetric(
          horizontal: defaultpadding, vertical: defaultpadding / 2),
      child: FutureBuilder<String?>(
        future: FirebaseServiceAuth().getUsernameByEmail(
            FirebaseAuth.instance.currentUser?.email ?? ""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
           
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle jika terjadi kesalahan
            return Text('Error: ${snapshot.error}');
          } else {
            // Tampilkan username jika data sudah tersedia
            String username = snapshot.data ?? "Username";
            return Row(
              children: [
                const Icon(
                  Icons.supervised_user_circle,
                  size: 40,
                ),
                SizedBox(width: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultpadding / 21),
                  child: Text(username),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

class Searchfield extends StatelessWidget {
  const Searchfield({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari...',
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: defaultpadding / 2),
            padding: EdgeInsets.all(defaultpadding * 0.75),
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
