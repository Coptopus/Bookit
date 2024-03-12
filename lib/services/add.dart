import 'dart:io';

import 'package:bookit/components/buttonauth.dart';
import 'package:bookit/components/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  File? file;
  getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    // Capture a photo.
    // final XFile? imageCamera =
    //     await picker.pickImage(source: ImageSource.camera);
    file = File(imageGallery!.path);
    setState(() {});
  }

  TextEditingController name = TextEditingController();
  String? type;
  TextEditingController desc = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController priceRng = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Adding new service",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.blue,
      ),
      body: Form(
        key: formState,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Text(
                "Please fill all the fields in the form:",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),

            //Image
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                  ButtonAuth(
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: CustomTextFormField2(
                label: "Service Name:",
                hintText: "The name of the service you'll provide",
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Service Category:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      RadioListTile(
                        activeColor: Colors.blueGrey,
                        title: const Text(
                          "Sports/Fitness",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        value: "sports/fitness",
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
                        value: "food",
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
                        value: "clinics",
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
                        value: "entertainment",
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
                        value: "other",
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 10,
                    minLines: 5,
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
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.blueGrey)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),

            // location
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: CustomTextFormField2(
                label: "Service Address:",
                hintText: "The location of the service you'll provide",
                controller: location,
                validator: (val) {
                  if (val == '') {
                    return "This field's required";
                  }
                  return null;
                },
              ),

              //PriceRange
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: CustomTextFormField2(
                label: "Service Price Range:",
                hintText: "e.g. \"100 / hr\" or \"100-200\" ",
                controller: priceRng,
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
                  onPressed: () {},
                ))
          ],
        ),
      ),
    );
  }
}

//TO DO
// Create the addition method, this adds all above data along with current user info.
