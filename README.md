# Untaint.pm

Perl module for untainting (sanitizing) data from external sources.

Automatically clears `PATH` and other dangerous values from `%ENV`.

## USAGE

```perl
use Untaint;

my $id = Untaint::positive_integer($param{'id'});

my @ids = Untaint::positive_integers($param{'id_list'});

my $checksum = Untaint::hexadecimal($param{'checksum'});

my $keyword = Untaint::word($param{'keyword'});

my $email = Untaint::email($param{'email'});

my $fname = Untaint::name($param{'first_name'});

my $other = Untaint::untaint(qr/[a-z. ;&]+/, $param{'other'});
```

## SUBROUTINES

### `is_tainted()`

When perl is running in taint mode (`-T`), this indicates whether the value or values are considered tainted. If not in taint mode, everything returns false.

### `positive_integer()`

Untaint a positive integer value. Returns the untainted value or undef.

### `positive_integers()`

Untaint a string that contains a delimited list of positive integers.
It does not matter what the delimiter is (as long as it's not an integer, of course). Returns a list of positive integers (maybe be empty if none were found).

### `number()`

Untaint a numeric value (interger, float, positive, negative, etc. - not scientific notation though). Returns the untainted value or undef.

### `hexadecimal()`

Untaint a hexadecimal value (e.g. MD5 or SHA1 checksum). Returns the untainted value or undef.

### `word()`

Untaint a "word" value (digits, upper and lowercase letters, and underscores). Returns the untainted value or undef.

### `email()`

Untaint an email address. Returns the untainted value or undef.

### `name()`

Untaint a name (English assumed). Returns the untainted value or undef.

### `us_zip_code()`

Untaint a U.S. zip code (5 digits). Also handles zip + 4. Returns the untainted value or undef.

### `date_yyyymmdd()`

Untaint a date in year-month-day format. Allows for pretty much any delimiter.
Returns the untainted value as an array or scalar depending on context, or undef if the pattern isn't matched.

### `date_mmddyyyy()`

Untaint a date in month-day-year format. Allows dashes, slashes, and dots as delimiters. Returns the untainted value or undef.

### `ip_v4()`

Untaint and IP v4 address.

### `domain_name()`

Untaint a domain name. Expects at least a TLD plus a second-level domain.

### `linux_file_path()`

Untaint a linux file path. It uses a very strict pattern, so things that are technically valid paths might get screened out. It doesn't like two dots in a row, and it keeps the allowed set of characters to lettes, numbers, dots, dashes, and underscores.

### `untaint()`

Untaint a value using a specified pattern. Returns the untainted value or undef.

```perl
my $untainted_val = Untaint::untaint(qr/[xyz]{3,5}/, $tainted_val);
```

Do not supply back-referencing parentheses in the pattern; they will be added by the subroutine.

## AUTHOR

John Winger

## COPYRIGHT

(c) Copyright 2016-2021, John Winger.

This program is free software. You may copy or redistribute it under the same terms as Perl itself.
