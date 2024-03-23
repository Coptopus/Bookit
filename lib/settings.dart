import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List buttons = [
  {
    "icon": Icons.notifications,
    "label": "Notifications",
    "onPressed": () {
      if (kDebugMode) {
        print("Nofications");
      }
    }
  },
  {
    "icon": Icons.edit,
    "label": "Edit Profile",
    "onPressed": () {
      if (kDebugMode) {
        print("EditProf");
      }
    }
  },
  {
    "icon": Icons.color_lens,
    "label": "Appearance",
    "onPressed": () {
      if (kDebugMode) {
        print("Appear");
      }
    }
  },
  {
    "icon": Icons.warning,
    "label": "Report A Problem",
    "onPressed": () {
      if (kDebugMode) {
        print("Report");
      }
    },
  },
    {
    "icon": Icons.thumb_up,
    "label": "Support Us",
    "onPressed": () {
      if (kDebugMode) {
        print("Support");
      }
    },
  },
    {
    "icon": Icons.info,
    "label": "About Us",
    "onPressed": () {
      if (kDebugMode) {
        print("About");
      }
    },
  }
];

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 243, 255),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w900),
              ),
              ListView.builder(
                itemCount: buttons.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: MaterialButton(
                      onPressed: buttons[index]["onPressed"],
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(child: Icon(buttons[index]["icon"])),
                          Expanded(
                              flex: 3,
                              child: Text(
                                "${buttons[index]['label']}",
                                style: const TextStyle(fontSize: 30),
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
