package XML::Liberal::Remedy::LowAsciiChars;
use strict;
use base qw( XML::Liberal::Remedy );

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s{(&#(?:(\d+)|x([0-9a-f]{4}));)}{
        ($2 && is_low_ascii($2)) || ($3 && is_low_ascii(hex($3)))
            ? '' : $1;
    }eg;
    return 1 if $match;

    Carp::carp("Can't find low ascii bytes $self->{error}");
    return;
}

sub is_low_ascii {
    my $num = shift;
    $num <= 31 || $num == 127;
}

1;
