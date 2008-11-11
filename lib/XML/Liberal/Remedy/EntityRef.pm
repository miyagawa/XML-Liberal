package XML::Liberal::Remedy::EntityRef;
use strict;
use base qw( XML::Liberal::Remedy );

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s/&(?!\w+;|#(?:x[a-fA-F0-9]+|\d+);)/&amp;/g;
    return 1 if $match;

    # there's no &bar in this XML document ...?
    Carp::carp("Can't find unescaped &, line $self->{line} pos $self->{pos}: $self->{error}");
    return;
}

1;
