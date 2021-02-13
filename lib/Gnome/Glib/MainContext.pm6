#TL:1:Gnome::Glib::MainContext:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Glib::MainContext

=head1 Description

See for more information L<here at module Gnome::Glib::Main|Main.html>.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Glib::MainContext;
  also is Gnome::N::TopLevelClassSupport;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
#use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::TopLevelClassSupport;

use Gnome::Glib::N-GMainContext;
use Gnome::Glib::N-GMainLoop;
#use Gnome::Glib::MainLoop;

#-------------------------------------------------------------------------------
unit class Gnome::Glib::MainContext:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::N::TopLevelClassSupport;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new MainContext object.

  multi method new ( )

=head3 :default

Set this object to the global default main context. This is the main context used for main loop functions when a main loop is not explicitly specified, and corresponds to the "main" main loop. See also C<new(:thread-default()>.

  multi method new ( :default! )

=head3 :thread-default

Gets the thread-default B<N-GMainContext> for this thread. Asynchronous operations that want to be able to be run in contexts other than the default one should call this method.

  multi method new ( :default! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Glib::MainContext' #`{{ or %options<GMainContext> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if %options<default>:exists {
        #$no = %options<___x___>;
        #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        $no = _g_main_context_default;
      }

      elsif %options<thread-default>:exists {
        $no = _g_main_context_get_thread_default;
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _g_main_context_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GMainContext');
  }
}

#-------------------------------------------------------------------------------
method native-object-ref ( $n-native-object ) {
  _g_main_context_ref($n-native-object)
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  _g_main_context_unref($n-native-object);
}

#-------------------------------------------------------------------------------
#TM:0:acquire:
=begin pod
=head2 acquire

Tries to become the owner of the specified context. If some other thread is the owner of the context, returns C<False> immediately. Ownership is properly recursive: the owner can require ownership again and will release ownership when C<release()> is called as many times as C<acquire()>.  You must be the owner of a context before you can call C<prepare()>, C<query()>, C<check()>, C<dispatch()>.

Returns: C<True> if the operation succeeded, and this thread is now the owner of the context.

  method acquire ( N-GMainContext $context --> Int )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method acquire ( N-GMainContext $context --> Int ) {

  g_main_context_acquire(
    self.get-native-object-no-reffing, $context
  );
}

sub g_main_context_acquire ( N-GMainContext $context --> gboolean )
  is native(&glib-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-poll:
=begin pod
=head2 add-poll

Adds a file descriptor to the set of file descriptors polled for this context. This will very seldom be used directly. Instead a typical event source will use C<g-source-add-unix-fd()> instead.

  method add-poll ( N-GMainContext $context, GPollFD $fd, Int $priority )

=item N-GMainContext $context; (nullable): a B<N-GMainContext> (or C<undefined> for the default context)
=item GPollFD $fd; a B<GPollFD> structure holding information about a file descriptor to watch.
=item Int $priority; the priority for this file descriptor which should be the same as the priority used for C<g-source-attach()> to ensure that the file descriptor is polled whenever the results may be needed.

=end pod

method add-poll ( N-GMainContext $context, GPollFD $fd, Int $priority ) {

  g_main_context_add_poll(
    self.get-native-object-no-reffing, $context, $fd, $priority
  );
}

sub g_main_context_add_poll ( N-GMainContext $context, GPollFD $fd, gint $priority  )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:check:
=begin pod
=head2 check

Passes the results of polling back to the main loop.  You must have successfully acquired the context with C<acquire()> before you may call this function.

Returns: C<True> if some sources are ready to be dispatched.

  method check ( N-GMainContext $context, Int $max_priority, GPollFD $fds, Int $n_fds --> Int )

=item N-GMainContext $context; a B<N-GMainContext>
=item Int $max_priority; the maximum numerical priority of sources to check
=item GPollFD $fds; (array length=n-fds): array of B<GPollFD>'s that was passed to the last call to C<query()>
=item Int $n_fds; return value of C<query()>

=end pod

method check ( N-GMainContext $context, Int $max_priority, GPollFD $fds, Int $n_fds --> Int ) {

  g_main_context_check(
    self.get-native-object-no-reffing, $context, $max_priority, $fds, $n_fds
  );
}

sub g_main_context_check ( N-GMainContext $context, gint $max_priority, GPollFD $fds, gint $n_fds --> gboolean )
  is native(&glib-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_g_main_context_default:
#`{{
=begin pod
=head2 default

Returns the global default main context. This is the main context used for main loop functions when a main loop is not explicitly specified, and corresponds to the "main" main loop. See also C<get-thread-default()>.

Returns: (transfer none): the global default main context.

  method default ( --> N-GMainContext )


=end pod

method default ( --> N-GMainContext ) {

  g_main_context_default(
    self.get-native-object-no-reffing,
  );
}
}}

sub _g_main_context_default (  --> N-GMainContext )
  is symbol('g_main_context_default')
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:dispatch:
=begin pod
=head2 dispatch

Dispatches all pending sources.  You must have successfully acquired the context with C<acquire()> before you may call this function.

  method dispatch ( N-GMainContext $context )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method dispatch ( N-GMainContext $context ) {

  g_main_context_dispatch(
    self.get-native-object-no-reffing, $context
  );
}

sub g_main_context_dispatch ( N-GMainContext $context  )
  is native(&glib-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:find-source-by-funcs-user-data:
=begin pod
=head2 find-source-by-funcs-user-data

Finds a source with the given source functions and user data.  If multiple sources exist with the same source function and user data, the first one found will be returned.

Returns: (transfer none): the source, if one was found, otherwise C<undefined>

  method find-source-by-funcs-user-data ( N-GMainContext $context, GSourceFuncs $funcs, Pointer $user_data --> GSource )

=item N-GMainContext $context; (nullable): a B<N-GMainContext> (if C<undefined>, the default context will be used).
=item GSourceFuncs $funcs; the I<source-funcs> passed to C<g-source-new()>.
=item Pointer $user_data; the user data from the callback.

=end pod

method find-source-by-funcs-user-data ( N-GMainContext $context, GSourceFuncs $funcs, Pointer $user_data --> GSource ) {

  g_main_context_find_source_by_funcs_user_data(
    self.get-native-object-no-reffing, $context, $funcs, $user_data
  );
}

sub g_main_context_find_source_by_funcs_user_data ( N-GMainContext $context, GSourceFuncs $funcs, gpointer $user_data --> GSource )
  is native(&glib-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:find-source-by-id:
=begin pod
=head2 find-source-by-id

Finds a B<GSource> given a pair of context and ID.  It is a programmer error to attempt to lookup a non-existent source.  More specifically: source IDs can be reissued after a source has been destroyed and therefore it is never valid to use this function with a source ID which may have already been removed.  An example is when scheduling an idle to run in another thread with C<g-idle-add()>: the idle may already have run and been removed by the time this function is called on its (now invalid) source ID.  This source ID may have been reissued, leading to the operation being performed against the wrong source.

Returns: (transfer none): the B<GSource>

  method find-source-by-id ( N-GMainContext $context, UInt $source_id --> GSource )

=item N-GMainContext $context; (nullable): a B<N-GMainContext> (if C<undefined>, the default context will be used)
=item UInt $source_id; the source ID, as returned by C<g-source-get-id()>.

=end pod

method find-source-by-id ( N-GMainContext $context, UInt $source_id --> GSource ) {

  g_main_context_find_source_by_id(
    self.get-native-object-no-reffing, $context, $source_id
  );
}

sub g_main_context_find_source_by_id ( N-GMainContext $context, guint $source_id --> GSource )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:find-source-by-user-data:
=begin pod
=head2 find-source-by-user-data

Finds a source with the given user data for the callback.  If multiple sources exist with the same user data, the first one found will be returned.

Returns: (transfer none): the source, if one was found, otherwise C<undefined>

  method find-source-by-user-data ( N-GMainContext $context, Pointer $user_data --> GSource )

=item N-GMainContext $context; a B<N-GMainContext>
=item Pointer $user_data; the user-data for the callback.

=end pod

method find-source-by-user-data ( N-GMainContext $context, Pointer $user_data --> GSource ) {

  g_main_context_find_source_by_user_data(
    self.get-native-object-no-reffing, $context, $user_data
  );
}

sub g_main_context_find_source_by_user_data ( N-GMainContext $context, gpointer $user_data --> GSource )
  is native(&glib-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:get-poll-func:
=begin pod
=head2 get-poll-func

Gets the poll function set by C<set-poll-func()>.

Returns: the poll function

  method get-poll-func ( N-GMainContext $context --> GPollFunc )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method get-poll-func ( N-GMainContext $context --> GPollFunc ) {

  g_main_context_get_poll_func(
    self.get-native-object-no-reffing, $context
  );
}

sub g_main_context_get_poll_func ( N-GMainContext $context --> GPollFunc )
  is native(&glib-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_g_main_context_get_thread_default:
#`{{
=begin pod
=head2 get-thread-default

Gets the thread-default B<N-GMainContext> for this thread. Asynchronous operations that want to be able to be run in contexts other than the default one should call this method or C<ref-thread-default()> to get a B<N-GMainContext> to add their B<GSources> to. (Note that even in single-threaded programs applications may sometimes want to temporarily push a non-default context, so it is not safe to assume that this will always return C<undefined> if you are running in the default thread.)

If you need to hold a reference on the context, use C<ref-thread-default()> instead.

Returns: (transfer none): the thread-default B<N-GMainContext>, or C<undefined> if the thread-default context is the global default context.

  method get-thread-default ( --> N-GMainContext )


=end pod

method get-thread-default ( --> N-GMainContext ) {

  g_main_context_get_thread_default(
    self.get-native-object-no-reffing,
  );
}
}}

sub _g_main_context_get_thread_default (  --> N-GMainContext )
  is symbol('g_main_context_get_thread_default')
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:invoke:
=begin pod
=head2 invoke

Invokes a function in such a way that the context is owned during the invocation of the callback handler.

=comment If the context is C<undefined> then the global default main context — as returned by C<default()> — is used.

If the context is owned by the current thread, the callback handler is called directly.  Otherwise, if the context is the thread-default main context of the current thread and C<acquire()> succeeds, then the callback handler is called and C<release()> is called afterwards.

In any other case, an idle source is created to call the callback handler and that source is attached to the context (presumably to be run in another thread).  The idle source is attached with B<G-PRIORITY-DEFAULT> priority.  If you want a different priority, use C<invoke-full()>.

Note that, as with normal idle functions, the callback handler should probably return G_SOURCE_REMOVE.  If it returns G_SOURCE_CONTINUE, it will be continuously run in a loop (and may prevent this call from returning).

  method invoke (
    Any:D $handler-object, Str:D $method, *%options
  )

=item $handler-object; The object where the callback method is defined
=item $method; The name of the callback method
=item %options; Options which can be provided to the handler

=end pod

method invoke ( Any:D $handler-object, Str:D $method, *%options ) {

  g_main_context_invoke(
    self.get-native-object-no-reffing,
    sub ( gpointer $d --> gboolean ) {
      if $handler-object.^can($method) {
        $handler-object."$method"(|%options)
      }

      else {
        note "Handler method $method not found";
        0 # == false == G_SOURCE_REMOVE
      }
    }, Pointer
  );
}

sub g_main_context_invoke (
  N-GMainContext $context,
  Callable $function ( gpointer --> gboolean ),
  gpointer $data
) is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:invoke-full:
=begin pod
=head2 invoke-full

Invokes a function in such a way that the context is owned during the invocation of the callback handler.  This function is the same as C<invoke()> except that it lets you specify the priority in case the callback handler ends up being scheduled as an idle and also lets you define a destroy notify handler. The notify handler should not assume that it is called from any particular thread or with any particular context acquired.

  method invoke-full (
    Int $priority, Any:D $handler-object, Str:D $method,
    Any:D $handler-notify-object, Str:D $method-notify, *%options
  )

=item Int $priority; the priority at which to run the callback.
=item $handler-object; The object where the callback method is defined.
=item $method; The name of the callback method.
=item $handler-notify-object; The object where the destroy notify method method is defined. This is optional.
=item $method-notify; The name of the notify method.
=item %options; Options which are provided to the callback handler and notify methods.

=end pod

method invoke-full (
  Int $priority,
  Any:D $handler-object, Str:D $method,
  Any:D $handler-notify-object, Str:D $method-notify,
  *%options
) {
#note 'if: ', $?LINE;

  g_main_context_invoke_full(
    self.get-native-object-no-reffing, $priority,
    sub ( gpointer $d --> gboolean ) {
      return unless (?$handler-object and ?$method);
#note 'if sub 1: ', $?LINE;
      if $handler-object.^can($method) {
        $handler-object."$method"(|%options)
      }

      else {
        note "Handler method $method-notify not found";
        0 # == false == G_SOURCE_REMOVE
      }
    }, Pointer,
    sub ( gpointer $d ) {
#note 'if sub 2: ', $?LINE;
      return unless (?$handler-notify-object and ?$method-notify);

      if $handler-notify-object.^can($method-notify) {
        $handler-notify-object."$method-notify"(|%options)
      }

      else {
        note "Handler method $method-notify not found";
      }
    },
  );
}

sub g_main_context_invoke_full (
  N-GMainContext $context, gint $priority,
  Callable $function ( gpointer ), gpointer,
  Callable $notify ( gpointer )
) is native(&glib-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:0:is-owner:
=begin pod
=head2 is-owner

Determines whether this thread holds the (recursive) ownership of this B<N-GMainContext>. This is useful to know before waiting on another thread that may be blocking to get ownership of the context.

Returns: C<True> if current thread is owner of the context.

  method is-owner ( N-GMainContext $context --> Int )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method is-owner ( N-GMainContext $context --> Int ) {

  g_main_context_is_owner(
    self.get-native-object-no-reffing, $context
  );
}

sub g_main_context_is_owner ( N-GMainContext $context --> gboolean )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:iteration:
=begin pod
=head2 iteration

Runs a single iteration for the given main loop. This involves checking to see if any event sources are ready to be processed, then if no events sources are ready and I<may-block> is C<True>, waiting for a source to become ready, then dispatching the highest priority events sources that are ready. Otherwise, if I<may-block> is C<False> sources are not waited to become ready, only those highest priority events sources will be dispatched (if any), that are ready at this given moment without further waiting.  Note that even when I<may-block> is C<True>, it is still possible for C<iteration()> to return C<False>, since the wait may be interrupted for other reasons than an event source becoming ready.

Returns: C<True> if events were dispatched.

  method iteration ( N-GMainContext $context, Int $may_block --> Int )

=item N-GMainContext $context; (nullable): a B<N-GMainContext> (if C<undefined>, the default context will be used)
=item Int $may_block; whether the call may block.

=end pod

method iteration ( N-GMainContext $context, Int $may_block --> Int ) {

  g_main_context_iteration(
    self.get-native-object-no-reffing, $context, $may_block
  );
}

sub g_main_context_iteration ( N-GMainContext $context, gboolean $may_block --> gboolean )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:pending:
=begin pod
=head2 pending

Checks if any sources have pending events for the given context.

Returns: C<True> if events are pending.

  method pending ( N-GMainContext $context --> Int )

=item N-GMainContext $context; (nullable): a B<N-GMainContext> (if C<undefined>, the default context will be used)

=end pod

method pending ( N-GMainContext $context --> Int ) {

  g_main_context_pending(
    self.get-native-object-no-reffing, $context
  );
}

sub g_main_context_pending ( N-GMainContext $context --> gboolean )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:pop-thread-default:
=begin pod
=head2 pop-thread-default

Pops the context off the thread-default context stack (verifying that it was on the top of the stack).

  method pop-thread-default ( N-GMainContext $context )

=item N-GMainContext $context; (nullable): a B<N-GMainContext> object, or C<undefined>

=end pod

method pop-thread-default ( ) {

  g_main_context_pop_thread_default(
    self.get-native-object-no-reffing
  );
}

sub g_main_context_pop_thread_default ( N-GMainContext $context  )
  is native(&glib-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:prepare:
=begin pod
=head2 prepare

Prepares to poll sources within a main loop. The resulting information for polling is determined by calling C<query()>.  You must have successfully acquired the context with C<acquire()> before you may call this function.

Returns: C<True> if some source is ready to be dispatched prior to polling.

  method prepare ( N-GMainContext $context, Int-ptr $priority --> Int )

=item N-GMainContext $context; a B<N-GMainContext>
=item Int-ptr $priority; location to store priority of highest priority source already ready.

=end pod

method prepare ( N-GMainContext $context, Int-ptr $priority --> Int ) {

  g_main_context_prepare(
    self.get-native-object-no-reffing, $context, $priority
  );
}

sub g_main_context_prepare (
  N-GMainContext $context, gint $priority is rw --> gboolean
) is native(&glib-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:push-thread-default:
=begin pod
=head2 push-thread-default

Acquires the context and sets it as the thread-default context for the current thread. This will cause certain asynchronous operations (such as most [gio][gio]-based I/O) which are started in this thread to run under the context and deliver their results to its main loop, rather than running under the global default context in the main thread. Note that calling this function changes the context created by C<new(:thread-default)>, not the one created by C<new(:default)>
=comment , so it does not affect the context used by functions like C<g-idle-add()>.

Normally you would call this function shortly after creating a new thread, passing it a B<Gnome::Glib::MainContext> which will be run by a B<Gnome::Glib::MainLoop> in that thread, to set a new default context for all async operations in that thread. In this case you may not need to ever call C<pop-thread-default()>, assuming you want the new B<Gnome::Glib::MainContext> to be the default for the whole lifecycle of the thread.

=comment If you don't have control over how the new thread was created (e.g. if the thread isn't newly created, or if the thread life cycle is managed by a B<GThreadPool>), it is always suggested to wrap the logic that needs to use the new B<Gnome::Glib::MainContext> inside a C<push-thread-default()> / C<pop-thread-default()> pair, otherwise threads that are re-used will end up never explicitly releasing the B<Gnome::Glib::MainContext> reference they hold.

In some cases you may want to schedule a single operation in a non-default context, or temporarily use a non-default context in the main thread. In that case, you can wrap the call to the asynchronous operation inside a C<push-thread-default()> / C<pop-thread-default()> pair, but it is up to you to ensure that no other asynchronous operations accidentally get started while the non-default context is active.

=comment Beware that libraries that predate this function may not correctly handle being used from a thread with a thread-default context. Eg, see C<g-file-supports-thread-contexts()>.

  method push-thread-default ( )

=end pod

method push-thread-default ( ) {
  g_main_context_push_thread_default(self.get-native-object-no-reffing);
}

sub g_main_context_push_thread_default ( N-GMainContext $context  )
  is native(&glib-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:query:
=begin pod
=head2 query

Determines information necessary to poll this main loop.  You must have successfully acquired the context with C<acquire()> before you may call this function.

Returns: the number of records actually stored in I<fds>, or, if more than I<n-fds> records need to be stored, the number of records that need to be stored.

  method query ( N-GMainContext $context, Int $max_priority, Int-ptr $timeout_, GPollFD $fds, Int $n_fds --> Int )

=item N-GMainContext $context; a B<N-GMainContext>
=item Int $max_priority; maximum priority source to check
=item Int-ptr $timeout_; (out): location to store timeout to be used in polling
=item GPollFD $fds; (out caller-allocates) (array length=n-fds): location to store B<GPollFD> records that need to be polled.
=item Int $n_fds; (in): length of I<fds>.

=end pod

method query ( N-GMainContext $context, Int $max_priority, Int-ptr $timeout_, GPollFD $fds, Int $n_fds --> Int ) {

  g_main_context_query(
    self.get-native-object-no-reffing, $context, $max_priority, $timeout_, $fds, $n_fds
  );
}

sub g_main_context_query ( N-GMainContext $context, gint $max_priority, gint-ptr $timeout_, GPollFD $fds, gint $n_fds --> gint )
  is native(&glib-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_g_main_context_ref:
#`{{
=begin pod
=head2 ref

Increases the reference count on a B<N-GMainContext> object by one.

Returns: the the context that was passed in (since 2.6)

  method ref ( N-GMainContext $context --> N-GMainContext )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method ref ( N-GMainContext $context --> N-GMainContext ) {

  g_main_context_ref(
    self.get-native-object-no-reffing, $context
  );
}
}}

sub _g_main_context_ref ( N-GMainContext $context --> N-GMainContext )
  is symbol('g_main_context_ref')
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:ref-thread-default:
=begin pod
=head2 ref-thread-default

Gets the thread-default B<N-GMainContext> for this thread, as with C<get-thread-default()>, but also adds a reference to it with C<ref()>. In addition, unlike C<get-thread-default()>, if the thread-default context is the global default context, this will return that B<N-GMainContext> (with a ref added to it) rather than returning C<undefined>.

Returns: (transfer full): the thread-default B<N-GMainContext>. Unref with C<unref()> when you are done with it.

  method ref-thread-default ( --> N-GMainContext )


=end pod

method ref-thread-default ( --> N-GMainContext ) {

  g_main_context_ref_thread_default(
    self.get-native-object-no-reffing,
  );
}

sub g_main_context_ref_thread_default (  --> N-GMainContext )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:release:
=begin pod
=head2 release

Releases ownership of a context previously acquired by this thread with C<acquire()>. If the context was acquired multiple times, the ownership will be released only when C<release()> is called as many times as it was acquired.

  method release ( N-GMainContext $context )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method release ( N-GMainContext $context ) {

  g_main_context_release(
    self.get-native-object-no-reffing, $context
  );
}

sub g_main_context_release ( N-GMainContext $context  )
  is native(&glib-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:remove-poll:
=begin pod
=head2 remove-poll

Removes file descriptor from the set of file descriptors to be polled for a particular context.

  method remove-poll ( N-GMainContext $context, GPollFD $fd )

=item N-GMainContext $context; a B<N-GMainContext>
=item GPollFD $fd; a B<GPollFD> descriptor previously added with C<add-poll()>

=end pod

method remove-poll ( N-GMainContext $context, GPollFD $fd ) {

  g_main_context_remove_poll(
    self.get-native-object-no-reffing, $context, $fd
  );
}

sub g_main_context_remove_poll ( N-GMainContext $context, GPollFD $fd  )
  is native(&glib-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:set-poll-func:
=begin pod
=head2 set-poll-func

Sets the function to use to handle polling of file descriptors. It will be used instead of the C<poll()> system call  (or GLib's replacement function, which is used where  C<poll()> isn't available).  This function could possibly be used to integrate the GLib event loop with an external event loop.

  method set-poll-func ( N-GMainContext $context, GPollFunc $func )

=item N-GMainContext $context; a B<N-GMainContext>
=item GPollFunc $func; the function to call to poll all file descriptors

=end pod

method set-poll-func ( N-GMainContext $context, GPollFunc $func ) {

  g_main_context_set_poll_func(
    self.get-native-object-no-reffing, $context, $func
  );
}

sub g_main_context_set_poll_func ( N-GMainContext $context, GPollFunc $func  )
  is native(&glib-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:`:_g_main_context_unref:
#`{{
=begin pod
=head2 unref

Decreases the reference count on a B<N-GMainContext> object by one. If the result is zero, free the context and free all associated memory.

  method unref ( N-GMainContext $context )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method unref ( N-GMainContext $context ) {

  g_main_context_unref(
    self.get-native-object-no-reffing, $context
  );
}
}}

sub _g_main_context_unref ( N-GMainContext $context  )
  is native(&glib-lib)
  is symbol('g_main_context_unref')
  { * }

#-------------------------------------------------------------------------------
#TM:0:wakeup:
=begin pod
=head2 wakeup

If the context is currently blocking in C<iteration()> waiting for a source to become ready, cause it to stop blocking and return.  Otherwise, cause the next invocation of C<iteration()> to return without blocking.  This API is useful for low-level control over B<N-GMainContext>; for example, integrating it with main loop implementations such as B<Gnome::Glib::MainLoop>.  Another related use for this function is when implementing a main loop with a termination condition, computed from multiple threads:  |[<!-- language="C" -->  B<define> NUM-TASKS 10 static volatile gint tasks-remaining = NUM-TASKS; ...   while (g-atomic-int-get (&tasks-remaining) != 0) iteration (NULL, TRUE); ]|   Then in a thread: |[<!-- language="C" -->  C<perform-work()>;  if (g-atomic-int-dec-and-test (&tasks-remaining)) wakeup (NULL); ]|

  method wakeup ( N-GMainContext $context )

=item N-GMainContext $context; a B<N-GMainContext>

=end pod

method wakeup ( N-GMainContext $context ) {

  g_main_context_wakeup(
    self.get-native-object-no-reffing, $context
  );
}

sub g_main_context_wakeup ( N-GMainContext $context  )
  is native(&glib-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_g_main_new:
#`{{
=begin pod
=head2 new

Creates a new B<N-GMainContext> structure.

Returns: the new B<N-GMainContext>

  method new ( --> N-GMainContext )


=end pod

method new ( --> N-GMainContext ) {

  g_main_context_new(
    self.get-native-object-no-reffing,
  );
}
}}

sub _g_main_context_new ( --> N-GMainContext )
  is native(&glib-lib)
  is symbol('g_main_context_new')
  { * }
