#!/usr/bin/perl
use strict;
use Test::More tests => 1;

BEGIN
{
	use_ok("Untaint");
}

unless (grep { /Untaint/ } keys %INC)
{
	BAIL_OUT("Unable to 'use' Untaint");
}
