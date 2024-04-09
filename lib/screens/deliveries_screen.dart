// ignore_for_file: unused_local_variable

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/widgets/order_summary_card.dart';

class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({Key? key}) : super(key: key);

  static const String id = 'deliveries-screen';

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {
  User? _user = FirebaseAuth.instance.currentUser;
  FirebaseServices _services = FirebaseServices();
  String? status;
  int tag = 1;
  List<String> options = [
    'All',
    'Accepted',
    'Picked Up',
    'On the Way',
    'Delivered',
  ];

  var pressCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: GlobalStyles.green,
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 56,
                width: GlobalStyles.screenWidth(context),
                child: ChipsChoice<int>.single(
                  value: tag,
                  onChanged: (val) => setState(() {
                    if (val == 0) {
                      setState(() {
                        status = null;
                      });
                    }
                    setState(() {
                      tag = val;
                      status = options[val];
                    });
                  }),
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _services.orders
                        .where('deliveryMan.email', isEqualTo: _user!.email)
                        .where('orderStatus',
                            isEqualTo: tag == 0 ? null : status)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.size == 0) {
                        return Center(child: Text('No $status Orders'));
                      }

                      return Column(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: OrderSummaryCard(document),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
