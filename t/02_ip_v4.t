#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [
		'0.0.0.0',
		'1.1.1.1',
		'127.0.0.1',
		'111.222.333.444',
		'10.10.1.255',
		'255.255.255.255',
		'8.8.8.8',
		'192.168.3.200',
		'4.55.66.101',
		'23.233.89.0',
	],

	invalid => [
		undef,
		'',
		'.12.12.12',
		'127.0.0.',
		'1.1.1.1111',
		'5555.0.0.33',
		'12.1234.12.12',
		'11.11.1111.11',
		'10R',
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
		'0x34ed',
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
		'List of Strange Invalid numbers',
		'“(),:;<>[\\]',
	],
);

plan tests => scalar(@{$test_values{valid}}) + scalar(@{$test_values{invalid}});

foreach my $test_str (@{$test_values{valid}})
{
	ok(defined(Untaint::ip_v4($test_str)), "valid: $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(! defined(Untaint::ip_v4($test_str)), "invalid: $test_str");
}

done_testing();
