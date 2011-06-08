package XML::Liberal::Remedy::XHTMLEmptyTag;
use strict;
use base qw( XML::Liberal::Remedy );

use HTML::Tagset ();

my @ELEMENTS = sort keys %HTML::Tagset::emptyElement;
my $ERROR_RX = do {
    my $pat = join '|', @ELEMENTS;
    qr/^:\d+: parser error : Opening and ending tag mismatch: (?i:$pat)/;
};
my $TAG_RX = do {
    my $pat = join '|', @ELEMENTS;
    qr{(<((?i:$pat)) (?: \s[^>]*)? ) (?<! /) (?= > (?! \s*</\2\s*>))}x;
};

sub new {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;

    return if $error !~ $ERROR_RX;
    return $class->new_with_location(@_);
}

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    return 1 if $$xml_ref =~ s{$TAG_RX}{$1 /}g;

    Carp::carp("Can't find XHTML empty-element tags: line $self->{line} pos $self->{pos}: $self->{error}");
    return;
}

1;
