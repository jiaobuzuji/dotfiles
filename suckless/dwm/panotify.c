#include <stdio.h>
#include <math.h>
#include <pulse/pulseaudio.h>
#include <pulse/glib-mainloop.h>
#include <libnotify/notify.h>

#define DEFAULT_VOLUME_STEP                       5
#define DEFAULT_VOLUME_MAX                        150

enum {
  V_MUTED  ,
  V_LOW    ,
  V_MEDIUM ,
  V_HIGH   ,
};

/* Icons for different volume levels */
static const char *icons_vol[] = {
  "audio-volume-muted-symbolic",
  "audio-volume-low-symbolic",
  "audio-volume-medium-symbolic",
  "audio-volume-high-symbolic",
  NULL
};

/* Icons for different mic volume levels */
static const char *icons_mic[] = {
  "microphone-sensitivity-muted-symbolic",
  "microphone-sensitivity-low-symbolic",
  "microphone-sensitivity-medium-symbolic",
  "microphone-sensitivity-high-symbolic",
  NULL
};

// enum {
//   VOLUME_CHANGED,
//   VOLUME_MIC_CHANGED,
//   LAST_SIGNAL
// };

// static guint pulseaudio_volume_signals[LAST_SIGNAL] = { 0, };


typedef struct _PulseaudioNotify
{
  NotifyNotification   *notification;
  NotifyNotification   *notification_mic;

  pa_glib_mainloop     *pa_mainloop;
  pa_context           *pa_context;
  gboolean              connected;
  gboolean              sink_connected;
  gboolean              source_connected;

  gdouble               volume;
  gboolean              muted;

  gdouble               volume_mic;
  gboolean              muted_mic;

  guint                 reconnect_timer_id;

  /* Device management */
  GHashTable           *sinks;
  GHashTable           *sources;

  guint                 sink_index;
  guint                 source_index;

  gchar                *default_sink_name;
  gchar                *default_source_name;
} PulseaudioNotify, PulseaudioVolume;


/* declarations */
static gboolean             pulseaudio_volume_get_connected           (PulseaudioVolume *volume);
static gboolean             pulseaudio_volume_get_sink_connected      (PulseaudioVolume *volume);
static gboolean             pulseaudio_volume_get_source_connected    (PulseaudioVolume *volume);

static gdouble              pulseaudio_volume_get_volume              (PulseaudioVolume *volume);
static void                 pulseaudio_volume_set_volume              (PulseaudioVolume *volume,
                                                                       gdouble           vol);
static gboolean             pulseaudio_volume_get_muted               (PulseaudioVolume *volume);
static void                 pulseaudio_volume_set_muted               (PulseaudioVolume *volume,
                                                                       gboolean          muted);
static void                 pulseaudio_volume_toggle_muted            (PulseaudioVolume *volume);

static gdouble              pulseaudio_volume_get_volume_mic          (PulseaudioVolume *volume);
static void                 pulseaudio_volume_set_volume_mic          (PulseaudioVolume *volume,
                                                                       gdouble           vol);

static gboolean             pulseaudio_volume_get_muted_mic           (PulseaudioVolume *volume);
static void                 pulseaudio_volume_set_muted_mic           (PulseaudioVolume *volume,
                                                                       gboolean          mic_muted);
static void                 pulseaudio_volume_toggle_muted_mic        (PulseaudioVolume *volume);

static GList               *pulseaudio_volume_get_output_list         (PulseaudioVolume *volume);
static gchar               *pulseaudio_volume_get_output_by_name      (PulseaudioVolume *volume,
                                                                       gchar            *name);
static const gchar         *pulseaudio_volume_get_default_output      (PulseaudioVolume *volume);
static void                 pulseaudio_volume_set_default_output      (PulseaudioVolume *volume,
                                                                       const gchar      *name);

static GList               *pulseaudio_volume_get_input_list          (PulseaudioVolume *volume);
static gchar               *pulseaudio_volume_get_input_by_name       (PulseaudioVolume *volume,
                                                                       gchar            *name);
static const gchar         *pulseaudio_volume_get_default_input       (PulseaudioVolume *volume);
static void                 pulseaudio_volume_set_default_input       (PulseaudioVolume *volume,
                                                                       const gchar      *name);

static void                 pulseaudio_volume_finalize           (GObject              *object);
static void                 pulseaudio_volume_connect            (PulseaudioVolume     *volume);
static gdouble              pulseaudio_volume_v2d                (PulseaudioVolume     *volume,
                                                                  pa_volume_t           vol);
static pa_volume_t          pulseaudio_volume_d2v                (PulseaudioVolume     *volume,
                                                                  gdouble               vol);
static gboolean             pulseaudio_volume_reconnect_timeout  (gpointer              userdata);
static void                 pulseaudio_volume_get_sink_list_cb   (pa_context           *context,
                                                                  const pa_sink_info   *i,
                                                                  int                   eol,
                                                                  void                 *userdata);
static void                 pulseaudio_volume_get_source_list_cb (pa_context           *context,
                                                                  const pa_source_info *i,
                                                                  int                   eol,
                                                                  void                 *userdata);
static void                 pulseaudio_volume_move_sink_input    (pa_context           *context,
                                                                  const                 pa_sink_input_info *i,
                                                                  int                   eol,
                                                                  void                 *userdata);


/* function implementations */
// --------------------------------------------------------------------------------------------------
static void
pulseaudio_notify_init (PulseaudioNotify *notify)
{
  notify->notification = NULL;
  notify->notification_mic = NULL;
  notify_init ("dwm pulseaudio control");
  notify->notification = notify_notification_new ("dwm-pulseaudio-audio", NULL, NULL);
  notify_notification_set_timeout (notify->notification, 2000);
  notify_notification_set_hint (notify->notification, "transient", g_variant_new_boolean (TRUE));
  notify->notification_mic = notify_notification_new ("dwm-pulseaudio-mic", NULL, NULL);
  notify_notification_set_timeout (notify->notification_mic, 2000);
  notify_notification_set_hint (notify->notification_mic, "transient", g_variant_new_boolean (TRUE));

  PulseaudioNotify *volume = notify;
  volume->connected = FALSE;
  volume->volume = 0.30; // 30%
  volume->muted = FALSE;
  volume->volume_mic = 0.50; // 50%
  volume->muted_mic = FALSE;
  volume->reconnect_timer_id = 0;
  volume->default_sink_name = NULL;
  volume->default_source_name = NULL;
  volume->pa_mainloop = pa_glib_mainloop_new (NULL);
  volume->sinks = g_hash_table_new_full (g_str_hash, g_str_equal, (GDestroyNotify)g_free, (GDestroyNotify)g_free);
  volume->sources = g_hash_table_new_full (g_str_hash, g_str_equal, (GDestroyNotify)g_free, (GDestroyNotify)g_free);
  pulseaudio_volume_connect (volume);

  // GObjectClass      *gobject_class;
  // pulseaudio_volume_signals[VOLUME_CHANGED] =
  //   g_signal_new (g_intern_static_string ("volume-changed"),
  //                 G_TYPE_FROM_CLASS (gobject_class),
  //                 G_SIGNAL_RUN_LAST,
  //                 0, NULL, NULL,
  //                 g_cclosure_marshal_VOID__BOOLEAN,
  //                 G_TYPE_NONE, 1, G_TYPE_BOOLEAN);

  // pulseaudio_volume_signals[VOLUME_MIC_CHANGED] =
  //   g_signal_new (g_intern_static_string ("volume-mic-changed"),
  //                 G_TYPE_FROM_CLASS (gobject_class),
  //                 G_SIGNAL_RUN_LAST,
  //                 0, NULL, NULL,
  //                 g_cclosure_marshal_VOID__BOOLEAN,
  //                 G_TYPE_NONE, 1, G_TYPE_BOOLEAN);
}

static void
pulseaudio_notify_finalize (PulseaudioNotify *notify)
{
  notify->notification = NULL;
  notify->notification_mic = NULL;
  notify_uninit ();

  PulseaudioNotify *volume = notify;
  if (volume->default_sink_name) g_free (volume->default_sink_name);
  if (volume->default_source_name) g_free (volume->default_source_name);
  g_hash_table_destroy (volume->sinks);
  g_hash_table_destroy (volume->sources);
  pa_glib_mainloop_free (volume->pa_mainloop);
}

// --------------------------------------------------------------------------------------------------
// notification
static void
pulseaudio_notify_notify (PulseaudioNotify *notify, gboolean mic)
{
  NotifyNotification *notification;
  gdouble             volume;
  gint                volume_i;
  gboolean            muted;
  gboolean            connected;
  char               *title = NULL;
  const char        **icons_array;
  const gchar        *icon = NULL;

  notification = mic ? notify->notification_mic : notify->notification;
  icons_array = mic ? icons_mic : icons_vol;

  volume = mic ? notify->volume_mic : notify->volume;
  muted = mic ? notify->muted_mic : notify->muted;
  title = mic ? "dwm-pulseaudio-mic" : "dwm-pulseaudio-audio";
  connected = pulseaudio_volume_get_connected (notify);
  volume_i = (gint) round (volume * 100);

  if (!connected) volume_i = 0;

  if (!connected) icon = icons_array[V_MUTED];
  else if (muted) icon = icons_array[V_MUTED];
  else if (volume <= 0.0) icon = icons_array[V_MUTED];
  else if (volume <= 0.3) icon = icons_array[V_LOW];
  else if (volume <= 0.7) icon = icons_array[V_MEDIUM];
  else icon = icons_array[V_HIGH];

  notify_notification_update (notification, title, NULL, icon);
  notify_notification_set_hint (notification, "value", g_variant_new_int32(volume_i)); // volume bar
  notify_notification_show (notification, NULL);
}

// --------------------------------------------------------------------------------------------------
// volume
static void
pulseaudio_volume_sink_info_cb (pa_context         *context,
                                const pa_sink_info *i,
                                int                 eol,
                                void               *userdata)
{
  gboolean  muted;
  gdouble   vol;

  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;


  volume->sink_index = (guint)i->index;

  muted = !!(i->mute);
  vol = pulseaudio_volume_v2d (volume, i->volume.values[0]);

  if (volume->muted != muted)
    {
      volume->muted = muted;

      // if (volume->sink_connected)
      //   g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_CHANGED], 0, TRUE);
    }

  if (ABS (volume->volume - vol) > 2e-3)
    {
      volume->volume = vol;

      // if (volume->sink_connected)
        // g_signal_emit(G_OBJECT(volume), pulseaudio_volume_signals[VOLUME_CHANGED], 0, TRUE);
    }

  volume->sink_connected = TRUE;
}



static void
pulseaudio_volume_source_info_cb (pa_context           *context,
                                  const pa_source_info *i,
                                  int                   eol,
                                  void                 *userdata)
{
  gboolean  muted_mic;
  gdouble   vol_mic;

  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;


  volume->source_index = (guint)i->index;

  muted_mic = !!(i->mute);
  vol_mic = pulseaudio_volume_v2d (volume, i->volume.values[0]);

  if (volume->muted_mic != muted_mic)
    {
      volume->muted_mic = muted_mic;

      // if (volume->source_connected)
      //   g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_MIC_CHANGED], 0, FALSE);
    }

  if (ABS (volume->volume_mic - vol_mic) > 2e-3)
    {
      volume->volume_mic = vol_mic;

      // if (volume->source_connected)
      //   g_signal_emit(G_OBJECT(volume), pulseaudio_volume_signals[VOLUME_MIC_CHANGED], 0, FALSE);
    }

  volume->source_connected = TRUE;
}



static void
pulseaudio_volume_server_info_cb (pa_context           *context,
                                  const pa_server_info *i,
                                  void                 *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  pulseaudio_volume_set_default_input (volume, i->default_source_name);
  pulseaudio_volume_set_default_output (volume, i->default_sink_name);

  pa_context_get_sink_info_by_name (context, i->default_sink_name, pulseaudio_volume_sink_info_cb, volume);
  pa_context_get_source_info_by_name (context, i->default_source_name, pulseaudio_volume_source_info_cb, volume);
}



static void
pulseaudio_volume_sink_source_check (PulseaudioVolume *volume,
                                     pa_context       *context)
{
  pa_context_get_server_info (context, pulseaudio_volume_server_info_cb, volume);

  g_hash_table_remove_all (volume->sinks);
  g_hash_table_remove_all (volume->sources);

  pa_context_get_sink_info_list (volume->pa_context, pulseaudio_volume_get_sink_list_cb, volume);
  pa_context_get_source_info_list (volume->pa_context, pulseaudio_volume_get_source_list_cb, volume);
}



static void
pulseaudio_volume_subscribe_cb (pa_context                   *context,
                                pa_subscription_event_type_t  t,
                                uint32_t                      idx,
                                void                         *userdata)
{
  PulseaudioVolume *volume = userdata;

  switch (t & PA_SUBSCRIPTION_EVENT_FACILITY_MASK)
    {
    case PA_SUBSCRIPTION_EVENT_SINK          :
      pulseaudio_volume_sink_source_check (volume, context);
      break;

    case PA_SUBSCRIPTION_EVENT_SINK_INPUT :
      pulseaudio_volume_sink_source_check (volume, context);
      break;

    case PA_SUBSCRIPTION_EVENT_SOURCE        :
      pulseaudio_volume_sink_source_check (volume, context);
      break;

    case PA_SUBSCRIPTION_EVENT_SOURCE_OUTPUT :
      pulseaudio_volume_sink_source_check (volume, context);
      break;

    case PA_SUBSCRIPTION_EVENT_SERVER        :
      pulseaudio_volume_sink_source_check (volume, context);
      break;

    default                                  :
      break;
    }
}



static void
pulseaudio_volume_get_sink_list_cb (pa_context         *context,
                                    const pa_sink_info *i,
                                    int                 eol,
                                    void               *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  if (eol > 0)
    return;

  g_hash_table_insert (volume->sinks, g_strdup (i->name), g_strdup (i->description));
}



static void
pulseaudio_volume_get_source_list_cb (pa_context           *context,
                                      const pa_source_info *i,
                                      int                   eol,
                                      void                 *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  if (eol > 0)
    return;

  /* Ignore sink monitors, not relevant for users */
  if (i->monitor_of_sink != PA_INVALID_INDEX)
    return;

  g_hash_table_insert (volume->sources, g_strdup (i->name), g_strdup (i->description));
}



static void
pulseaudio_volume_get_server_info_cb (pa_context           *context,
                                      const pa_server_info *i,
                                      void                 *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  g_free (volume->default_sink_name);
  g_free (volume->default_source_name);

  volume->default_sink_name = g_strdup (i->default_sink_name);
  volume->default_source_name = g_strdup (i->default_source_name);
}



static void
pulseaudio_volume_context_state_cb (pa_context *context,
                                    void       *userdata)
{
  PulseaudioVolume *volume = userdata;

  printf("pa_context_get_state : %d\n", pa_context_get_state (context));
  printf("state : %d, %d, %d, %d, %d, %d, %d\n", PA_CONTEXT_READY,PA_CONTEXT_FAILED,PA_CONTEXT_TERMINATED,PA_CONTEXT_CONNECTING  , PA_CONTEXT_SETTING_NAME, PA_CONTEXT_AUTHORIZING , PA_CONTEXT_UNCONNECTED);

  switch (pa_context_get_state (context))
    {
    case PA_CONTEXT_READY        :
      pa_context_subscribe (context, PA_SUBSCRIPTION_MASK_SINK | PA_SUBSCRIPTION_MASK_SINK_INPUT | PA_SUBSCRIPTION_MASK_SOURCE | PA_SUBSCRIPTION_MASK_SOURCE_OUTPUT | PA_SUBSCRIPTION_MASK_SERVER , NULL, NULL);
      pa_context_set_subscribe_callback (context, pulseaudio_volume_subscribe_cb, volume);

      volume->connected = TRUE;
      // Check current sink and source volume manually. PA sink events usually not emitted.
      pulseaudio_volume_sink_source_check (volume, context);

      // g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_CHANGED], 0, FALSE);
      // g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_MIC_CHANGED], 0, FALSE);

      volume->sink_connected = FALSE;
      volume->source_connected = FALSE;

      pa_context_get_server_info (volume->pa_context, pulseaudio_volume_get_server_info_cb, volume);

      break;

    case PA_CONTEXT_FAILED       :
    case PA_CONTEXT_TERMINATED   :
      g_warning ("Disconected from the PulseAudio server. Attempting to reconnect in 5 seconds.");
      volume->pa_context = NULL;
      volume->connected = FALSE;
      volume->volume = 0.0;
      volume->muted = FALSE;
      volume->volume_mic = 0.0;
      volume->muted_mic = FALSE;

      // g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_CHANGED], 0, FALSE);
      // g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_MIC_CHANGED], 0, FALSE);

      g_hash_table_remove_all (volume->sinks);
      g_hash_table_remove_all (volume->sources);

      if (volume->reconnect_timer_id == 0)
        volume->reconnect_timer_id = g_timeout_add_seconds
          (5, pulseaudio_volume_reconnect_timeout, volume);
      break;

    case PA_CONTEXT_CONNECTING   :
      break;

    case PA_CONTEXT_SETTING_NAME :
      break;

    case PA_CONTEXT_AUTHORIZING  :
      break;

    case PA_CONTEXT_UNCONNECTED  :
      break;

    default                      :
      g_warning ("Unknown pulseaudio context state");
      break;
    }
}



static void
pulseaudio_volume_connect (PulseaudioVolume *volume)
{
  pa_proplist  *proplist;

  proplist = pa_proplist_new ();
  pa_proplist_sets (proplist, PA_PROP_APPLICATION_NAME, "dwm-pulseaudio-plugin");
  pa_proplist_sets (proplist, PA_PROP_APPLICATION_ID, "dwm-pulseaudio-plugin");
  pa_proplist_sets (proplist, PA_PROP_APPLICATION_ICON_NAME, "multimedia-volume-control");

  volume->pa_context = pa_context_new_with_proplist (pa_glib_mainloop_get_api (volume->pa_mainloop), NULL, proplist);
  pa_context_set_state_callback(volume->pa_context, pulseaudio_volume_context_state_cb, volume);

  pa_context_connect (volume->pa_context, NULL, PA_CONTEXT_NOFAIL, NULL);
}



static gboolean
pulseaudio_volume_reconnect_timeout  (gpointer userdata)
{
  PulseaudioVolume *volume = userdata;

  volume->reconnect_timer_id = 0;
  pulseaudio_volume_connect (volume);

  return FALSE;  // stop the timer
}



static gboolean
pulseaudio_volume_get_connected (PulseaudioVolume *volume)
{

  return volume->connected;
}



static gboolean
pulseaudio_volume_get_sink_connected (PulseaudioVolume *volume)
{

  return volume->sink_connected;
}



static gboolean
pulseaudio_volume_get_source_connected (PulseaudioVolume *volume)
{

  return volume->source_connected;
}



static gdouble
pulseaudio_volume_v2d (PulseaudioVolume *volume,
                       pa_volume_t       pa_volume)
{
  gdouble vol;
  gdouble vol_max;

  vol_max = DEFAULT_VOLUME_MAX / 100.0;

  vol = (gdouble) pa_volume - PA_VOLUME_MUTED;
  vol /= (gdouble) (PA_VOLUME_NORM - PA_VOLUME_MUTED);
  /* for safety */
  vol = MIN (MAX (vol, 0.0), vol_max);
  return vol;
}



static pa_volume_t
pulseaudio_volume_d2v (PulseaudioVolume *volume,
                       gdouble           vol)
{
  pa_volume_t pa_volume;


  pa_volume = (pa_volume_t) ((PA_VOLUME_NORM - PA_VOLUME_MUTED) * vol);
  pa_volume = pa_volume + PA_VOLUME_MUTED;
  /* for safety */
  pa_volume = MIN (MAX (pa_volume, PA_VOLUME_MUTED), PA_VOLUME_MAX);
  return pa_volume;
}



static gboolean
pulseaudio_volume_get_muted (PulseaudioVolume *volume)
{

  return volume->muted;
}



/* final callback for volume/mute changes */
/* pa_context_success_cb_t */
static void
pulseaudio_volume_sink_volume_changed (pa_context *context,
                                       int         success,
                                       void       *userdata)
{
  PulseaudioVolume *volume = userdata;

  // if (success)
    // g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_CHANGED], 0, TRUE);
}



static void
pulseaudio_volume_set_muted (PulseaudioVolume *volume,
                             gboolean          muted)
{

  if (volume->muted != muted)
    {
      volume->muted = muted;
      pa_context_set_sink_mute_by_index (volume->pa_context, volume->sink_index, volume->muted, pulseaudio_volume_sink_volume_changed, volume);
    }
}



static void
pulseaudio_volume_toggle_muted (PulseaudioVolume *volume)
{

  pulseaudio_volume_set_muted (volume, !volume->muted);
}



static gboolean
pulseaudio_volume_get_muted_mic (PulseaudioVolume *volume)
{

  return volume->muted_mic;
}



/* final callback for mic volume/mute changes */
/* pa_context_success_cb_t */
static void
pulseaudio_volume_source_volume_changed (pa_context *context,
                                         int         success,
                                         void       *userdata)
{
  PulseaudioVolume *volume = userdata;

  // if (success)
    // g_signal_emit (G_OBJECT (volume), pulseaudio_volume_signals [VOLUME_MIC_CHANGED], 0, TRUE);
}



static void
pulseaudio_volume_set_muted_mic (PulseaudioVolume *volume,
                                 gboolean          muted_mic)
{

  if (volume->muted_mic != muted_mic)
    {
      volume->muted_mic = muted_mic;
      pa_context_set_source_mute_by_index (volume->pa_context, volume->source_index, volume->muted_mic, pulseaudio_volume_source_volume_changed, volume);
    }
}



static void
pulseaudio_volume_toggle_muted_mic (PulseaudioVolume *volume)
{

  pulseaudio_volume_set_muted_mic (volume, !volume->muted_mic);
}



static gdouble
pulseaudio_volume_get_volume (PulseaudioVolume *volume)
{

  return volume->volume;
}



/* volume setting callbacks */
/* pa_sink_info_cb_t */
static void
pulseaudio_volume_set_volume_cb2 (pa_context         *context,
                                  const pa_sink_info *i,
                                  int                 eol,
                                  void               *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  pa_cvolume_set ((pa_cvolume *)&i->volume, 1, pulseaudio_volume_d2v (volume, volume->volume));
  pa_context_set_sink_volume_by_index (context, i->index, &i->volume, pulseaudio_volume_sink_volume_changed, volume);
}



/* pa_server_info_cb_t */
static void
pulseaudio_volume_set_volume_cb1 (pa_context           *context,
                                  const pa_server_info *i,
                                  void                 *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  pa_context_get_sink_info_by_name (context, i->default_sink_name, pulseaudio_volume_set_volume_cb2, volume);
}



static void
pulseaudio_volume_set_volume (PulseaudioVolume *volume,
                              gdouble           vol)
{
  gdouble vol_max;
  gdouble vol_trim;


  vol_max = DEFAULT_VOLUME_MAX / 100.0;
  vol_trim = MIN (MAX (vol, 0.0), vol_max);

  if (volume->volume != vol_trim)
  {
    volume->volume = vol_trim;
    pa_context_get_server_info (volume->pa_context, pulseaudio_volume_set_volume_cb1, volume);
  }
}



static gdouble
pulseaudio_volume_get_volume_mic (PulseaudioVolume *volume)
{

  return volume->volume_mic;
}



/* volume setting callbacks */
/* pa_source_info_cb_t */
static void
pulseaudio_volume_set_volume_mic_cb2 (pa_context           *context,
                                      const pa_source_info *i,
                                      int                   eol,
                                      void                 *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  pa_cvolume_set ((pa_cvolume *)&i->volume, 1, pulseaudio_volume_d2v (volume, volume->volume_mic));
  pa_context_set_source_volume_by_index (context, i->index, &i->volume, pulseaudio_volume_source_volume_changed, volume);
}



/* pa_server_info_cb_t */
static void
pulseaudio_volume_set_volume_mic_cb1 (pa_context           *context,
                                      const pa_server_info *i,
                                      void                 *userdata)
{
  PulseaudioVolume *volume = userdata;
  if (i == NULL) return;

  pa_context_get_source_info_by_name (context, i->default_source_name, pulseaudio_volume_set_volume_mic_cb2, volume);
}



static void
pulseaudio_volume_set_volume_mic (PulseaudioVolume *volume,
                                  gdouble           vol)
{
  gdouble vol_max;
  gdouble vol_trim;


  vol_max = DEFAULT_VOLUME_MAX / 100.0;
  vol_trim = MIN (MAX (vol, 0.0), vol_max);

  if (volume->volume_mic != vol_trim)
    {
      volume->volume_mic = vol_trim;
      pa_context_get_server_info (volume->pa_context, pulseaudio_volume_set_volume_mic_cb1, volume);
    }
}



static gint
sort_device_list (gchar *a,
                  gchar *b,
                  void  *hash_table)
{
  GHashTable *table = (GHashTable *)hash_table;
  gchar      *a_val = (gchar *) g_hash_table_lookup (table, a);
  gchar      *b_val = (gchar *) g_hash_table_lookup (table, b);
  return g_strcmp0 (a_val, b_val);
}



static GList *
pulseaudio_volume_get_output_list (PulseaudioVolume *volume)
{
  GList *list;
  GList *sorted;

  list = g_hash_table_get_keys (volume->sinks);
  sorted = g_list_sort_with_data (list, (GCompareDataFunc) sort_device_list, volume->sinks);

  return sorted;
}



static gchar *
pulseaudio_volume_get_output_by_name (PulseaudioVolume *volume,
                                      gchar            *name)
{
  return (gchar *) g_hash_table_lookup (volume->sinks, name);
}



static GList *
pulseaudio_volume_get_input_list (PulseaudioVolume *volume)
{
  GList *list;
  GList *sorted;


  list = g_hash_table_get_keys (volume->sources);
  sorted = g_list_sort_with_data (list, (GCompareDataFunc) sort_device_list, volume->sources);

  return sorted;
}



static gchar *
pulseaudio_volume_get_input_by_name (PulseaudioVolume *volume,
                                     gchar            *name)
{
  return (gchar *) g_hash_table_lookup (volume->sources, name);
}



static const gchar *
pulseaudio_volume_get_default_output (PulseaudioVolume *volume)
{
  return volume->default_sink_name;
}


static const gchar *
pulseaudio_volume_get_default_input (PulseaudioVolume *volume)
{
  return volume->default_source_name;
}



static void
pulseaudio_volume_default_sink_changed_info_cb (pa_context         *context,
                                                const pa_sink_info *i,
                                                int                 eol,
                                                void               *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  pa_context_move_sink_input_by_index (context, volume->sink_index, i->index, NULL, NULL);
  volume->sink_index = (guint)i->index;

  pa_context_get_sink_input_info_list (volume->pa_context, pulseaudio_volume_move_sink_input, volume);
}



static void
pulseaudio_volume_default_sink_changed (pa_context *context,
                                        int         success,
                                        void       *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (success)
    pa_context_get_sink_info_by_name (volume->pa_context, volume->default_sink_name, pulseaudio_volume_default_sink_changed_info_cb, volume);
}



static void
pulseaudio_volume_move_sink_input (pa_context               *context,
                                   const pa_sink_input_info *i,
                                   int                       eol,
                                   void                     *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL) return;
  if (eol > 0) return;

  pa_context_move_sink_input_by_name (context, i->index, volume->default_sink_name, NULL, NULL);
}



static void
pulseaudio_volume_set_default_output (PulseaudioVolume *volume,
                                      const gchar      *name)
{
  if (g_strcmp0(name, volume->default_sink_name) == 0)
    return;

  g_free (volume->default_sink_name);
  volume->default_sink_name = g_strdup (name);

  pa_context_set_default_sink (volume->pa_context, name, pulseaudio_volume_default_sink_changed, volume);
}



static void
pulseaudio_volume_default_source_changed_info_cb (pa_context         *context,
                                                  const pa_source_info *i,
                                                  int                 eol,
                                                  void               *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (i == NULL)
    return;

  pa_context_move_source_output_by_index (context, volume->source_index, i->index, NULL, NULL);
  volume->source_index = (guint)i->index;
}



static void
pulseaudio_volume_default_source_changed (pa_context *context,
                                          int         success,
                                          void       *userdata)
{
  PulseaudioVolume *volume = userdata;

  if (success)
    pa_context_get_source_info_by_name (volume->pa_context, volume->default_source_name, pulseaudio_volume_default_source_changed_info_cb, volume);
}



static void
pulseaudio_volume_set_default_input (PulseaudioVolume *volume,
                                     const gchar      *name)
{
  if (g_strcmp0 (name, volume->default_source_name) == 0)
    return;

  g_free (volume->default_source_name);
  volume->default_source_name = g_strdup (name);

  pa_context_set_default_source (volume->pa_context, name, pulseaudio_volume_default_source_changed, volume);
}



// // --------------------------------------------------------------------------------------------------
// // DEPRECATED
// // static const char *upvol[]   = { "pactl", "set-sink-volume", "0", "+5%", NULL };
// // static const char *downvol[] = { "pactl", "set-sink-volume", "0", "-5%", NULL }; // /usr/bin/amixer -qM set Master 5%- umute
// // static const char *mutevol[] = { "pactl", "set-sink-mute",   "0", "toggle", NULL }; // /usr/bin/amixer set Master toggle
// // static const char *mutemic[] = { "pactl", "set-source-mute", "1", "toggle", NULL };
// // #define XF86XK_AudioPlay
// // #define XF86XK_AudioStop
// // #define XF86XK_AudioPrev
// // #define XF86XK_AudioNext
// // { 0,                   XF86XK_AudioLowerVolume, spawn,     {.v = downvol } },
// // { 0,                   XF86XK_AudioMute,        spawn,     {.v = mutevol } },
// // { 0,                   XF86XK_AudioRaiseVolume, spawn,     {.v = upvol   } },
// // { 0,                   XF86XK_AudioMicMute,     spawn,     {.v = mutemic } },

// debug
#include <unistd.h> // sleep
int
main(int argc, char *argv[])
{
  PulseaudioNotify panotify;
  /* init pulseaudio notification */
  pulseaudio_notify_init(&panotify);
  // printf("test : %d", volume->connected ? 50 : 20);
  pulseaudio_notify_notify(&panotify,FALSE);
  // sleep(1);
  // pulseaudio_notify_notify(&panotify,TRUE);

  /* uninit pulseaudio notification */
  pulseaudio_notify_finalize (&panotify);

  return EXIT_SUCCESS;
}
