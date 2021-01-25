function filewrite(filename,filedata)
%filedata is the array of outputfile, filename is the file name 
%for example :
%filewrite('outputfile1',filedata)
%this function is aimed to save a array to a file.txt



file=strcat(filename);%

fid = fopen(file,'wt');%OUtput file
[len1,len2]=size(filedata);
for i=1:1:len1
for j=1:1:len2

    if j==len2
         fprintf(fid,'%1.6f\n',filedata(i,j)); 
    else
         fprintf(fid,'%1.6f\t',filedata(i,j)); 
    end
end
end
fclose(fid);



