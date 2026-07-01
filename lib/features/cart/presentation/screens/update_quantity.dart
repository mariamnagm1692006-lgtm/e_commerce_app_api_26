import 'package:cloud_firestore/cloud_firestore.dart';

void updateQuantity({
  required String userId,
  required String prodId,
  required int newQuantity,
}) async {
  DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();

  Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

  List<dynamic> cart = userData?['cart'] ?? [];
  int index = cart.indexWhere((value) => value['id'] == prodId);

  if (index != -1) {
    if (newQuantity <= 0) {
      cart.removeAt(index);
    } else {
      cart[index]['quantity'] = newQuantity;
    }

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'cart': cart,
    });
  }
}
