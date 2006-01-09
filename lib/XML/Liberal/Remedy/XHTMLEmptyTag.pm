package XML::Liberal::Remedy::XHTMLEmptyTag;
use strict;
use base qw( XML::Liberal::Remedy );

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s!<(br|hr|img)(\s[^/>]*)?>!$2 ? "<$1$2 />" : "<$1 />"!eg;
    return if $match;

    Carp::carp("Can't find empty <br>, <hr> nor <img> tags: line $self->{line} pos $self->{pos}: $self->{error}");
}

1;
