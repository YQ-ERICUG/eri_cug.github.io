#!/bin/csh -f


###  set parameters

set line = `awk '{if (NR == 2) print $0}' query.csv`
set eqla = `echo "${line}" | awk -F',' '{print $2}'` 
set eqlo = `echo "${line}" | awk -F',' '{print $3}'`
set dep = `echo "${line}" | awk -F'[,]' '{printf "%.2f", $4}'` 
set ftmp = `echo "${line}" | awk -F'T|Z' '{print $1,$2}'`       
set origin_time = `date +%s -d "${ftmp}"` 
set hhmmss = ` echo "${line}" | awk -F'T|Z' '{print $2}'`
set year = `date +%Y -d "${ftmp}"`
set origin_julian = `date +%j -d "${ftmp}"`
set start_time = `echo "${line}" | awk -F'[Z]' '{print $1}'` 

@ tmp = 30 * 60                 # plus 30 min
@ end_time_s = $origin_time + $tmp

set end_time = `date +%Y-%m-%d"T"%H:%M:00 -d "1970-01-01 UTC $end_time_s seconds"`
set evt_name = `echo "${line}" | awk -F'T|,|:' '{OFS = "_";print $1,$2,$3 }'`M`echo "${line}" | awk -F'[,]' '{printf "%3.1f", $5}'`H`echo "${line}" | awk -F'[,]' '{printf "%.0f", $4}'`

echo $eqla $eqlo
echo $ftmp
echo $start_time 
echo $end_time
echo $evt_name
echo $origin_julian $year


### download data

set max_d = 95
set min_d = 10

perl FetchData-2017.164 --net _GSN -L 00 --chan BHZ  -s $start_time -e $end_time -o $evt_name.mseed -m $evt_name.metadata -sd . --radius "$eqla":"$eqlo":"$max_d":"$min_d"
