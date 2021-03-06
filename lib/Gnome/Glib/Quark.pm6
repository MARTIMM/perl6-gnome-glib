#TL:1:Gnome::Glib::Quark

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Glib::Quark

Quark - a 2-way association between a string and a unique integer identifier

=head1 Description

Quarks are associations between strings and integer identifiers or a I<GQuark>. Given either the string or the I<GQuark> identifier it is possible to retrieve the other.

=begin comment
Quarks are used for both datasets](https://developer.gnome.org/glib/stable/glib-Datasets.html) and [keyed data lists](https://developer.gnome.org/glib/stable/glib-Keyed-Data-Lists.html).
=end comment

Quarks are used for example to specify error domains, see also I<Gnome::Glib::Error>.

To create a new quark from a string, use C<g_quark_from_string()>.

To find the string corresponding to a given I<GQuark>, use C<g_quark_to_string()>.

To find the I<GQuark> corresponding to a given string, use C<g_quark_try_string()>.

=begin comment
Another use for the string pool maintained for the quark functions is string interning, using C<g_intern_string()> or C<g_intern_static_string()>. An interned string is a canonical representation for a string. One important advantage of interned strings is that they can be compared for equality by a simple pointer comparison, rather than using C<strcmp()>.
=end comment

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Glib::Quark;

=head2 Example

  use Test;
  use Gnome::Glib::Quark;

  my Gnome::Glib::Quark $quark .= new;
  my UInt $q = $quark.try-string('my string');
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
use Gnome::N::GlibToRakuTypes;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Glib::Quark:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
# method new, mark for code coverage
#TS:1:new
=begin pod
=head2 new
=head3 default, no options

Create a new quark object.

  multi method new ( )

=end pod

#TM:1:new()
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  # no parent, nor children ...
  # return unless self.^name eq 'Gnome::Glib::Error';

  # process all named arguments
  if %options<empty>:exists {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.15.5', '0.18.0');
  }

  elsif %options.elems {
    die X::Gnome.new(
      :message( 'Unsupported options for ' ~ self.^name ~
                ': ' ~ %options.keys.join(', ')
      )
    );
  }
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  note "\nSearch for .$native-sub\() following ", self.^mro
    if $Gnome::N::x-debug;

#  CATCH { test-catch-exception( $_, $native-sub); }
  CATCH { .note; die; }

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::("g_quark_$native-sub"); };
  try { $s = &::("g_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'g_' /;

  test-call-without-natobj( &$s, |c)
}

#-------------------------------------------------------------------------------
#TM:1:g_quark_try_string
=begin pod
=head2 [[g_] quark_] try_string

Gets the I<GQuark> associated with the given string, or 0 if string is undefined or it has no associated I<GQuark>.

If you want the GQuark to be created if it doesn't already exist, use C<g_quark_from_string()> or C<g_quark_from_static_string()>.

Returns: the I<GQuark> associated with the string, or 0 if I<$string> is undefined or there is no I<GQuark> associated with it.

  method g_quark_try_string ( Str $string --> Int  )

=item Str $string: a string

=end pod

sub g_quark_try_string ( Str $string --> GQuark )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:g_quark_from_string
=begin pod
=head2 [[g_] quark_] from_string

Gets the I<GQuark> identifying the given string. If the string does not currently have an associated I<GQuark>, a new I<GQuark> is created, using a copy of the string.

Returns: the I<GQuark> identifying the string, or 0 if I<$string> is undefined

  method g_quark_from_string ( Str $string --> Int  )

=item Str $string: a string

=end pod

sub g_quark_from_string ( Str $string --> GQuark )
  is native(&glib-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:1:g_quark_to_string
=begin pod
=head2 [[g_] quark_] to_string

Gets the string associated with the given GQuark.

  method g_quark_to_string ( Int $quark --> Str  )

=end pod

sub g_quark_to_string ( GQuark $quark --> Str )
  is native(&glib-lib)
  { * }





=finish

#`{{
#-------------------------------------------------------------------------------
#TM:0:g_quark_from_static_string
=begin pod
=head2 [[g_] quark_] from_static_string

Gets the I<GQuark> identifying the given (static) string. If the
string does not currently have an associated I<GQuark>, a new I<GQuark>
is created, linked to the given string.

Note that this function is identical to C<g_quark_from_string()> except
that if a new I<GQuark> is created the string itself is used rather
than a copy. This saves memory, but can only be used if the string
will continue to exist until the program terminates. It can be used
with statically allocated strings in the main program, but not with
statically allocated memory in dynamically loaded modules, if you
expect to ever unload the module again (e.g. do not use this
function in GTK+ theme engines).

Returns: the I<GQuark> identifying the string, or 0 if I<$string> is undefined

  method g_quark_from_static_string ( Str $string --> N-GObject  )

=item Str $string: a string

=end pod

sub g_quark_from_static_string ( Str $string --> N-GObject )
  is native(&glib-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[g_] quark_] from_static_string

Gets the I<GQuark> identifying the given (static) string. If the
string does not currently have an associated I<GQuark>, a new I<GQuark>
is created, linked to the given string.

Note that this function is identical to C<g_quark_from_string()> except
that if a new I<GQuark> is created the string itself is used rather
than a copy. This saves memory, but can only be used if the string
will continue to exist until the program terminates. It can be used
with statically allocated strings in the main program, but not with
statically allocated memory in dynamically loaded modules, if you
expect to ever unload the module again (e.g. do not use this
function in GTK+ theme engines).

Returns: the I<GQuark> identifying the string, or 0 if I<$string> is undefined

  method g_quark_from_static_string ( Str $string --> N-GObject  )

=item Str $string: a string

=end pod

sub g_quark_from_static_string ( Str $string --> N-GObject )
  is native(&glib-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [g_] intern_string

Returns a canonical representation for I<string>. Interned strings
can be compared for equality by comparing the pointers, instead of
using C<strcmp()>.

Returns: a canonical representation for the string

Since: 2.10

  method g_intern_string ( Str $string --> Str  )

=item Str $string; (nullable): a string

=end pod

sub g_intern_string ( Str $string --> Str )
  is native(&glib-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [g_] intern_static_string

Returns a canonical representation for I<string>. Interned strings
can be compared for equality by comparing the pointers, instead of
using C<strcmp()>. C<g_intern_static_string()> does not copy the string,
therefore I<string> must not be freed or modified.

Returns: a canonical representation for the string

Since: 2.10

  method g_intern_static_string ( Str $string --> Str  )

=item Str $string; (nullable): a static string

=end pod

sub g_intern_static_string ( Str $string --> Str )
  is native(&glib-lib)
  { * }
}}
