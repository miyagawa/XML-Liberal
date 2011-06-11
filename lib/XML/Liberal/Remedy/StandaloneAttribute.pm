package XML::Liberal::Remedy::StandaloneAttribute;
use strict;

use List::Util qw( min );

sub apply {
    my $class = shift;
    my($driver, $error, $xml_ref) = @_;

    my ($attr) = $error->message =~
        /^parser error : Specification mandate value for attribute (\w+)/
            or return 0;

    my $index = $error->location($xml_ref);

    # <hr noshade />
    #             ^
    $index -= length($attr) + 1; # xxx is there a case that it's not 1?

    my $buffer = substr($$xml_ref, $index, min(64, length($$xml_ref) - 1));
       $buffer =~ s/^\Q$attr\E/$attr="$attr"/;
    substr($$xml_ref, $index, length($buffer), $buffer);
    return 1; # xxx

    Carp::carp("Can't find standalone attribute '$attr', error was: ",
               $error->summary);
    return 0;
}

1;
