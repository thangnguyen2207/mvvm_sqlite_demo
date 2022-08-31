import 'package:flutter/material.dart';
import 'package:mvvm_sqlite_demo/ui/major/major_screen.dart';
import 'package:mvvm_sqlite_demo/ui/settings/setting_screen.dart';
import 'package:mvvm_sqlite_demo/ui/student/student_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Color.fromARGB(255, 84, 171, 243)]
              )
            ),
            child: Stack(
              children: const [
                Align(
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    radius: 45,
                  )
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Student Management', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_sharp),
            title: const Text("Students"),
            onTap: () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => StudentScreen())
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("Majors"),
            onTap: () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => MajorScreen())
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const SettingScreen())
            ),
          ),
        ],
      ),
    );
  }
}