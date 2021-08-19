package Untaint;
# Author........John Winger
# Description...Help with untainting data from external sources

use strict;

# Make %ENV safer
BEGIN
{
	delete(@ENV{qw(PATH IFS CDPATH ENV BASH_ENV)});
}

my $debugging = 0;
sub debugging_on  { $debugging = 1 }
sub debugging_off { $debugging = 0 }

sub is_tainted
{
	# Copied from perlsec documentation.
	# This only works correctly when perl is running in taint mode (-T);
	# otherwise everything returns false.
	local $@; # Don't pollute caller's value.
	return ! eval { eval("#" . substr(join("", @_), 0, 0)); 1 };
}

sub positive_integer
{
	my ($val) = @_;
	return untaint(qr/^\d{1,20}$/, $val);
	# 20 digits will accommodate an unsigned bigint: 18446744073709551615
}

sub positive_integers
{
	my ($val) = @_;
	my @ints = $val =~ /(\d{1,20})/g;
	warn("No integers found in: $val") if ($debugging && !@ints);
	return @ints;
}

sub number
{
	my ($val) = @_;
	return undef if (length($val) == 0 || $val eq '-0' || $val eq '-');
	return untaint(qr/^-?(?:(?:\d*\.\d+)?|\d+)$/, $val);
}

sub hexadecimal
{
	my ($val) = @_;
	return untaint(qr/^[0-9A-Fa-f]{1,255}$/, $val);
}

sub word
{
	my ($val) = @_;
	return untaint(qr/^\w{1,255}$/, $val);
}

sub email
{
	my ($val) = @_;
	return untaint(qr/^[A-Z0-9.\-_%\+]+\@[A-Z0-9.\-]+\.[A-Z]{2,6}$/i, $val);
}

sub name
{
	my ($val) = @_;
	return untaint(qr/^[A-Z][A-Z\-' .]*$/i, $val);
}

sub us_zip_code
{
	my ($val) = @_;
	return untaint(qr/^\d\d\d\d\d(?:-\d\d\d\d)?$/, $val);
}

sub date_yyyymmdd
{
	my ($val) = @_;

	my @date;

	if ($val =~ /^(\d\d\d\d)\D(\d\d?)\D(\d\d?)$/)
	{
		@date = ($1, $2, $3);
	}
	elsif ($val =~ /^(\d\d\d\d)(\d\d)(\d\d)$/)
	{
		@date = ($1, $2, $3);
	}
	else
	{
		return undef;
	}

	return @date if wantarray;
	return sprintf("%04d-%02d-%02d", @date); # normalize the format of the return value
}

sub date_yyyymmdd_hhmmss
{
	my ($val) = @_;

	# This isn't really ISO 8601 compliant. It's more for MySQL date/time format.
	# Should create a separate sub for testing ISO date/time specifically.
	my ($date, $time) = split(/[ T]/, $val);

	my $date_fmt = date_yyyymmdd($date);
	return undef unless $date_fmt;

	my @time = split(/:/, $time);
	my $time_part_count = scalar(@time);
	return undef if ($time_part_count < 2 || 3 < $time_part_count); # allow with or without seconds

	$time[0] = positive_integer($time[0]);
	$time[1] = positive_integer($time[1]);
	$time[2] = defined($time[2]) ? positive_integer($time[2]) : 0;
	return undef unless (defined($time[0]) && defined($time[1]) && defined($time[2]));

	my $time_fmt = sprintf("%02d:%02d:%02d", @time);

	return $date_fmt . ' ' . $time_fmt;
}

sub date_mmddyyyy
{
	my ($val) = @_;
	return untaint(qr/^\d{1,2}[\-\/\.]\d{1,2}[\-\/\.]\d\d\d\d$/, $val);
}

sub ip_v4
{
	my ($val) = @_;
	return untaint(qr/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/, $val);
}

sub domain_name
{
	my ($val) = @_;
	return $val if $val eq 'localhost'; # allow special case 'localhost'
	return untaint(qr/^(?:[0-9a-z][0-9a-z\-]*?\.)+[a-z]+$/i, $val);
}

sub linux_file_path
{
	my ($val) = @_;

	# Disallow '..' - backing up a directory level. That can lead to Bad Things.
	return undef if $val =~ m!\.\./!;

	return untaint(qr/^[\/\w][0-9A-Za-z\.\/\-_]+$/i, $val);
}

sub untaint
{
	my ($pattern, $val) = @_;

	if ($val =~ /($pattern)/)
	{
		return $1;
	}

	warn("Not a valid value in pattern $pattern: $val") if $debugging;
	return undef;
}

1;
