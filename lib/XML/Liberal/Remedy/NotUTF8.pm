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
        # fallback to UTF-8 and do roundtrip conversion
        my $xml = Encode::encode("utf-8", Encode::decode("utf-8", $$xml_ref));
        $$xml_ref = $xml;
    }
}

1;
