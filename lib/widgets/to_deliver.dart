import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/order_services.dart';

class ToDeliver extends StatefulWidget {
  const ToDeliver({Key? key});

  @override
  State<ToDeliver> createState() => _ToDeliverState();
}

class _ToDeliverState extends State<ToDeliver> {
  OrderServices _orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _orderServices.orders
          .where('deliveryMan.email', isEqualTo: user!.email)
          .where('orderStatus',
              whereIn: ['Picked Up', 'On the Way', 'On the Way']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

        int toDeliver = snapshot.data!.docs.length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(3, 3),
                  ),
                ],
                color: Colors.green.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              width: GlobalStyles.screenWidth(context) - 100,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'To Deliver',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      toDeliver.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        );
      },
    );
  }
}
