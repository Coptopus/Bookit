import 'dart:io';
import 'dart:core';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'package:bookit/components/buttonauth.dart';
import 'package:bookit/components/textformfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  DateTime dateTime = DateTime(1990, 1, 1, 0, 0);
  File? file;
  dynamic imgName;
  String? imageURL;
  getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    // Capture a photo.
    // final XFile? imageCamera =
    //     await picker.pickImage(source: ImageSource.camera);
    if (imageGallery != null) {
      file = File(imageGallery.path);
      imgName = basename(imageGallery.path);
      setState(() {});
    }
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: this.context,
      initialDate: dateTime,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: this.context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) {
      return;
    } //CANCEL

    TimeOfDay? time = await pickTime();
    if (time == null) {
      return;
    }

    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() => this.dateTime = dateTime);
  }

  TextEditingController name = TextEditingController();
  String? type;
  TextEditingController desc = TextEditingController();
  TextEditingController location = TextEditingController();
  bool timed = false;
  bool oneTime = false;
  TextEditingController price = TextEditingController();
  CollectionReference service =
      FirebaseFirestore.instance.collection('services');
  bool isComplete = false;
  bool isLoading = false;
  addService() async {
    if (formState.currentState!.validate()) {
      try {
        if (imgName != null) {
          var refStorage = FirebaseStorage.instance.ref(imgName);
          await refStorage.putFile(file!);
          imageURL = await refStorage.getDownloadURL();
        }

        await service.add({
          "provider": FirebaseAuth.instance.currentUser!.uid,
          "img": imageURL ?? "none",
          "name": name.text,
          "type": type,
          "desc": desc.text,
          "location": location.text,
          "timed": timed,
          "oneTime": oneTime,
          "price": price.text,
        });
        isComplete = true;
      } catch (e) {
        if (!mounted) {
          return;
        }
        AwesomeDialog(
          context: this.context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: "Error",
          desc: e.toString(),
          btnOkOnPress: () {},
        ).show();
        if (kDebugMode) {
          print("Error $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adding new service",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(
              heightFactor: 500,
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Form(
              key: formState,
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Text(
                      "Please fill all the fields in the form:",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                  ),

                  //Image
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Column(
                      children: [
                        file != null
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      file!,
                                      height: 300,
                                      width: 500,
                                      fit: BoxFit.cover,
                                    )),
                              )
                            : Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 20),
                                height: 300,
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[300]),
                                child: const Icon(
                                  Icons.add_photo_alternate,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                        file != null
                            ? ButtonAuth(
                                label: "Change Image",
                                onPressed: () async {
                                  await getImage();
                                },
                                color: Colors.blueGrey,
                                textColor: Colors.white,
                              )
                            : ButtonAuth(
                                label: "Get Image",
                                onPressed: () async {
                                  await getImage();
                                },
                                color: Colors.blueGrey,
                                textColor: Colors.white,
                              ),
                      ],
                    ),
                  ),

                  //Name
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: CustomTextFormField2(
                      label: "Service Name:",
                      hintText: "The name of the service you'll provide",
                      textInputType: TextInputType.name,
                      controller: name,
                      validator: (val) {
                        if (val == '') {
                          return "This field's required";
                        }
                        return null;
                      },
                    ),
                  ),

                  //Type
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Service Category:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            RadioListTile(
                              activeColor: Colors.blueGrey,
                              title: const Text(
                                "Sports & Fitness",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              value: "Sports & Fitness",
                              groupValue: type,
                              onChanged: (value) {
                                type = value;
                                setState(() {});
                              },
                            ),
                            RadioListTile(
                              activeColor: Colors.blueGrey,
                              title: const Text(
                                "Food",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              value: "Food",
                              groupValue: type,
                              onChanged: (value) {
                                type = value;
                                setState(() {});
                              },
                            ),
                            RadioListTile(
                              activeColor: Colors.blueGrey,
                              title: const Text(
                                "Clinics",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              value: "Clinics",
                              groupValue: type,
                              onChanged: (value) {
                                type = value;
                                setState(() {});
                              },
                            ),
                            RadioListTile(
                              activeColor: Colors.blueGrey,
                              title: const Text(
                                "Entertainment",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              value: "Entertainment",
                              groupValue: type,
                              onChanged: (value) {
                                type = value;
                                setState(() {});
                              },
                            ),
                            RadioListTile(
                              activeColor: Colors.blueGrey,
                              title: const Text(
                                "Other",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              value: "Other",
                              groupValue: type,
                              onChanged: (value) {
                                type = value;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //description
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          minLines: 3,
                          cursorColor: Colors.blueGrey,
                          cursorErrorColor: Colors.red,
                          validator: (value) {
                            if (value == '') {
                              return "This field's required";
                            }
                            return null;
                          },
                          controller: desc,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            focusColor: Colors.blueGrey,
                            hintText: "Describe the service you're offering",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.blueGrey[100],
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.blueGrey)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // location
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: CustomTextFormField2(
                      label: "Service Address:",
                      hintText: "The location of the service you'll provide",
                      textInputType: TextInputType.streetAddress,
                      controller: location,
                      validator: (val) {
                        if (val == '') {
                          return "This field's required";
                        }
                        return null;
                      },
                    ),
                  ),

                  //Checkboxes
                  CheckboxListTile(
                    activeColor: Colors.blueGrey,
                    title: const Text(
                      "This service is timed.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    value: timed,
                    onChanged: (value) {
                      timed = value!;
                      setState(() {});
                    },
                  ),
                  CheckboxListTile(
                    activeColor: Colors.blueGrey,
                    title: const Text(
                      "This service is a one-time event.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    value: oneTime,
                    onChanged: (value) {
                      oneTime = value!;
                      if (oneTime) {
                        dateTime = DateTime.now();
                      } else {
                        dateTime = DateTime(1990, 1, 1, 0, 0);
                      }
                      setState(() {});
                    },
                  ),

                  //Date for oneTime
                  if (oneTime)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Event Date:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                          MaterialButton(
                              color: Colors.blueGrey[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              height: 50,
                              onPressed: () async {
                                await pickDateTime();
                              },
                              child: Text(
                                  "${dateTime.day}/${dateTime.month}/${dateTime.year}\n$hours:$minutes",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)))
                        ],
                      ),
                    ),

                  //Price
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: CustomTextFormField2(
                      label: "Service Price:",
                      hintText: timed
                          ? "How much does it cost per hour?"
                          : "How much does it cost?",
                      textInputType: TextInputType.number,
                      controller: price,
                      validator: (val) {
                        if (val == '') {
                          return "This field's required";
                        }
                        return null;
                      },
                    ),
                  ),

                  Center(
                      heightFactor: 2,
                      child: ButtonAuth(
                        color: Colors.blueGrey,
                        textColor: Colors.white,
                        label: "Add",
                        onPressed: () async {
                          isLoading = true;
                          setState(() {});
                          await addService();
                          isLoading = false;
                          setState(() {});
                          if (isComplete) {
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                'home', (route) => false);
                          }
                        },
                      ))
                ],
              ),
            ),
    );
  }
}
