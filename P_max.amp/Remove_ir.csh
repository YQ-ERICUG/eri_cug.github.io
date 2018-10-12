#!/bin/csh -f

####   mark the phase arrivals

@ nsacfile=0
foreach sacfile (*.SAC)
   @ nsacfile++

####   write the arrival times

   taup_setsac -mod prem -ph P-0,S-1,Pdiff-7,PcP-8,ScS-9 -evdpkm $sacfile

####   remove the instrument response

           echo "r  $sacfile" > sac.com
           echo 'rmean' >> sac.com
           echo 'rtrend' >> sac.com
           echo 'taper' >> sac.com
           set staname = `echo $sacfile | awk -F'.' '{print $2}'`
           set respfile = `ls SACPZ*$staname*BHZ`
#           echo $staname $respfile
           echo "transfer from polezero subtype $respfile to none freqlimits 0.001 0.002 40 50" >> sac.com
           echo 'rmean' >> sac.com
           echo 'rtrend' >> sac.com
           echo 'taper' >> sac.com
           echo 'w over' >> sac.com
####   calculate the maximum displacement
           echo 'cut T0 T1' >> sac.com     
           echo "r  $sacfile" >> sac.com 
           echo 'rmean' >> sac.com
           echo 'rtrend' >> sac.com
           echo 'taper' >> sac.com    
           echo "w append .cut" >> sac.com   
           echo 'exit' >> sac.com
           sac < sac.com


           set depmax = `saclst depmax f $sacfile.cut | awk '{printf "%g", $2}'`
           set gcarc  = `saclst gcarc f $sacfile.cut | awk '{printf "%g", $2}'`
           set depmin = `saclst depmin f $sacfile.cut | awk '{printf "%g", $2}'`
           set dismax = `echo $depmax $depmin | awk '{if ($1 > -$2) print $1; else print -$2}'` 
 
           if ($nsacfile == 1) then
             echo $sacfile.cut $gcarc $dismax $depmax  $depmin  > Max_disp_gcarc.txt
           else
             echo $sacfile.cut $gcarc $dismax $depmax  $depmin  >> Max_disp_gcarc.txt        
           endif  
           
end
 
