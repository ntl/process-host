#ifndef PROCESS_HOST_MRB_PROCESS_HOST_H
#define PROCESS_HOST_MRB_PROCESS_HOST_H

static inline
struct RClass* mrb_process_host_class(mrb_state* mrb) {
  return mrb_class_get(mrb, "ProcessHost");
}

#endif /* PROCESS_HOST_MRB_PROCESS_HOST_H */
