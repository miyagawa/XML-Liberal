use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'      => 'XML::Liberal',
    'VERSION_FROM' => 'lib/XML/Liberal.pm', # finds $VERSION
    'PREREQ_PM' => {
	Test::More => 0.32,
        XML::LibXML => 1.58,
        HTML::Entities::Numbered => 0.04,
        Module::Pluggable::Fast => 0.16,
        Class::Accessor => 0,
    },
);
