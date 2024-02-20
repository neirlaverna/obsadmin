import 'dart:async';

import 'package:desktopadmin/Services/constans.dart';
import 'package:desktopadmin/Services/firebase_services.dart';
import 'package:desktopadmin/Services/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:desktopadmin/Services/menucontroller.dart';

// ignore: must_be_immutable
class Header extends StatefulWidget {
  final String title;
  Header({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late Timer _timer;
  late StreamController<DateTime> _clockStreamController;

  @override
  void initState() {
    super.initState();
    _clockStreamController = StreamController<DateTime>();
    _updateTime();
  }

  void _updateTime() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Trigger a rebuild every second
      _clockStreamController.add(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _clockStreamController.close();
    super.dispose();
  }

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
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Column(
          children: [
            DateNTime(clockStreamController: _clockStreamController),
          ],
        ),
        ProfileCard(),
      ],
    );
  }
}

class DateNTime extends StatelessWidget {
  const DateNTime({
    super.key,
    required StreamController<DateTime> clockStreamController,
  }) : _clockStreamController = clockStreamController;

  final StreamController<DateTime> _clockStreamController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _clockStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String formattedDate =
              DateFormat('dd/MM/yyyy').format(snapshot.data!);
          String formattedTime =
              DateFormat('HH:mm:ss').format(snapshot.data!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Tanggal : $formattedDate",
                style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 16,
                ),
              ),
              Text(
                "Jam : ${formattedTime.padLeft(8, '0')}",
                style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 16,
                ),
              ),
            ],
          );
        } else {
          return const Text("Loading...");
        }
      },
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
        future: FirebaseServiceAuth()
            .getUsernameByEmail(FirebaseAuth.instance.currentUser?.email ?? ""),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: defaultpadding / 21),
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
