package XML::Liberal::Remedy::UnclosedHTML;
use strict;
use base qw( XML::Liberal::Remedy );

__PACKAGE__->mk_accessors(qw( unclosed detected ));

use HTML::Tagset ();

my $ERROR_RX = do {
    # Exclude void elements
    my $pat = join '|', reverse sort grep { !$HTML::Tagset::emptyElement{$_} }
        keys %HTML::Tagset::isKnown;
    qr/^:\d+: parser error : Opening and ending tag mismatch: ((?i:$pat)) line \d+ and (\S+)/
};

sub new {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;
    my ($unclosed, $detected) = $error =~ $ERROR_RX or return;
    my $self = $class->new_with_location(@_) or return;
    $self->unclosed($unclosed);
    $self->detected($detected);
    return $self;
}

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $unclosed = $self->unclosed;
    my $detected = $self->detected;
    my $index = $self->error_location($xml_ref);
    my $tail = substr $$xml_ref, $index, length($$xml_ref) - $index, '';

    $$xml_ref =~ s{( </ \Q$detected\E \s* > \z )}{</$unclosed>$1$tail}xms
        or Carp::carp("Can't find incorrect close tag"), return;

    return 1;
}

1;
