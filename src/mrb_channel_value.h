#ifndef PROCESS_HOST_MRB_CHANNEL_VALUE_H
#define PROCESS_HOST_MRB_CHANNEL_VALUE_H

#include <mruby.h>

#include "mrb_channel.h"
#include "channel_value.h"

mrb_value mrb_process_host_channel_value_convert(mrb_state*, mrb_value);
mrb_value mrb_process_host_channel_value_restore(mrb_state*, const ChannelValue* const);

static inline
struct RClass* mrb_process_host_channel_value_class(mrb_state* mrb) {
  return mrb_class_get_under(mrb, mrb_process_host_channel_class(mrb), "Value");
}

void mrb_process_host_channel_value_init(mrb_state*);
void mrb_process_host_channel_value_final(mrb_state*);

#endif /* PROCESS_HOST_MRB_CHANNEL_VALUE_H */
