function cal=gps2cal1(date,tow)
% gps2cal1	由公历日期和gps周内秒计算公历GPS时间
%  cal=gps2cal1(date,tow)  返回的公历是1x6矩阵，6列分别为年月日时分秒
%  date：1x3矩阵，3列分别为公历年月日
%  tow：GPS周内秒

mjd=cal2mjd(date);

% GPS从MJD44244开始
week=floor((mjd-44244)/7);
cal=gps2cal([week,tow]);
