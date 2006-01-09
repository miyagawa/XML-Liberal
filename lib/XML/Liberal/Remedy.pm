package XML::Liberal::Remedy;
use strict;
use base qw( Class::Accessor );

sub new {
    my $class = shift;
    my($driver, $line, $pos, $error) = @_;
    bless { driver => $driver, line => $line,
            pos => $pos, error => $error }, $class;
}

sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    $$xml_ref;
}

1;
