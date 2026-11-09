import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/dto.dart';
import 'package:dto_exercice/screens/single_category_screen.dart';
import 'package:dto_exercice/styles/spacings.dart';
import 'package:dto_exercice/widgets/category_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirestoreODM(appSchema, firestore: FirebaseFirestore.instance);

    return FutureBuilder(
      future: db
          .users(FirebaseAuth.instance.currentUser!.uid)
          .categories
          .where(($) => $.id(isNotEqualTo: 'NotRefered'))
          .get(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        final categories = snapshot.data ?? [];

        if (categories.isEmpty) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: Text(
                'Aucune catégorie',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width ,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SingleCategoryScreen.routeName,
                    arguments: category.id,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: kVerticalPadding),
                  child: CategoryItem(
                    categoryId: category.id,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
