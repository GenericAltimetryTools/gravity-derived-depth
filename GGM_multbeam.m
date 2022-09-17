function [output]=GGM_multbeam(free,control,check,d,range)
%% usage:    GGM(free,control,check,-8000,'142.6/147.3/23/27')
%         free&control&check点位矩阵
%   d=-8000 为参考水深
%   rou=0.7
%   range='142.6/147.3/23/27' Test area

%% -------------------------------数据准备------------------------------------

order=['surface -R',range,' -I1m -Gfree.grd -T0.25 -C0.1'];
gmt(order,free); % generate gravity grid from free.txt file

% Combine all the single beam data as control.
control=gmt('select -Rfree.grd',control); % data in the same extent.
check=gmt('select -Rfree.grd',check); % data in the same extent.
control_all=[control.data; check.data];
latlon=[control.data(:,1:2); check.data(:,1:2)];

control_free=gmt('grdtrack -Gfree.grd ',control_all(:,1:2)); % GMT grdtrack select the gravity on the control points.

check_mb= csvread('mb1.csv');
%% 
%---------------------------求最合适密度差---------------------------------
%---------------------------Calculate the best density differenec---------
stdlist=[];
roulist=[];
xianguanlist=[];
for rou=0.5:0.1:5 % 在一个范围内寻找最合适密度差，可以修改范围. Set a initial searching extent and this can be changed according to your area.
    roulist=[roulist rou];

    control_short=(control_all(:,3)-d)*2*3.1415*6.67259*(10^-8)*rou*100000;

    control_long=control_free.data(:,3)-control_short;

    order=['surface -R',range,' -I1m -Glong.grd -T0.25 -C0.1 '];
    gmt(order,[latlon control_long]);

    gmt('grdmath free.grd long.grd SUB = short.grd')

    tem1=num2str(2*3.1415*6.67259*10^-8*rou*100000);
    order1=['grdmath short.grd ',tem1,' DIV ',num2str(d),' ADD = ggm.grd'];
    gmt(order1);

    ggm_depth=gmt('grdtrack -Gggm.grd -h',check_mb(:,1:2));
    stdinfo=std(ggm_depth.data(:,3)-check_mb(:,3));
    temcorr=corrcoef(ggm_depth.data(:,3),check_mb(:,3));
    xianguanlist=[xianguanlist temcorr(2)];
    stdlist=[stdlist stdinfo];
    
    X = [' The std of depth difference is: ',num2str(stdinfo)];
    disp(X)
end

%-----------------------GGM水深反演-----------------------------------------
%-----------------------GGM water depth retrieving-------------------------
[minstd,index]=min(stdlist);
suit_rou=roulist(index);
X = [' The suit rou is: ',num2str(suit_rou)];
disp(X)
%% 
control_short=(control_all(:,3)-d)*2*3.1415*6.67259*10^-8*suit_rou*100000;

control_long=control_free.data(:,3)-control_short;

order=['surface -R',range,' -I1m -Glong.grd -T0.25 -C0.1'];
gmt(order,[latlon control_long]);

gmt('grdmath free.grd long.grd SUB = short.grd')

tem1=num2str(2*3.1415*6.67259*10^-8*suit_rou*100000); % GGM.grd is the output ocean depth.
order1=['grdmath short.grd ',tem1,' DIV ',num2str(d),' ADD = ggm.grd']; % This step can be changed to AI.
gmt(order1);

ggm_depth=gmt('grdtrack -Gggm.grd -h',check_mb(:,1:2));
%% 结果 Result
output.stdinfo=minstd;%密度差 density difference
output.rou=suit_rou;%标准差 STD
output.d=d;%参考深度 reference depth
output.detaD=ggm_depth.data(:,3)-check_mb(:,3);%与检核点深度差值, bias
output.rou_std_list=[roulist' stdlist' xianguanlist'];%不同密度下相关系数和标准差，用来画图. For ploting

return