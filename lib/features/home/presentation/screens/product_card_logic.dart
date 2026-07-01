import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app_api_26/features/auth/presentation/screens/login_screen.dart';

class ProductServices {
  ///favorites
  static Future<void> toggleFavorite({
    required BuildContext context,
    required String productId,
    required VoidCallback onStateChanged,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }

    onStateChanged();

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    List<dynamic> favorites = (snapshot.data()! as Map)['favorites'] ?? [];

    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'favorites': favorites,
    });
  }

  ///cart
  static Future<void> addToCart({
    required BuildContext context,
    required String productId,
  }) async {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      return;
    }

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    List<dynamic> cart = (snapshot.data()! as Map)['cart'] ?? [];
    int index = cart.indexWhere((item) => item['id'] == productId);

    if (index != -1) {
      cart[index]['quantity'] += 1;
    } else {
      cart.add({'id': productId, 'quantity': 1});
    }

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'cart': cart,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to Cart!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
