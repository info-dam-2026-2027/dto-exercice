import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/dto.dart';
import 'package:dto_exercice/screens/single_product_screen.dart';
import 'package:dto_exercice/styles/spacings.dart';
import 'package:dto_exercice/widgets/product_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductSlider extends StatelessWidget {
  const ProductSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirestoreODM(appSchema, firestore: FirebaseFirestore.instance);

    return StreamBuilder(
      stream: db
          .users(FirebaseAuth.instance.currentUser!.uid)
          .categories('NotRefered')
          .products
          .stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: Text(
                'Aucun produit',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return Column(
          children: [
            for (final product in products)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SingleProductScreen.routeName,
                    arguments: product.id,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: kVerticalPadding),
                  child: ProductItem(
                    productId: product.id,
                    categoryId: 'NotRefered',
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
