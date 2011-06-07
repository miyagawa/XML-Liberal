package XML::Liberal::LibXML;
use strict;

use Carp;
use XML::LibXML;

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

sub handle_error {
    my $self = shift;
    my($error) = @_;

    # for XML::LibXML > 1.69
    if (ref $error eq 'XML::LibXML::Error') {
        while($error->_prev) {
            last if ($error->message =~/Unregistered error message/);
            last if ($error->message =~/internal error/);
            $error = $error->_prev
        }
        $error = $error->as_string;
    }
    my @errors = split /\n/, $error;

    # strip internal error and unregistered error message
    while ($errors[0] =~ /^:(\d+): parser error : internal error/ ||
           $errors[0] =~ /^:(\d+): parser error : Unregistered error message/) {
        splice(@errors, 0, 3);
    }

    for my $remedy_class (sort XML::Liberal->remedies) {
        next unless $remedy_class->handles_driver($self, @errors[0 .. 2]);
        my $remedy = $remedy_class->new($self, @errors[0 .. 2])
            or next;
        return $remedy;
    }

    return;
}

# recover() is not useful for Liberal parser ... IMHO
sub recover { }

1;
