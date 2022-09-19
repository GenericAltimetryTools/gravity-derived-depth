% 检核数据稀疏和GGM的效果关系

%% Set GMT path. 
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % should change it to your path.

clc
clear

%% Set loading files
range='142.6/147.3/23/27'; % ocean area
d=-8000;
suit_rou=1;
free=load('free.txt'); % Gravity Anamony data.
order=['surface -R',range,' -I1m -Gfree.grd -T0.25 -C0.1 -Vl'];
gmt(order,free); % generate gravity grid from free.txt file

stdlist=[];
xianguanlist=[];
%%
for i=1:99
    i
    control=load('control.txt'); % Input ocean depth data
%     check=load('check.txt'); % checking data of depth
    check= csvread('mb1.csv');
    index=1:i:length(control);
    control=control(index,:);
%     index=1:i:length(check);
%     check=check(index,:);    
    
    control=gmt('select -Rfree.grd',control); % data in the same extent.

    control_free=gmt('grdtrack -Gfree.grd ',control.data(:,1:2));

    control_short=(control.data(:,3)-d)*2*3.1415*6.67259*10^-8*suit_rou*100000;

    control_long=control_free.data(:,3)-control_short;

    order=['surface -R',range,' -I1m -Glong.grd -T0.25 -C0.1'];
    gmt(order,[control.data(:,1:2) control_long]);

    gmt('grdmath free.grd long.grd SUB = short.grd')

    tem1=num2str(2*3.1415*6.67259*10^-8*suit_rou*100000); % GGM.grd is the output ocean depth.
    order1=['grdmath short.grd ',tem1,' DIV ',num2str(d),' ADD = ggm.grd']; % This step can be changed to AI.
    gmt(order1);

    ggm_depth=gmt('grdtrack -Gggm.grd -h',check(:,1:2));
    detaD=ggm_depth.data(:,3)-check(:,3);%与检核点深度差值, bias
    stdinfo=std(detaD);
    temcorr=corrcoef(ggm_depth.data(:,3),check(:,3));
    stdlist=[stdlist stdinfo];
    xianguanlist=[xianguanlist temcorr(2)];
end
index=1:99;
control=load('control.txt');
x_ind=length(control)./index;

loglog(x_ind,stdlist)
set(gca,'XDir','reverse'); 
xlabel("number of points")
ylabel("std of depth difference")

