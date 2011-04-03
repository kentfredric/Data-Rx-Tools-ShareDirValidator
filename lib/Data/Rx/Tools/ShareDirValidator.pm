use strict;
use warnings;
package Data::Rx::Tools::ShareDirValidator;

# ABSTRACT: A Simple base class for generating simple validators based on Data::Rx

=head1 SYNOPSIS

  package Foo;
  use Data::Rx::Tools::ShareDirValidator;
  use parent 'Data::Rx::Tools::ShareDirValidator';

  sub filename { 'schema' } # default value.
  sub suffix  {'.json'} # default value.

  1;

  ...


Later:

  use Foo;
  Foo->check({ some => [ 'data', 'structure' ] }) # true/false

  1;

=cut

=head1 DESCRIPTION

The purpose of this is to make creating a portable validator with Data::Rx as painless as possible, while still
permitting you to keep the specification itself seperate from the actual implementation.

=head1 IMPLEMENTATION INSTRUCTIONS

=over 4

=item 1. Create package 'Foo' and fill it with the generic boilerplate to extend the base class.

=item 2. Generate your Data::Rx schema in the format you desire ( ideally JSON ) and place it in the modules "Share" directory.

( ie: With Dist::Zilla, you would do this:

  [ModuleSharedirs]
  Foo = sharedir/Foo

or something similar. )

=item 3. Ship your distribution and/or install it.

=item 4. Use it by simply doing:

  use Foo;
  if( Foo->check({ datastructure => [] })

passing the data structure you need validated to check().

=back 4

=head1 EXTENDING

By default, we assume you want JSON for everything, so by defualt, the suffix is ".json",
and the default deserialiser is as follows:

  sub decode_file {
    my ( $self, $file ) = @_;
    require JSON;
    return JSON->new()->utf8(1)->relaxed(1)->decode( scalar $file->slurp() );
  }

If you want to use a file format other than JSON, overriding the suffix and decode_file sub is required.

Note: C<$file> in this context is a L<< C<file> from Path::Class|Path::Class::File >>, which is why we can
just do C<slurp()> on it.

=cut

use Data::Rx;
use File::ShareDir qw();
use Path::Class::Dir;
use Scalar::Util qw( blessed );

sub filename { 'schema' }
sub suffix   { '.json' }

my $cache;

sub check {
  my ( $self, $data ) = @_;
  if ( not exists $cache->{spec} ){
    $cache->{spec} = _CLASS($self)->_make_rx;
  }
  return $cache->{spec}->check( $data );
}

sub decode_file {
  my ( $self, $file ) = @_;
  require JSON;
  return JSON->new()->utf8(1)->relaxed(1)->decode( scalar $file->slurp() );
}

sub _make_rx {
  my ( $self ) = @_;
  return Data::Rx->new()->make_schema(
    _CLASS($self)->decode_file( _CLASS($self)->_specfile )
  );
}

sub _sharedir {
  my ( $self ) = @_;
  return Path::Class::Dir->new( File::ShareDir::module_dir( _CLASS($self) ) );
}

sub _specfile {
  my ( $self ) = @_;
  return _CLASS($self)->_sharedir->file( _CLASS($self)->filename . _CLASS($self)->suffix );
}

sub _CLASS {
  my ( $classname ) = @_;
  return blessed $classname if ( ref $classname && blessed $classname );
  return $classname if not ref $classname;
  require Carp;
  Carp::croak(q{Argument 0 was an unblessed ref instead of the expected classname, ensure you are calling the method right with $classname->check( $data ) or similar});
}

1;
