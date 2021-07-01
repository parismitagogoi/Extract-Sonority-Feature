
function [index1 value1  dist pk_to_dp1 index2 value2 index3 value3 index2_3db index3_3db] = find_prominent_peak_v2 (x,th_peak,P)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%This function gives the values and indexes of promonent peaks%%%%%%%
% index1 = index of peaks
%value1=values of peaks
% pk_to_dp1 = peak to its preceeding dip ratio
% index2 = index of preceeding dips 
%index3=index of succeeding dips
%dist= distance between peaks
%Bandwidth=index3_3db-index2_3db 

%%%Inputs
%th_peak=threshold for peak value
%th_p2d=Threshold for peak to dip ratio
%P=No of peaks to be detected
%x=Spectrum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 


index1=[];
value1=[];

%%%%%%%%find peaks%%%%%%%%%%%%%%

%%%%%%%%%%%For peaks starting from zero%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if (x(1)>x(2) && x(2)>x(3) && x(1)>0.5)
    
index1=[1];
value1=[x(1)];   
    
end;    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(x)-2 
   if (x(i)<x(i+1) && x(i+1)>x(i+2) && x(i+1)>th_peak)
        
        index1=[index1 i+1];
        value1=[value1 x(i+1)];
  
    end;  
end;


%%%%%%%Adjust number of peaks%%%%%%%%%%%%%%%%%%%%%%%
if (length(index1)<P)
    
    difrn=P-length(index1);
    
    for k=1:difrn
        
        if(length(index1)==0)
         strt=0;
        else
          strt=index1(end); 
        end;
        
        
        next_ind=strt+200;
        if(next_ind>1000)
            
            next_ind=1000;
            
        end;
        index1=[index1 next_ind];
        value1=[value1 x(next_ind)];
        
        
    end;    
    
end


 [index2_3db index3_3db]=find_3db_points(index1,x);
%%%%%%%%%%%find  left side dip%%%%%%%%%%%%%%%%


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
    
        
    while index1(i)-1-j>0 & x(index1(i)-j)>x(index1(i)-j-1)  
        j=j+1;
    end
    dip_locs_l(i) =( index1(i)-j);
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
    

%%%%%%%%%%%find  right side dip%%%%%%%%%%%%%%%%
j=0;
dip_locs_r=[];
for i=1:length(index1)
        
    while index1(i)+1+j<length(x) & x(index1(i)+j)>x(index1(i)+1+j)   
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


%%%%%%%%peak to dip%%%%%%%%%%%%%%%%%%%%%%%
B = any(value2);
if(B==1)
    pk_to_dp1=value1./value2;
else
    pk_to_dp1=zeros(1,length(value1));
end;

%%%%%%%%%%%%distance between peaks%%%%%%%%%%%%%%%
dist=abs(diff(index1));
%%%%%%%%%%%Bandwidths%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% index1= index1(1:P);
% value1=value1(1:P);
% dist= dist(1:P-1); pk_to_dp1 = pk_to_dp1(1:P); index2= index2(1:P); value2=value2(1:P); index3 = index3(1:P);
% value3=value3(1:P); index2_3db=  index2_3db(1:P); index3_3db=index3_3db(1:P);



