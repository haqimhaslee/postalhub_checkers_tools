import 'package:flutter/material.dart';

class CheckersParcel extends StatefulWidget {
  const CheckersParcel({super.key});
  @override
  State<CheckersParcel> createState() => _CheckersParcelState();
}

class _CheckersParcelState extends State<CheckersParcel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
      child: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 25,
                right: 25,
                bottom: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 5,
                      right: 5,
                      bottom: 20,
                    ),
                    child: Text(
                      'Checker Tools',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 5,
                    ),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                labelText: 'Search course',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
