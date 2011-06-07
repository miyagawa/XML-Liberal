use strict;
use Test::More 'no_plan';

use FindBin;
use XML::LibXML;
use XML::Liberal;

binmode Test::More->builder->$_, ':utf8'
    for qw( output failure_output todo_output );

my $data = "$FindBin::Bin/bad";

opendir D, $data;
for my $f (readdir D) {
    next unless $f =~ /\.xml$/;

    my $parser = XML::LibXML->new;
    eval { $parser->parse_file("$data/$f") };
    next if ($f =~/^MAYBE/ && !$@);
    ok $@, $@;

    open my $fh, "$data/$f" or die $!;
    my $xml = do { local $/; <$fh> };

    my $liberal = XML::Liberal->new('LibXML');
    my $doc = eval { $liberal->parse_string($xml) };
    is $@, '', "$data/$f";
    isa_ok $doc, 'XML::LibXML::Document', "created DOM node with $data/$f";
}

