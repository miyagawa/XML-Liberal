package XML::Liberal::Remedy::HTMLEntity;
use strict;
use base qw( XML::Liberal::Remedy );

use HTML::Entities ();

my %DECODE = map {
    (my $name = $_) =~ s{\;\z}{};
    $name => sprintf '&#x%x;', ord $HTML::Entities::entity2char{$_}
} keys %HTML::Entities::entity2char;

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    $$xml_ref =~ s{&([a-zA-Z0-9]+);}{
        $DECODE{$1}
            || Carp::carp("Can't find named HTML entity $1, line $self->{line} pos $self->{pos}: $self->{error}")
    }ge;

    return 1;
}

1;
