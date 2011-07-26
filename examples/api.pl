#!/usr/bin/perl

use strict;
use warnings;
use lib '../lib';
use Net::WholesaleSystem;

my $WholesaleSystem = Net::WholesaleSystem->new(
    resellerID => $ENV{resellerID},
    apiKey     => $ENV{apiKey},
    is_ote     => 1,
    debug      => 1,
);

my $balance = $WholesaleSystem->balanceQuery or die $WholesaleSystem->errstr;
print $balance;