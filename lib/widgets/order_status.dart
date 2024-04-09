// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, void_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:seller/services/order_services.dart';

Widget statusContainer(DocumentSnapshot document, BuildContext context) {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  GeoPoint? _shopLocation;

  if ((document.data() as Map<String, dynamic>)['deliveryMan']['name'].length >
      1) {
    if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
        'Accepted') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Container(
              width: GlobalStyles.screenWidth(context) - 40,
              child: TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                ),
                onPressed: () {
                  EasyLoading.show(status: 'Updating Order Status');
                  _services
                      .updateStatus(id: document.id, status: 'Picked Up')
                      .then((value) {
                    EasyLoading.showSuccess('You have Picked Up the Order');
                  });
                },
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Pick Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: GlobalStyles.screenWidth(context) - 40,
              child: TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.red,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.0),
                    ),
                  ),
                ),
                onPressed: () {
                  EasyLoading.show(status: 'Updating Order Status');
                  _services
                      .updateStatus(id: document.id, status: 'Accepted')
                      .then((value) {
                    EasyLoading.showSuccess('You have rejected the order');
                  });
                },
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Reject Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
        'Picked Up') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          width: GlobalStyles.screenWidth(context) - 40,
          child: TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 42, 32, 179),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0)))),
            onPressed: () {
              EasyLoading.show(status: 'Updating Order Status');
              _services
                  .updateStatus(id: document.id, status: 'On the Way')
                  .then((value) {
                EasyLoading.showSuccess('You have Picked Up the Order');
              });
            },
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'On the way',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
    if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
        'On the Way') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          width: GlobalStyles.screenWidth(context) - 40,
          child: TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.orangeAccent,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0)))),
            onPressed: () {
              if ((document.data() as Map<String, dynamic>)['cod'] == true) {
                return _orderServices.showMyDialog(
                    'Receive Payment', 'Delivered', document.id, context);
              } else {
                EasyLoading.show(status: 'Updating Order Status');
                _services
                    .updateStatus(id: document.id, status: 'Delivered')
                    .then((value) {
                  EasyLoading.showSuccess('Order Status is "On the way"');
                });
              }
            },
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Deliver Order',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
    if ((document.data() as Map<String, dynamic>)['orderStatus'] ==
        'Delivered') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          width: GlobalStyles.screenWidth(context) - 40,
          child: TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.green,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0)))),
            onPressed: () {},
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  Text(
                    'Order Completed',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  GlobalStyles.green,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0)))),
            onPressed: () {
              _orderServices.showMyDialog(
                  'Accept Order', 'Accepted', document.id, context);
            },
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          AbsorbPointer(
            absorbing:
                (document.data() as Map<String, dynamic>)['orderStatus'] ==
                        'Rejected'
                    ? true
                    : false,
            child: TextButton.icon(
              style: ButtonStyle(
                  backgroundColor: (document.data()
                              as Map<String, dynamic>)['orderStatus'] ==
                          'Rejected'
                      ? MaterialStateProperty.all<Color>(
                          Colors.grey,
                        )
                      : MaterialStateProperty.all<Color>(
                          Colors.red,
                        ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1.0)))),
              onPressed: () {
                _orderServices.showMyDialog(
                    'Reject Order', 'Rejected', document.id, context);
              },
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Reject',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
