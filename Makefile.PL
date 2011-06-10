use inc::Module::Install;
name 'Rediq';
all_from 'lib/Rediq.pm';

#requires '';

test_requires 'Test::More' => '0.94';

tests 't/*.t t/*/*.t';
author_tests('xt');

auto_set_repository;

WriteAll;
