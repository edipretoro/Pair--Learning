#! /usr/bin/perl -w

use strict;
use warnings;

use File::Next;
use MP3::Tag;
use XML::Writer;
use IO::File;

my $iter = File::Next::files( { file_filter => sub { /\.mp3$/ } }, '.' );

while (defined( my $file = $iter->() )) {
  my $mp3 = MP3::Tag->new($file);
  my @metadata = $mp3->autoinfo();

  my $output = new IO::File ("output.xml", ">>:utf8");

  my $writer = new XML::Writer(OUTPUT => $output,
			       DATA_MODE   => 1,
			       DATA_INDENT => 2
			      );

  $writer->startTag("song",
		    "filename" => "/home/miniseb/Media/Musique/$file");

  $writer->startTag("title",
		    "n" => "$metadata[1]");
  $writer->characters("$metadata[0]");
  $writer->endTag("title");

  $writer->startTag("artist");
  $writer->characters("$metadata[2]");
  $writer->endTag("artist");

  $writer->startTag("album",
		    "year" => "$metadata[5]");
  $writer->characters("$metadata[3]");
  $writer->endTag("album");

  $writer->endTag("song");

  $writer->end();
  $output->close;

};
