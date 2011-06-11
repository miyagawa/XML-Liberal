package XML::Liberal::LibXML;
use strict;

use Carp;
use XML::LibXML;
use XML::Liberal::Error;

use base qw( XML::Liberal );

our $XML_LibXML_new;

sub globally_override {
    my $class = shift;

    no warnings 'redefine';
    unless ($XML_LibXML_new) {
        $XML_LibXML_new = \&XML::LibXML::new;
        *XML::LibXML::new = sub { XML::Liberal->new('LibXML') };
    }

    1;
}

sub globally_unoverride {
    my $class = shift;

    no warnings 'redefine';
    if ($XML_LibXML_new) {
        *XML::LibXML::new = $XML_LibXML_new;
        undef $XML_LibXML_new;
    }

    return 1;
}

sub new {
    my $class = shift;
    my %param = @_;

    my $self = bless { %param }, $class;
    $self->{parser} = $XML_LibXML_new
        ? $XML_LibXML_new->('XML::LibXML') : XML::LibXML->new;

    $self;
}

sub extract_error {
    my $self = shift;
    my($exn) = @_;

    # for XML::LibXML > 1.69
    if (ref $exn eq 'XML::LibXML::Error') {
        while($exn->_prev) {
            last if $exn->message =~/Unregistered error message/;
            last if $exn->message =~/internal error/;
            $exn =  $exn->_prev
        }
        $exn = $exn->as_string;
    }
    my @errors = split /\n/, $exn;

    # strip internal error and unregistered error message
    while ($errors[0] =~ /^:\d+: parser error : internal error/ ||
           $errors[0] =~ /^:\d+: parser error : Unregistered error message/) {
        splice @errors, 0, 3;
    }

    my $line   =  $errors[0]        =~ s/^:(\d+):\s*// ?        $1  : undef;
    my $column = ($errors[2] || '') =~  /^(\s*)\^/     ? length($1) : undef;

    return XML::Liberal::Error->new({
        message => $errors[0],
        line    => $line,
        column  => $column,
    });
}

# recover() is not useful for Liberal parser ... IMHO
sub recover { }

1;
