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

%% Call the GGM function
result=GGM(free,control,check,-8000,range);
