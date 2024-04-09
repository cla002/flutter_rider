import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:seller/services/firebase_services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices {
  FirebaseServices _services = FirebaseServices();

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({
      'orderStatus': status,
    });
    return result;
  }

  void launchCall(String? number) async {
    if (number != null && number.isNotEmpty) {
      String url = 'tel:$number';
      await launch(url);
    } else {
      throw 'Phone number is invalid';
    }
  }

  void launchMap(lat, long, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first
        .showMarker(coords: Coords(lat, long), title: name);
  }

  showMyDialog(title, status, documentId, context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text('Make sure to receive payment for COD'),
          actions: [
            TextButton(
                onPressed: () {
                  EasyLoading.show();
                  _services
                      .updateStatus(id: documentId, status: 'Delivered')
                      .then((value) {
                    EasyLoading.showSuccess('Order is Delivered');
                  });
                  Navigator.pop(context);
                },
                child: const Text('Deliver')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          ],
        );
      },
    );
  }
}
