import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/dto.dart';
import 'package:dto_exercice/styles/others.dart';
import 'package:dto_exercice/styles/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dto_exercice/styles/colors.dart';
import 'package:dto_exercice/styles/font.dart';
import 'package:dto_exercice/styles/spacings.dart';
import 'package:dto_exercice/widgets/product_slider.dart'; // pour afficher les produits

class SingleCategoryScreen extends StatefulWidget {
  const SingleCategoryScreen({super.key});

  static final String routeName = '/single-category';

  @override
  State<SingleCategoryScreen> createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final db = FirestoreODM(appSchema, firestore: FirebaseFirestore.instance);
    final String categoryId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        iconTheme: const IconThemeData(color: kWhiteColor),
        title: Text('Catégorie', style: kAppbarText),
      ),
      body: FutureBuilder(
        future: db
            .users(FirebaseAuth.instance.currentUser!.uid)
            .categories(categoryId)
            .get(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
            return const Center(child: Text("Catégorie introuvable"));
          }

          final category = asyncSnapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(kAllPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      border: Border.all(color: kMainColor, width: kBorderSize),
                      color: kWhiteColor,
                      boxShadow: [
                        kBoxShadow,
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: kCategoryTitle,
                        ),
                        const SizedBox(height: 4),

                        FutureBuilder(
                          future: db
                              .users(FirebaseAuth.instance.currentUser!.uid)
                              .categories(categoryId)
                              .products
                              .get(),
                          builder: (context, countSnapshot) {
                            if (!countSnapshot.hasData) {
                              return const SizedBox(height: 4);
                            }
                            final itemCount = countSnapshot.data!.length;
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "$itemCount élément${itemCount > 1 ? 's' : ''}",
                                style: kCategoryItemCount,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 8),
                        Text(
                          category.description,
                          style: kCategoryDescription,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: kSpaceBetween),

                  Text(
                    "Produits de cette catégorie",
                    style: kCategoryProductTitle,
                  ),
                  const SizedBox(height: kSpaceBetween),

                  FutureBuilder(
                    future: db
                        .users(FirebaseAuth.instance.currentUser!.uid)
                        .categories(categoryId)
                        .products
                        .get(),
                    builder: (context, productsSnapshot) {
                      if (productsSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!productsSnapshot.hasData || productsSnapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: kVerticalPadding),
                          child: Center(child: Text("Aucun produit pour cette catégorie.")),
                        );
                      }

                      final products = productsSnapshot.data ?? [];;

                      return Column(
                        children: products!.map((p) {
                          final product = p;
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: kVerticalPaddingS),
                            padding: const EdgeInsets.all(kAllPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kBorderRadius),
                              color: kMainColor,
                              boxShadow: [
                                kBoxShadow,
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: kProductName,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.description,
                                  style: kProductDescription,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${product.price} €",
                                  style: kProductPrice,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
