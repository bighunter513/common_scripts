#!/bin/bash

# how many days will tar expired
Days=3

function find_expired()
{
  echo "expired files are "
  Files=`find . -ctime +$Days | grep tar.bz2`
  echo $Files
  echo
}

function del_expired()
{
  find . -ctime +$Days | grep tar.bz2 | xargs rm 
}
del_expired

