
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "FindBin" => 0,
    "Module::Build" => "0.3601",
    "Test::Fatal" => 0,
    "Test::File::ShareDir" => 0,
    "Test::More" => "0.96",
    "parent" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "A Simple base class for generating simple validators based on Data::Rx",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Data-Rx-Tools-ShareDirValidator",
  "dist_version" => "0.1.1",
  "license" => "perl",
  "module_name" => "Data::Rx::Tools::ShareDirValidator",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Data::Rx" => 0,
    "File::ShareDir" => 0,
    "JSON" => 0,
    "Path::Class::Dir" => 0,
    "Scalar::Util" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
