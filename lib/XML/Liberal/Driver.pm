package XML::Liberal::Driver;
use strict;
use base qw( Class::Accessor );
__PACKAGE__->mk_accessors(qw( guess_encodings ));

sub new {
    my $class = shift;
    my %param = @_;

    my $self = bless {%param}, $class;
    $self->init;
    $self;
}

sub init {
    my $self = shift;
    $self->guess_encodings([ qw(euc-jp shift_jis) ])
        unless defined $self->guess_encodings;
}

1;
