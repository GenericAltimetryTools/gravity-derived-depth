function gpst=cal2gps(cal)
% cal2gps	将公历GPS时间转换到GPS周和周内的秒。
%  gpst==cal2gps(cal)  返回的gpst是1x2矩阵，2列分别为GPS周和周内秒
%  cal：1x6矩阵，6列分别为年月日时分秒。构造cal时可以省略末尾的0

if length(cal) < 6
	cal(6)=0;
end
mjd=cal2mjd(cal);
% GPS从MJD44244开始
elapse=mjd-44244;
week=floor(elapse/7);
elapse=elapse-week*7;	% 周内天数
gpst=[week round(elapse*86400) elapse];
