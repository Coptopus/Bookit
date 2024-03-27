import 'package:cloud_firestore/cloud_firestore.dart';
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
                                              height: 75,
                                              width: 75,
                                            )
                                          : Container(
                                              padding: const EdgeInsets.all(10),
                                              height: 75,
                                              width: 75,
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
                                        title:
                                            Text("${snapshot.data!["name"]}"),
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
                                                    ? "Price: E£ ${cart.cartItems[index].price} (${cart.cartItems[index].duration} hour)"
                                                    : "Price: E£ ${cart.cartItems[index].price} (${cart.cartItems[index].duration} hours)"
                                                : "Price: E£ ${cart.cartItems[index].price}"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${cart.cartItems[index].start.day}/${cart.cartItems[index].start.month}/${cart.cartItems[index].start.year}"),
                                                snapshot.data!['timed']
                                                    ? Text(
                                                        "${cart.cartItems[index].start.hour.toString().padLeft(2, '0')}: ${cart.cartItems[index].start.minute.toString().padLeft(2, '0')} ~ ${cart.cartItems[index].end.hour.toString().padLeft(2, '0')}: ${cart.cartItems[index].end.minute.toString().padLeft(2, '0')}")
                                                    : Text(
                                                        "${cart.cartItems[index].start.hour.toString().padLeft(2, '0')}: ${cart.cartItems[index].start.minute.toString().padLeft(2, '0')}"),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total: E£ ${cart.totalPrice}",
                            style: const TextStyle(
                                color: Colors.teal,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          if (cart.totalPrice != 0.0)
                            MaterialButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              color: Colors.teal,
                              textColor: Colors.white,
                              child: const Text(
                                "Pay",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
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
