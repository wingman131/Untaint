#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my @test_values = (
	{
		pattern => qr/^[A-Z]{2,4}$/,
		valid => [
			'AA',
			'AAA',
			'AAAA',
			'ZZ',
			'ZZZ',
			'ZZZZ',
			'AB',
			'ABC',
			'ABCD',
			'YZ',
			'XYZ',
			'WXYZ',
			'EF',
			'QRS',
			'TUVI',
			'JOHN',
			'JANE',
			'JOE',
			'ID',
		],
		invalid => [
			'A',
			'Z',
			'a',
			'z',
			'abc',
			'xyz',
			'ABCDE',
			'1999/1/1',
			'1-2-3',
			'11-22-33',
			'2000--',
			'2008-1-',
			'2010--15',
			'99-12-12',
			'2010.05.22',
			'2012/11/24',
			'this_IS/_TEST',
			'quisnostrudexercitationullamcorpersuscipitlobortisnislutaliquipexeacommodoconsequatDuisautemveleumiriuredolorinhendreritinvulputatevelitessemolestieconsequatvelillumdoloreeufeugiatnullafacilisisatveroerosetaccumsanetiustoodiodignissimquiblanditpraesentluptatumzzrildelenitaugueduisdoloretefeugaitnullafacilisi',
			'QUISNOSTRUDEXERCITATIONULLAMCORPERSUSCIPITLOBORTISNISLUTALIQUIPEXEACOMMODOCONSEQUATDUISAUTEMVELEUMIRIUREDOLORINHENDRERITINVULPUTATEVELITESSEMOLESTIECONSEQUATVELILLUMDOLOREEUFEUGIATNULLAFACILISISATVEROEROSETACCUMSANETIUSTOODIODIGNISSIMQUIBLANDITPRAESENTLUPTATUMZZRILDELENITAUGUEDUISDOLORETEFEUGAITNULLAFACILISI',
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
	},
	{
		pattern => qr/^(?:[A-Z]\d{1,9})+$/i,
		valid => [
			'A1',
			'A12',
			'A123',
			'A1A1',
			'A12A12',
			'A123A123',
			'Z0',
			'Z09',
			'Z098',
			'Z0Z0Z0',
			'Z09Z09Z09Z09',
			'Z098Z098Z098Z098Z098',
			'B2',
			'C32',
			'a9',
			'z3',
			'x4567890',
			'W123456789',
			'C32C32',
			'a9a9a9',
			'z3z3z3z3z3',
			'x4567890x4567890x4567890',
			'W123456789W123456789W123456789W123456789W123456789W123456789W123456789',
			'e55555',
			'Q7654321',
			's000000000',
			'J666',
			'y33',
			'L1',
			'i8903',
		],
		invalid => [
			'A',
			'Z',
			'a',
			'z',
			'abc',
			'xyz',
			'ABCDE',
			'AA123',
			'zS834834893489',
			'1999/1/1',
			'1-2-3',
			'11-22-33',
			'2000--',
			'2008-1-',
			'2010--15',
			'99-12-12',
			'2010.05.22',
			'2012/11/24',
			'this_IS/_TEST',
			'quisnostrudexercitationullamcorpersuscipitlobortisnislutaliquipexeacommodoconsequatDuisautemveleumiriuredolorinhendreritinvulputatevelitessemolestieconsequatvelillumdoloreeufeugiatnullafacilisisatveroerosetaccumsanetiustoodiodignissimquiblanditpraesentluptatumzzrildelenitaugueduisdoloretefeugaitnullafacilisi',
			'QUISNOSTRUDEXERCITATIONULLAMCORPERSUSCIPITLOBORTISNISLUTALIQUIPEXEACOMMODOCONSEQUATDUISAUTEMVELEUMIRIUREDOLORINHENDRERITINVULPUTATEVELITESSEMOLESTIECONSEQUATVELILLUMDOLOREEUFEUGIATNULLAFACILISISATVEROEROSETACCUMSANETIUSTOODIODIGNISSIMQUIBLANDITPRAESENTLUPTATUMZZRILDELENITAUGUEDUISDOLORETEFEUGAITNULLAFACILISI',
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
	},

# 	{
# 		pattern => qr//,
# 		valid => [
# 		],
# 		invalid => [
# 		],
# 	},

);

#plan tests => scalar(@{$test_values{valid}}) + scalar(@{$test_values{invalid}});
my $test_count = 0;

foreach my $test_href (@test_values)
{
	my $test_pattern = $test_href->{'pattern'};

	foreach my $test_str (@{$test_href->{'valid'}})
	{
		ok(defined(Untaint::untaint($test_pattern, $test_str)), "valid: $test_str");
		++$test_count;
	}

	foreach my $test_str (@{$test_href->{'invalid'}})
	{
		ok(! defined(Untaint::untaint($test_pattern, $test_str)), "invalid: $test_str");
		++$test_count;
	}
}

done_testing($test_count);