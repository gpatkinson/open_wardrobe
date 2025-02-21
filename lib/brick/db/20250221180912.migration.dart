// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250221180912_up = [
  CreateIndex(columns: ['item_category_ItemCategory_brick_id'], onTable: 'WardrobeItem', unique: false)
];

const List<MigrationCommand> _migration_20250221180912_down = [
  DropIndex('index_WardrobeItem_on_item_category_ItemCategory_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250221180912',
  up: _migration_20250221180912_up,
  down: _migration_20250221180912_down,
)
class Migration20250221180912 extends Migration {
  const Migration20250221180912()
    : super(
        version: 20250221180912,
        up: _migration_20250221180912_up,
        down: _migration_20250221180912_down,
      );
}
