#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => [
		'/tmp/temp_file.txt',
		'/tmp/cache/hold-stuff.cache',
		'blah.log',
		'/var/www/site/',
		'/var/www/site/index.html',
		'this/is/path123/_to_a_file',
		'/this/is/path123/_to_a_file-2018',
		'/1/place/test',
		'/_stuff/file.pl',
		'/-test/filename1',
		'_filename',
		'example',
		'example/',
		'/example',
		'/123.456.789',
		'/tmp/..hidden-w-two-dots',
		'0x34ed',
	],

	invalid => [
		undef,
		'',
		'-filename', # iffy - should this be allowed?
		'../../etc/passwd',
		'/var/../etc/hosts',
		'1,2,3,4,5,6,7',
		'#999999',
		'****',
		'15%',
		'$456',
		'test@example.com',
		"1;DROP TABLE users",
		"1'; DROP TABLE users-- 1",
		"' OR 1=1 -- 1",
		"' OR '1'='1",
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
	ok(defined(Untaint::linux_file_path($test_str)), "valid: $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(! defined(Untaint::linux_file_path($test_str)), "invalid: $test_str");
}

done_testing();
