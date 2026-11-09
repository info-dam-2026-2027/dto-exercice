import 'package:firestore_odm/firestore_odm.dart';
import 'package:dto/converters/firestore_timestamp_converter.dart';
import 'models/category.dart';
import 'models/product.dart';
import 'models/user.dart';

part 'schema.odm.dart';

@Schema()
@Collection<User>('users')
@Collection<Category>('users/*/categories')
@Collection<Product>('users/*/categories/*/products')
final appSchema = _$AppSchema;


