use inc::Module::Install;

name('XML-Liberal');
all_from('lib/XML/Liberal.pm');

requires('XML::LibXML', 1.58);
requires('HTML::Entities::Numbered', 0.04);
requires('Module::Pluggable::Fast', 0.16);
requires('Class::Accessor');

build_requires('Test::More');
use_test_base;

auto_include;
WriteAll;
