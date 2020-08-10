function [output]=GGM(free,control,check,d,range)
%usage:    GGM(free,control,check,-8000,'142.6/147.3/23/27')
%         free&control&check点位矩阵
%d=-8000 为参考水深
%range='142.6/147.3/23/27' 为实验数据

%-------------------------------数据准备------------------------------------

order=['surface -R',range,' -I1m -Gfree.grd -T0.25 -C0.1 -Vl'];
gmt(order,free);

control_free=gmt('grdtrack -Gfree.grd -h',control(:,1:2));
%% 
%---------------------------求最合适密度差---------------------------------
stdlist=[];
roulist=[];
xianguanlist=[];
for rou=0.5:0.1:5%在一个范围内寻找最合适密度差，可以修改范围
roulist=[roulist rou];

control_short=(control(:,3)-d)*2*3.1415*6.67259*10^-8*rou*100000;

control_long=control_free.data(:,3)-control_short;

order=['surface -R',range,' -I1m -Glong.grd -T0.25 -C0.1 -Vl'];
gmt(order,[control(:,1:2) control_long]);

gmt('grdmath free.grd long.grd SUB = short.grd')

tem1=num2str(2*3.1415*6.67259*10^-8*rou*100000);
order1=['grdmath short.grd ',tem1,' DIV ',num2str(d),' ADD = ggm.grd'];
gmt(order1);

ggm_depth=gmt('grdtrack -Gggm.grd -h',check(:,1:2));
stdinfo=std(ggm_depth.data(:,3)-check(:,3));
temcorr=corrcoef(ggm_depth.data(:,3),check(:,3));
xianguanlist=[xianguanlist temcorr(2)];

stdlist=[stdlist stdinfo];
%-----------------------GGM水深反演---------------------------------------------------
[minstd,index]=min(stdlist);
suit_rou=roulist(index);
%% 
control_short=(control(:,3)-d)*2*3.1415*6.67259*10^-8*suit_rou*100000;

control_long=control_free.data(:,3)-control_short;

order=['surface -R',range,' -I1m -Glong.grd -T0.25 -C0.1 -Vl'];
gmt(order,[control(:,1:2) control_long]);

gmt('grdmath free.grd long.grd SUB = short.grd')

tem1=num2str(2*3.1415*6.67259*10^-8*suit_rou*100000);%求出GGM.grd 
order1=['grdmath short.grd ',tem1,' DIV ',num2str(d),' ADD = ggm.grd'];
gmt(order1);

ggm_depth=gmt('grdtrack -Gggm.grd -h',check(:,1:2));
%% 结果
output.stdinfo=minstd;%密度差
output.rou=suit_rou;%标准差
output.d=d;%参考深度
output.detaD=ggm_depth.data(:,3)-check(:,3);%与检核点深度差值
output.rou_std_list=[roulist' stdlist' xianguanlist'];%不同密度下相关系数和标准差，用来画图
end