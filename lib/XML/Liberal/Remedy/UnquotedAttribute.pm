package XML::Liberal::Remedy::UnquotedAttribute;
use strict;

use List::Util qw( min );

sub apply {
    my $class = shift;
    my($driver, $error, $xml_ref) = @_;

    return 0 if $error->message !~ /^parser error : AttValue: \" or \' expected/;

    my $index = $error->location($xml_ref);
    my $buffer = substr($$xml_ref, $index, min(64, length($$xml_ref) - 1));
       $buffer =~ s/^([^\s>]+)/"$1"/;
    substr($$xml_ref, $index, length($buffer), $buffer);
    return 1; # xxx

    Carp::carp("Can't find unquoted attribute in line, error was: ",
               $error->summary);
    return 0;
}

1;
