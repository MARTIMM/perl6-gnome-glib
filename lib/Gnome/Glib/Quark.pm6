use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Glib::Quark

=SUBTITLE a 2-way association between a string and a unique integer identifier

=head1 Description

Quarks are associations between strings and integer identifiers or a C<GQuark>. Given either the string or the C<GQuark> identifier it is possible to retrieve the other.

=begin comment
Quarks are used for both [datasets](https://developer.gnome.org/glib/stable/glib-Datasets.html) and [keyed data lists](https://developer.gnome.org/glib/stable/glib-Keyed-Data-Lists.html).
=end comment
Quarks are used for example for error domains, see also C<Gnome::Glib::Error>.

To create a new quark from a string, use C<g_quark_from_string()>.

To find the string corresponding to a given C<GQuark>, use C<g_quark_to_string()>.

To find the C<GQuark> corresponding to a given string, use C<g_quark_try_string()>.

=begin comment
Another use for the string pool maintained for the quark functions is string interning, using C<g_intern_string()> or C<g_intern_static_string()>. An interned string is a canonical representation for a string. One important advantage of interned strings is that they can be compared for equality by a simple pointer comparison, rather than using C<strcmp()>.
=end comment

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Glib::Quark;

=head2 Example

  use Test;
  use Gnome::Glib::Quark;

  my Int $q = $quark.try-string('my string');
  is $q, 0, 'no quark for string';

  $q = $quark.from-string('my 2nd string');
  is $quark.from-string('my 2nd string'), $q, "2nd string has got quark $q";
  is $quark.to-string($q), 'my 2nd string', "2nd string found from quark";

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Glib::Quark:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  CATCH { test-catch-exception( $_, $native-sub); }

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');
  die X::Gnome.new(:message(
      "Native sub name '$native-sub' made too short. Keep at least one '-' or '_'."
    )
  ) unless $native-sub.index('_') >= 0;

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("g_quark_$native-sub"); }

  test-call( &$s, Any, |c)
}

#-------------------------------------------------------------------------------
=begin pod
=head2 [g_quark_] try_string

Gets the C<GQuark> associated with the given string, or 0 if string is
undefined or it has no associated C<GQuark>.

If you want the GQuark to be created if it doesn't already exist,
use C<g_quark_from_string()> or C<g_quark_from_static_string()>.

Returns: the C<GQuark> associated with the string, or 0 if I<string> is
C<Any> or there is no C<GQuark> associated with it

  method g_quark_try_string ( Str $string --> Int  )

=item Str $string; (nullable): a string

=end pod

sub g_quark_try_string ( Str $string )
  returns int32
  is native(&glib-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [g_quark_] from_static_string

Gets the C<GQuark> identifying the given (static) string. If the
string does not currently have an associated C<GQuark>, a new C<GQuark>
is created, linked to the given string.

Note that this function is identical to C<g_quark_from_string()> except
that if a new C<GQuark> is created the string itself is used rather
than a copy. This saves memory, but can only be used if the string
will continue to exist until the program terminates. It can be used
with statically allocated strings in the main program, but not with
statically allocated memory in dynamically loaded modules, if you
expect to ever unload the module again (e.g. do not use this
function in GTK+ theme engines).

Returns: the C<GQuark> identifying the string, or 0 if I<string> is C<Any>

  method g_quark_from_static_string ( Str $string --> N-GObject  )

=item Str $string; (nullable): a string

=end pod

sub g_quark_from_static_string ( Str $string )
  returns N-GObject
  is native(&glib-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [g_quark_] from_string

Gets the C<GQuark> identifying the given string. If the string does
not currently have an associated C<GQuark>, a new C<GQuark> is created,
using a copy of the string.

Returns: the C<GQuark> identifying the string, or 0 if I<string> is C<Any>

  method g_quark_from_string ( Str $string --> Int  )

=item Str $string; (nullable): a string

=end pod

sub g_quark_from_string ( Str $string )
  returns int32
  is native(&glib-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 g_intern_string

Returns a canonical representation for I<string>. Interned strings
can be compared for equality by comparing the pointers, instead of
using C<strcmp()>.

Returns: a canonical representation for the string

Since: 2.10

  method g_intern_string ( Str $string --> Str  )

=item Str $string; (nullable): a string

=end pod

sub g_intern_string ( Str $string )
  returns Str
  is native(&glib-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 g_intern_static_string

Returns a canonical representation for I<string>. Interned strings
can be compared for equality by comparing the pointers, instead of
using C<strcmp()>. C<g_intern_static_string()> does not copy the string,
therefore I<string> must not be freed or modified.

Returns: a canonical representation for the string

Since: 2.10

  method g_intern_static_string ( Str $string --> Str  )

=item Str $string; (nullable): a static string

=end pod

sub g_intern_static_string ( Str $string )
  returns Str
  is native(&glib-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [g_quark_] to_string

Gets the string associated with the given GQuark.

  method g_quark_to_string ( Int $quark --> Str  )

=end pod

sub g_quark_to_string ( int32 $quark )
  returns Str
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=begin comment

=head1 Not yet implemented methods

=head3 method  ( ... )

=end comment
=end pod

#-------------------------------------------------------------------------------
=begin pod
=begin comment

=head1 Not implemented methods

=head3 method g_quark_from_static_string ( ... )
=head3 method g_intern_string ( ... )
=head3 method g_intern_static_string ( ... )
=head3 method  ( ... )

=end comment
=end pod