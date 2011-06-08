package XML::Liberal::Remedy::XHTMLEmptyTag;
use strict;
use base qw( XML::Liberal::Remedy );

sub new {
    my $class = shift;
    my($driver, $error, $error1, $error2) = @_;

    return if $error !~
        /^:\d+: parser error : Opening and ending tag mismatch: (?:br|hr|img)/;
    return $class->new_with_location(@_);
}

# optimized to fix all errors in one apply() call
sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s{
        (<(area | base (?:font)? | [bh]r | col | frame | img | input | isindex |
           link | meta | param)
         (?: \s[^>]*)?)
         (?<! /) (?= > (?! \s*</\2\s*>))
    }
    {$1 /}gx;
    return 1 if $match;

    Carp::carp("Can't find XHTML empty-element tags: line $self->{line} pos $self->{pos}: $self->{error}");
    return;
}

1;
