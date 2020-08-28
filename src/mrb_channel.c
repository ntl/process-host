#include <mruby.h>
#include <mruby/class.h>

#include "mrb_process_host.h"
#include "mrb_channel_value.h"

void
mrb_process_host_channel_init(mrb_state* mrb) {
  struct RClass* channel_class = mrb_define_class_under(mrb, mrb_process_host_class(mrb), "Channel", mrb->object_class);
  MRB_SET_INSTANCE_TT(channel_class, MRB_TT_DATA);

  mrb_process_host_channel_value_init(mrb);

  return;
}

void
mrb_process_host_channel_final(mrb_state* mrb) {
  mrb_process_host_channel_value_final(mrb);

  return;
}
