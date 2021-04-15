#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [
		'webmaster@mv-research.com',
		'test@example.com',
		'test@example.co',
		'test@example.museum',
		'test@example.gov',
		'test@example.edu',
		'test@example.org',
		'test@example.us',
		'test@example.me',
		'test@some.example.net',
		'a.test@some.example.net',
		'a-test@example.com',
		'firstname.lastname@example.com',
		'email@subdomain.example.com',
		'firstname+lastname@example.com',
		'email@123.123.123.123',
		'email@[123.123.123.123]',
		'“email”@example.com',
		'1234567890@example.com',
		'email@example-one.com',
		'_______@example.com',
		'email@example.name',
		'email@example.museum',
		'email@example.co.jp',
		'firstname-lastname@example.com',
		'test@xn--example.com',
		'email@example.web',
		'tina.adams@ky.gov',
	],

	invalid => [
		' test@example.me ',
		'test@example',
		'test@',
		'@example.com',
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
		'plainaddress',
		'#@%^%#$@#$@#.com',
		'Joe Smith <email@example.com>',
		'email.example.com',
		'email@example@example.com',
		'.email@example.com',
		'email.@example.com',
		'email..email@example.com',
		'?????@example.com',
		'email@example.com (Joe Smith)',
		'email@-example.com',
		'email@111.222.333.44444',
		'email@example..com',
		'Abc..123@example.com',
		'List of Strange Invalid Email Addresses',
		'“(),:;<>[\\]@example.com',
		'just"not"right@example.com',
		'this\\ is"really"not\\allowed@example.com',
	],
);

plan tests => scalar(@{$test_values{valid}}) + scalar(@{$test_values{invalid}});

diag("Some failure expected with these tests.");
diag("There are things that are technically allowed in email addresses but are not commonly used in real life.");

foreach my $test_str (@{$test_values{valid}})
{
	ok(Untaint::email($test_str), "valid email: $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(!Untaint::email($test_str), "invalid email: $test_str");
}

done_testing();
