package XML::Liberal::Remedy::DeprecatedDTD;
use strict;
use base qw( XML::Liberal::Remedy );

sub apply {
    my $self = shift;
    my($xml_ref) = @_;
    $$xml_ref =~ s{(?<=http://)my\.netscape\.com/publish/formats(?=/rss-0\.91?\.dtd)}
                  {www.rssboard.org};
}

1;
