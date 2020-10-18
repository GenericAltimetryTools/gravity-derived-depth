rem 
gmt gmtset FORMAT_GEO_MAP = ddd:mmF
gmt gmtset MAP_FRAME_WIDTH=2p
gmt gmtset FONT_ANNOT_PRIMARY 7p,Helvetica,black FONT_LABEL 8p,Helvetica,black 

set ps=3d3.ps
set R=-Rggm.grd
set R3=-R142.6/147.3/23/27/-8000/-20

gmt grd2cpt ggm.grd -Crainbow -E200>depth_plan.cpt
gmt grdgradient ggm.grd -A0 -Gt_intens.nc -Nt0.75 %R%

gmt grdview ggm.grd -It_intens.nc %R3% -JM5i -p170/80 -JZ5i -Cdepth_plan.cpt  -K -Y1.5i -Qs -B60m -N-8000+glightgray -BNESW > %ps%
gmt psscale %R% -JM5i -p -DjBC+o0.i/-0.8i+w3i/0.15i+e -Cdepth_plan.cpt -I -O -Bx2000 -By+lm  --FONT_LABEL=10p,Helvetica,black >> %ps%
gmt psconvert %ps% -A -P -Tg
del gmt.history