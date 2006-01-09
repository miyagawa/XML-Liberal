package XML::Liberal::Remedy::NotUTF8;
use strict;
use base qw( XML::Liberal::Remedy );

use Encode;
use Encode::Guess;

__PACKAGE__->mk_accessors(qw( guess_encodings ));

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my @suspects = @{ $self->guess_encodings };
    my $enc = guess_encoding($$xml_ref, @suspects);
    if (ref($enc)) {
        Encode::from_to($$xml_ref, $enc->name, "UTF-8");
        return;
    } else {
        Carp::carp("Can't guess encoding of XML using ", join(", ", @suspects), " line $self->{line}: $self->{error}");
    }
}

1;
