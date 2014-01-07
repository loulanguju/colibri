#!/usr/bin/perl

@state = stat($ARGV[0]);
$size = $state[7];

print "$ARGV[0] size is $size\n";

$input = $ARGV[0];
open(SIG, $input) || die "open $ARGV[0]: $!";
binmode (SIG);

$output = ">".$ARGV[1];
open(OUTSIG, $output) || die "open $ARGV[1]: $!";
binmode (OUTSIG);

seek(SIG, 2, 0);
$binsize = pack("S", $size);
syswrite(OUTSIG, $binsize, 2, 0);
while (read(SIG, $buffer, 512)) {
    syswrite(OUTSIG, $buffer, length($buffer));
}

close SIG;
close OUTSIG;
