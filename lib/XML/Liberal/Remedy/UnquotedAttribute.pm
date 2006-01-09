package XML::Liberal::Remedy::UnquotedAttribute;
use strict;
use base qw( XML::Liberal::Remedy );

use List::Util qw( min );

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $line = $self->{line} - 1;
    my $index = 0;
    while ($line) {
        $index = index($$xml_ref, "\n", $index + 1);
        $line--;
    }

    $index += $self->{pos} + 1;

    my $buffer = substr($$xml_ref, $index, min(64, length($$xml_ref) - 1));
       $buffer =~ s/^([^\s>]+)/"$1"/;
    substr($$xml_ref, $index, length($buffer), $buffer);
    return;

    Carp::carp("Can't find unquoted attribute in line $self->{line} pos $self->{pos}: $self->{error}");
}

1;
