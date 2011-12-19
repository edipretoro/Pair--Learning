package db1::Schema::Result::Contact;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('contacts');

__PACKAGE__->add_columns(
    'id' => {
        'data_type'         => 'bigint',
        'is_auto_increment' => 1,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'id',
        'is_nullable'       => 0
    },
    'phone' => {
        'data_type'         => 'text',
        'is_auto_increment' => 0,
        'default_value'     => undef,
        'is_foreign_key'    => 0,
        'name'              => 'name',
        'is_nullable'       => 0
    },
    'mail' => {
        'data_type'         => 'text',
        'is_auto_increment' => 0,
        'default_value'     => undef,
        'is_foreign_key'    => 1,
        'name'              => 'contacts',
        'is_nullable'       => 1
    }
);

__PACKAGE__->set_primary_key('id');

1;
