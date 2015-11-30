clc; %clear screen
clear all;% clearing all variables
close all;% closing all windows
hold all;% hold all the plots


% a = input('Enter width of map: '); %user entry comment
% b = input('Enter length of map: '); % length
% n = input('Enter number of other mobiles in the region: '); % mobiles


a=100;%comment by putting % sign
b=100;%do same
n=50;% do same


% userx = input('Enter your x co-ordinate: '); % This user entry point
% usery = input('Enter your y co-ordinate: '); % same as above for y uncomment

fprintf('channel idle for a long time jammer might be present \n');

subplot(2,2,1);

for i=1:1:n
    xco = rand(1,1);
    yco = rand(1,1);
    xcord(i) = ceil(xco*a);
    ycord(i) = ceil(yco*b);
    figure(1)
    plot(xcord(i),ycord(i),'*g');
    hold all;
end

xcordj = ceil(rand(1,1)*a);
ycordj = ceil(rand(1,1)*b);

figure(1)
plot(xcordj,ycordj,'or');

r=20;
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
figure(1)
plot(xcordj+xp,ycordj+yp,'r');
hold all

r=60;
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
figure(1)
plot(xcordj+xp,ycordj+yp,'b');
hold all

for i=1:1:120
    if((i)<=20)
        pdr(i)=0;
   
    elseif(i>60)
            pdr(i) = 100;
        else
            pdr(i) = (i-20)*100/40;
            end
end


for i = 1:1:n
    disty = ycord(i) - ycordj;
    distx = xcord(i) - xcordj;
    distance = disty^2 + distx^2;
    dist(i) = floor(sqrt(distance));
end

j=0;
k = 0;
for i=1:1:n
    if(dist(i)<=20)
        j=j+1;
        firstc(j) = i;
    end
    if(dist(i)<60&& dist(i)>=20)
        k=k+1;
        second(k) = i;
    end
end

if(j==0)
    fprintf('Signal strength analysis cannot be performed  as no node present in range of jammer');
else
figure(1)
plot(xcord(firstc(1)),ycord(firstc(1)),'ob');
hold all
figure(1)
plot(xcord(firstc(2)),ycord(firstc(2)),'ob');
hold all
title('Original map');

for i = 1:1:n
    disty1 = ycord(i) - ycord(firstc(1));
    distx1 = xcord(i) - xcord(firstc(1));
    distance1 = disty1^2 + distx1^2;
    dist1(i) = floor(sqrt(distance1));
end
for i = 1:1:n
   angy1 = ycord(i) - ycord(firstc(1));
   angx1 = xcord(i) - xcord(firstc(1));
   effangle1 = atan2d(angy1,angx1);
   theta1(i) = floor(mod(360+effangle1,360));
end


subplot(2,2,3)

figure(1)
plot(xcord(firstc(1)),ycord(firstc(1)),'*g');
hold all

Gt = 1;
Gr = 1;
l = rand(1,1)*0.1;
transfrequency = l+2.4;
lambda = 3*(10^8)/(transfrequency*(10^9));
Pt  = 0.02;
Pjam = 45;

    disty1 =  ycordj -  ycord(firstc(1)) ;
    distx1 =  xcordj - xcord(firstc(1)) ;
    distance = disty1^2 + distx1^2;
    distjam1 = floor(sqrt(distance));
    effangle1 = atan2d(disty1,distx1);
    jamtheta1 = floor(mod(360+effangle1,360));


for temptheta = 0:1:359
    Pr1(temptheta+1) = 0;
end

for temptheta = 0:1:359
    for i=1:1:n
        if(temptheta+1 == theta1(i))
            Pr1(temptheta+1) = Pr1(temptheta+1) +(Pt*Gt*Gr*((lambda*(10^6))/(4*pi*dist1(i)))^2);
        end
    end
    if((temptheta+1)==jamtheta1)
        Pr1(temptheta+1) = Pr1(temptheta+1) + (Pjam*Gt*Gr*(lambda*(10^6)/(4*pi*distjam1))^2);
    end
end
title('Estimated position after signal strength analysis');
subplot(2,2,2)
bar(Pr1);
hold all
title('Recieved power in every direction for first node');
abc  = (Pjam*Gt*Gr*(lambda*(10^6)/(4*pi*distjam1))^2);

for temp1 = 1:1:360
if(Pr1(temp1) == max(Pr1))
    fprintf('Jammer present at %d degrees according to signal strength analysis at node 1',temp1);
    if(temp1>180)
        temp1 = temp1 - 360;
    end
    m1 = (tan(temp1*pi/180));
end
end
b1 = ycord(firstc(1))- m1*(xcord(firstc(1)));
end

if(j>1)

for i = 1:1:n
    disty2 = ycord(i) - ycord(firstc(2));
    distx2 = xcord(i) - xcord(firstc(2));
    distance2 = disty2^2 + distx2^2;
    dist2(i) = floor(sqrt(distance1));
end
for i = 1:1:n
   angy2 = ycord(i) - ycord(firstc(2));
   angx2 = xcord(i) - xcord(firstc(2));
   effangle2 = atan2d(angy2,angx2);
   theta2(i) = floor(mod(360+effangle2,360));
end
subplot(2,2,3)   
figure(1)
plot(xcord(firstc(2)),ycord(firstc(2)),'*g');
hold all
    

disty2 =  ycordj - ycord(firstc(2)) ;
distx2 =  xcordj - xcord(firstc(2))   ;
distance = disty2^2 + distx2^2;
distjam2 = floor(sqrt(distance));
effangle2 = atan2d(disty2,distx2);
jamtheta2 = floor(mod(360+effangle2,360));



for temptheta = 0:1:359
    Pr2(temptheta+1) = 0;
end

for temptheta = 0:1:359
    for i=1:1:n
        if(temptheta+1 == theta2(i))
            Pr2(temptheta+1) = Pr2(temptheta+1) +(Pt*Gt*Gr*((lambda*(10^6))/(4*pi*dist2(i)))^2);
        end
    end
    if((temptheta+1)==jamtheta2)
        Pr2(temptheta+1) = Pr2(temptheta+1) + (Pjam*Gt*Gr*(lambda*(10^6)/(4*pi*distjam2))^2);
    end
end


abc  = (Pjam*Gt*Gr*(lambda*(10^6)/(4*pi*distjam2))^2);

for temp2 = 1:1:360
if(Pr2(temp2) == max(Pr2))
    fprintf('\n Jammer present at %d degrees according to signal strength analysis at node 2',temp2);
    if(temp2>180)
    temp2 = temp2-360;
    end
    m2 = (tan(temp2*pi/180));
end
end



b2 = ycord(firstc(2))- m2*(xcord(firstc(2)));

xintersect = (b2-b1)/(m1-m2);
yintersect = m1*xintersect + b1;

plot(xintersect,yintersect,'*r');
hold all

r=20;
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
figure(1)
plot(xintersect+xp,yintersect+yp,'r');
hold all

r=60;
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
figure(1)
plot(xintersect+xp,yintersect+yp,'b');
hold all


subplot(2,2,4)

bar(Pr2);
hold all
title('Recieved power in every direction for second node');

end

if(j==0 || j<2)
    fprintf('\n pdr analysis cannot be performed');
else 
      
figure(1)
subplot(2,2,1);
plot(xcord(second(1)),ycord(second(1)),'ob');
hold all


figure(1)
subplot(2,2,1);
plot(xcord(second(2)),ycord(second(2)),'ob');
hold all



for i=1:1:n
    figure(2)
    plot(xcord(i),ycord(i),'*g');
    hold all;
end
fprintf('\n pdr at node 1 is %f therefore distance from the jammer might be %d ',pdr(dist(second(1))),dist(second(1)));
fprintf('\n pdr at node 2 is %f therefore distance from the jammer might be %d ',pdr(dist(second(2))),dist(second(2)));
figure(2)
plot(xcord(second(1)),ycord(second(1)),'ob');
hold all


figure(2)
plot(xcord(second(2)),ycord(second(2)),'ob');
hold all 


r=20;
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
figure(2)
plot(xintersect+xp,yintersect+yp,'r');
hold all

r=dist(second(1))+0.5;
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
figure(2)
plot(xcord(second(1))+xp,ycord(second(1))+yp,'b');
hold all
    

radius = dist(second(2))+0.5;
ang=0:0.01:2*pi;
xp=radius*cos(ang)+0.5;
yp=radius*sin(ang)+0.5;
figure(2)
plot(xcord(second(2))+xp,ycord(second(2))+yp,'b');
hold all

[xout , yout] = circcirc(xcord(second(1)),ycord(second(1)),r,xcord(second(2)),ycord(second(2)),radius);

if(((xout(1)-xintersect)^2 + (yout(1)-yintersect)^2) <= ((xout(2)-xintersect)^2 + (yout(2)-yintersect)^2))
    
    xpdr = xout(1);
    ypdr = yout(1);
    
else
    xpdr = xout(2);
    ypdr = yout(2);
end
 
figure(2)
plot(xcordj,ycordj,'*r');
hold all 

figure(2)
plot(xpdr,ypdr,'*b');
hold all 

fprintf('\n original coordinates %f, %f',xcordj,ycordj);
fprintf('\n signal strength analysis %f, %f',xintersect,yintersect);
fprintf('\n pdr analysis %f,%f',xpdr,ypdr);
end












 
