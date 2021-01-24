function jd=cal2jd(cal)
% cal2jd1	将公历年月日时分秒转换到儒略日。
%  jd=cal2jd(cal)  返回儒略日
%  cal：1x6矩阵，6列分别为年月日时分秒。构造cal时可以省略末尾的0
%
% 公元1582年10月4日24:00点之前使用儒略历，公元1582年10月15日00:00点之后使用公历

if length(cal) < 6
	cal(6)=0;
end
year=cal(1);
month=cal(2);
day=cal(3)+(cal(4)*3600+cal(5)*60+cal(6))/86400;

y = year + 4800; %4801 B.C. is a century year and also a leap year.  

if( year < 0 )
	y =y+ 1; 	% Please note that there is no year 0 A.D.
end

m=month;
if( m <= 2 )	% January and February come after December.
	m = m+12; 
	y = y - 1;
end

e=floor(30.6 * (m+1));

a=floor(y/100);	% number of centuries

% 教皇格雷戈里十三世于1582年2月24日以教皇训令颁布，将1582年10月5日至14抹掉。1582年10月4日过完后第二天是10月15日
if( year <1582 )|(year==1582&month<10)|(year==1582& month==10 &day<15)
	b = -38;
else
	b = floor((a/4) - a); % number of century years that are not leap years
end

c=floor(365.25* y); % Julian calendar years and leap years 

jd= b + c + e + day - 32167.5;
