function cal=gps2cal(gpst)
% gps2cal	将GPS周和周内的秒转换到公历GPS时间
%  cal=gps2cal(week,sec)  返回的公历是1x6矩阵，6列分别为年月日时分秒
%  gpst：1x2矩阵，2列分别为GPS周和周内的秒

% GPS从MJD44244开始
mjd=44244+(gpst(1)*86400*7+gpst(2))/86400;
cal=mjd2cal(mjd);
