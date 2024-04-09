import 'package:flutter/material.dart';
import 'package:seller/globals/styles.dart';
import 'package:seller/widgets/collected_amount.dart';
import 'package:seller/widgets/delivery_request.dart';
import 'package:seller/widgets/to_deliver.dart';
import 'package:seller/widgets/total_deliveries.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const String id = 'dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Column(
                      children: [
                        TotalAmountCollected(),
                        SizedBox(
                          height: 10,
                        ),
                        TotalDeliveries(),
                        SizedBox(
                          height: 10,
                        ),
                        DeliveryRequest(),
                        SizedBox(
                          height: 10,
                        ),
                        ToDeliver(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
