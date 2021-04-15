#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my @env_vars = qw(PATH IFS CDPATH ENV BASH_ENV);

plan tests => scalar(@env_vars);

foreach my $evar (@env_vars)
{
	ok(!exists($ENV{$evar}), "ENV{$evar} has been removed");
}
