package XML::Liberal;

use strict;
our $VERSION = '0.03';

use base qw( Class::Accessor );
use Carp;
use UNIVERSAL::require;
use Module::Pluggable::Fast
    name => 'remedies',
    search => [ 'XML::Liberal::Remedy' ],
    require => 1;

__PACKAGE__->remedies(); # load remedies now
__PACKAGE__->mk_accessors(qw( max_fallback debug ));

sub new {
    my $class = shift;
    my $driver = shift || 'LibXML';

    my $subclass = "XML::Liberal::$driver";
       $subclass->require or die $@;

    my %param = @_;
    my $max_fb = delete $param{max_fallback} || 15;

    bless {
        driver => $subclass->new(%param),
        max_fallback => $max_fb,
    }, $class;
}

sub driver { $_[0]->{driver} }

sub parse_string {
    my $self = shift;
    my($xml) = @_;

    my $doc;
    my $try = 0;

    TRY: {
        eval {
            $doc = $self->driver->parse_string($xml);
        };
        last TRY if $doc || ($try++ > $self->max_fallback);

        if ($@) {
            my $remedy = $self->driver->handle_error($@);
            if ($remedy) {
                warn "try fixing with ", ref($remedy) if $self->debug;
                $remedy->apply(\$xml);
                warn "--- remedy applied: $xml" if $self->debug;
                redo TRY;
            }
        }
    }

    Carp::croak($@) if !$doc;

    return $doc;
}

sub parse_file {
    my($self, $file) = @_;
    open my $fh, "<", $file or croak "$file: $!";
    $self->parse_fh($fh);
}

sub parse_fh {
    my($self, $fh) = @_;
    my $xml = join '', <$fh>;
    $self->parse_string($xml);
}

1;
__END__

=head1 NAME

XML::Liberal - Super liberal XML parser that parses broken XML

=head1 SYNOPSIS

  use XML::Liberal;

  my $parser = XML::Liberal->new('LibXML');
  my $doc = $parser->parse_string($broken_xml);

=head1 DESCRIPTION

XML::Liberal is a super liberal XML parser that can fix broken XML
stream and create a DOM node out of it.

B<This module is ALPHA SOFTWARE> and its API and internal class
layouts etc. are subject to change later.

=head1 BUGS

This module tries to fix the XML data in various ways, some of which
might alter your XML content, especially bytes written in CDATA.

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<XML::LibXML>

=cut
