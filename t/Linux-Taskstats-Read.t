use Test::More tests => 2;
BEGIN { use_ok('Linux::Taskstats::Read') };

#########################

my $file = 'junk01';
if( -d 't' ) {
    $file = 't/' . $file;
}

my $ts = new Linux::Taskstats::Read( -file => $file, -ver => 3 );

my %comm = ();
my $rec = $ts->read;
$ts->close;

is( $rec->{ac_comm}, 'grep' );
