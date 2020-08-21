#!/bin/sh

set -eu

if [ ${MRUBY:-on} = 'on' ]; then
  if [ ${RECOMPILE:-yes} = 'yes' ]; then
    export MRUBY_GEM_PATH=$(dirname $(realpath $0))

    echo "MRUBY_ROOT: ${MRUBY_ROOT:-(not set)}"
    echo "MRUBY_GEM_PATH: $MRUBY_GEM_PATH"
    echo

    pushd $MRUBY_ROOT

    rm -vf ./bin/*

    rake -m -j ${MRUBY_COMPILE_JOBS:-1}

    popd

    mkdir -p ./gems/bin
    cp -v $MRUBY_ROOT/bin/* ./gems/bin
  fi

  ./gems/bin/bench-mruby $@
fi

if [ ${RUBY:-off} = 'on' ]; then
  ./gems/script/bench $@
fi
