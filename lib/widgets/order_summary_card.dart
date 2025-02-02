// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers, unused_local_variable, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/services/order_services.dart';
import 'package:seller/widgets/order_status.dart';

class OrderSummaryCard extends StatefulWidget {
  final DocumentSnapshot document;

  OrderSummaryCard(this.document);

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  DocumentSnapshot? _customer;

  @override
  void initState() {
    _services
        .getCustomerDetails(
            (widget.document.data() as Map<String, dynamic>)['userId'])
        .then((value) {
      if (value != null) {
        setState(() {
          _customer = value;
        });
      } else {
        print('No Data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor(DocumentSnapshot document) {
      if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
          'Accepted') {
        return Colors.green;
      }

      if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
          'Picked Up') {
        return const Color.fromARGB(255, 42, 32, 179);
      }
      if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
          'On the Way') {
        return Colors.orangeAccent;
      }
      if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
          'Delivered') {
        return Colors.purple.shade800;
      }
      return Colors.blueAccent;
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            horizontalTitleGap: 0,
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 14,
              child: Icon(CupertinoIcons.square_list, size: 18),
            ),
            title: Text(
              (widget.document.data() as Map<String, dynamic>)['orderStatus'],
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: statusColor(widget.document)),
            ),
            subtitle: Text(
              'On ${DateFormat.yMMMMd().format(
                DateTime.parse(
                  (widget.document.data() as Map<String, dynamic>)['timestamp'],
                ),
              )}',
            ),
            trailing: Text(
              'Amount : ${(widget.document.data() as Map<String, dynamic>)['total']}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ),
          _customer != null
              ? ListTile(
                  title: Text(
                    'Customer : ${(_customer!.data()! as Map<String, dynamic>)['firstName']} '
                    ' ${(_customer!.data()! as Map<String, dynamic>)['lastName']}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    (_customer!.data() as Map<String, dynamic>)['address'],
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _orderServices.launchMap(
                              (_customer!.data()
                                  as Map<String, dynamic>)['latitude'],
                              (_customer!.data()
                                  as Map<String, dynamic>)['longitude'],
                              (_customer!.data()
                                  as Map<String, dynamic>)['firstName']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3)),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          '+${(_customer!.data() as Map<String, dynamic>)['number']}';
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3)),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          ExpansionTile(
            title: const Text(
              'Order Details',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'View more details...',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final productImageUrl = (widget.document.data()
                          as Map<String, dynamic>)['products'][index]
                      ['productImage'];
                  final productImage = productImageUrl != null
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.network(productImageUrl),
                        )
                      : SizedBox();
                  return ListTile(
                    leading: productImage,
                    title: Text(
                      (widget.document.data()
                              as Map<String, dynamic>)['products'][index]
                          ['productName'],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'x',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ),
                            Text(
                              (widget.document.data()
                                          as Map<String, dynamic>)['products']
                                      [index]['quantity']
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Price each : ',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            Text(
                              '₱${(widget.document.data() as Map<String, dynamic>)['products'][index]['price'].toString()}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                itemCount:
                    (widget.document.data() as Map<String, dynamic>)['products']
                        .length,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Seller : ',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54),
                            ),
                            Text(
                              (widget.document.data()
                                          as Map<String, dynamic>)['seller']
                                      ['shopName']
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Delivery Fee : ',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54),
                            ),
                            Text(
                              (widget.document.data()
                                      as Map<String, dynamic>)['deliveryFee']
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Payment Method : ',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54),
                            ),
                            if ((widget.document.data()
                                    as Map<String, dynamic>)['cod'] ==
                                true)
                              const Text(
                                'Cash On Delivery',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            if ((widget.document.data()
                                    as Map<String, dynamic>)['cod'] ==
                                false)
                              const Text(
                                'Gcash',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          statusContainer(widget.document, context),
        ],
      ),
    );
  }
}
