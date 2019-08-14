use v6;
use NativeCall;
use Test;

use Gnome::Glib::Quark;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Glib::Quark $quark;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  throws-like(
    { Gnome::Glib::Quark.new(); },
    X::Gnome, 'Cannot create without args',
    :message(/:s No options specified/)
  );

  throws-like(
    { Gnome::Glib::Quark.new(:message('abc def')); },
    X::Gnome, 'Cannot create with wrong args',
    :message(/:s Unsupported options for/)
  );

  my Gnome::Glib::Quark $quark .= new(:empty);
  isa-ok $quark, Gnome::Glib::Quark;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Int $q = $quark.try-string('my string');
  is $q, 0, 'no quark for string';

  $q = $quark.from-string('my string');
  is $quark.from-string('my string'), $q, "string has now quark $q";

  $q = $quark.from-string('my 2nd string');
  is $quark.from-string('my 2nd string'), $q, "2nd string has got quark $q";
  is $quark.to-string($q), 'my 2nd string', "2nd string found from quark";

  is $quark.to-string(42), Str, 'quark not registered';
}

#-------------------------------------------------------------------------------
done-testing;
