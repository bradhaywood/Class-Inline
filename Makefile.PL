use 5.010; 
use strict;
use warnings FATAL => 'all';
use inc::Module::Install;

name     'Class-Inline';
all_from 'lib/Class/Inline.pm';
author   q{Brad Haywood <brad@geeksware.com>};
license  'artistic2';

perl_version 5.010;

tests_recursive('t');

resources (
   #homepage   => 'http://yourwebsitehere.com',
   #IRC        => 'irc://irc.perl.org/#Class-Inline',
   license    => 'http://www.perlfoundation.org/artistic_license_2_0',
   #repository => 'git://github.com/Brad Haywood/Class-Inline.git',
   bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Class-Inline',
);

configure_requires (
   'Module::Install' => 0,
);

build_requires (
   'Test::More' => 0,
);

requires (
);

install_as_cpan;
auto_install;
WriteAll;
