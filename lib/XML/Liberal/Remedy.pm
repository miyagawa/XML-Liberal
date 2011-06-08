package XML::Liberal::Remedy;
use strict;
use base qw( Class::Accessor );

__PACKAGE__->mk_ro_accessors(qw( driver error error1 error2 line pos ));

sub new {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;
    return unless $class->handles_error($error, $error1, $error2);
    bless { driver => $driver, error  => $error,
            error1 => $error1, error2 => $error2 }, $class;
}

sub new_with_location {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;
    my ($line) = $error =~ /^:(\d+):/ or return;
    $error2 =~ /^(\s*)\^/ or Carp::carp("Can't get pos from $error"), return;
    my $pos = length $1;
    return bless { driver => $driver, error  => $error,
                   error1 => $error1, error2 => $error2,
                   line   => $line,   pos    => $pos }, $class;
}

sub handles_driver {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;
    return $driver->isa('XML::Liberal::LibXML');
}

sub handles_error { 0 }

sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    $$xml_ref;
}

1;
