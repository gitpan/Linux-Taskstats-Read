use Test::More tests => 5;
BEGIN { use_ok('Linux::Taskstats::Read') };

#########################

my $file = 'junk01';
if( -d 't' ) {
    $file = 't/' . $file;
}

my $ts = new Linux::Taskstats::Read( -ver => 3 );

is( $ts->version, 3, "version check" );

my @fields = $ts->fields;
is( scalar(@fields), 36, "field count" );
is( $fields[2], "ac_flag", "field member" );

$ts->open($file);

my %comm = ();
my $rec = $ts->read;
$ts->close;

is( $rec->{ac_comm}, 'grep', "groked comm" );
