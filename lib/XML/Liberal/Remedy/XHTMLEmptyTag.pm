package XML::Liberal::Remedy::XHTMLEmptyTag;
use strict;
use base qw( XML::Liberal::Remedy );

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s{
        <(area | base (?:font)? | [bh]r | col | frame | img | input | isindex |
          link | meta | param)
         (?: \s[^>]*)?
         (?<! /) (?= > (?! \s*</\1\s*>))
    }
    {$& /}gx;
    return 1 if $match;

    Carp::carp("Can't find XHTML empty-element tags: line $self->{line} pos $self->{pos}: $self->{error}");
    return;
}

1;
