import 'package:bookit/components/buttonauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/forrmatting.dart';

class Payment extends StatefulWidget {
  final double total;
  const Payment({super.key, required this.total});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController card = TextEditingController();
  TextEditingController exp = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 243, 255),
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        children: [
          Center(
            heightFactor: 1.15,
            child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(children: [
                  const TextSpan(
                      text: "\nYour total is:\n",
                      style: TextStyle(fontSize: 20, color: Colors.black38)),
                  TextSpan(
                      text: money.format(widget.total),
                      style: const TextStyle(
                          fontSize: 45,
                          color: Colors.teal,
                          fontWeight: FontWeight.w900)),
                ])),
          ),
          const Text("Please enter card info below:",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black38,
              )),
          Form(
            key: formState,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Card Number",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                          CardInputFormatter()
                        ],
                        cursorColor: Colors.blue,
                        cursorErrorColor: Colors.red,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "*Required*";
                          }
                          return null;
                        },
                        controller: card,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.credit_card_outlined,
                          ),
                          focusColor: Colors.blue,
                          hintText: "1234 1234 1234 1234",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 227, 233, 249),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.blue)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Full Name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.blue,
                        cursorErrorColor: Colors.red,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "*Required*";
                          }
                          return null;
                        },
                        controller: name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person_outline,
                          ),
                          focusColor: Colors.blue,
                          hintText: "Name On The Card",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 227, 233, 249),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.blue)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Expiration",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              FilteringTextInputFormatter.digitsOnly,
                              ExpInputFormatter()
                            ],
                            cursorColor: Colors.blue,
                            cursorErrorColor: Colors.red,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "*Required*";
                              }
                              return null;
                            },
                            controller: exp,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              focusColor: Colors.blue,
                              prefixIcon:
                                  const Icon(Icons.calendar_month_outlined),
                              hintText: "MM/YY",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 227, 233, 249),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.blue)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "CVV",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.blue,
                            cursorErrorColor: Colors.red,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "*Required*";
                              }
                              return null;
                            },
                            controller: cvv,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              focusColor: Colors.blue,
                              prefixIcon: const Icon(Icons.numbers_outlined),
                              hintText: "CVV",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 227, 233, 249),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide:
                                      const BorderSide(color: Colors.blue)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ],
            ),
          ),
          Align(
            heightFactor: 1.15,
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: ButtonAuth(
                      onPressed: () {
                        if (formState.currentState!.validate()) {
                          // print("Pay and add reservation here");
                          //CONSUMER: Access Cart, Go through each service ID,
                          //PROTIP: define a collection reference up top before "Firestoring".
                          //SET: Add the price of each service to their owner's points (revenue),
                          //ADD: In each document add to the reservations collection the booking data + *current user ID*,
                          //SET: Add 10% (and round to the nearest int) of the paid price to the current users points (if he didn't redeem - more on that later),
                          //Show Awesome Dialogue and go home.
                          //BONUS: Notification to SP!
                        }
                      },
                      color: Colors.teal,
                      textColor: Colors.white,
                      label: "Pay ${money.format(widget.total)}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write(" ");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

class ExpInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 2 == 0 && inputData.length != index) {
        buffer.write("/");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}
