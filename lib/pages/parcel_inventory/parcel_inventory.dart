import 'package:flutter/material.dart';

class ParcelInventory extends StatefulWidget {
  const ParcelInventory({super.key});
  @override
  State<ParcelInventory> createState() => _ParcelInventoryState();
}

class _ParcelInventoryState extends State<ParcelInventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 5,
                  right: 5,
                  bottom: 20,
                ),
                child: Text(
                  'Inventory',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: const [
                    Padding(
                        padding: EdgeInsets.only(
                          top: 0,
                          left: 25,
                          right: 25,
                          bottom: 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                                left: 5,
                                right: 5,
                                bottom: 20,
                              ),
                              child: Text(
                                'Inventory',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
