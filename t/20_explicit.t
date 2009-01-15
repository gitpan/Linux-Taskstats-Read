use Test::More tests => 10;
BEGIN { use_ok('Linux::Taskstats::Read') };

#########################

my $file_v3 = 'ver3.dump';
my $file_v4 = 'ver4.dump';
my $file_v6 = 'ver6.dump';
my $file_v7 = 'ver7.dump';
if( -d 't' ) {
    $file_v3 = 't/' . $file_v3;
    $file_v4 = 't/' . $file_v4;
    $file_v6 = 't/' . $file_v6;
    $file_v7 = 't/' . $file_v7;
}

my $ts = new Linux::Taskstats::Read( -ver => 3 );

is( $ts->version, 3, "version check" );

my @fields = $ts->fields;
is( scalar(@fields), 36, "field count" );
is( $fields[2], "ac_flag", "field member" );

like( $ts->template, qr(QQQQQQ$), "template read" );

$ts->open($file_v3);

my $rec_raw = $ts->read_raw;
is( length($rec_raw), $ts->size, "size of raw record" );

eval { my $q = unpack("Q", 1234123412341234) };
my $can_Q = ( $@ ? 0 : 1 );

SKIP: {
    skip("64-bit architecture required", 4) unless $can_Q;

    my $rec = $ts->read;
    $ts->close;

    is( $rec->{ac_comm}, 'grep', "v3 groked comm" );

    ## try v4 record
    undef $ts;
    $ts = new Linux::Taskstats::Read( -ver => 4 );
    $ts->open($file_v4);

    $ts->read;
    $ts->read;
    undef $rec;
    $rec = $ts->read;
    $ts->close;

    is( $rec->{ac_comm}, 'php', "v4 groked comm" );


    ## try v6 record
    undef $ts;
    $ts = new Linux::Taskstats::Read( -ver => 6 );
    $ts->open($file_v6);

    while( my $trec = $ts->read ) { $rec = $trec }  ## find last record                                               
    $ts->close;

    is( $rec->{ac_comm}, 'perl', "v6 groked comm" );

    ## try v7 record
    undef $ts;
    $ts = new Linux::Taskstats::Read( -ver => 7 );
    $ts->open($file_v7);

    while( my $trec = $ts->read ) { $rec = $trec }  ## find last record                                               
    $ts->close;

    is( $rec->{ac_comm}, 'php5', "v7 groked comm" );
}
