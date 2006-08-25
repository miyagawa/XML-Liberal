package XML::Liberal::Remedy::UndeclaredNS;
use strict;
use base qw( XML::Liberal::Remedy );

our %namespaces = (
    rdf     => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    dc      => "http://purl.org/dc/elements/1.1/",
    syn     => "http://purl.org/rss/1.0/modules/syndication/",
    sy      => "http://purl.org/rss/1.0/modules/syndication/",
    admin   => "http://webns.net/mvcb/",
    content => "http://purl.org/rss/1.0/modules/content/",
    cc      => "http://web.resource.org/cc/",
    taxo    => "http://purl.org/rss/1.0/modules/taxonomy/",
    rss20   => "http://backend.userland.com/rss2", # really a dummy
    rss10   => "http://purl.org/rss/1.0/",
    rss09   => "http://my.netscape.com/rdf/simple/0.9/",
    ag      => "http://purl.org/rss/modules/aggregation/",
    wfw     => "http://wellformedweb.org/CommentAPI/",
    trackback => "http://madskills.com/public/xml/rss/module/trackback/",
    nf      => "http://purl.org/atompub/nofollow/1.0",
    slash   => "http://purl.org/rss/1.0/modules/slash/",
    thr     => "http://purl.org/syndication/thread/1.0",
    rdfs    => "http://www.w3.org/2000/01/rdf-schema#",
    dcterms => "http://purl.org/dc/terms/",
    xhtml   => "http://www.w3.org/1999/xhtml",
    atom    => "http://www.w3.org/2005/Atom",
    media   => "http://search.yahoo.com/mrss",
    hatena  => "http://www.hatena.ne.jp/info/xmlns#",
    'apple-wallpapers' => "http://www.apple.com/ilife/wallpapers",
    itunes  => "http://www.itunes.com/dtds/podcast-1.0.dtd",
);

sub prefix {
    my $self = shift;
    $self->{prefix} = shift if @_;
    $self->{prefix};
}

sub apply {
    my $self = shift;
    my($xml_ref) = @_;

    my $prefix = $self->prefix;
    my $ns = $namespaces{$prefix} || "http://example.org/unknown/$self->{prefix}#";

    my $match = $$xml_ref =~ s!^(<\?xml .*?\?>\s*<.*?)(\s*/?)>!$1 xmlns:$prefix="$ns"$2>!s;
    return 1 if $match;

    Carp::carp("Can't find root element");
    return;
}

1;
