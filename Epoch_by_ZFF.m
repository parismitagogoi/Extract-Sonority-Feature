function [zfr_sig,epoch_loc,epoch_interval] = Epoch_by_ZFF(speech,Fs);

s=speech;
L=length(s);


ak = [1, -2, 1];  % zero freq resonator 

y1 = filter(1,ak,s);    %ZFR output

y2 = filter(1,ak,y1);%final ZFR output

s=s';



%%%%%%%%%%%%%%% DETECTION OF AVERAGE PITCH PERIOD BEGINS %%%%%%%%%%%%%%

%To decide window length over which trend has to be removed
%To find average pitch period
W=floor(0.03*Fs); %30ms window for autocorrelation
strt=floor(0.032*Fs);          % looking for peak from 2ms to 15 ms
stpt=floor(0.045*Fs);       % looking for peak from 2ms to 15 ms
no_samples_one_ms=floor(0.001*Fs);
%%%%%% added recently
sp_mat=enframe(s,hamming(W),floor(W/2));%window shift is half of the window length; 
%enframe : splits the signal into frames with each column a frame
sp_mat=sp_mat';
ham_win=xcorr(hamming(W),'coeff');%find autocorrelation of hamming window
%%%%%%%%%%%%%%%%%%%%
for j=1:size(sp_mat,2) %size(sp_mat,2) : no. of frames
    %Rx(:,j)=xcorr(sp_mat(:,j),'coeff');
    Rx(:,j)=xcorr(sp_mat(:,j),'coeff')./ham_win;%autocorrelation of each frame
    [maxval indm]=max(Rx(strt:stpt,j));
    ind(j)=indm+2*no_samples_one_ms; % changed as indm starts from 2msec                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j=1:14
    xax(j)=(j+1)*no_samples_one_ms;      %no. of samples in 2,3,4....15 msec
end
                                                                                                       
[pp,fr]=hist(ind,xax);       %histogram of pitch information of 30ms windows
[m_pitch,m_pitch_ind]=max(pp);           % to get the index of maximum

%hist(ind,xax);



N=floor(1.5*fr(m_pitch_ind)/2); %working fine for speech

pitch_avg=fr(m_pitch_ind)*1000/Fs; %average pitch period in ms

%%%%%%%%%%%%%%%%%%%% DETECTION OF AVERAGE PITCH PERIOD ENDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%% TREND REMOVAL %%%%%%%%%%%%%%%%%%%%


% for speech signal of duration of few seconds trend removal has to be done 3 times
% i.e, subtraction of local mean
y22 = [zeros(N,1);y2;zeros(N,1)];% y2 is the final filtered output
zfr_sig1 =  zeros(length(y22),1);
for j = 1:3
    fltavg = ones(2*N+1,1)/(2*N+1); %(2*N+1):frame length corresponding to avg pitch period
    yavg = conv(y22,fltavg,'same');%computing average for each pitch period
    zfr_sig1(1+N:length(y22)-N) = y22(1+N:length(y22)-N)-yavg(N+1:length(yavg)-N);%subtracting mean from the signal
    y22 = zfr_sig1;
    
end

 %subplot(2,1,2);
 %plot(y22(1:(length(y22)-300)));% y22 contains the ZFFS
 %title('ZFFS signal');

%%%%%%%%%%%%%%%%%%%%% Get the epoch locations %%%%%%%%%%%%%%%%%%%%%%

zff_gci1=[];
zc_ind=[];
epoch_loc=[];

zfr_sig = y22(N+1:length(y22)-N); %length of zfr_sig is made equal to the original speech



zff_gci1=cat(1,0,diff(sign(zfr_sig))/2);% find difference of sign of each element
zc_ind=find(zff_gci1>0);%find positive zero crossings
max(zc_ind);
zff_gci=zeros(L,1);
zff_gci(zc_ind)=1; %%Final output containing array of zeros and ones with ones representing epoch positions
epoch_loc=[1;zc_ind;length(s)];%%%%%%%%%contains the index of epoch locations
max(epoch_loc);
epoch_interval=diff(epoch_loc);


%ha(2)=subplot(2,1,2);
%plot(zfr_sig(1:77300));
