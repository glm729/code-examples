#!/usr/bin/env perl


# Usage requirements
# -----------------------------------------------------------------------------


use strict;
use warnings;


# Operations
# -----------------------------------------------------------------------------


print "\033[7;34mUpdating package lists....\033[0m\n";

my @ud = &cmd_update;
my $cl = &check_last($ud[-1]);

if ($cl == 0) {
  print "\033[7;32mNothing to upgrade\033[0m\n";
  exit 0;
};

my $s = $cl == 1 ? '' : "s";
print "\033[7;33m$cl package$s to upgrade, fetching list....\033[0m\n";

my $u = join "\n  ", &check_upgradable;
print "\033[7;34mPackages to be upgraded:\033[0m\n  $u\n";

if (&is_upgrade) {
  print "\033[7;36mUpgrading packages\033[0m\n";
  system "sudo apt -y dist-upgrade";
};

print "\033[7;32mEnd of operations\033[0m\n";
exit 0;


# Subroutine definitions
# -----------------------------------------------------------------------------


sub cmd_update {
  my $opr = `sudo apt update 2>/dev/null`;
  $opr =~ s/\s+$//;
  return split /\n/, $opr;
};

sub check_last {
  my ($v) = @_;
  return 0 if $v eq "All packages are up to date.";
  if ($v =~ /(\d+) packages? can be upgraded/) {
    return $1;
  };
  print "\033[7;31mMessage not recognised:\033[0m\n$v\n";
  die "Message not recognised";
};

sub check_upgradable {
  my @r = split /\n/, `apt list --upgradable 2>/dev/null`;
  shift @r;
  return map { $_ =~ /^([^\/]+)(?=\/)/ } @r;
};

sub is_upgrade {
  print "\033[7;33mUpgrade packages? [y/n]:\033[0m  ";
  my $is = lc(<STDIN>);
  chomp $is;
  while (not $is =~ /^[ny]$/) {
    print "\033[7;35mPlease enter only y or n\033[0m\n";
    $is = &is_upgrade ? 'y' : 'n';
  };
  return $is eq 'y';
};
