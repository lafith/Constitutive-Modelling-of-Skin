function [extension,load,width,thickness,t]=dataselect

q=string(input('Horizontal or vertical? h or v: ','s'));
if q=='h'
    width=[11.23 9.90 10.13 10.76 10.37 13.56 13.27];
    thickness=[2.01 3.55 3.05 3.63 3.55 3.38 3.61];
elseif q=='v'
    width=[10.11 9.80 10.71 11.24 10.35 11.16 10.68];
    thickness=[2.70 2.97 3.34 3.46 3.88 3.76 4.68];
else
    fprintf('wrong input');
    clear;
    clc;
end
p=string(input('which rate ? 5,10 or 20 :','s'));
if q=='h' && p=='5'
    data=["SH1-T5 RD" "S1H-T5M RD" "S2H-T5M RD" "S3H-TEST5 RD" "S4H-TEST5 RD" "S7H-TEST5 RD" "S8H-TEST5 RD"];
elseif q=='h' && p=='10'
    data=["SH1-T10 RD" "S1H-T10M RD" "S2H-T10M RD" "S3H-TEST10 RD" "S4H-TEST10 RD" "S7H-TEST10 RD" "S8H-TEST10"];
elseif q=='h' && p=='20'
    data=["SH1-T20 RD" "S1H-T20M RD" "S2H-T20M RD" "S3H-TEST20 RD" "S4H-TEST20 RD" "S7H-TEST20 RD" "S8H-TEST20 RD"];
elseif q=='v' && p=='5'
    data=["SV1-T5 RD" "S1V-T5M RD" "S2V-T5M RD" "S3V-TEST RD" "S4V-TEST5 RD" "S7V-TEST5 RD" "S8V-TEST5 RD"];
elseif q=='v' && p=='10'
    data=["SV1-T10 RD" "S1V-T10M RD" "S2V-T10M RD" "S3V-TEST10 RD" "S4V-TEST10 RD" "S7V-TEST10 RD" "S8V-TEST10 RD"];
elseif q=='v' && p=='20'
    data=["SV1-T20 RD" "S1V-T20M RD" "S2V-T20M RD" "S3V-TEST20 RD" "S4V-TEST20 RD" "STV-TEST20 RD" "S8V-TEST20 RD"];
else
    fprintf('error');
    clear;
    clc;
end

%for single sample
r=input('which sample? 1 to 7:');

[~,~,raw]=xlsread(data(r)+'.xlsx',1);
extension=cell2mat(raw(10:end,2));
load=cell2mat(raw(10:end,3));
width=width(r);
thickness=thickness(r);
t=data(r);
