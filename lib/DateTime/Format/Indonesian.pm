package DateTime::Format::Indonesian;

use 5.010001;
use strict;
use warnings;

use DateTime;

# VERSION

our $_Current_Dt; # for testing only, to mock current time

my %short_id_month_names = (
    jan => 1,
    feb => 2, peb => 2,
    mar => 3, mrt => 3,
    apr => 4,
    mei => 5,
    jun => 6,
    jul => 7,
    agu => 8, agt => 8,
    sep => 9, sept => 9,
    okt => 10,
    nop => 11, nov => 11,
    des => 12,
);

my %short_en_month_names = (
    jan => 1,
    feb => 2,
    mar => 3,
    apr => 4,
    may => 5,
    jun => 6,
    jul => 7,
    aug => 8,
    sep => 9,
    oct => 10,
    nov => 11,
    dec => 12,
);

my %long_id_month_names = (
    januari => 1,
    februari => 2, pebruari => 2,
    maret => 3,
    april => 4,
    mei => 5,
    juni => 6,
    juli => 7,
    agustus => 8,
    september => 9,
    oktober => 10,
    november => 11, nopember => 12,
    desember => 12,
);

my %long_en_month_names = (
    january => 1,
    february => 2,
    march => 3,
    april => 4,
    may => 5,
    june => 6,
    july => 7,
    august => 8,
    september => 9,
    october => 10,
    november => 11,
    december => 12,
);

# assume last century if year is larger than current year
sub _convert_to_4dig_year {
    my ($self, $y) = @_;

    state $curdt    = $_Current_Dt // DateTime->now;
    state $curyear  = $curdt->year;
    state $cur2digy = $curyear % 100;
    state $curcent  = $curyear - $cur2digy;

    return $y if $y >= 100;
    if ($y > $cur2digy) {
        return $y + $curcent-100;
    } else {
        return $y + $curcent;
    }
}

sub _find_month {
    my ($self, $m) = @_;

    state $months = do {
        my %mm = (%short_en_month_names, %long_en_month_names,
                  %short_id_month_names, %long_id_month_names);
        \%mm;
    };

    $m = lc($m);
    die "Invalid month name '$m'" unless $months->{$m};
    $months->{$m};
}

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub parse_datetime {
    my ($self, $str) = @_;

    if ($str =~ m!^(\d+)[ /-]+(\w{3,15})[ ,/-]+(\d\d\d\d|\d\d)$!) {
        my $d = $1;
        my $m = $self->_find_month($2);
        my $y = $self->_convert_to_4dig_year($3);
        return DateTime->new(day=>$d, month=>$m, year=>$y);
    } else {
        return undef;
    }
}

1;
# ABSTRACT: Parse and format Indonesian dates

=head1 SYNOPSIS

 use DateTime::Format::Indonesian;

 my $dt = DateTime::Format::Indonesian->parse_datetime("14 agt 2013");


=head1 DESCRIPTION

This is an early release. Not all things have been implemented yet.


=head1 METHODS

=head2 new()

=head2 $fmt->format_datetime()

NOT YET IMPLEMENTED.

=head2 $fmt->parse_datetime($str) => OBJ

Parse an Indonesian string. Return undef if C<$str> cannot be parsed. Currently
the recognized forms include:

 dd-mmm-yy or dd-mmm-yy   (other separators include whitespace or dash)
 dd-mmmm-yy or dd-mmmm-yy (long month names)


=head1 SEE ALSO

L<DateTime>

=cut
