import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void getCartData({
  required String userId,
  required Function(List<Map<String, dynamic>> tempItems, double tempTotal)
  onDataLoaded,
}) async {
  if (FirebaseAuth.instance.currentUser == null) return;

  FirebaseFirestore.instance.collection('users').doc(userId).snapshots().listen(
    (userSnapshot) async {
      List<dynamic> cartList = userSnapshot.data()?['cart'] ?? [];
      List<Map<String, dynamic>> tempItems = [];
      double tempTotal = 0.0;

      for (var cartItem in cartList) {
        String prodId = cartItem['id'];
        int qty = cartItem['quantity'];

        DocumentSnapshot prodSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(prodId)
            .get();

        if (prodSnapshot.exists) {
          Map<String, dynamic> prodData =
              prodSnapshot.data() as Map<String, dynamic>;

          double price = (prodData['price'] is int)
              ? (prodData['price'] as int).toDouble()
              : (prodData['price'] ?? 0.0);

          tempItems.add({
            'id': prodId,
            'title': prodData['name'] ?? 'No Name',
            'price': price,
            'image': prodData['image_url'],
            'quantity': qty,
          });
          tempTotal += price * qty;
        }
      }
      onDataLoaded(tempItems, tempTotal);
    },
  );
}
