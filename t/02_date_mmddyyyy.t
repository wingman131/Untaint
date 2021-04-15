#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [
		'01-01-1999',
		'1-1-1999',
		'01/01/1999',
		'1/1/1999',
		'01.01.1999',
		'1.1.1999',
		'1-1/1999',
		'1.1-1999',
		'12-31-1999',
		'12-1-1999',
		'09-18-2003',
		'10-19-2007',
		'05.22.2010',
		'11/24/2012',
		'05-6-1900',
		'7-09-1875',
		'5-6-1289',
		'02-29-2050',
		# the function only tests whether the string matches the right pattern, not that it's a real and valid date
		'56-78-1234',
		'9-9-9999',
		'00-00-0001',
	],
	invalid => [
		'01-01-1999-12',
		'/01/01/1999',
		'01/01/19/99',
		'05..22.2010',
		'05.22..2010',
		'05//22/2010',
		'05/22//2010',
		'05-22--2010',
		'1-2-3',
		'11-22-33',
		'2000--',
		'2008-1-',
		'2010--15',
		'--2000',
		'-1-2008',
		'-15-2010',
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

foreach my $test_str (@{$test_values{valid}})
{
	ok(defined(Untaint::date_mmddyyyy($test_str)), "valid: $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(! defined(Untaint::date_mmddyyyy($test_str)), "invalid: $test_str");
}

done_testing();
