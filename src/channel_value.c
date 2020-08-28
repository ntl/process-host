#include <stdlib.h>
#include <string.h>

#include "channel_value.h"

#include <stdio.h>
ChannelValue* const
channel_value_allocate(const ChannelValueType type, const ChannelValueData data, void* source_mem) {
  switch(type) {
    case Boolean:
      break;
    default:
      return NULL;
  }

  int malloc_size = sizeof(ChannelValue);

  ChannelValue* const channel_value = malloc(malloc_size);
  if(channel_value == NULL) return NULL;

  channel_value->type = type;
  channel_value->data = data;

  return channel_value;
}

void
channel_value_release(ChannelValue* const channel_value) {
  free(channel_value);
}

int
channel_value_data_size(const ChannelValue* const channel_value) {
  switch(channel_value_type(channel_value->type)) {
    case Boolean:
      return sizeof(channel_value->data.boolean);
    default:
      return -1;
  }
}
