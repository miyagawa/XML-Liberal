package XML::Liberal::LibXML;
use strict;

use Carp;
use XML::LibXML;

use base qw( XML::Liberal::Driver );

sub init {
    my $self = shift;
    $self->SUPER::init();
    $self->{parser} = XML::LibXML->new;
}

sub parse_string {
    my $self = shift;
    my($xml) = @_;
    $self->{parser}->parse_string($xml);
}

sub handle_error {
    my $self = shift;
    my($error) = @_;

    my @errors = split /\n/, $error;

    # TODO: this if ... elsif should be pluggable, but depends on drivers
    if ($errors[0] =~ /^:(\d+): parser error : EntityRef: expecting ';'/) {
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

    #warn $_[1];
    return;
}

sub get_pos {
    my($self, $err) = @_;
    if ($err =~ /^(\s*)\^/) {
        return length $1;
    } else {
        return;
    }
}

1;
