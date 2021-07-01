function [Sonority_feat] = src_supra_sys_evidnc_func_7dimension(s,fs)

   
s=preemphasize(s,0.5);
lporder=floor(fs/1000+4);


 
ressp1=LPres(s,fs,20,10,lporder,1);
ressp1=ressp1./(1.01*max(abs(ressp1)));
hensp1=HilbertEnv(ressp1,fs,1);
hensp1=hensp1./(max(abs(hensp1))); 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%Extract vocal-tract system features%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
[VTS_feat]=ztl_evidence_func_5dimension(s,fs);
 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%Refine epoch locations%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 ngdloc1=VTS_feat(:,6);
 ngdloc=ngdloc1;
 for l=1:length(ngdloc1)-1
strt=ngdloc1(l);
stpt=ngdloc1(l+1);    
    if (strt<1)
      strt=1;     
    end;
    
    if(stpt>length(s)) 
        stpt=length(s);
    end;
    [m ind]=max(hensp1(strt:stpt));
   ngdloc(l)=strt+ind-1;    
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%Extract source features%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

source2=[];
count2=0;
ms=1*10^-3*fs;
for i=1:length(ngdloc)
   strt=round(ngdloc(i)-1.5*ms);
    stpt=round(ngdloc(i)+1.5*ms);
    
    if(strt<1)
       source2(i)=0;
       continue
    end
    
    if(stpt>length(hensp1))
       source2(i)=0;
       continue
    end
       
   
   seg1=(hensp1(strt:stpt));
   seg=seg1./max(seg1);
   tmp=0;
%   if(seg(13)==1)
   
   tmp2=seg1(13)/mean(seg1(20:end)) ;
  % tmp2=mean(seg1)/std(seg1) ;
       
  %count2=count2+1;     
%   tmp2=seg(20:end);
%   tmp=sum(tmp2(find(tmp2>.11 & tmp2<.55 )))+.55-sum(tmp2(find(tmp2<.11)));
%  source2(i)=tmp;
%   else  
   source2(i)=tmp2;
%   end
end;


%%%%%%%%%%%%%%%%%%%%Extract suprasegmental features%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for p=1:length(ngdloc)
    
    strt=round(ngdloc(p)-1.5*10^-3*fs);
    stpt=round(ngdloc(p)+1.5*10^-3*fs);
    req_len=stpt-strt;
    if (strt<1)
       % continue
       strt=1;
       stpt=strt+req_len;
    end  
   if (stpt>=length(hensp1))
       % continue
       stpt=length(hensp1);
   end  
   array=abs(s(strt:stpt));
   All_arr2(:,p)=array;   
    
end;

%%%%%%%%%%%%%%%%%%%%Find correlation%%%%%%%%%%%%%%%%%%%%

fin_cor=zeros(1,length(ngdloc));
K=6;%ACR order
if K>=length(ngdloc)
    K=length(ngdloc)-1;
end;

for q=1:length(ngdloc)-K
        cor1=0;
        for l=1:K         
            x= All_arr2(:,q);
            y1=All_arr2(:,q+l-1);   
            norm_factor=sqrt(sum(x.^2)*sum(y1.^2));
            tmp=sum(x.*y1)./norm_factor;
            cor1=cor1+tmp;
        end;

fin_cor(q)=cor1;
end;
fin_cor(q+1:length(ngdloc))=cor1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Sonority_feat=[VTS_feat(:,1:5) fin_cor' source2' VTS_feat(:,6)];



