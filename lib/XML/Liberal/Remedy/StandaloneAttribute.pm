package XML::Liberal::Remedy::StandaloneAttribute;
use strict;
use base qw( XML::Liberal::Remedy );

use List::Util qw( min );

__PACKAGE__->mk_accessors(qw( attribute ));

sub new {
    my $class = shift;
    my ($driver, $error, $error1, $error2) = @_;

    my ($attr) = $error =~ /^:\d+: parser error : Specification mandate value for attribute (\w+)/
        or return;
    my $self = $class->new_with_location(@_) or return;
    $self->attribute($attr);
    return $self;
}

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $index = $self->error_location($xml_ref);

    # <hr noshade />
    #             ^
    my $attr = $self->attribute;
    $index -= length($attr) + 1; # xxx is there a case that it's not 1?

    my $buffer = substr($$xml_ref, $index, min(64, length($$xml_ref) - 1));
       $buffer =~ s/^\Q$attr\E/$attr="$attr"/;
    substr($$xml_ref, $index, length($buffer), $buffer);
    return 1; # xxx

    Carp::carp("Can't find standalone attribute '$attr' in line $self->{line} pos $self->{pos}: $self->{error}");
    return;
}

1;
