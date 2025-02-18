// GENERATED CODE DO NOT EDIT
// This file should be version controlled
import 'package:brick_sqlite/db.dart';
part '20250218085846.migration.dart';

/// All intelligently-generated migrations from all `@Migratable` classes on disk
final migrations = <Migration>{
  const Migration20250218085846(),};

/// A consumable database structure including the latest generated migration.
final schema = Schema(20250218085846, generatorVersion: 1, tables: <SchemaTable>{
  SchemaTable('Category', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar),
    SchemaColumn('name', Column.varchar)
  }, indices: <SchemaIndex>{}),
  SchemaTable('Outfit', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('user_profile_id', Column.varchar),
    SchemaColumn('name', Column.varchar),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('updated_at', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('WardrobeItem', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar, unique: true),
    SchemaColumn('user_profile_id', Column.varchar),
    SchemaColumn('brand_Brand_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Brand',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('category_Category_brick_id', Column.integer,
        isForeignKey: true,
        foreignTableName: 'Category',
        onDeleteCascade: false,
        onDeleteSetDefault: false),
    SchemaColumn('created_at', Column.datetime),
    SchemaColumn('updated_at', Column.datetime),
    SchemaColumn('deleted_at', Column.datetime),
    SchemaColumn('image_path', Column.varchar)
  }, indices: <SchemaIndex>{
    SchemaIndex(columns: ['id'], unique: true)
  }),
  SchemaTable('Brand', columns: <SchemaColumn>{
    SchemaColumn('_brick_id', Column.integer,
        autoincrement: true, nullable: false, isPrimaryKey: true),
    SchemaColumn('id', Column.varchar),
    SchemaColumn('name', Column.varchar)
  }, indices: <SchemaIndex>{})
});
