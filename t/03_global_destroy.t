use strict;
use warnings;
use Test::More 'no_plan';

use FindBin;
use XML::LibXML;
use XML::Liberal;

my $data = "$FindBin::Bin/bad";

opendir D, $data;
for my $f (readdir D) {
    next unless $f =~ /\.xml$/;
    next if $f =~ /chr|lowascii/;

    {
        my $foo = XML::Liberal->globally_override('LibXML');

        my $parser = XML::LibXML->new;
        my $doc = eval { $parser->parse_file("$data/$f") };
        is $@, '', "$data/$f";
        isa_ok $doc, 'XML::LibXML::Document', "created DOM node with $data/$f";
    }

    my $parser = XML::LibXML->new;
    my $doc = eval { $parser->parse_file("$data/$f") };
    next if ($f =~/^MAYBE/ && !$@);
    ok $@, $@;
}

