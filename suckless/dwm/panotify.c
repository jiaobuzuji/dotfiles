#include <libnotify/notify.h>

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

typedef struct _PulseaudioNotify
{
  NotifyNotification   *notification;
  NotifyNotification   *notification_mic;
  int                   volume;
  char                  muted;
  int                   volume_mic;
  char                  muted_mic;

} PulseaudioNotify;

PulseaudioNotify panotify;

/* declarations */
static void pulseaudio_notify_volume (const int volume, const char mic);
static void pulseaudio_notify_muted (const char muted, const char mic);

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

  notify->volume = 30; // 30%
  notify->muted = 0; // FALSE
  notify->volume_mic = 10; // 30%
  notify->muted_mic = 0; // FALSE

  pulseaudio_notify_volume (notify->volume,FALSE);
  pulseaudio_notify_muted (notify->muted,FALSE);
  pulseaudio_notify_volume (notify->volume_mic,TRUE);
  pulseaudio_notify_muted (notify->muted_mic,TRUE);
}

static void
pulseaudio_notify_finalize (PulseaudioNotify *notify)
{
  notify->notification = NULL;
  notify->notification_mic = NULL;
  notify_uninit ();
}

// --------------------------------------------------------------------------------------------------
// notification
static void
pulseaudio_notify_notify (PulseaudioNotify *notify, char mic)
{
  NotifyNotification *notification;
  int                 volume;
  char                muted;
  char               *title = NULL;
  const char        **icons_array;
  const char         *icon = NULL;

  notification = mic ? notify->notification_mic : notify->notification;
  icons_array = mic ? icons_mic : icons_vol;

  volume = mic ? notify->volume_mic : notify->volume;
  muted = mic ? notify->muted_mic : notify->muted;
  title = mic ? "dwm-pulseaudio-mic" : "dwm-pulseaudio-audio";

  if (muted) icon = icons_array[V_MUTED];
  else if (volume <=  0) icon = icons_array[V_MUTED];
  else if (volume <= 30) icon = icons_array[V_LOW];
  else if (volume <= 70) icon = icons_array[V_MEDIUM];
  else icon = icons_array[V_HIGH];

  notify_notification_update (notification, title, NULL, icon);
  notify_notification_set_hint (notification, "value", g_variant_new_int32(volume)); // volume bar
  notify_notification_show (notification, NULL);
}
// --------------------------------------------------------------------------------------------------
// voiume control
static void
pulseaudio_notify_volume (const int volume, const char mic)
{
  char *pacmd[] = {"pactl", "set-sink-volume", "0", "100%", NULL};
  char vol_char[5] = {0};
  sprintf(vol_char,"%d%%",volume);
  pacmd[3] = vol_char;
  if(mic) {
    pacmd[1] = "set-source-volume";
    pacmd[2] = "1";
  }
  // printf("pacmd[3] : %s\n", pacmd[3]);
  if (fork() == 0) {
    setsid();
    execvp(pacmd[0], pacmd);
    fprintf(stderr, "dwm: execvp %s", pacmd[0]);
    perror(" failed");
    exit(EXIT_SUCCESS);
  }
}


static void
pulseaudio_notify_muted (const char muted, const char mic)
{
  char *pacmd[] = {"pactl", "set-sink-mute", "0", "0", NULL};
  char mute_char[2] = {0};
  sprintf(mute_char,"%d",muted);
  pacmd[3] = mute_char;
  if(mic) {
    pacmd[1] = "set-source-mute";
    pacmd[2] = "1";
  }
  if (fork() == 0) {
    setsid();
    execvp(pacmd[0], pacmd);
    fprintf(stderr, "dwm: execvp %s", pacmd[0]);
    perror(" failed");
    exit(EXIT_SUCCESS);
  }
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

void
pulseaudiovol(const Arg *arg)
{
  if(arg->i == 0) {
    panotify.muted = 1-panotify.muted;
    pulseaudio_notify_muted (panotify.muted,FALSE); // toggle
  } else {
    panotify.volume += arg->i;
    panotify.volume = MIN (MAX (panotify.volume, 0), 100); // for safety
    pulseaudio_notify_volume (panotify.volume,FALSE);
  }
  pulseaudio_notify_notify (&panotify,FALSE);
}

void
pulseaudiovolmic(const Arg *arg)
{
  if(arg->i == 0) {
    panotify.muted_mic = 1-panotify.muted_mic;
    pulseaudio_notify_muted (panotify.muted_mic,TRUE); // toggle
  } else {
    panotify.volume_mic += arg->i;
    panotify.volume_mic = MIN (MAX (panotify.volume_mic, 0), 100); // for safety
    pulseaudio_notify_volume (panotify.volume_mic,TRUE);
  }
  pulseaudio_notify_notify (&panotify,TRUE);
}

