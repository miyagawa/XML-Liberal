# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v6.024.
use strict;
use warnings;

use 5.008001;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
  "ABSTRACT" => "Super liberal XML parser that parses broken XML",
  "AUTHOR" => "Tatsuhiko Miyagawa <miyagawa\@bulknews.net>",
  "BUILD_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.59"
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0
  },
  "DISTNAME" => "XML-Liberal",
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.008001",
  "NAME" => "XML::Liberal",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Class::Accessor" => 0,
    "Encode" => 0,
    "Encode::Guess" => 0,
    "Filter::Util::Call" => 0,
    "HTML::Entities" => 0,
    "HTML::Tagset" => 0,
    "List::Util" => 0,
    "Module::Pluggable::Fast" => "0.16",
    "UNIVERSAL::require" => 0,
    "XML::LibXML" => "1.69_02"
  },
  "TEST_REQUIRES" => {
    "Test::Base" => 0
  },
  "VERSION" => "0.32",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Carp" => 0,
  "Class::Accessor" => 0,
  "Encode" => 0,
  "Encode::Guess" => 0,
  "ExtUtils::MakeMaker" => "6.59",
  "Filter::Util::Call" => 0,
  "HTML::Entities" => 0,
  "HTML::Tagset" => 0,
  "List::Util" => 0,
  "Module::Pluggable::Fast" => "0.16",
  "Test::Base" => 0,
  "UNIVERSAL::require" => 0,
  "XML::LibXML" => "1.69_02"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
