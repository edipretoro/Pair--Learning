#!/usr/bin/env perl

use strict;
use warnings;

use lib '.';
use db1::Schema;

my $schema = db1::Schema->connect('dbi:SQLite:dbname=./db1.sqlite');
$schema->deploy();

