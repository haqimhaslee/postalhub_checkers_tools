import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference parcelhub =
      FirebaseFirestore.instance.collection('ParcelInventory');
}
