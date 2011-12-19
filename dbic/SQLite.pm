package Aggregator::Schema::Result::Feed;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('feeds');

__PACKAGE__->add_columns(
    'feed_id' => {
        'name'              => 'feed_id',
        'data_type'         => 'bigint',
        'default_value'     => undef,
        'is_auto_increment' => 1,
        'is_foreign_key'    => 0,
        'is_nullable'       => 0,
        'size'              => 20,
    },
    'title' => {
        'name'              => 'title',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'link' => {
        'name'              => 'link',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'tagline' => {
        'name'              => 'tagline',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'format' => {
        'name'              => 'format',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 50,
    },
    'author' => {
        'name'              => 'author',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'language' => {
        'name'              => 'language',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 75,
    },
    'modified' => {
        'name'              => 'modified',
        'data_type'         => 'datetime',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
    },
);

__PACKAGE__->set_primary_key('feed_id');

package Aggregator::Schema::Result::Entry;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('entries');

__PACKAGE__->add_columns(
    'entry_id' => {
        'name'              => 'entry_id',
        'data_type'         => 'bigint',
        'default_value'     => undef,
        'is_auto_increment' => 1,
        'is_foreign_key'    => 0,
        'is_nullable'       => 0,
        'size'              => 20,
    },
    'title' => {
        'name'              => 'title',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'link' => {
        'name'              => 'link',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'author' => {
        'name'              => 'author',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'tags' => {
        'name'              => 'tags',
        'data_type'         => 'varchar',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
        'size'              => 225,
    },
    'issued' => {
        'name'              => 'issued',
        'data_type'         => 'datetime',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
    },
    'modified' => {
        'name'              => 'modified',
        'data_type'         => 'datetime',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
    },
    'content' => {
        'name'              => 'content',
        'data_type'         => 'text',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 0,
        'is_nullable'       => 1,
    },
    'feed_id' => {
        'name'              => 'feed_id',
        'data_type'         => 'bigint',
        'default_value'     => undef,
        'is_auto_increment' => 0,
        'is_foreign_key'    => 1,
        'is_nullable'       => 0,
        'size'              => 20,
    },

);

__PACKAGE__->set_primary_key('entry_id');
__PACKAGE__->belongs_to( 'feed', 'Aggregator::Schema::Result::Feed',
    'feed_id' );

package Aggregator::Schema::Result::Feed;

__PACKAGE__->has_many( 'entries', 'Aggregator::Schema::Result::Entry',
    'feed_id' );

package Aggregator::Schema;
use base 'DBIx::Class::Schema';

__PACKAGE__->register_class( 'Feed'  => 'Aggregator::Schema::Result::Feed' );
__PACKAGE__->register_class( 'Entry' => 'Aggregator::Schema::Result::Entry' );

package Plagger::Plugin::Publish::SQLite;
use strict;
use base qw( Plagger::Plugin );

use Plagger::Date;
use Encode qw( encode );
use Data::Dump;

sub register {
    my ( $self, $context ) = @_;
    $context->register_hook(
        $self,
        'publish.feed'     => \&feed,
        'publish.finalize' => \&finalize,
    );
}

sub feed {
    my ( $self, $context, $args ) = @_;

    push @{ $self->{_feeds} }, $args->{feed};
}

sub finalize {
    my ( $self, $context, $args ) = @_;

    if ( _exists_entries( $self->{_feeds} ) ) {
        my $database       = $self->conf->{database}      || './plagger_entries.db';
        my $encoding   = $self->conf->{encoding}  || 'latin1';

        my $schema = Aggregator::Schema->connect( 'dbi:SQLite:dbname=' . $database );
        $schema->deploy() unless -e $database;

        foreach my $feed ( @{ $self->{_feeds} } ) {
            my $feed_db = $schema->resultset('Feed')->find_or_new({ link => $feed->link });
            unless ($feed_db->in_storage) {
                $feed_db->title( $feed->title );
                $feed_db->author( $feed->author );
                $feed_db->language( $feed->language );
                $feed_db->format( $feed->type );
                $feed_db->modified( $feed->updated );
                $feed_db->tagline( $feed->description );
                $feed_db->insert();
            }

            foreach my $entry ( @{ $feed->entries } ) {
                my $entry_db = $feed_db->find_or_new_related( 'entries', { link => $entry->link });
                unless ( $entry_db->in_storage) {
                    $entry_db->title( $entry->title->data ) if $entry->title;
                    $entry_db->author( $entry->author->data ) if $entry->author;
                    $entry_db->content( $entry->body->data ) if $entry->body;
                    $entry_db->tags( join(', ', @{$entry->tags}) );
                    $entry_db->modified( $entry->date );
                    $entry_db->issued( $entry->date );
                    $entry_db->insert;
                }
            }
        }
    }
}

sub _exists_entries {
    my $feeds = shift;
    my $total = 0;
    map { $total += scalar @{ $_->entries } } @{$feeds};
    return $total;
}

1;
