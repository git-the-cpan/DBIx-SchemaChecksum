
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Generate and compare checksums of database schematas",
  "dist_author" => [
    "Thomas Klausner <domm\@cpan.org>",
    "Maro\305\241 Koll\303\241r <maros\@cpan.org>",
    "Klaus Ita <koki\@worstofall.com>"
  ],
  "dist_name" => "DBIx-SchemaChecksum",
  "dist_version" => "1.005",
  "license" => "perl",
  "module_name" => "DBIx::SchemaChecksum",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "DBI" => 0,
    "Data::Dumper" => 0,
    "Digest::SHA1" => 0,
    "File::Find::Rule" => 0,
    "IO::Prompt::Tiny" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "MooseX::App" => "1.21",
    "MooseX::App::Command" => 0,
    "Path::Class" => 0,
    "Try::Tiny" => 0,
    "namespace::autoclean" => 0,
    "perl" => "5.010",
    "strict" => 0,
    "utf8" => 0,
    "warnings" => 0
  },
  "script_files" => [
    "bin/scs.pl"
  ],
  "test_requires" => {
    "DBD::SQLite" => "1.35",
    "File::Copy" => 0,
    "File::Spec" => 0,
    "File::Temp" => 0,
    "Module::Pluggable" => 0,
    "Test::More" => 0,
    "Test::Most" => 0,
    "Test::Trap" => 0,
    "lib" => 0
  }
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
