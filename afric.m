% This is an simple example for ocean bathy retrieving using GGM. The test
% area was selected over the Gulf of Guinea.
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

% The same as the Python AI
control=load('cont.txt'); % Input ocean depth data
check=load('chec.txt');
d=-8000;

%% Call the GGM function
result=GGM(free,control,check,d,range);
% Show the information of result
X = [' The mean difference between GGM and the truth is: ',num2str(mean(result.detaD)),' meter'];
disp(X)
X = [' The STD difference between GGM and the truth is: ',num2str(std(result.detaD)),' meter'];
disp(X)
X = [' The best rou is: ',num2str(result.rou)];
disp(X)

