#!/usr/bin/env perl
use strict;
use GoIDN;
use Benchmark qw(timethis);

my $client = GoIDN->new(program => './scripts/idntest');

# my $response = $client->to_ascii("español.com");

timethis -1, sub {
    my $response = $client->to_ascii("español.com");
};