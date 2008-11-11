package XML::Liberal::Remedy::Declaration;
use strict;
use base qw( XML::Liberal::Remedy );

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    if ($$xml_ref =~ s/^\s+(?=<)//) { # s/^[^<]+//
        return 1;
    }

    Carp::carp("Can't find white spaces at the start of the document.");
    return;
}

1;
