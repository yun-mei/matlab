HW = input('Enter the the 6 HW assignments grades (in a vector):');
Q = input('Enter the the 6 quiz grades (in a vector): '); 
Mid = input('Enter the the 2 midterm grades (in a vector): ');
P = input('Enter the project grade: ');
F = input('Enter the final exam grade: ');

PandFavg=(P+F)/(2*100); 
sumHW= sum(HW);sumQ=sum(Q);sumMid=sum(Mid);
HWavg = (sumHW - HW(1)) / (5*50); 
Qavg= (sumQ - Q(1)) / (5*10); 
MidTavg = sumMid/(2*100); 

if MidTavg>PandFavg 
Grade = (HWavg*0.2+(Qavg*0.1)+MidTavg*0.4+(PandFavg*0.3))*100;
elseif MifTavg<=PandFavg 
Grade = (HWavg*0.2+(Qavg*0.1)+MidTavg*0.3+(PandFavg*0.4))*100;
end

if Grade >=90
    gradeletter = 'A';
elseif (80 <= Grade <90)
    gradeletter = 'B';
elseif (70 <= Grade <80)
    gradeletter = 'C';
elseif (60 <= Grade <70)
    gradeletter = 'D' ; 
else    
    gradeletter = 'E';
end

fprintf ('The overall course score is %2.1f for a letter grade of %s\t \n',Grade,gradeletter)
