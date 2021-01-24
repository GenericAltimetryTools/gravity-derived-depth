%%
% Remove the drift of shipborne gravity using the EGM2008 model.
% This is coded by Cheinway Hwang in National Chiao Tung University, Hsinchu, Taiwan.
% Improved by YongKang Wang in 2018-2020 in FIO

%%
clc
path1='.\m77t\';
path2='.\xyz\';

total_f_g=[];
total_8_g=[];
total_f_g=[];

total_lat=[];
total_lon=[];
%%
w_aa=load('gravity_model.txt');%interplotation

filename=dir([path1,'*.m77t']);
for tt=1:length(filename)
  tt
  modified_line_gravity_name=strcat(filename(tt).name,'modified.txt')
  [a,zone,date,time,lat,lon,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]=...
      textread([path1,filename(tt).name],'%s %f %8f %4f %9.5f %10.5f %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s %d %s%s%s','headerlines',1);
  clear a g h i j k l m n o p q r s t u v w x y  z
  lat=roundn(lat,-5);
  lon=roundn(lon,-5);
  
  xyz=dlmread([path2,filename(tt).name(1:end-4),'xyz']);
  xyz(:,2)=roundn(xyz(:,2),-5);
  xyz(:,3)=roundn(xyz(:,3),-5);
  [ss1,ss2]=size(xyz);
  freeair=NaN(length(lat),1);
  for i=1:ss1
      ind=find(xyz(i,1)==lon &xyz(i,2)==lat);
      freeair( ind)=xyz(i,3);
  end
indnan=find(isnan( freeair));
lon(indnan)=[];
lat(indnan)=[];
zone(indnan)=[];
freeair(indnan)=[];
date( indnan)=[];
time(indnan)=[];
ymd=num2str(date);
year=str2num(ymd(:,1:4));
month=str2num(ymd(:,5:6));
day=str2num(ymd(:,7:8));
if isempty(find(zone~=0))
    Time=fix(time);
    hour=fix(Time/100);
    min=Time-hour*100;
else
    Time=fix(time);
    Time=Time-zone*100;
    hour=fix(Time/100);
    min=Time-hour*100;
end
sumall=[lon lat freeair year month day hour min zone];

F=sumall;
C=[0 0 0 0 0 0 0 0 0];
[len1,len2]=size(F);
for i=1:1:len1
    if ((F(i,1))>142.6) && ((F(i,1))<147.3)        %range
        if ((F(i,2))>23) && ((F(i,2))<27)
        C=[C;F(i,:)]  ;
        end
    end
        
end

%%
clear i 
sumall=C(2:end,:);
lon=sumall(:,1);
lat=sumall(:,2);
freeair=sumall(:,3);
year=sumall(:,4);
month =sumall(:,5);
day =sumall(:,6);
hour =sumall(:,7);
min=sumall(:,8);
zone=sumall(:,9);

gravityline=[lon lat freeair];
% filewrite('alldata',sumall)
% filewrite('gravityline',gravityline)

w_inter=griddata(w_aa(:,1),w_aa(:,2),w_aa(:,3),lon,lat,'linear');

d_gravity=w_inter-freeair;
gpstime_start=cal2gps(sumall(1,4:9));

for i=1:length(year)%calculate timeseries
   gpstime=cal2gps(sumall(i,4:9)); 
    gpssecond1(i)=(gpstime(1)-gpstime_start(1))*604800+gpstime(2)-gpstime_start(2);
end
gpssecond2=gpssecond1';
gpssecond=gpssecond2/3600/24;
leastmethod= polyfit(gpssecond,d_gravity,2);%拟合
leastmethod

fittinggravity=leastmethod(1)*gpssecond.^2+leastmethod(2)*gpssecond.^1   +leastmethod(3)+ freeair;
d_fitgravity=fittinggravity-w_inter;
figure(tt)
% plot(freeair,'r')
% hold on
if length(fittinggravity)>100
 plot(fittinggravity,'b')
 hold on
plot(w_inter,'k')
plot(freeair,'r')
legend('拟合后船测重力数据','EGM2008','原始船测重力数据')
xlabel('重力测点')
ylabel('mgal')

% disp('未拟合差：')
% std(w_inter-freeair)
% disp('拟合差:')
% std(d_fitgravity)

disp('拟合前与EGM2008平均误差：')
mean(-w_inter+freeair)
disp('拟合后与EGM2008平均误差：')
mean(-w_inter+fittinggravity)
% filewrite(modified_line_gravity_name,[gravityline fittinggravity])

total_f_g=[total_f_g;[gravityline fittinggravity]];
end
freeairtem=freeair;

clear lon lat freeair year month day hour min zone gpssecond gpssecond1 gpssecond2
end

%%
figure(100)
% filewrite('gravatiline.txt',total_f_g)

hist(fittinggravity-w_inter);
xlabel('重力异常差值（mgal）')
ylabel('个数')
legend('拟合后')
figure(101)
hist(freeairtem-w_inter)
xlabel('重力异常差值（mgal）')
ylabel('个数')
legend('拟合前')

