// GENERATED CODE EDIT WITH CAUTION
// THIS FILE **WILL NOT** BE REGENERATED
// This file should be version controlled and can be manually edited.
part of 'schema.g.dart';

// While migrations are intelligently created, the difference between some commands, such as
// DropTable vs. RenameTable, cannot be determined. For this reason, please review migrations after
// they are created to ensure the correct inference was made.

// The migration version must **always** mirror the file name

const List<MigrationCommand> _migration_20250221154502_up = [
  InsertTable('CategorySummary'),
  InsertColumn('category_id', Column.varchar, onTable: 'CategorySummary'),
  InsertColumn('category_name', Column.varchar, onTable: 'CategorySummary'),
  InsertColumn('item_count', Column.integer, onTable: 'CategorySummary'),
  InsertColumn('category_image', Column.varchar, onTable: 'CategorySummary')
];

const List<MigrationCommand> _migration_20250221154502_down = [
  DropTable('CategorySummary'),
  DropColumn('category_id', onTable: 'CategorySummary'),
  DropColumn('category_name', onTable: 'CategorySummary'),
  DropColumn('item_count', onTable: 'CategorySummary'),
  DropColumn('category_image', onTable: 'CategorySummary')
];

//
// DO NOT EDIT BELOW THIS LINE
//

@Migratable(
  version: '20250221154502',
  up: _migration_20250221154502_up,
  down: _migration_20250221154502_down,
)
class Migration20250221154502 extends Migration {
  const Migration20250221154502()
    : super(
        version: 20250221154502,
        up: _migration_20250221154502_up,
        down: _migration_20250221154502_down,
      );
}
