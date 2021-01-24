function mjd=cal2mjd(cal)
% cal2mjd	将公历年月日时分秒转换到简化儒略日。
%  mjd=cal2mjd(cal)  返回简化儒略日
%  cal：1x6矩阵，6列分别为年月日时分秒。构造cal时可以省略末尾的0

jd = cal2jd(cal);
mjd = jd - 2400000.5;
