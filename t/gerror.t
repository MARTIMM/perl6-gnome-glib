use v6;
use Test;

use Gnome::Glib::GError;

#-------------------------------------------------------------------------------
subtest 'create error object', {
  my Gnome::Glib::GError $e .= new;
  isa-ok $e, Gnome::Glib::GError, 'object ok';
}


#-------------------------------------------------------------------------------
done-testing;
