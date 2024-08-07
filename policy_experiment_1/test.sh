#!/bin/bash

if [ "$1" == "clean" ]; then
    rm allow/*
    rm deny/*
fi

for f in query*.n3; do
  # Pass one create a result
  eye --nope --quiet --query $f data.n3 > .tmp 2>&1

  # Pass two evaluate the result
  eye --nope --quiet --pass .tmp policy* > .tmp2 2>&1  

  if [ $? -eq 0 ]; then
    echo "allow $f"
    mv .tmp allow/$f
    mv .tmp2 allow/$f.reason
  else
    echo "deny $f"
    mv .tmp deny/$f
    mv .tmp2 deny/$f.reason
  fi
done