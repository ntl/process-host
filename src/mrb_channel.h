#ifndef PROCESS_HOST_MRB_CHANNEL_H
#define PROCESS_HOST_MRB_CHANNEL_H

#include "mrb_process_host.h"

static inline
struct RClass* mrb_process_host_channel_class(mrb_state* mrb) {
  return mrb_class_get_under(mrb, mrb_process_host_class(mrb), "Channel");
}

void mrb_process_host_channel_init(mrb_state*);
void mrb_process_host_channel_final(mrb_state*);

#endif /* PROCESS_HOST_MRB_CHANNEL_H */
