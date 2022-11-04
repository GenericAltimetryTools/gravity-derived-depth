% This is an simple example for ocean bathy retrieving using GGM. The test
% area was selected over the Mariana Trench where has the deepest point of
% the ocean. 
% Test enviroment: GMT 6.1.1, Matlab R2018b, Windows10
% Author: Wang Yongkang
% Editor: Lei Yang

%% Set GMT path. 
oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin'); % should change it to your path.

clc
clear

%% Set loading files
% gmt grdcut -R-15/5/-4/4 Free_Air_Gravity_Anomalies.nc -Gsubset.nc
range='-15/5/-4/4'; % ocean area
order=['grd2xyz guinea.nc '];
free0=gmt(order);
free=free0.data;

% control=load('guinea.txt'); % Input ocean depth data
% index=randperm(length(control));
% temp=fix(length(control)*0.2);
% check=control(index(1:temp),:);
% temp=fix(length(control)*0.8);
% control=control(index(1:temp),:);

% The same as the Python AI
control=load('cont.txt'); % Input ocean depth data
check=load('chec.txt');
d=-8000;

%% Call the GGM function
% 这里有两个GGM程序，GGM()使用单波束数据作为控制和检核，GGM_multbeam()使用单波束作为控制，多波束作为检核。
result=GGM(free,control,check,d,range);
% result=GGM_multbeam(free,control,check,d,range);

% Show the information of result
X = [' The mean difference between GGM and the truth is: ',num2str(mean(result.detaD)),' meter'];
disp(X)
X = [' The STD difference between GGM and the truth is: ',num2str(std(result.detaD)),' meter'];
disp(X)
X = [' The best rou is: ',num2str(result.rou)];
disp(X)



% Remove outliers by 3 sigma
u=mean(result.detaD);
s=std(result.detaD);
big=u+3*s;
small=u-3*s;
d_d=result.detaD;
[n]=find(d_d>big);
d_d(n)=NaN;
[n]=find(d_d<small);
d_d(n)=NaN;

d_d(any(isnan(d_d),2),:)=[];
figure ('name','d')
plot(d_d)
figure ('name','his')
nbins = 100; h = histogram(d_d,nbins);%与hist相同

X = [' The STD difference between GGM and the truth is: ',num2str(std(d_d)),' meter'];
disp(X)

% save result.mat result 
% delete free.grd
% delete long.grd
% delete short.grd
% delete ggm.grd
