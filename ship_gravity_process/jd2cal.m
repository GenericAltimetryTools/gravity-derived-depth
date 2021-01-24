function cal=jd2cal(J)
% 从儒略日计算公历年月日时分秒
% cal=jd2cal(J)
% 返回的cal是1x6矩阵，6列分别为年月日时分秒
%
% 公元1582年10月4日24:00点之前使用儒略历，公元1582年10月15日00:00点之后使用公历

if (J < 1721423.5)	% 公元1月1日0时
	BC = 1;
else
	BC = 0;
end

%start from Julian March 1, 4801 B.C.

if( J < 2299160.5 )	% before 1582.10.4. 24:00 is Julian calender
	j0=floor(J+0.5);
	dd=J+0.5-j0;
else	% after 1582.10.15. 00:00 is Gregorian calender
	%number of certury years that are not leap year
	n1=floor((J-2342031.5)/36524.25/4)+1;	%1700.3.1.0
	n2=floor((J-2378555.5)/36524.25/4)+1;	%1800.3.1.0
	n3=floor((J-2415079.5)/36524.25/4)+1;	%1900.3.1.0
	j0=n1+n2+n3+J+10;
	dd=j0+0.5-floor(j0+0.5);
	j0=floor(j0+0.5);
end

j0=j0+32083;
year0=ceil(j0/365.25)-1;
year=year0-4800;
day=j0-floor(year0*365.25);
month=floor((day-0.6)/30.6)+3;
day=day-round((month-3)*30.6);
if month>12
	month=month-12;
	year=year+1;
end

year=year-BC;

sec=round(dd*86400);

hour=floor(sec/3600);
sec=sec-hour*3600;
min=floor(sec/60);
sec=sec-min*60;
cal=[year, month, day, hour, min, sec];
