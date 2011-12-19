package db1::Schema::Result::Pers;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('pers');

__PACKAGE__->add_columns(
'id' => {
  'data_type' => 'bigint',
  'is_auto_increment' => 1,
  'default_value' => undef,
  'is_foreign_key' => 0,
  'name' => 'id',
  'is_nullable' => 0
},
'name' => {
  'data_type' => 'text',
  'is_auto_increment' => 0,
  'default_value' => undef,
  'is_foreign_key' => 0,
  'name' => 'name',
  'is_nullable' => 0
},
'contacts' => {
  'data_type' => 'bigint',
  'is_auto_increment' => 0,
  'default_value' => undef,
  'is_foreign_key' => 1,
  'name' => 'contacts',
  'is_nullable' => 0
}
);

__PACKAGE__->set_primary_key( 'id' );

1;
