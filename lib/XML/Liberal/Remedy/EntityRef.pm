package XML::Liberal::Remedy::EntityRef;
use strict;

# optimized to fix all errors in one apply() call
sub apply {
    my $class = shift;
    my($driver, $error, $xml_ref) = @_;

    return 0 if $error->message !~
        /^parser error : (?:EntityRef: expecting ';'|xmlParseEntityRef: no name)/;

    return 1 if $$xml_ref =~
        s/&(?!\w+;|#(?:x[a-fA-F0-9]+|\d+);)/&amp;/g;

    Carp::carp("Can't find unescaped &, error was: ", $error->summary);
    return 0;
}

1;
