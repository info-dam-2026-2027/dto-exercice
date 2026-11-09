import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/dto.dart';
import 'package:dto_exercice/styles/others.dart';
import 'package:dto_exercice/styles/size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dto_exercice/styles/colors.dart';
import 'package:dto_exercice/styles/font.dart';
import 'package:dto_exercice/styles/spacings.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({super.key});

  static final String routeName = '/single-product';

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final db = FirestoreODM(appSchema, firestore: FirebaseFirestore.instance);
    final String productId =
    ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        iconTheme: const IconThemeData(color: kWhiteColor),
        title: Text('Produit', style: kAppbarText),
      ),
      body: FutureBuilder(
        future: db
            .users(FirebaseAuth.instance.currentUser!.uid)
            .categories('NotRefered')
            .products(productId)
            .get(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
            return const Center(child: Text("Produit introuvable"));
          }

          final product = asyncSnapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(kHorizontalPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
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
                        const SizedBox(height: 8),
                        Text(
                          "${product.price} €",
                          style: kProductPrice,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.description,
                          style: kProductDescription,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceBetween),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(kAllPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      color: kWhiteColor,
                      boxShadow: [
                        kBoxShadow,
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Modifier la catégorie",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: kMainColor,
                          ),
                        ),
                        const SizedBox(height: kSpaceBetween),
                        FutureBuilder(
                          future: db
                              .users(FirebaseAuth.instance.currentUser!.uid)
                              .categories
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final categories = snapshot.data!;

                            return DropdownButtonFormField<String>(
                              value: selectedCategoryId,
                              items: categories.map<DropdownMenuItem<String>>(
                                    (cat) {
                                  return DropdownMenuItem<String>(
                                    value: cat.id,
                                    child: Text(cat.title),
                                  );
                                },
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategoryId = value;
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                                  borderSide:
                                  BorderSide(color: kMainColor, width: 1),
                                ),
                              ),
                              hint: const Text("Choisir une catégorie"),
                            );
                          },
                        ),
                        const SizedBox(height: kSpaceBetween),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedCategoryId == null
                                ? null
                                : () async {
                              try {
                                await db
                                    .users(FirebaseAuth.instance.currentUser!.uid)
                                    .categories(selectedCategoryId!)
                                    .products
                                    .insert(product.copyWith());

                                await db
                                    .users(FirebaseAuth
                                    .instance.currentUser!.uid)
                                    .categories('NotRefered')
                                    .products(product.id)
                                    .delete();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Catégorie du produit mise à jour"),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Erreur lors de la mise à jour : $e"),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(kBorderRadius),
                              ),
                            ),
                            child: const Text(
                              "Enregistrer",
                              style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
