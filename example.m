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
free=load('free.txt'); % Gravity Anamony data.
control=load('control.txt'); % Input ocean depth data
check=load('check.txt'); % checking data of depth
range='142.6/147.3/23/27'; % ocean area
d=-8000;
%% Call the GGM function
% result=GGM(free,control,check,d,range);
result=GGM_multbeam(free,control,check,d,range);

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
nbins = 100; h = histogram(d_d,nbins);%ÓëhistÏàÍ¬

X = [' The STD difference between GGM and the truth is: ',num2str(std(d_d)),' meter'];
disp(X)

delete free.grd
delete long.grd
