package XML::Liberal::Remedy::TrailingElements;
use strict;
use base qw( XML::Liberal::Remedy );

sub new {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;

    return if $error !~ /^:(\d+): parser error : Extra content at the end of the document/;
    my $self = $class->new_with_location(@_);
    return if substr($error1, $self->pos) !~ /\A <[-:\w]+ (?:[>\s]|\z)/xms;
    return $self;
}

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $pos = $self->error_location($xml_ref);
    while ($pos > 0) {
        pos($$xml_ref) = $pos--;
        return 1 if $$xml_ref =~ s{\G (</[^\s<>/]+ \s*>) (.*)}{$2$1}xms
    }

    return;
}

1;
