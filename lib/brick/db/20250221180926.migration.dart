// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250221180926_up = [
  CreateIndex(columns: ['brand_Brand_brick_id'], onTable: 'WardrobeItem', unique: false)
];

const List<MigrationCommand> _migration_20250221180926_down = [
  DropIndex('index_WardrobeItem_on_brand_Brand_brick_id')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250221180926',
  up: _migration_20250221180926_up,
  down: _migration_20250221180926_down,
)
class Migration20250221180926 extends Migration {
  const Migration20250221180926()
    : super(
        version: 20250221180926,
        up: _migration_20250221180926_up,
        down: _migration_20250221180926_down,
      );
}
