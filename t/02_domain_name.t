#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [
		'localhost',
		'example.com',
		'example.io',
		'example.i',
		'example.museum',
		'example.city',
		'web.example.info',
		'google.com',
		'g-1.google.com',
		'test.example.com',
		'test1.example.com',
		'mv-research.com',
		'www.mv-research.com',
		'www.mv-research.mobile',
		'm.mv-research.com',
		'mail.mv-research.com',
		'dev.test.mv-research.com',
		'dev-1.test.mv-research.com',
		'marketvisionresearch.us',
		'survey.marketvision.research',
		'test1.test2.test3.mv-research.me',
	],

	invalid => [
		undef,
		'',
		'example',
		'example.c-om',
		'example.-us',
		'example.mobile-',
		'-.example.ly',
		'-example.io',
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
	ok(defined(Untaint::domain_name($test_str)), "valid: $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(! defined(Untaint::domain_name($test_str)), "invalid: $test_str");
}

done_testing();
