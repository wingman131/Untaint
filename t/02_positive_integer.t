#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [qw(
		0 1 2 3 4 5 6 7 8 9 10 21 32 43 54 65 76 87 98 100 555 999 1001 12345 234567 34567089
		01234 9999 123456 1234567890 289452730459029 98765432109876543210
	)],

	invalid => [
		'',
		'-1',
		'-0',
		'-33',
		'9-9',
		'12345-',
		'.5',
		'1234.56',
		'56e3.456',
		'd039791cc508a3b7af9b6d1d2a3568b354cbfb6d',
		'9' x 21,
		'23' x 99,
		'56' x 500,
		'1,2,3,4,5,6,7',
		'3.1459',
		'1/4',
		'0x34ed',
		'97ef34',
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
	ok(defined(Untaint::positive_integer($test_str)), "valid: $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(! defined(Untaint::positive_integer($test_str)), "invalid: $test_str");
}

done_testing();
