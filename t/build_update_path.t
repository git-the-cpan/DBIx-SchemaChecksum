use strict;
use warnings;
use Test::More tests => 10;
use Test::NoWarnings;
use Test::Deep;
use DBI;
use DBIx::SchemaChecksum;
use File::Spec;

my $sc =
  DBIx::SchemaChecksum->new( dsn => "dbi:SQLite:dbname=t/dbs/update.db" );

my $update = $sc->build_update_path('t/dbs/snippets');
is( int keys %$update, 2, '2 updates' );
is(
    $update->{'5f22e538285f79ec558e16dbfeb0b34a36e4da19'}->[1],
    '6620c14bb4aaafdcf142022b5cef7f74ee7c7383',
    'first sum link'
);
is(
    $update->{'6620c14bb4aaafdcf142022b5cef7f74ee7c7383'}->[1],
    '39219d6fd802540c79b0a93d7111ea45f66e9518',
    'second sum link'
);
is( $update->{'7a1263a17bc9648e06de64fabb688633feb04f05'},
    undef, 'end of chain' );

cmp_deeply(
    [File::Spec->splitdir($update->{'5f22e538285f79ec558e16dbfeb0b34a36e4da19'}->[0])],
    [qw(t dbs snippets first_change.sql)],
    'first snippet'
);
cmp_deeply(
    [File::Spec->splitdir($update->{'6620c14bb4aaafdcf142022b5cef7f74ee7c7383'}->[0])],
    [qw(t dbs snippets another_change.sql)],
    'second snippet'
);

# corner cases
my $sc2 = DBIx::SchemaChecksum->new(
    dsn          => "dbi:SQLite:dbname=t/dbs/update.db",
    sqlsnippetdir => 't/dbs/no_snippets'
);
my $update2 = $sc2->build_update_path();
is( $update2, undef, 'no snippets found' );

eval {
    my $sc3 = DBIx::SchemaChecksum->new(
        dsn          => "dbi:SQLite:dbname=t/dbs/update.db",
        sqlsnippetdir => 't/no_snippts_here',
    );
    $sc->build_update_path;
};
like($@,qr/please specify sqlsnippetdir/i,'no snippet dir');

eval {
    my $sc4 = DBIx::SchemaChecksum->new(
        dsn          => "dbi:SQLite:dbname=t/dbs/update.db",
        sqlsnippetdir => 't/build_update_path.t',
    );
    $sc4->build_update_path;
};
like($@,qr/cannot find sqlsnippetdir/i,'no snippet dir');



