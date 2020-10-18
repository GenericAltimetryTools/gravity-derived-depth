rem Leiyang, FIO, leiyang@fio.org.cn

gmt gmtset FORMAT_GEO_MAP = ddd.xxxxF
gmt gmtset MAP_FRAME_WIDTH=2p
gmt gmtset FONT_ANNOT_PRIMARY 7p,Helvetica,black FONT_LABEL 7p,Helvetica,black 

grdinfo ggm.grd
gmt grd2cpt ggm.grd -Crainbow -E200>depth_plan.cpt
gmt grdimage ggm.grd -JM5.5i -I+a45+nt1 -Cdepth_plan.cpt  -K -P -Y5 -Q -Rggm.grd > depth_plan.ps
gmt grdcontour ggm.grd -J -C200 -A800+f7p -L-6000/-2000 -Gd2i -O -K -S4 -Wa0.3p, -R>> depth_plan.ps
gmt pscoast -R -J -O -Df+ -Gyellow -W0.5p -Baf -BnWSe -K >>depth_plan.ps
gmt psbasemap -R -J -O -LjLT+c27.8414S+f+w1000e+u+o0.1i --FONT_ANNOT_PRIMARY=9p --FONT_LABEL=7p -K>>depth_plan.ps
gmt psscale -DjBC+o0c/-2.2c+w3.8i/0.08ih -R -J -Cdepth_plan.cpt -Bx2000f -By+lm -I -O -F+gwhite+p1p --FONT_ANNOT_PRIMARY=7p >> depth_plan.ps

gmt psconvert depth_plan.ps -A -P -Tg
del gmt.history
