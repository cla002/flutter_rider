// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseServices {
//   User? user = FirebaseAuth.instance.currentUser;
//   CollectionReference riders = FirebaseFirestore.instance.collection('riders');
//   CollectionReference orders = FirebaseFirestore.instance.collection('orders');
//   CollectionReference users = FirebaseFirestore.instance.collection('users');

//   Future<DocumentSnapshot> validateUser(id) async {
//     DocumentSnapshot result = await riders.doc(id).get();
//     return result;
//   }

//   Future<DocumentSnapshot> getCustomerDetails(id) async {
//     DocumentSnapshot doc = await users.doc(id).get();
//     return doc;
//   }

//   Future<void> updateStatus(
//       {required String id, required String status}) async {
//     String timestamp = Timestamp.now().toDate().toString();
//     try {
//       await orders.doc(id).update({
//         'orderStatus': status,
//         'timestamp': timestamp,
//       });
//     } catch (error) {
//       print('Error updating status: $error');
//     }
//   }

//   Future<void> saveEmail(String email) async {
//     try {
//       await FirebaseFirestore.instance.collection('ridersRequest').add({
//         'email': email,
//       });
//       print('Email saved successfully');
//     } catch (error) {
//       print('Error saving email: $error');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference riders = FirebaseFirestore.instance.collection('riders');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot> validateUser(id) async {
    DocumentSnapshot result = await riders.doc(id).get();
    return result;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<void> updateStatus(
      {required String id, required String status}) async {
    String timestamp = Timestamp.now().toDate().toString();
    try {
      if (status == 'Accepted') {
        // Clear the deliveryMan fields when the order is rejected
        await orders.doc(id).update({
          'orderStatus': status,
          'timestamp': timestamp,
          'deliveryMan': {
            'email': '',
            'image': '',
            'location': '',
            'name': '',
            'phone': '',
          },
        });
      } else {
        // Update status normally
        await orders.doc(id).update({
          'orderStatus': status,
          'timestamp': timestamp,
        });
      }
    } catch (error) {
      print('Error updating status: $error');
    }
  }

  Future<void> saveEmail(String email) async {
    try {
      await FirebaseFirestore.instance.collection('ridersRequest').add({
        'email': email,
      });
      print('Email saved successfully');
    } catch (error) {
      print('Error saving email: $error');
    }
  }
}
