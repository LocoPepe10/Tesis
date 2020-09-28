clear all
close all
global my_plot;

calculate=1;0;1;0;1;
opt=3; % 0: use original data; 1: simulate data using ari; 2: original data with stmcb 3: use all aris
show_plot=1;0;
outfile='temp';

pos1=[10 500 600 400];
pos2=[10 10 600 400];
pos3=[610 500 600 400];
pos4=[610 10 600 400];

hc_t_lims=[50,-50]; % amount of time to cut at start and end of hypercapnia recordings. 

max_bad_data=3;2; % maximum range of nans
good_data_length=70;
step_size=10;
fc_hi=0.03;
filter_order=2;
dec_factor=5;
T_tiecks=10;
CrCP=0;
fs_dec=2;
f_phi=1/12;0.12;
Nfft=256; %100
mean_f=0.10;
std_f=0.06;
T_pulse=60;
T_spec=20;
ar_order=15;
ari1=5;
ari2=4;
aris=[0:9];
Np=20;
alpha=0.05;
param.T_FIR=15;
param.Ma=1;
param.Mb=5;
param.orig_x=0;
param.model=1; %0: use FIR filter to find residual; 1: use best Tiecks filter
param.ar_order=ar_order;
plot_param.linewidths=[5,2];
if any(opt==[0,2]);
    ari1=nan;
    ari2=nan;
end

xls_file='dir_file_Leicester_NC_HC1.xls';
nc_dir='C:\local\Data\EPSRC\leicester_mat_files\1_baseline\';
hc_dir='C:\local\Data\EPSRC\leicester_mat_files\6_constant_co2_no_thigh_cuffs\';


[dummy,xls_text]=xlsread([xls_file]);%xlsread([dir_name,xls_file]);

mat_files=xls_text(:,1:end);

% channel names - from SQWAB data information.xls

% fs=100;
%
% mat_files=dir([dir_name,'*.mat']);

% load sqwab_info
% channel_names={{'vr','vl','pc','pa','nothing','etco2','pf'};{'vr','vl','pc','pa','nothing','etco2','pf'}; ...
%    {'vr','vl','pc','pa','nothing','nothing','etco2','pf'};{'nothing','vl','pc','pa','nothing','nothing','etco2','nothing'}; ...
%    {}};
%
% save sqwab_info dir_name mat_files channel_names fs

%good_p='pf';


% proc_segments=['W'];['Q','W','K','L']; % Q: baseline, W: baseline with mask; K: SQWAB low, L: SQWAB high
% seg_colours=['r','g','b','m'];
% col=['r','g','b','y','c','m','k','r','g','b','y','c','m','k'];
% page_length=10;
% fs=100;
%
% fs=100;
% [b,a]=butter(filter_order,fc_hi/fs*2,'high');
%     freqz(b,a,10000,fs);
% dec_factor=round(fs/fs_dec);
% fs_dec=fs/dec_factor;
% fir_length=param.T_FIR*fs_dec+1;


if calculate
    %     for ari=0:9
    %         [b_tiecks(ari+1,:),a_tiecks(ari+1,:)]=tiecks_ab1(ari,CrCP,fs);
    %     end
    for prot_index=1:size(mat_files, 2)
        for file_index=1:size(mat_files, 1)
            window_counter=1;
            
            
            % file_name=cell2mat(mat_files(file_index+1));
            %         good_v=xls_text(13,file_index+1);
            %         good_p=xls_text(14,file_index+1);
            % load([dir_name,file_name]);
            % N=length(data);
            % no_channels=size(data,2);
            %
            % i=[1:N];
            %
            % [b,a]=butter(filter_order,lp_cut/fs*2);
            % chan=1;
            
            % find the appropriate data segment
            file_name=mat_files{file_index,prot_index};%cell2mat(xls_text(16,file_index+1));
            disp(['Processing file: ',file_name]);
            % file_name=['processed_',file_name];
            if prot_index>2
                data_dir=hc_dir;
            else
                data_dir=nc_dir;
            end
            
            load([data_dir,file_name]);
            
            p_nan=bp;
            v_nan=v1;
            i=1:length(p_nan);
            t=(i-1)/fs;
            data_range=[min(t),max(t)];
            if prot_index>2
                data_range=data_range+hc_t_lims;
            end;
            
            if show_plot
                figure('Position',pos4);
                plot(t,bp,t,v1,t,v2);
                place_marker(data_range,'c',':',1);
            end;
            i=find(t >=min(data_range) & t<=max(data_range));
            p_mean=mean(p_nan(i));
            v_mean=mean(v_nan(i));
            v=v_nan(i)/v_mean*100-100;
            p=p_nan(i)/p_mean*100-100;
            v1=v_nan(i)/v_mean*100-100;
            p1=p_nan(i)/p_mean*100-100;
            ti=t(i);
            % seg_times_sel(file_index,seg*2-1:2*seg)=[min(ti),max(ti)];
            
            %         n=find_str_in_cell(processed_sig.variable_names,'co2');
            %         if isempty(n)
            %             n=find_str_in_cell(processed_sig.variable_names,'etco2');
            %             disp('Only etco2 recorded');
            %         end
            %         co2=processed_sig.signals(n,:);
            
            %         n=find_str_in_cell(processed_sig.variable_names,'pa');
            %         pa=processed_sig.signals(n,:);
            %
            %         figure
            %         plot(ti,p,ti,p_nan(i),'b',ti,v,ti,v_nan(i),'b');
            %         title([file_name,' Marker: ',proc_segment]);
            %         %plot(ti,p0(i),ti,p,ti,v0(i),ti,v);
            %         figure
            %         plot(ti,co2,ti,pa);
            
            %         stds_v(file_index,seg)=std(v);
            %         stds_p(file_index,seg)=std(p);
            for ari=0:9
                [b_tiecks(ari+1,:),a_tiecks(ari+1,:)]=tiecks_ab1(ari,CrCP,fs);
            end
            
            [ari,nrmse,gain]=est_ari(p,v,b_tiecks,a_tiecks,fs);
            ari_(window_counter)=ari;
            nrmse_(window_counter)=nrmse(ari+1);
            gain_(window_counter)=gain(ari+1);
            stdv_(window_counter)=nanstd(v);
            stdp_(window_counter)=nanstd(p);
            mv_(window_counter)=v_mean;
            mp_(window_counter)=p_mean;
            
            %     fs_dec=fs/dec_factor;
            [p_dec,fs_dec]=filtfilt_decimate(p,dec_factor,fs);
            v_dec=filtfilt_decimate(v,dec_factor);
            [b,a]=butter(filter_order,fc_hi/fs_dec*2,'high');
            p_dec=filtfilt(b,a,p_dec);
            v_dec=filtfilt(b,a,v_dec);
            t_dec=[0:length(p_dec)-1]/fs_dec;
            %                     i_dec=find(t_dec>=ti(1) & t_dec<=ti(end));
            %                     p_dec=p_dec(i_dec);
            %                     v_dec=v_dec(i_dec);
            %                     t_dec=t_dec(i_dec);
            fir_length=param.T_FIR*fs_dec+1;
            
            [dummy_b,dummy_a,h,cov_h,res]=arx_est(p_dec,v_dec,fir_length,0);
            % h=firnan(p_dec,v_dec,fir_length);
            h_(:,window_counter)=h;
            cov_h_(:,:,window_counter)=cov_h;
            H=fft(h,Nfft);
            %hs(file_index,:)=h';
            Hs{file_index,prot_index}=H';
            phi=angle(H);
            f_fft=[0:Nfft-1]/Nfft*fs_dec;
            [dummy,i_f_phi]=min(abs(f_fft-f_phi));
            
            %        hs(file_index,seg,:)=h;
            phi_(window_counter)=phi(i_f_phi);
            %         [x,tx]=make_pulse(mean_f,std_f,fs_dec,T_pulse);
            %         y=filter(h,1,x);
            
            [a_p,sigma2_p]=armcov(p_dec,ar_order);
            [a_v,sigma2_v]=armcov(v_dec,ar_order);
            [a_e,sigma2_e]=armcov(res.e,ar_order);
            
            a_p_(:,window_counter)=a_p;
            a_v_(:,window_counter)=a_v;
            a_e_(:,window_counter)=a_e;
            sigma2_p_(window_counter)=sigma2_p;
            sigma2_v_(window_counter)=sigma2_v;
            sigma2_e_(window_counter)=sigma2_e;
            
            if show_plot
                
                figure('Position',pos1);
                %             plot(t,p,t,v);
                %             hold on
                plot(t_dec,p_dec,t_dec,v_dec);
                title([num2str(file_index),', ',num2str(prot_index),': ',file_name],'interpreter','none');
                [Pp,f]=ar_spectrum(a_p,sigma2_p,fs_dec,Nfft);
                [Pv,f]=ar_spectrum(a_v,sigma2_v,fs_dec,Nfft);
                [Pe,f]=ar_spectrum(a_e,sigma2_e,fs_dec,Nfft);
                %             figure
                %             plot(f,Pp,f,Pv,f,Pe);
                %             xlabel('frequency (Hz)');
                %             legend('PSD - ABP','PSD - CBFV','PSD - residual');
            end;
            %    end
            %                 i_start=i_start+step_size*fs;
            %                 i_end=i_end+step_size*fs;
            %             end
            %         seg=1;
            ARI{file_index,prot_index}=ari_;
            nrmses{file_index,prot_index}=nrmse_;
            gains{file_index,prot_index}=gain_;
            phis{file_index,prot_index}=phi_;
            no_windows(file_index,prot_index)=window_counter;
            stdvs{file_index,prot_index}=stdv_;
            stdps{file_index,prot_index}=stdp_;
            mvs{file_index,prot_index}=mv_;
            mps{file_index,prot_index}=mp_;
            hs{file_index,prot_index}=h_;
            cov_hs{file_index,prot_index}=cov_h_;
            a_ps{file_index,prot_index}=a_p_;
            a_vs{file_index,prot_index}=a_v_;
            a_es{file_index,prot_index}=a_e_;
            sigma2_ps{file_index,prot_index}=sigma2_p_;
            sigma2_vs{file_index,prot_index}=sigma2_v_;
            sigma2_es{file_index,prot_index}=sigma2_e_;
            
            
            if show_plot
                figure('Position',pos2);
                plot([h_,cumsum(h_)]);
                legend('impulse response','step response');
                
                
                %             figure
                %             plot(tx,x,tx,y);
                %             figure
                %             plot(f_spec,Pp,f_spec,Pv);
                %             xlim([0,0.5]);
            end
            
            %     i=find(t>=t_seg_now(1) & t<=t_seg_now(2));
            %     signals=processed_sig.signals(:,i);
            %     figure
            %     plot(t(i),signals');
            %     title(file_name);
            %     legend(processed_sig.variable_names);
            % end
            %keyboard
            clear ari_ nrmse_ gain_ phi_ h_ cov_h_
            %         window=hanning(round(T_spec*fs));
            %         [Pv,f_spec]=spec2(v1,window,0.5,fs);
            %         [Pp,f_spec]=spec2(p1,window,0.5,fs);
            %         Pps(file_index,seg,:)=Pp;
            %         Pvs(file_index,seg,:)=Pv;
            
            
            % end;
            
            %         if show_plot
            %             figure
            %             plot(t,p_nan/nanmean(p_nan)*100-100,t,v_nan/nanmean(v_nan)*100-100);
            %             xlabel('time (s)');
            %             ylabel('%');
            %             title([file_name, ': p and v']);
            %             for seg=1:length(proc_segments);
            %                 place_marker(seg_times(file_index,seg*2-1:2*seg)',seg_colours(seg),'--',3);
            %                 %           place_marker(seg_times_sel(file_index,seg*2-1:2*seg)',seg_colours(seg),':',1);
            %             end
            %
            %             %         figure
            %             %         plot(t,co2./nanmean(co2)*100,t,pa./nanmean(pa)*100);
            %             %         xlabel('time (s)');
            %             %         ylabel('%');
            %             %         title([file_name,' co2 and pa']);
            %             %         for seg=1:length(proc_segments);
            %             %             place_marker(seg_times(file_index,seg*2-1:2*seg)',seg_colours(seg),'--',3);
            %             %             place_marker(seg_times_sel(file_index,seg*2-1:2*seg)',seg_colours(seg),':',1);
            %             %         end
            %
            %         end
            %         if opt==1;
            %             res=medsip2_function_ari(p_dec,v_dec,fs_dec,ari1,param);
            %             Res(file_index,1)=res;
            %             res=medsip2_function_ari(p_dec,v_dec,fs_dec,ari2,param);
            %             Res(file_index,2)=res;
            %             if show_plot
            %                 figure
            %                 param.linewidths=[4,2,3];
            %                 plot_it('t_dec,res.x,t_dec,res.y,''r'',t_dec,res.y_est,''r:''','time (s)','%','','''Pressure'',''Measured V'',''Estimated V''',param);
            %                 figure
            %                 plot_it('res.t_ip_pulse,res.ip_pulse,res.t_ip_pulse,res.p0,''r:''','time (s)','%','','');
            %                 figure
            %                 plot_it('res.t_ip_pulse,res.ip_step,res.t_ip_pulse,res.s0,''r:''','time (s)','%','','');
            %                 pause
            %             end
            %         elseif opt==2
            %             res=medsip2_function_stmcb(p_dec,v_dec,fs_dec,param);
            %             Res(file_index)=res;
            %             figure
            %             param.linewidths=[4,2,3];
            %             plot_it('t_dec,res.x,t_dec,res.y,''r'',t_dec,res.y_est,''r:''','time (s)','%','','''Pressure'',''Measured V'',''Estimated V''',param);
            %             figure
            %             param.linewidths=[4,3];
            %             plot_it('res.t_ip_pulse,res.ip_pulse,res.t_ip_pulse,res.p0,''r:''','time (s)','%','','''Input (P)'',''Output (V)''',param);
            %             figure
            %             plot_it('res.t_ip_pulse,res.ip_step,res.t_ip_pulse,res.s0,''r:''','time (s)','%','','''Input (P)'',''Output (V)''',param);
            %             pause
            %             close all
            %         elseif opt==3
            %             % keyboard
            %             for ari_count=1:length(aris)
            %                 res=medsip2_function_ari(p_dec,v_dec,fs_dec,aris(ari_count),param);
            %                 Res(file_index,ari_count)=res;
            %             end
            %         end
            %         % else
            %         %     res=medsip2_function(p_dec,v_dec,fs_dec,param);
            %         %     Res(file_index)=res;
            %         %     figure
            %         %     param.linewidths=[4,2,3];
            %         %     plot_it('t_dec,res.x,t_dec,res.y,''r'',t_dec,res.y_est,''r:''','time (s)','%','','''Pressure'',''Measured V'',''Estimated V''',param);
            %         %     figure
            %         %     param.linewidths=[4,3];
            %         %     plot_it('res.t_ip_pulse,res.ip_pulse,res.t_ip_pulse,res.p0,''r:''','time (s)','%','','''Input (P)'',''Output (V)''',param);
            %         %     figure
            %         %     plot_it('res.t_ip_pulse,res.ip_step,res.t_ip_pulse,res.s0,''r:''','time (s)','%','','''Input (P)'',''Output (V)''',param);
            %         %     pause
            %         %     close all
            %         % end;
            %
            %         %         s=input('Save data? ','s');
            %         %         if upper(s)=='Y'
            %         %             t_start=(i_start-1)/fs;
            %         %             t_end=(i_end-1)/fs;
            %         %             save medsip1_example_data file_name t_start t_end fc_hi filter_order p_dec v_dec fs_dec p_mean v_mean res
            %         %         end
            %
            %         %        keyboard
            %
            % pause
            close all
        end
    end
    
    
    % eval(['save ',outfile,' proc_segments good_data_length step_size file_indexes xls_file plot_order T_tiecks CrCP aris ari1 ari2 opt fs_dec Nfft f_phi file_names ar_order param phis no_windows ARI nrmses gains mvs mps stdvs stdps hs cov_hs a_ps a_es sigma2_ps sigma2_es Res']);
    
    eval(['save ',outfile,'  xls_file T_tiecks CrCP aris opt fs_dec Nfft f_phi mat_files ar_order param phis no_windows ARI nrmses gains mvs mps stdvs stdps hs cov_hs a_ps a_es sigma2_ps sigma2_es fs fs_dec']);
    
else
    load(outfile);
    res=Res(end);
    for ari=0:9
        [b_tiecks(ari+1,:),a_tiecks(ari+1,:)]=tiecks_ab1(ari,CrCP,fs_dec);
        dummy_p(:,ari+1)=filter(b_tiecks(ari+1,:),a_tiecks(ari+1,:),res.ip_pulse(:));
        dummy_s(:,ari+1)=filter(b_tiecks(ari+1,:),a_tiecks(ari+1,:),res.ip_step(:));
        [dummy_H(:,ari+1),fH]=freqz(b_tiecks(ari+1,:),a_tiecks(ari+1,:),512,fs_dec);
    end
    
    figure
    plot_it('res.t_ip_pulse,res.ip_pulse,''k:'',res.t_ip_pulse,dummy_p','Time (s)','%','',['''Input'',''Output'''],plot_param);
    ylim([-1,1.2]);
    xlim([-15,15]);
    figure
    plot_it('res.t_ip_pulse,res.ip_step,''k:'',res.t_ip_pulse,dummy_s','Time (s)','%','',['''Input'',''Output'''],plot_param);
    xlim([-15,15]);
    ylim([-.2,1.2]);
    figure
    plot_it('fH,abs(dummy_H)','frequency (Hz)','gain',[],[]);
    figure
    
    
    
    
    plot_it('fH,angle(dummy_H)','frequency (Hz)','phase',[],[]);
    
    
    for i=1:length(Res);
        resp(:,i)=Res(i).p0(:);
        if isfield(Res(i),'b0')
            [respf(:,i),fH]=freqz(Res(i).b0,Res(i).a0,512,res.fs);
        else
            [respf(:,i),fH]=freqz(Res(i).h0,1,512,fs_dec);
        end;
        respcos(:,i)=Res(i).cos0(:);
    end
    figure
    plot_it('Res(1).t_ip_pulse,resp','time (s)','%','','')
    xlim([-15,15]);
    figure
    plot_it('Res(1).t_ip_pulse,respcos','time (s)','%','','')
    xlim([-15,15]);
    figure
    plot_it('fH,abs(respf)','frequency (Hz)','gain',[],[]);
    figure
    plot_it('fH,angle(respf)','frequency (Hz)','phase',[],[]);
    for i=1:length(Res);
        resp(:,i)=Res(i).s0(:);
    end
    figure
    plot_it('Res(1).t_ip_pulse,resp','time (s)','%','','')
    xlim([-5,15]);
    ylim([-1,1.6]);
    
    
    if opt==1
        for i=1:length(Res);
            lag_p1(:,plot_order(i))=Res(i,1).lag_p1(:);
            lag_p0(plot_order(i))=Res(i,1).lag_p0;
            lag_cos0(plot_order(i))=Res(i,1).lag_cos0;
            lag_cos1(:,plot_order(i))=Res(i,1).lag_cos1(:);
            zc_p1(:,plot_order(i))=Res(i,1).zc_p1(:);
            zc_p0(plot_order(i))=Res(i,1).zc_p0;
            zc_p12(:,plot_order(i))=Res(i,2).zc_p1(:);
            zc_p02(plot_order(i))=Res(i,2).zc_p0;
            s1_end(:,plot_order(i))=Res(i,1).s1_end;
            lag_p12(:,plot_order(i))=Res(i,2).lag_p1(:);
            lag_p02(plot_order(i))=Res(i,2).lag_p0;
            lag_cos02(plot_order(i))=Res(i,2).lag_cos0;
            lag_cos12(:,plot_order(i))=Res(i,2).lag_cos1(:);
            s1_end2(:,plot_order(i))=Res(i,2).s1_end;
        end
        figure
        boxplot(lag_p1);
        xlabel('File number');
        ylabel('Lag of peak of pulse-response');
        figure
        boxplot(lag_cos1);
        xlabel('File number');
        ylabel('Lag of peak of cosine-response');
        
        figure
        plot_it('file_indexes,mean(lag_p1),''o-r'',file_indexes,mean(lag_p12),''o-k''','file number',[],'Pulse',['''ARI high'',''ARI low''']);
        hold on
        plot_it('file_indexes,std(lag_p1),''o:r'',file_indexes,std(lag_p12),''o:k''','file number','seconds',[],[]);
        [h,p]=ttest2(lag_p1(1:Np,:),lag_p12(1:Np,:));
        disp(['P-value = ',num2str(p),' for Np=',num2str(Np)]);
        sum(p<alpha)
        
        figure
        plot_it('file_indexes,mean(zc_p1),''o-r'',file_indexes,mean(zc_p12),''o-k''','file number',[],'Pulse',['''ARI high'',''ARI low''']);
        hold on
        plot_it('file_indexes,std(zc_p1),''o:r'',file_indexes,std(zc_p12),''o:k''','file number','seconds','Pulse - zero crossing',[]);
        [h,p]=ttest2(zc_p1(1:Np,:),zc_p12(1:Np,:));
        disp(['P-value = ',num2str(p),' for Np=',num2str(Np)]);
        sum(p<alpha)
        
        figure
        %     plot(file_indexes,mean(lag_p1),'o-',file_indexes,mean(lag_cos1),'o-');
        %     hold on
        %     plot(file_indexes,std(lag_p1),'x:',file_indexes,std(lag_cos1),'x:');
        %     plot(file_indexes,mean(lag_p1),'o-',file_indexes,mean(lag_cos1),'o-');
        %     hold on
        %     plot(file_indexes,std(lag_p1),'x:',file_indexes,std(lag_cos1),'x:');
        plot_it('file_indexes,mean(lag_cos1),''o-r'',file_indexes,mean(lag_cos12),''o-k''','file number',[],'Pulse',['''ARI high'',''ARI low''']);
        hold on
        %plot_it('file_indexes,mean(lag_p1)+1.96*std(lag_p1),''x:r'',file_indexes,mean(lag_p1)-1.96*std(lag_p1),''x:r'',file_indexes,mean(lag_cos1)+1.96*std(lag_cos1),''x:k'',file_indexes,mean(lag_cos1)-1.96*std(lag_cos1),''x:k''','file number','seconds',[],[]);
        plot_it('file_indexes,std(lag_cos1),''o:r'',file_indexes,std(lag_cos12),''o:k''','file number','seconds',[],[]);
        [h,p]=ttest2(lag_cos1(1:Np,:),lag_cos12(1:Np,:));
        disp(['P-value = ',num2str(p),' for Np=',num2str(Np)]);
        sum(p<alpha)
        
        figure
        plot_it('file_indexes,mean(s1_end),''o-r'',file_indexes,mean(s1_end2),''o-k''','file number',[],'Pulse',['''ARI high'',''ARI low''']);
        hold on
        %plot_it('file_indexes,mean(lag_p1)+1.96*std(lag_p1),''x:r'',file_indexes,mean(lag_p1)-1.96*std(lag_p1),''x:r'',file_indexes,mean(lag_cos1)+1.96*std(lag_cos1),''x:k'',file_indexes,mean(lag_cos1)-1.96*std(lag_cos1),''x:k''','file number','seconds',[],[]);
        plot_it('file_indexes,std(s1_end),''o:r'',file_indexes,std(s1_end2),''o:k''','file number','seconds',[],[]);
        [h,p]=ttest2(s1_end(1:Np,:),s1_end2(1:Np,:));
        disp(['P-value = ',num2str(p),' for Np=',num2str(Np)]);
        sum(p<alpha)
        
    else
        for i=1:length(Res);
            lag_p1(:,plot_order(i))=Res(i).lag_p1(:);
            lag_p0(plot_order(i))=Res(i).lag_p0;
            lag_cos0(plot_order(i))=Res(i).lag_cos0;
            lag_cos1(:,plot_order(i))=Res(i).lag_cos1(:);
            s1_end(:,plot_order(i))=Res(i).s1_end;
        end
        figure
        boxplot(lag_p1);
        xlabel('File number');
        ylabel('Lag of peak of pulse-response');
        figure
        boxplot(lag_cos1);
        xlabel('File number');
        ylabel('Lag of peak of cosine-response');
        figure
        %     plot(file_indexes,mean(lag_p1),'o-',file_indexes,mean(lag_cos1),'o-');
        %     hold on
        %     plot(file_indexes,std(lag_p1),'x:',file_indexes,std(lag_cos1),'x:');
        plot_it('file_indexes,mean(lag_p1),''o-r'',file_indexes,mean(lag_cos1),''o-k'',file_indexes,lag_p0,''xr'',file_indexes,lag_cos0,''xk''','file number',[],[],['''Pulse'',''Cosine''']);
        hold on
        %plot_it('file_indexes,mean(lag_p1)+1.96*std(lag_p1),''x:r'',file_indexes,mean(lag_p1)-1.96*std(lag_p1),''x:r'',file_indexes,mean(lag_cos1)+1.96*std(lag_cos1),''x:k'',file_indexes,mean(lag_cos1)-1.96*std(lag_cos1),''x:k''','file number','seconds',[],[]);
        plot_it('file_indexes,std(lag_p1),''o:r'',file_indexes,std(lag_cos1),''o:k''','file number','seconds',[],[]);
        
        figure
        %     plot(file_indexes,mean(lag_p1),'o-',file_indexes,mean(lag_cos1),'o-');
        %     hold on
        %     plot(file_indexes,std(lag_p1),'x:',file_indexes,std(lag_cos1),'x:');
        plot_it('file_indexes,mean(s1_end),''o-b'',file_indexes,std(s1_end),''x:b''','file number',[],[],['''End of step-response''']);
        
    end
end



