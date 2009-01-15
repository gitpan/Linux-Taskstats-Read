use Test::More tests => 2;
BEGIN { use_ok('Linux::Taskstats::Read') };

#########################

eval { my $q = unpack("Q", 1234123412341234) };
if ($@) {
    skip("64-bit architecture required", 1);
} else {
    ok("quad unpack");
}
