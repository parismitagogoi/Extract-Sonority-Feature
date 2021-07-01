function [index2 index3]=find_3db_points(index1,x)
%%%%%%%%%%%find  left side 3db points%%%%%%%%%%%%%%%%
%Inputs
%index1=peak locations of the spectrum
%x=spectrum 
%index2=3dB point in the left side of the spectrum
%index3=3dB point in the right side of the spectrum
%BW=index3-index2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=0;
dip_locs_l=[];
dip_en_l=[];
q1=1;
    if(index1(1)==1)
    dip_locs_l=[dip_locs_l 0];
    dip_en_l=[dip_en_l 0];
    q1=2;
    end;

for i=q1:length(index1)
    
        
    while index1(i)-1-j>0 & x(index1(i)-j)>=0.707*x(index1(i))   
        j=j+1;
    end
    dip_locs_l(i)=( index1(i)-j);
    dip_en_l(i)=x(dip_locs_l(i));
    j=0;

end
TF = isempty(dip_locs_l);
 
if (TF==1)
    
    dip_locs_l=zeros(1,length( index1));
    dip_en_l=zeros(1,length( index1));
end

index2=dip_locs_l;
value2=dip_en_l;
    

%%%%%%%%%%%find  right side 3 db points%%%%%%%%%%%%%%%%
j=0;
dip_locs_r=[];
for i=1:length(index1)
        
    while index1(i)+1+j<length(x) & 0.707*x(index1(i))<=x(index1(i)+1+j)   
        j=j+1;
    end
    dip_locs_r(i) =( index1(i)+j);
    dip_en_r(i)=x(dip_locs_r(i));
    j=0;

end
TF = isempty(dip_locs_r);
if (TF==1)
    
    dip_locs_r=zeros(1,length( index1));
    dip_en_r=zeros(1,length( index1));
end

index3=dip_locs_r;
value3=dip_en_r;