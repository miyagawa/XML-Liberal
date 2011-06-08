package XML::Liberal::Remedy::LowAsciiChars;
use strict;
use base qw( XML::Liberal::Remedy );

my @low_ascii = (0..8, 11..12, 14..31, 127);
my $dec_rx = do {
    my $pat = join '|', @low_ascii;
    qr/$pat/;
};
my $hex_rx = do {
    my $pat = join '|', map { sprintf '%x', $_ } @low_ascii;
    qr/$pat/i;
};

sub handles_error {
    my $class = shift;
    my($error, $error1, $error2) = @_;

    return $error =~ /^:\d+: parser error : xmlParseCharRef: invalid xmlChar value $dec_rx\b/;
}

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    return 1 if $$xml_ref =~ s{&#(?:0*$dec_rx|[xX]0*$hex_rx);}{}g;

    Carp::carp("Can't find low ascii bytes $self->{error}");
    return;
}

1;
