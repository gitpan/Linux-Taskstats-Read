use Test::More tests => 8;
BEGIN { use_ok('Linux::Taskstats::Read') };

#########################

my $file = 'ver3.dump';
my $file2 = 'ver4.dump';
if( -d 't' ) {
    $file = 't/' . $file;
    $file2 = 't/' . $file2;
}

my $ts = new Linux::Taskstats::Read( -ver => 3 );

is( $ts->version, 3, "version check" );

my @fields = $ts->fields;
is( scalar(@fields), 36, "field count" );
is( $fields[2], "ac_flag", "field member" );

like( $ts->template, qr(QQQQQQ$), "template read" );

$ts->open($file);

my $rec_raw = $ts->read_raw;
is( length($rec_raw), $ts->size, "size of raw record" );

eval { my $q = unpack("Q", 1234123412341234) };
my $can_Q = ( $@ ? 0 : 1 );

SKIP: {
    skip("64-bit architecture required", 2) unless $can_Q;

    my %comm = ();
    my $rec = $ts->read;
    $ts->close;

    is( $rec->{ac_comm}, 'grep', "groked comm" );


    ## try v4 record
    undef $ts;
    $ts = new Linux::Taskstats::Read( -ver => 4 );
    $ts->open($file2);

    $ts->read;
    $ts->read;
    undef $rec;
    $rec = $ts->read;
    $ts->close;

    is( $rec->{ac_comm}, 'php', "groked v4 comm" );
}
