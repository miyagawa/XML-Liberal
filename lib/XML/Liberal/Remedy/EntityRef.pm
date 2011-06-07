package XML::Liberal::Remedy::EntityRef;
use strict;
use base qw( XML::Liberal::Remedy );

sub new {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;

    return if $error !~
        /^:\d+: parser error : (?:EntityRef: expecting ';'|xmlParseEntityRef: no name)/;
    return $class->new_with_location(@_);
}

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s/&(?!\w+;|#(?:x[a-fA-F0-9]+|\d+);)/&amp;/g;
    return 1 if $match;

    # there's no &bar in this XML document ...?
    Carp::carp("Can't find unescaped &, line $self->{line} pos $self->{pos}: $self->{error}");
    return;
}

1;
