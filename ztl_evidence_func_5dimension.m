function [VTS_feat]=ztl_evidence_func_5dimension(x,fs)

nfft = 2^11;
lporder=floor(fs/1000+4);

All_hngd=[];
All_mean=[];
All_1st_dim=[];
All_pk_2val=[];

%addpath('/home/nus/PHDWorkspace/All_evidences');
ressp1=LPres(x,fs,20,10,lporder,1);
ressp1=ressp1./(1.01*max(abs(ressp1)));
hensp1=HilbertEnv(ressp1,fs,1);
hensp1=hensp1./(max(abs(hensp1)));
%Find epoch locations
[zfr_sig,epochlocs1,epoch_interval]=Epoch_by_ZFF(x,fs);
%Correct epoch locations
for k=1:length(epochlocs1)-1
strt=epochlocs1(k);
stpt=epochlocs1(k+1);
    if (strt<1)
      strt=1;
        
    end;
    
    if(stpt>length(x)) 
        stpt=length(x);
    end;
    [m ind]=max(hensp1(strt:stpt)); 
    epochlocs(k)=strt+ind-1;
    
end;
epochlocs(k+1)=epochlocs1(k+1);
VTS_feat=[];
Arr=zeros(1,6);
%%
for i=1:length(epochlocs)-1

    
    strt=round(epochlocs(i));
    stpt=round(epochlocs(i)+5*10^-3*fs);
    
    if (strt<=0)
        strt=1;
    end;
    
    if (stpt>epochlocs(end))
        stpt=epochlocs(end);
    end;
    
    nwin=stpt-strt; 
    if (nwin<5*10^-3*fs-1)
     VTS_feat=[VTS_feat; Arr];
    continue
    end
    temp=x(strt:stpt);
  %   temp= temp./(sqrt(temp.*temp)); %%%energy normalized
    
[hngd,f,dngd,ngd,mag,hgd,dgd,gd,w] =ztl(temp,fs,nfft,nwin,0);   
clear indx2;clear pks2;clear dist;clear pk_to_dp1;clear dip_indx;clear dip_val;  
[index1 value1  dist pk_to_dp1 index2 value2 index3 value3 index2_3db index3_3db] = find_prominent_peak_v2 (hngd,0,1);

P=3;

if(P>length(index1))
    continue
end;

%[indx3 pks3 dipl_locs dipr_locs dipl_en dipr_en] = find_peak_array (hngd,0,1,P);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bw=index3_3db(1:P)-index2_3db(1:P);

 indx3=index1(1:P);%%%peak locations
 pks3=value1(1:P);%peak values
 dist3=dist(1:P-1);%distance between peaks
 diff_val=abs(diff(pks3));%%%difference between peak values
 dip_indx3=index2(1:P);%dip locations
 dip_val3=value2(1:P);%dip values
 p2d=pk_to_dp1(1:P);%peak to dip ratios
 slope=(pks3-dip_val3)./(indx3-dip_indx3);%slope of the peaks
 
 clear Arr
Arr=[mean(pks3) mean((diff_val))  mean(dip_val3) mean(slope) mean(bw) epochlocs(i)];
VTS_feat=[VTS_feat; Arr];

end;
%  
