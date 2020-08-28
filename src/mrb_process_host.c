#include <mruby.h>

#include "mrb_channel.h"

void
mrb_mruby_process_host_gem_init(mrb_state* mrb) {
  mrb_define_class(mrb, "ProcessHost", mrb->object_class);

  mrb_process_host_channel_init(mrb);

  return;
}

void
mrb_mruby_process_host_gem_final(mrb_state* mrb) {
  mrb_process_host_channel_final(mrb);

  return;
}
