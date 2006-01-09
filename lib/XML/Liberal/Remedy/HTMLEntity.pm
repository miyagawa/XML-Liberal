package XML::Liberal::Remedy::HTMLEntity;
use strict;
use base qw( XML::Liberal::Remedy );

use HTML::Entities::Numbered;

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $old = $$xml_ref;
    $$xml_ref = name2hex_xml($$xml_ref);

    return if $$xml_ref ne $old;

    Carp::carp("Can't find named HTML entities, line $self->{line} pos $self->{pos}: $self->{error}");
}

1;
