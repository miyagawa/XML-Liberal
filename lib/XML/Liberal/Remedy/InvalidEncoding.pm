package XML::Liberal::Remedy::InvalidEncoding;
use strict;
use base qw( XML::Liberal::Remedy );

use Encode;
use Encode::Guess;

__PACKAGE__->mk_accessors(qw( guess_encodings ));

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $encoding = ( $$xml_ref =~ /<\?xml version="1\.0" encoding="(.*?)"/ )[0];
    unless ($encoding) {
        my @suspects = @{ $self->guess_encodings || [ qw(euc-jp shift_jis utf-8) ] };
        my $enc = guess_encoding($$xml_ref, @suspects);
        $encoding = $enc->name;
    }

    if ($encoding) {
        Encode::from_to($$xml_ref, $encoding, "UTF-8");
        $$xml_ref =~ s/<\?xml version="1\.0" encoding=".*?"/<?xml version="1.0" encoding="utf-8"/;
        return 1;
    }

    Carp::carp("Can't find encoding from XML declaration: ", substr($$xml_ref, 0, 128));
    return;
}

1;
