oldpath = path;
path(oldpath,'C:\programs\gmt6exe\bin')

clc
clear

free=load('free.txt');
control=load('control.txt');
check=load('check.txt');
range='142.6/147.3/23/27';
%free.txt为重力异常数据
%control.txt为水深控制点
%check.txt为水深检核点

result=GGM(free,control,check,-8000,range)
