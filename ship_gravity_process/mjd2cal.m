function cal=mjd2cal(mjd)
% mjd2cal	将简化儒略日转换到公历年月日时分秒。
%  cal=mjd2cal(mjd)  返回的cal是1x6矩阵，6列分别为年月日时分秒
%  mjd：简化儒略日

jd=mjd+2400000.5;
cal=jd2cal(jd);
