package XML::Liberal::Remedy::DeprecatedDTD;
use strict;
use base qw( XML::Liberal::Remedy );

sub handles_error {
    my $class = shift;
    my($error, $error1, $error2) = @_;

    return $error =~ /:\d+: parser error : Content error in the external subset/;
}

sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    my $match = $$xml_ref =~ s{(?<=\s(["'])http://)my\.netscape\.com/publish/formats(?=/rss-0\.91?\.dtd\1\s*>)}
                              {www.rssboard.org};
    return 1 if $match;

    Carp::carp("Can't find deprecated DTD: line $self->{line}");
    return;
}

1;
