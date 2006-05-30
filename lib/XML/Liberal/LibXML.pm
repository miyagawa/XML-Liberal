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

    my @errors = split /\n/, $error;

    # TODO: this if ... elsif should be pluggable, but depends on drivers
    if ($errors[0] =~ /^:(\d+): parser error : (?:EntityRef: expecting ';'|xmlParseEntityRef: no name)/) {
        my $line = $1;
        my $pos = $self->get_pos($errors[2]);
        defined($pos) or Carp::carp("Can't get pos from $error"), return;

        return XML::Liberal::Remedy::EntityRef->new($self, $line, $pos, $error);
    }
    elsif ($errors[0] =~ /^:(\d+): parser error : Opening and ending tag mismatch: (br|hr|img)/) {
        my $line = $1;
        my $pos = $self->get_pos($errors[2]);
        defined($pos) or Carp::carp("Can't get pos from $error"), return;

        return XML::Liberal::Remedy::XHTMLEmptyTag->new($self, $line, $pos, $error);
    }
    elsif ($errors[0] =~ /^:(\d+): parser error : Input is not proper UTF-8, indicate encoding \!/) {
        my $line = $1;
        my $remedy = XML::Liberal::Remedy::NotUTF8->new($self, $line, undef, $error);
        $remedy->guess_encodings($self->guess_encodings);
        return $remedy;
    }
    elsif ($errors[0] =~ /^input conversion failed due to input error/) {
        my $remedy = XML::Liberal::Remedy::InvalidEncoding->new($self, 0, undef, $error);
        $remedy->guess_encodings($self->guess_encodings);
        return $remedy;
    }
    elsif ($errors[0] =~ /^:(\d+): parser error : Entity 'nbsp' not defined/) {
        my $line = $1;
        my $pos = $self->get_pos($errors[2]);
        defined($pos) or Carp::carp("Can't get pos from $error"), return;

        return XML::Liberal::Remedy::HTMLEntity->new($self, $line, $pos, $error);
    }
    elsif ($errors[0] =~ /^:(\d+): parser error : AttValue: \" or \' expected/) {
        my $line = $1;
        my $pos = $self->get_pos($errors[2]);
        defined($pos) or Carp::carp("Can't get pos from $error"), return;

        return XML::Liberal::Remedy::UnquotedAttribute->new($self, $line, $pos, $error);
    }
    elsif ($errors[0] =~ /^:(\d+): parser error : Specification mandate value for attribute (\w+)/) {
        my($line, $attribute) = ($1, $2);
        my $pos = $self->get_pos($errors[2]);
        defined($pos) or Carp::carp("Can't get pos from $error"), return;

        my $remedy = XML::Liberal::Remedy::StandaloneAttribute->new($self, $line, $pos, $error);
        $remedy->attribute($attribute);
        return $remedy;
    }
    elsif ($errors[0] =~ /^:(\d+): namespace error : Namespace prefix (\S+)(?: for (\S+))? on (\S+) is not defined/) {
        my($line, $prefix, $attr, $element) = ($1, $2, $3, $4);
        my $pos = $self->get_pos($errors[2]);
        defined($pos) or Carp::carp("Can't get pos from $error"), return;

        my $remedy = XML::Liberal::Remedy::UndeclaredNS->new($self, $line, $pos, $error);
        $remedy->prefix($prefix);
        return $remedy;
    }

    #warn $_[1];
    return;
}

# recover() is not useful for Liberal parser ... IMHO
sub recover { }

sub get_pos {
    my($self, $err) = @_;
    if ($err =~ /^(\s*)\^/) {
        return length $1;
    } else {
        return;
    }
}

1;
