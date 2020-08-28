#include <mruby.h>
#include <mruby/class.h>
#include <mruby/data.h>
#include <mruby/string.h>

#include <stdlib.h>

#include "mrb_channel_value.h"

static struct {
  mrb_int bytes_transferred;
} mrb_value_stats = { 0 };

static void
mrb_process_host_channel_value_free(mrb_state* mrb, void* ptr) {
  if(ptr) {
    ChannelValue* const channel_value = ptr;
    free(channel_value);
  }
}

static const struct mrb_data_type mrb_process_host_channel_value_type = {
  "mrb_process_host_channel_value", mrb_process_host_channel_value_free
};

static void
mrb_value_convert(mrb_state* mrb, mrb_value object, mrb_value value) {
  ChannelValueType type = Unknown;
  ChannelValueData data;

  switch(mrb_type(object)) {
    case MRB_TT_TRUE:
    case MRB_TT_FALSE:
      type = Boolean;
      data.boolean = mrb_bool(object);
      break;
    default:
      mrb_raisef(mrb, E_TYPE_ERROR, "Can't convert %S into binary data", mrb_inspect(mrb, object));
  }

  ChannelValue* const channel_value = channel_value_allocate(type, data, NULL);

  if(channel_value) {
    mrb_data_init(value, channel_value, &mrb_process_host_channel_value_type);
  }
}

mrb_value
mrb_process_host_channel_value_convert(mrb_state* mrb, mrb_value object) {
  mrb_value value = mrb_obj_value(mrb_obj_alloc(mrb, MRB_TT_DATA, mrb_process_host_channel_value_class(mrb)));

  mrb_value_convert(mrb, object, value);

  return value;
}

mrb_value
mrb_process_host_channel_value_restore(mrb_state* mrb, const ChannelValue* const channel_value) {
  __sync_add_and_fetch(&mrb_value_stats.bytes_transferred, channel_value_data_size(channel_value));

  switch(channel_value_type(channel_value->type)) {
    case Boolean:
      return mrb_bool_value(channel_value->data.boolean);
    default:
      mrb_raisef(mrb, E_TYPE_ERROR, "Can't convert from %s", channel_value_type_names[channel_value->type]);
  }
}

static mrb_value
mrb_value_initialize(mrb_state* mrb, mrb_value self) {
  mrb_value object;

  mrb_get_args(mrb, "o", &object);

  mrb_value_convert(mrb, object, self);

  return self;
};

static mrb_value
mrb_value_restore(mrb_state* mrb, mrb_value self) {
  const ChannelValue* const channel_value = DATA_PTR(self);

  return mrb_process_host_channel_value_restore(mrb, channel_value);
};

static mrb_value
mrb_value_raw(mrb_state* mrb, mrb_value self) {
  const ChannelValue* const channel_value = DATA_PTR(self);

  int mem_size = channel_value_size(channel_value);

  return mrb_str_new(mrb, (void*)channel_value, mem_size);
};

static mrb_value
mrb_value_size(mrb_state* mrb, mrb_value self) {
  const ChannelValue* const channel_value = DATA_PTR(self);

  int data_size = channel_value_data_size(channel_value);

  return mrb_fixnum_value(data_size);
};

static mrb_value
mrb_value_dump(mrb_state* mrb, mrb_value self) {
  mrb_value object;
  mrb_get_args(mrb, "o", &object);

  mrb_value value = mrb_obj_new(mrb, mrb_process_host_channel_value_class(mrb), 1, &object);

  const ChannelValue* const channel_value = DATA_PTR(value);
  int mem_size = channel_value_size(channel_value);

  return mrb_str_new(mrb, (void*)channel_value, mem_size);
};

static mrb_value
mrb_value_load(mrb_state* mrb, mrb_value self) {
  mrb_value binary_str;

  mrb_get_args(mrb, "S", &binary_str);

  return mrb_process_host_channel_value_restore(mrb, (void*)RSTRING_PTR(binary_str));
};

static mrb_value
mrb_value_bytes_transferred(mrb_state* mrb, mrb_value self) {
  return mrb_fixnum_value(mrb_value_stats.bytes_transferred);
}

void
mrb_process_host_channel_value_init(mrb_state* mrb) {
  struct RClass* value_class = mrb_define_class_under(mrb, mrb_process_host_channel_class(mrb), "Value", mrb->object_class);
  MRB_SET_INSTANCE_TT(value_class, MRB_TT_DATA);

  mrb_define_method(mrb, value_class, "initialize", mrb_value_initialize, MRB_ARGS_REQ(1));
  mrb_define_method(mrb, value_class, "restore", mrb_value_restore, MRB_ARGS_NONE());
  mrb_define_method(mrb, value_class, "raw", mrb_value_raw, MRB_ARGS_NONE());
  mrb_define_method(mrb, value_class, "size", mrb_value_size, MRB_ARGS_NONE());

  mrb_define_class_method(mrb, value_class, "dump", mrb_value_dump, MRB_ARGS_REQ(1));
  mrb_define_class_method(mrb, value_class, "load", mrb_value_load, MRB_ARGS_REQ(1));

  mrb_define_class_method(mrb, value_class, "bytes_transferred", mrb_value_bytes_transferred, MRB_ARGS_NONE());
}

void
mrb_process_host_channel_value_final(mrb_state* mrb) {
}
