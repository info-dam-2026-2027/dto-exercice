import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dto/dto.dart';
import 'package:dto_exercice/styles/colors.dart';
import 'package:dto_exercice/styles/font.dart';
import 'package:dto_exercice/styles/size.dart';
import 'package:dto_exercice/styles/spacings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  final db = FirestoreODM(appSchema, firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db
          .users(FirebaseAuth.instance.currentUser!.uid)
          .categories(widget.categoryId)
          .stream,
      builder: (context, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return const SizedBox();
        }

        final category = asyncSnapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 8),
          child: Container(
            width: MediaQuery.of(context).size.width - (kHorizontalPadding * 8),
            padding: const EdgeInsets.all(kAllPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
              border: Border.all(color: kMainColor, width: kBorderSize),
              color: kWhiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: kMainColor,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),

                StreamBuilder(
                  stream: db
                      .users(FirebaseAuth.instance.currentUser!.uid)
                      .categories(category.id)
                      .products
                      .stream,
                  builder: (context, countSnapshot) {
                    if (!countSnapshot.hasData) return const SizedBox(height: 4);
                    final itemCount = countSnapshot.data!.length; // nombre de documents
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "$itemCount élément${itemCount > 1 ? 's' : ''}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kMainColor.withOpacity(0.8),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                Text(
                  category.description,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.75),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
