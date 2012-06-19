#!/opt/local/bin/perl

use strict;
use LWP::Simple;
use POSIX qw( tzset );

if ($#ARGV != 0) { die "Usage: $0 [name]\n" };

binmode STDOUT, ":utf8";
$ENV{TZ} = "Asia/Tokyo";
tzset;

my ($day, $month, $year) = (localtime)[3,4,5];
my $end_date = $year+1900 . ($month < 9 ? "0".("$month"+1) : $month+1) . ($day < 10 ? "0".$day : $day);

my @stats = split "\n", get("http://arcturus.su/tenhou/ranking/ranking.pl?name=$ARGV[0]&m=3&r=0&t=0&a=0&from=20060701&to=$end_date&rn=&tn=&l=&p=1") || die "Could not get stats: $!";

my $points = 0;
my $first = 0;
my $second = 0;
my $third = 0;
my $fourth = 0;

for (@stats){
  $1 ? ($points -= int($2)) : ($points += $2) if /$ARGV[0]\(\+?(-?)(\d+)\)/o;
  if (/^(\d)/o){
    if ($1 == 1) { $first++; }
    elsif ($1 == 2) { $second++; }
    elsif ($1 == 3) { $third++; }
    else { $fourth++; }
  }
}

my $total = $first + $second + $third + $fourth;

printf "Tenhou Stats ($ARGV[0])\n";
print "-" x 22 . "\n";
printf "First:     %3d (%2d%)\n", $first, int( $first/$total*100+.5 );
printf "Second:    %3d (%2d%)\n", $second, int( $second/$total*100+.5 );
printf "Third:     %3d (%2d%)\n", $third, int( $third/$total*100+.5 );
print "Current Points: $points\n";
