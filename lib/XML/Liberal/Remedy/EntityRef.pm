package XML::Liberal::Remedy::EntityRef;
use strict;
use base qw( XML::Liberal::Remedy );

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s/&(?!amp|quot|lt|gt)/&amp;/g;
    return if $match;

    # there's no &bar in this XML document ...?
    Carp::carp("Can't find unescaped &, line $self->{line} pos $self->{pos}: $self->{error}");
}

1;
