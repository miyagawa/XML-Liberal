# NAME

XML::Liberal - Super liberal XML parser that parses broken XML

# SYNOPSIS

    use XML::Liberal;

    my $parser = XML::Liberal->new('LibXML');
    my $doc = $parser->parse_string($broken_xml);

    # or, override XML::LibXML->new globally
    use XML::LibXML;
    use XML::Liberal;

    XML::Liberal->globally_override('LibXML');
    my $parser = XML::LibXML->new; # isa XML::Liberal

    # revert the global overrides back
    XML::Liberal->globally_unoverride('LibXML');

    # override XML::LibXML->new globally in a lexical scope
    {
       my $destructor = XML::LibXML->globally_override('LibXML');
       my $parser = XML::LibXML->new; # isa XML::Liberal
    }

    # $destructor goes out of scope and global override doesn't take effect
    my $parser = XML::LibXML->new; # isa XML::LibXML

# DESCRIPTION

XML::Liberal is a super liberal XML parser that can fix broken XML
stream and create a DOM node out of it.

**This module is ALPHA SOFTWARE** and its API and internal class
layouts etc. are subject to change later.

# METHODS

- new

        $parser = XML::Liberal->new('LibXML');

    Creates an XML::Liberal object. Currently accepted driver is only _LibXML_.

- globally\_override

        XML::Liberal->globally_override('LibXML');

    Override XML::LibXML's new method globally, to create XML::Liberal
    object instead of XML::LibXML parser.

    This is considered **so evil**, but would be useful if you have
    existent software/library that uses XML::LibXML inside and change the
    behaviour globally to use Liberal parser instead, with a single method
    call.

    For example, the following code lets XML::Atom's parser use Liberal
    LibXML parser.

        use URI;
        use XML::Atom::Feed;
        use XML::Liberal;

        XML::Liberal->globally_override('LibXML');

        # XML::Atom calls XML::LibXML->new, which is aliased to Liberal now
        my $feed = XML::Atom::Feed->new(URI->new('http://example.com/atom.xml'));

    If you want the original XML::LibXML->new back in business, you can
    call _globally\_unoverride_ method.

        XML::Liberal->globally_override('LibXML');
        # ... do something
        XML::Liberal->globally_unoverride('LibXML');

    Or, you can hold the destructor object in a scalar variable and make
    the global override take effect only in a lexical scope:

        {
          my $destructor = XML::Liberal->globally_override('LibXML');
          # ... do something
        }

        # now XML::LibXML::new is back as normal

# BUGS

This module tries to fix the XML data in various ways, some of which
might alter your XML content, especially bytes written in CDATA.

# AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

Aaron Crane

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[XML::LibXML](https://metacpan.org/pod/XML%3A%3ALibXML)
