package XML::Liberal::Remedy::NotUTF8;
use strict;
use base qw( XML::Liberal::Remedy );

use Encode;
use Encode::Guess;

__PACKAGE__->mk_accessors(qw( guess_encodings ));

sub new {
    my $class = shift;
    my ($driver, $error, $error1, $error2) = @_;

    my ($line) = $error =~ /^:(\d+): parser error : Input is not proper UTF-8, indicate encoding !/
        or return;
    my $self = bless { driver => $driver, error  => $error,
                       error1 => $error1, error2 => $error2,
                       line   => $line,   pos    => undef }, $class;
    $self->guess_encodings($driver->guess_encodings);
    return $self;
}

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my @suspects = @{ $self->guess_encodings || [ qw(euc-jp shift_jis utf-8) ] };
    my $enc = guess_encoding($$xml_ref, @suspects);
    if (ref($enc)) {
        Encode::from_to($$xml_ref, $enc->name, "UTF-8");
        return 1;
    } else {
        # fallback to UTF-8 and do roundtrip conversion
        my $old = $$xml_ref;
        my $xml = Encode::encode("utf-8", Encode::decode("utf-8", $$xml_ref));
        $$xml_ref = $xml;
        return $$xml_ref ne $old;
    }
}

1;
