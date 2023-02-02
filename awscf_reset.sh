#!/usr/bin/env bash

######################
swtr_ver="v1.3.8"
######################

pathF="$HOME/.aws"
aws_cfile="config"
bk_file="${aws_cfile}.bk"

RG1="region = ap-northeast-2"
RG2=""

mainfc()
{
$( cd ${pathF} && touch "${bk_file}" && cat /dev/null > ${bk_file} ) ;

cat ${aws_cfile} | while read line || [ -n "$line" ]; do
  if [[ $line == *"profile"* || $line == "[default]" ]]; then
    echo $line >> ${bk_file}
    echo "${RG1}" >> ${bk_file} 
  fi
done

stlist=( $(grep -oE '.*\]' ${aws_cfile} | xargs) ) ;
delete="profile" ; stlist=( "${stlist[@]/$delete}" ) ;
new_list=() ;

for i in "${stlist[@]}"; do
  i="${i//[\[\]]/}"
  if [[ $i == *" "* ]]; then
      i="${i##*}"
  fi
  # echo "$i"
  new_list+=("$i")
done

IFS=' ' read -ra new_arr <<< "${new_list[*]}" ;

for v in "${new_arr[@]}" ; do
  sed -i "/$v\]$/{G;/^\(\S*\s\).*\1/!P;h;d}" ${aws_cfile}
  sed -i "/$v\]$/{G;/^\(\S*\s\).*\1/!P;h;d}" ${bk_file}
done

mv ${aws_cfile} ${aws_cfile}.bk2 && mv ${bk_file} ${aws_cfile} ;

}

###### sub-main ####
mainfc && mainfc ;


