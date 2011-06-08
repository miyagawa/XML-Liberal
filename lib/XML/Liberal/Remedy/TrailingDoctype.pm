package XML::Liberal::Remedy::TrailingDoctype;
use strict;
use base qw( XML::Liberal::Remedy );

sub new {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;

    return if $error !~ /^:(\d+): parser error : Extra content at the end of the document/;
    my $self = $class->new_with_location(@_);
    return if substr($error1, $self->pos) !~ /\A <!doctype \b/xmsi;
    return $self;
}

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    pos($$xml_ref) = $self->error_location($xml_ref);
    return 1 if $$xml_ref =~ s{\G <!doctype .*?>}{}xmsi;

    return;
}

1;
