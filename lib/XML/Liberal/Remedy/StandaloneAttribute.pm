package XML::Liberal::Remedy::StandaloneAttribute;
use strict;
use base qw( XML::Liberal::Remedy );

use List::Util qw( min );

__PACKAGE__->mk_accessors(qw( attribute ));

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

    # <hr noshade />
    #             ^
    my $attr = $self->attribute;
    $index -= length($attr) + 1; # xxx is there a case that it's not 1?

    my $buffer = substr($$xml_ref, $index, min(64, length($$xml_ref) - 1));
       $buffer =~ s/^\Q$attr\E/$attr="$attr"/;
    substr($$xml_ref, $index, length($buffer), $buffer);
    return;

    Carp::carp("Can't find standalone attribute '$attr' in line $self->{line} pos $self->{pos}: $self->{error}");
}

1;
