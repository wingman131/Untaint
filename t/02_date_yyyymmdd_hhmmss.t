#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [
		'1999-01-01 12:12:12',
		'1999-1-1 00:00:00',
		'1999/1/1 13:00:59',
		'1999-12-31 15:23',
		'1999-12-1 01:01:19',
		'2003-09-18 23:59:59',
		'2007-10-19T03:55:00',
		'1900-05-6T06:42',
		'1875-7-09 17:19',
		'1289-5-6T18:50:01',
		'2050-02-29 14:00:00',
		# any non-digit delimiter will do
		'2010.05.22 22:56:03',
		'2012/11/24T20:09:10',
		'2017*08*14 19:19:19',
		'2017,08,14 11:11:11',
		'2017~08~14 12:12:0',
		# the function only tests whether the string matches the right pattern, not that it's a real and valid date
		'1234-56-78 78:99:71',
		'9999-9-9 00:66:77',
		'0001-00-00T88:60:00',
	],
	invalid => [
		'2012 02 30 55:61',
		'2003-09-18 23;59;59',
		'1-2-3',
		'11-22-33',
		'2003-01-04',
		'2003-01-04 17',
		'17:59:44',
		'2004-08 19:14:55',
		'2020-12-16 ::00',
		'2000--T23:45:18',
		'2008-1-',
		'2010--15',
		'201/01/31 99:99:99',
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

plan tests => scalar(@{$test_values{valid}}) + scalar(@{$test_values{invalid}});

for my $test_str (@{$test_values{valid}})
{
	ok(defined(Untaint::date_yyyymmdd_hhmmss($test_str)), "valid (scalar context): $test_str");

}

for my $test_str (@{$test_values{invalid}})
{
	ok(! defined(Untaint::date_yyyymmdd_hhmmss($test_str)), "invalid: $test_str");
}

done_testing();
