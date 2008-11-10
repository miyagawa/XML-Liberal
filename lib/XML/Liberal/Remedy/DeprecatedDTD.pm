package XML::Liberal::Remedy::DeprecatedDTD;
use strict;
use base qw( XML::Liberal::Remedy );

sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    $$xml_ref =~s {http://my\.netscape\.com/publish/formats/rss-([\d\.]+).dtd}{http://www.rssboard.org/rss-$1.dtd}
}

1;
