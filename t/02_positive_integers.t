#!/usr/bin/perl
use strict;
use Test::More;
use Untaint;

my %test_values = (
	valid => {
		'0' => ['0'],
		'1' => ['1'],
		'2' => ['2'],
		'3' => ['3'],
		'4' => ['4'],
		'5' => ['5'],
		'6' => ['6'],
		'7' => ['7'],
		'8' => ['8'],
		'9' => ['9'],
		'10' => ['10'],
		'21' => ['21'],
		'32' => ['32'],
		'98' => ['98'],
		'100' => ['100'],
		'555' => ['555'],
		'999' => ['999'],
		'1001' => ['1001'],
		'12345' => ['12345'],
		'234567' => ['234567'],
		'34567089' => ['34567089'],
		'01234' => ['01234'],
		'9999' => ['9999'],
		'123456' => ['123456'],
		'1234567890' => ['1234567890'],
		'289452730459029' => ['289452730459029'],
		'98765432109876543210' => ['98765432109876543210'],
		"289452730459029 98765432109876543210" => ['289452730459029','98765432109876543210'],
		"289452730459029,98765432109876543210" => ['289452730459029','98765432109876543210'],
		"1,2,3,4,5,6,7,8,9,10" => ["1","2","3","4","5","6","7","8","9","10"],
		"1, 2, 3, 4, 5, 6, 7, 8, 9, 10" => ["1","2","3","4","5","6","7","8","9","10"],
		"1|22|333|4444|55555|666666|7777777|88888888|" => ['1','22','333','4444','55555','666666','7777777','88888888'],
		"123\t456\t789" => ['123','456','789'],
		"18\n459\n9095\n1\n0" => ['18','459','9095','1','0'],
		"1,2\t3|4\n5" => ["1","2","3","4","5"],
		"513-791-3100" => ["513","791","3100"],
		"1;DROP TABLE users" => ['1'],
		"1'; DROP TABLE users-- 1" => ['1','1'],
		"' OR 1=1 -- 1" => ['1','1','1'],
		"' OR '1'='1" => ['1','1'],
		'-1' => ['1'],
		'-0' => ['0'],
		'-33' => ['33'],
		'9-9' => ['9','9'],
		'12345-' => ['12345'],
		'.5' => ['5'],
		'1234.56' => ['1234','56'],
		'56e3.456' => ['56','3','456'],
		'd039791cc508a3b7af9b6d1d2a3568b354cbfb6d' => ['039791','508','3','7','9','6','1','2','3568','354','6'],
		'999999999999999999999' => ['99999999999999999999','9'],
		'2323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323' => [('23232323232323232323') x 5],
		'3.1459' => ['3','1459'],
		'1/4' => ['1','4'],
		'0x34ed' => ['0','34'],
		'97ef34' => ['97','34'],
		'#999999' => ['999999'],
		'15%' => ['15'],
		'$456' => ['456'],
		'111.256.0.44' => ['111','256','0','44'],
		'{0}' => ['0'],
	},

	invalid => [
		'',
		'x,y,z',
		'****',
		'test@example.com',
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
		'%*.*s',
		'Joe Schmoe',
		'#@%^%#$@#$@#',
		'?????',
		'List of Strange Invalid numbers',
		'???(),:;<>[\\]',
	],
);

plan tests => scalar(keys %{$test_values{valid}}) + scalar(@{$test_values{invalid}});

foreach my $test_str (keys %{$test_values{valid}})
{
	is_deeply([Untaint::positive_integers($test_str)], $test_values{valid}->{$test_str}, "valid: $test_str");
}

foreach my $test_str (@{$test_values{invalid}})
{
	ok(! Untaint::positive_integers($test_str), "invalid: $test_str");
}

done_testing();
