#!/usr/bin/perl -T
use strict;
use Test::More;
use Untaint;

my @test_values = ();
my $test_count = 0;

++$test_count;
ok(!Untaint::is_tainted($test_count), "test_count should not be tainted");

++$test_count;
ok(!Untaint::is_tainted(@test_values), "test_values should not be tainted");

my $taint_test_file = "/tmp/tainttest.txt";
open(FH, ">", $taint_test_file) || die("Unable to open $taint_test_file for writing. $!");
print FH "1000\n";
close(FH);

open(FH, "<", $taint_test_file) || die("Unable to open $taint_test_file for reading. $!");
my $file_value_test = <FH>;
close(FH);

++$test_count;
ok(Untaint::is_tainted($file_value_test), "file_value_test should be tainted");

++$test_count;
$file_value_test = Untaint::positive_integer($file_value_test);
ok(!Untaint::is_tainted($file_value_test), "file_value_test should now be untainted");

unlink($taint_test_file);

if (@ARGV)
{
	for (0 .. $#ARGV)
	{
		++$test_count;
		ok(Untaint::is_tainted($ARGV[$_]), "Command line arg at index $_ should be considered tainted");
	}
}

done_testing($test_count);
