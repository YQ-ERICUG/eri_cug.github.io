r  IU.YAK.00.BHZ.M.2011.070.054624.SAC
rmean
rtrend
taper
transfer from polezero subtype SACPZ.IU.YAK.00.BHZ to none freqlimits 0.001 0.002 40 50
rmean
rtrend
taper
w over
cut T0 T1
r  IU.YAK.00.BHZ.M.2011.070.054624.SAC
rmean
rtrend
taper
w append .cut
exit
