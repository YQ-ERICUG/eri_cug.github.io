#!/bin/csh
gmtset ANNOT_FONT_PRIMARY Times-Roman
gmtset HEADER_FONT Times-Roman
gmtset LABEL_FONT Times-Roman
gmtset BASEMAP_TYPE     = plain
gmtset LABEL_FONT_SIZE 15p
gmtset PAPER_MEDIA A2

set psfile = Rspeed.ps
set energy_file = mkrup_sm_CBP.out_calibrated
set ptime = 115
set evlo = 119.84
set evla = -0.1781
set duration=100

###### (a) Rupture process
set REGION=119/122/-2/1
set SIZE=M15c
set AXIS=a1
set cptfile=color.cpt
### basemap
pscoast -R$REGION -J$SIZE -B$AXIS -SLIGHTCYAN -GBEIGE -Na -Dh -W0.02/150 -K -P > $psfile
pscoast -R -J -I1 -Lf119.5/-1.5/-2/50+ukm -Tf121.7/0.7/0.6i --HEADER_FONT_SIZE=10p --HEADER_OFFSET=0.05i -K -O >> $psfile
### insert map
pscoast -R100/140/-10/20 -JM5c -Na -Bewsn -Swhite -Ggray -K -O -Y11.1c >> $psfile
echo 119.86 -0.18 | psxy -Sa0.5c -Wblack -Gred -J -R -K -O >> $psfile
### make cpt
makecpt -Crainbow -T0/$duration/1 -N -Z > $cptfile
### rupture source
awk '{if($4-'$ptime' < '$duration' ) print $1,$2,$4-'$ptime',($3)^1.5}' $energy_file |  psxy -R$REGION -J$SIZE -Wblack -C$cptfile -Sc -K -O -Y-11.1c  >> $psfile
### focal mechanism
echo "119.86 -0.18 12 -0.48 0.76 -0.27 -1.45 -0.87 -2.19 27 119.86 -0.18" | psmeca -R -J -Sm0.4c/12p/2c/15c -Gred -T0 -O -K -P -N -C0.02c/150  >> $psfile
### colorbar
psscale -C$cptfile -B20::/:'Time/s': -D5i/2i/8.0c/0.3c -O -K >> $psfile

###### (b) Normalized amplitude with time
set range = 0/$duration/0/1
set size = 16c/5.0c
### basemap
psbasemap -JX$size -R$range -Ba20f5:"Time (s)":/a0.2f0.05:"Normalized Amplitude":SW -K -O -X20c -Y10c >> $psfile
### normalized amplitude
awk '{print $4-'$ptime',$3}' $energy_file | psxy -St0.3c -Gblue -Wblack -R -J -O -K  >> $psfile
### arrow
echo 57.7 0.4 -90 1.5 | psxy -R -J -Sv0.06c/0.3c/0.15c -Gred -K -O  >> $psfile
### legend
echo 75 0.9 | psxy -St0.3c -Gblue -Wblack -R -J -O -K  >> $psfile
echo 75 0.75 -90 0.5 | psxy -R -J -Sv0.025c/0.12c/0.07c -Gred -K -O  >> $psfile
pstext -J -R -K -O >> $psfile << EOF
80 0.9 12 0 7 ML Rupture source
80 0.7 12 0 7 ML Source duration
EOF


###### (c) Epicentral distance with time
set range = 0/$duration/0/150
set size = 16c/5.0c
### basemap
psbasemap -JX$size -R$range -Ba20f5:"Time (s)":/a50f10:"Epicentral distance (km)":SW -K -O -Y-10c >> $psfile
### rupture source
awk '{print $4-'$ptime',$5,($3)^2}' $energy_file | psxy -Wthinnest/gray -Sc -Gblack -R -J -O -K >> $psfile
### speed reference line
psxy -W0.5p,gray -R$range  -JX$size -O -K >> $psfile << EOF
0 0
100 100
<
0 0
100 200
<
0 0
100 400
EOF
pstext -R$range -Ggray20 -JX$size -O -K -N  >> $psfile << EOF
100 100 15 0 4 MC 1 km/s
75  150 15 0 4 MC 2 km/s
37  150 15 0 4 MC 4 km/s
EOF

####### Subplot number
pstext -JX10c/10c -R0/10/0/10 -K -O -N -X-20c  >>  $psfile << EOF
-1.5 16 15 0 7 MC (a)
18.5 16 15 0 7 MC (b)
18.5 6  15 0 7 MC (c) 
EOF

###### Convert pdf&png and remove margin
ps2pdf $psfile Rupture.pdf
pdfcrop --margin 10 Rupture.pdf Rupture_crop.pdf
gs Rupture_crop.pdf
convert Rupture_crop.pdf Rupture.png

