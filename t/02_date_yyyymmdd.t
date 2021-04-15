#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [
		'1999-01-01',
		'1999-1-1',
		'1999/1/1',
		'1999-12-31',
		'1999-12-1',
		'2003-09-18',
		'2007-10-19',
		'1900-05-6',
		'1875-7-09',
		'1289-5-6',
		'2050-02-29',
		# any non-digit delimiter will do
		'2010.05.22',
		'2012/11/24',
		'2017*08*14',
		'2017,08,14',
		'2017~08~14',
		# the function only tests whether the string matches the right pattern, not that it's a real and valid date
		'2012 02 30',
		'1234-56-78',
		'9999-9-9',
		'0001-00-00',
	],
	invalid => [
		'1-2-3',
		'11-22-33',
		'2000--',
		'2008-1-',
		'2010--15',
		'201/01/31',
		'99-12-12',
		'this_IS/_TEST',
		'quisnostrudexercitationullamcorpersuscipitlobortisnislutaliquipexeacommodoconsequatDuisautemveleumiriuredolorinhendreritinvulputatevelitessemolestieconsequatvelillumdoloreeufeugiatnullafacilisisatveroerosetaccumsanetiustoodiodignissimquiblanditpraesentluptatumzzrildelenitaugueduisdoloretefeugaitnullafacilisi',
		'1A*9',
		'',
		'FOREIGN-KEY',
		'Lorem Ispem',
		'-1',
		'-0',
		'-33',
		'9-9',
		'12345-',
		'.5',
		'1234.56',
		'56e3.456',
		'56' x 500,
		'1,2,3,4,5,6,7',
		'3.1459',
		'1/4',
		'#999999',
		'****',
		'15%',
		'$456',
		'test@example.com',
		"1;DROP TABLE users",
		"1'; DROP TABLE users-- 1",
		"' OR 1=1 -- 1",
		"' OR '1'='1",
		'-',
		'--',
		'--version',
		'--help',
		'$USER',
		'/dev/null; touch /tmp/blns.fail ; echo',
		'`touch /tmp/blns.fail`',
		'$(touch /tmp/blns.fail)',
		'@{[system "touch /tmp/blns.fail"]}',
		'$HOME',
		"\$ENV{'HOME'}",
		'%d',
		'%s',
		'{0}',
		'%*.*s',
		'Joe Schmoe',
		'#@%^%#$@#$@#',
		'?????',
		'111.222.333.444',
		'10.10.1.255',
		'List of Strange Invalid numbers',
		'“(),:;<>[\\]',
	],
);

plan tests => (scalar(@{$test_values{valid}}) * 2) + scalar(@{$test_values{invalid}});

foreach my $test_str (@{$test_values{valid}})
{
	ok(defined(Untaint::date_yyyymmdd($test_str)), "valid (scalar context): $test_str");

	my @date = Untaint::date_yyyymmdd($test_str);
	ok(scalar(@date) == 3, "valid (list context): $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(! defined(Untaint::date_yyyymmdd($test_str)), "invalid: $test_str");
}

done_testing();
