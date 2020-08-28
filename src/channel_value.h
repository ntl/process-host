#ifndef PROCESS_HOST_CHANNEL_VALUE_H
#define PROCESS_HOST_CHANNEL_VALUE_H

#include <stdbool.h>

static const char* const channel_value_type_names[] = {
  "Unknown",
  "Boolean"
};

typedef enum {
  Unknown = 0,
  Boolean
} ChannelValueType;
#define channel_value_type(i) ((ChannelValueType)(i))

typedef union {
  bool boolean;
} ChannelValueData;

typedef struct {
  ChannelValueType type;
  ChannelValueData data;
  char mem[];
} ChannelValue;

ChannelValue* const channel_value_allocate(const ChannelValueType, const ChannelValueData, void*);
void channel_value_release(ChannelValue* const channel_value);

int channel_value_data_size(const ChannelValue* const);

static inline int channel_value_size(const ChannelValue* const channel_value) {
  int size = sizeof(ChannelValue);

  switch(channel_value_type(channel_value->type)) {
    case Boolean:
      return size;
    default:
      return -1;
  }
}

#endif /* PROCESS_HOST_CHANNEL_VALUE_H */
