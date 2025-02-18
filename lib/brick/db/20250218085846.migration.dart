// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250218085846_up = [
  InsertTable('Category'),
  InsertTable('Outfit'),
  InsertTable('WardrobeItem'),
  InsertTable('Brand'),
  InsertColumn('id', Column.varchar, onTable: 'Category'),
  InsertColumn('name', Column.varchar, onTable: 'Category'),
  InsertColumn('id', Column.varchar, onTable: 'Outfit', unique: true),
  InsertColumn('user_profile_id', Column.varchar, onTable: 'Outfit'),
  InsertColumn('name', Column.varchar, onTable: 'Outfit'),
  InsertColumn('created_at', Column.datetime, onTable: 'Outfit'),
  InsertColumn('updated_at', Column.datetime, onTable: 'Outfit'),
  InsertColumn('deleted_at', Column.datetime, onTable: 'Outfit'),
  InsertColumn('id', Column.varchar, onTable: 'WardrobeItem', unique: true),
  InsertColumn('user_profile_id', Column.varchar, onTable: 'WardrobeItem'),
  InsertForeignKey('WardrobeItem', 'Brand', foreignKeyColumn: 'brand_Brand_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertForeignKey('WardrobeItem', 'Category', foreignKeyColumn: 'category_Category_brick_id', onDeleteCascade: false, onDeleteSetDefault: false),
  InsertColumn('created_at', Column.datetime, onTable: 'WardrobeItem'),
  InsertColumn('updated_at', Column.datetime, onTable: 'WardrobeItem'),
  InsertColumn('deleted_at', Column.datetime, onTable: 'WardrobeItem'),
  InsertColumn('image_path', Column.varchar, onTable: 'WardrobeItem'),
  InsertColumn('id', Column.varchar, onTable: 'Brand'),
  InsertColumn('name', Column.varchar, onTable: 'Brand'),
  CreateIndex(columns: ['id'], onTable: 'Outfit', unique: true),
  CreateIndex(columns: ['id'], onTable: 'WardrobeItem', unique: true)
];

const List<MigrationCommand> _migration_20250218085846_down = [
  DropTable('Category'),
  DropTable('Outfit'),
  DropTable('WardrobeItem'),
  DropTable('Brand'),
  DropColumn('id', onTable: 'Category'),
  DropColumn('name', onTable: 'Category'),
  DropColumn('id', onTable: 'Outfit'),
  DropColumn('user_profile_id', onTable: 'Outfit'),
  DropColumn('name', onTable: 'Outfit'),
  DropColumn('created_at', onTable: 'Outfit'),
  DropColumn('updated_at', onTable: 'Outfit'),
  DropColumn('deleted_at', onTable: 'Outfit'),
  DropColumn('id', onTable: 'WardrobeItem'),
  DropColumn('user_profile_id', onTable: 'WardrobeItem'),
  DropColumn('brand_Brand_brick_id', onTable: 'WardrobeItem'),
  DropColumn('category_Category_brick_id', onTable: 'WardrobeItem'),
  DropColumn('created_at', onTable: 'WardrobeItem'),
  DropColumn('updated_at', onTable: 'WardrobeItem'),
  DropColumn('deleted_at', onTable: 'WardrobeItem'),
  DropColumn('image_path', onTable: 'WardrobeItem'),
  DropColumn('id', onTable: 'Brand'),
  DropColumn('name', onTable: 'Brand'),
  DropIndex('index_Outfit_on_id'),
  DropIndex('index_WardrobeItem_on_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250218085846',
  up: _migration_20250218085846_up,
  down: _migration_20250218085846_down,
)
class Migration20250218085846 extends Migration {
  const Migration20250218085846()
    : super(
        version: 20250218085846,
        up: _migration_20250218085846_up,
        down: _migration_20250218085846_down,
      );
}
