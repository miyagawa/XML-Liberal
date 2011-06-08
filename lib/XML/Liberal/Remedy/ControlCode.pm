package XML::Liberal::Remedy::ControlCode;
use strict;
use base qw( XML::Liberal::Remedy );

use Encode;

my $ERROR_RX = do {
    my $pat = join '|', (
        'CData section not finished',
        'PCDATA invalid Char value \d+',
        'Char 0x[0-9A-F]+ out of allowed range',
    );
    qr/^:\d+: parser error : (?:$pat)/;
};

sub handles_error {
    my $class = shift;
    my($error, $error1, $error2) = @_;

    return $error =~ $ERROR_RX;
}

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $string = $$xml_ref;
    my $match  = $string =~ s/[\x00-\x08\x0b-\x0c\x0e-\x1f\x7f]+//g;
    if ($match) {
        $$xml_ref = $string;
        return 1;
    }

    Carp::carp("Can't find control code line $self->{line}: $self->{error}");
    return;
}

1;
