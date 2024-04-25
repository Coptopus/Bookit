import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookit/model/forrmatting.dart';
import 'package:bookit/pages/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/cart.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 240, 243, 255),
        body: Consumer<Cart>(
          builder: (context, cart, child) {
            if (cart.cartItems.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      shrinkWrap: true,
                      itemCount: cart.cartItems.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('services')
                              .doc(cart.cartItems[index].serviceID)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Card(
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      child: snapshot.data!['img'] != "none"
                                          ? Image.network(
                                              snapshot.data!['img'],
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
                                            )
                                          : Container(
                                              padding: const EdgeInsets.all(10),
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  color: Colors.grey[300]),
                                              child: const Icon(
                                                Icons.photo,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          "${snapshot.data!["name"]}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data!['timed']
                                                ? cart.cartItems[index]
                                                            .duration ==
                                                        1
                                                    ? "Price: ${money.format(cart.cartItems[index].price)} (${cart.cartItems[index].duration} hour)"
                                                    : "Price: ${money.format(cart.cartItems[index].price)} (${cart.cartItems[index].duration} hours)"
                                                : "Price: ${money.format(cart.cartItems[index].price)}"),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${cart.cartItems[index].start.day}/${cart.cartItems[index].start.month}/${cart.cartItems[index].start.year}"),
                                                snapshot.data!['timed']
                                                    ? Text(
                                                        "${ftime.format(cart.cartItems[index].start)} ~ ${ftime.format(cart.cartItems[index].end)}")
                                                    : Text(ftime.format(cart
                                                        .cartItems[index]
                                                        .start)),
                                              ],
                                            )
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete_outlined,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            cart.remove(cart.cartItems[index]);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const Text("Loading...");
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                      width: 500,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.teal[50]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 6,
                            child: cart.redeemed
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          money.format(cart.oldPrice),
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Total: ${money.format(cart.totalPrice)}",
                                          style: const TextStyle(
                                              color: Colors.teal,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    "Total: ${money.format(cart.totalPrice)}",
                                    style: const TextStyle(
                                        color: Colors.teal,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          if (cart.totalPrice != 0.0)
                            Expanded(
                              flex: 2,
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Payment(total: cart.totalPrice),
                                  ));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.teal,
                                textColor: Colors.white,
                                child: const Text(
                                  "Pay",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                          //REDEEM POINTS
                          Expanded(
                            flex: 1,
                            child: cart.redeemed
                                ? IconButton(
                                    onPressed: () {
                                      cart.revert();
                                    },
                                    iconSize: 30,
                                    color: Colors.red,
                                    icon: const Stack(
                                      children: [
                                        Icon(
                                          Icons.discount,
                                          color: Colors.black,
                                        ),
                                        Icon(
                                          Icons.clear,
                                        )
                                      ],
                                    ))
                                : PopupMenuButton(
                                    icon: Icon(
                                      Icons.discount_outlined,
                                      color: Colors.teal[700],
                                      size: 30,
                                    ),
                                    onSelected: (value) async {
                                      var response = await FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get();
                                      Map<String, dynamic>? user =
                                          response.data();

                                      switch (value) {
                                        case 10:
                                          if (user!['points'] >= 100 &&
                                              !cart.redeemed) {
                                            cart.redeem(0.9, -100);
                                          } else {
                                            if (!context.mounted) {return;}
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.bottomSlide,
                                              title: "Not enough points",
                                              desc:
                                                  "You currently have ${user['points']} points in your account, you need at least 100 for this discount.",
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                          break;
                                        case 25:
                                          if (user!['points'] >= 250) {
                                            cart.redeem(0.75, -250);
                                          } else {
                                            if (!context.mounted) {return;}
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.bottomSlide,
                                              title: "Not enough points",
                                              desc:
                                                  "You currently have ${user['points']} points in your account, you need at least 250 for this discount.",
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                          break;
                                        case 50:
                                          if (user!['points'] >= 500) {
                                            cart.redeem(0.5, -500);
                                          } else {
                                            if (!context.mounted) {return;}
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.bottomSlide,
                                              title: "Not enough points",
                                              desc:
                                                  "You currently have ${user['points']} points in your account, you need at least 500 for this discount.",
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                          break;
                                        case 75:
                                          if (user!['points'] >= 750) {
                                            cart.redeem(0.25, -750);
                                          } else {
                                            if (!context.mounted) {return;}
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.bottomSlide,
                                              title: "Not enough points",
                                              desc:
                                                  "You currently have ${user['points']} points in your account, you need at least 750 for this discount.",
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                          break;
                                        case 90:
                                          if (user!['points'] >= 900) {
                                            cart.redeem(0.1, -900);
                                          } else {
                                            if (!context.mounted) {return;}
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.bottomSlide,
                                              title: "Not enough points",
                                              desc:
                                                  "You currently have ${user['points']} points in your account, you need at least 900 for this discount.",
                                              btnOkOnPress: () {},
                                            ).show();
                                          }
                                          break;
                                        default:
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          value: 10,
                                          child: Row(
                                            children: [
                                              Icon(Icons.discount_outlined),
                                              Text(" 100 points = 10% off")
                                            ],
                                          )),
                                      const PopupMenuItem(
                                          value: 25,
                                          child: Row(
                                            children: [
                                              Icon(Icons.discount_outlined),
                                              Text(" 250 points = 25% off")
                                            ],
                                          )),
                                      const PopupMenuItem(
                                          value: 50,
                                          child: Row(
                                            children: [
                                              Icon(Icons.discount_outlined),
                                              Text(" 500 points = 50% off")
                                            ],
                                          )),
                                      const PopupMenuItem(
                                          value: 75,
                                          child: Row(
                                            children: [
                                              Icon(Icons.discount_outlined),
                                              Text(" 750 points = 75% off")
                                            ],
                                          )),
                                      const PopupMenuItem(
                                          value: 90,
                                          child: Row(
                                            children: [
                                              Icon(Icons.discount_outlined),
                                              Text(" 900 points = 90% off")
                                            ],
                                          )),
                                    ],
                                  ),
                          )
                        ],
                      ))
                ],
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_online_outlined,
                      size: 100,
                      color: Colors.black26,
                    ),
                    Text(
                      "No reservations yet.\nStart booking! :D",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.black38),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}
