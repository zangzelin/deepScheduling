clear;
clc;


for loop = 1:1000

            % init %��Ⱥ��ʼ������Ⱥ��СΪ20
            %--------------------------��Ⱥ��ʼ��------------------------------------%
            seed=[1 1 1 2 2 2 3 3 3 ];%����
            Chrom=zeros(20,9);%Ԥ������������ڴ���20��Ⱦɫ��

            for i=1:20
                Chrom(i,:)=seed(randperm(numel(seed)));%����Ⱦɫ�岢�����������
            end

             NIND=20;%��Ⱥ��С20
             WNumber=9;%Ⱦɫ�峤��Ϊ9
             XOVR=0.2;%�������=0.6
             MUTR=0.03;
             gongjian_1=[11 3 randi(20); 12 2 randi(20); 13 1 randi(20)];
             gongjian_2=[21 2 randi(20); 22 1 randi(20); 23 3 randi(20)];
             gongjian_3=[31 1 randi(20); 32 3 randi(20); 33 2 randi(20)];
             time_opt=zeros(20,800);% Ԥ����20*100�ľ���洢100����Ⱥ�еĸ�������ʱ��
            for generation=1:1000

            %%���½��н��롢������Ӧ�ȡ�ѡ�񡪡���������������������

            %%��������Ӧ�� �������ʱ��
            P=zeros(9,1);
            M=zeros(9,1);
            T=zeros(9,1);
            t_bz=zeros(3,3);
            T_qunti=zeros(20,1);
            %�ú�������1 :������Ⱥ�и���Ⱦɫ���ʱ�䣬���ս��Ϊ20*1�ľ��󣬴������Ⱦɫ���Ӧ��ʱ��
            %          2 :ͨ��ѡ�������µ���Ⱥ�����У����Ÿ���ֱ�ӱ���
            %  ����ʱ��ŵ�20��100�����У�ÿһ�д���һ���е�20�������ʱ��
            for i=1:20         %%Ⱥ���е�20��Ⱦɫ��ֱ���ʱ��   
                 a=1; b=1;c=1;%����a b c ����ȷ��������󡢻��������Լ�ʱ�����
                 t1=0;t2=0;t3=0;%��ʼ������1 ����2 ����3 ��ֵ
                for j=1:9
                    if Chrom(i,j)==1
                        P(j)=10+a;
            %             if a==4
            %                a=3;
            %             end
                        M(j)=gongjian_1(a,2);
                        T(j)=gongjian_1(a,3);
                        a=a+1;
                    elseif Chrom(i,j)==2
                            P(j)=20+b;
            %                   if b==4
            %                      b=3;
            %                    end
                            M(j)=gongjian_2(b,2);
                            T(j)=gongjian_2(b,3);
                            b=b+1;
                    elseif Chrom(i,j)==3
                             P(j)=30+c;
            %                    if c==4
            %                       c=3;
            %                     end
                             M(j)=gongjian_3(c,2);
                             T(j)=gongjian_3(c,3);
                             c=c+1;
                    end
                end  %������� ���P M T
                %% ���¼���ÿ��Ⱦɫ���ʱ��

                for k=1:9
                    if M(k)==1
                        x=floor(P(k)/10);% xΪ������
                        y=rem(P(k),10);% yΪ�����
                        if y==1%��Ȼ������ù���Ϊ��һ��������M1����ʱ��t1ֱ��Ϊ��ǰʱ����ϸù����ʱ��
                            t1=t1+T(k);
                            t_bz(x,y)=t1;%��32��,�ڳ����ʼ���������Ѿ�Ԥ����t_bz=zeros(3,3);t_bz��Ϊ3*3����������ڴ洢���������ڻ����϶�Ӧ�Ļ���ʱ�䣬�����������ţ�����������
                        else %����ù����ǵ�һ������temp1Ϊһ���м������Ԫ��Ϊ�û�����ǰ��ʱ��t1���Լ��ù�����һ�������ڻ����Ķ�Ӧ����ʱ��
                            temp1=[ t1 t_bz(x,y-1)];
                            t1=max(temp1)+T(k);%��ѡ������֮�еĽϴ�ֵ����Ϊ�ù�����1�����ϣ�2 3����ͬ���϶�Ӧ�Ļ���ʱ��
                            t_bz(x,y)=t1;%����ʱ�丳ֵ��ʱ�����
                        end
                    elseif M(k)==2
                          x=floor(P(k)/10);% xΪ������
                          y=rem(P(k),10); % yΪ�����
                        if y==1   % ���Ϊ�ù����ĵ�һ��������û���ʱ��Ϊ��ǰһʱ��ʱ��+�õ������ʱ��
                            t2=t2+T(k);
                            t_bz(x,y)=t2;
                        else    %����ù����ǵ�һ������
                             temp2=[ t2 t_bz(x,y-1)];
                             t2=max(temp2)+T(k);
                             t_bz(x,y)=t2; 
                        end
                    elseif M(k)==3
                          x=floor(P(k)/10);% xΪ������
                          y=rem(P(k),10); % yΪ�����
                        if y==1
                            t3=t3+T(k);
                            t_bz(x,y)=t3;
                        else 
                            temp3=[ t3 t_bz(x,y-1)];
                            t3=max(temp3)+T(k);
                            t_bz(x,y)=t3; 
                        end
                    end    
                end
                   temp=[t1 t2 t3];%����Ȼ����Ⱦɫ���Ӧ�ļӹ�ʱ�������������ʱ������ֵ
                   t=max(temp);      %�ó���Ⱦɫ���Ӧ�ļӹ�ʱ��
                   T_qunti(i,1)=t;   %����Ⱦɫ���Ӧ��ʱ�丳ֵ��ʱ�������Ⱥ��20��Ⱦɫ���ʱ���ŷ��
            time_add=sum(T_qunti); %�������Ⱥ�и���Ⱦɫ����ʱ���
            time_indiv=T_qunti/time_add; %����ÿһ����������ʱ��ı�ֵ
            min_time=min(T_qunti);%�ô���Ⱥ��ʱ����̵ĸ���ʱ��
            end %%�����þ䣬�����ÿ��Ⱦɫ���ʱ��
            % 
            % 

            %����ִ��*ѡ��*���� ---.>��̬���Ƶķ���
            next_pop=Chrom;%��ʼ��Ⱥ��
            best_flag=0;
              for tt=1:20
                if T_qunti(tt,1)==min_time %����ø���Ϊ��ֹ����ǰ����õĸ��壬����
                   best_flag=best_flag+1;
                   next_pop(best_flag,:)=Chrom(tt,:);
                   time_indiv(tt,:)=2;% ����ø���Ϊ�ô������ţ��򽫸ø���ֱ�Ӹ��Ƶ���һ����Ȼ��time_indiv��ֵΪ2���Աܿ�����ͱ���
                end
              end

            flag=best_flag;
            while flag<20
                for z=1:20 %��һ��Ⱥ���ǰflag������ֱ��ȡ��һ������Ѹ��壬ʣ�µĸ������漴����ѡ��
                    sj=rand;
                    if  time_indiv(z,1)<sj %�����������ڵ�i��Ⱦɫ��ĸ��ʣ���Ϊ��Ⱦɫ��Ϻã�����
                        next_pop(flag+1,:)=Chrom(z,:);
                        flag=flag+1;
                    end
                end
            end
            Chrom=next_pop;


            % % 
            % % % %--------------------------------------------------------------------------
            % % % %��ֹ��������� ʵ����ѡ�񡢼�����Ӧ�ȡ����룬һ�½��н���ͱ���
            % % % %--------------------------------------------------------------------------
            % % % % % % % % %����
            SelNum=randperm(NIND);
             %������������
            %  Num=NIND/2;
            %  Num=2*fix(Num);
            ChromNew=Chrom;

             for mm=(20-best_flag):19
                 rd=rand;
                 if XOVR>rd;

                        %ȡ�����ĸ���;
                        if best_flag==20% �������Ⱥ���Ÿ���ﵽ�����������
                            break
                        end
                        S1=Chrom(SelNum(mm),:);
                        S2=Chrom(SelNum(mm+1),:);
                        A=S1;
                        B=S2;
                         %�����--postion
                        n=fix(9*rand);
                        C=[A(1:n) B(n+1:9)];
                        D=[B(1:n) A(n+1:9)];

                        c1=sum(C(n+1:9)==1);
                        d1=sum(D(n+1:9)==1);
                        c2=sum(C(n+1:9)==2);
                        d2=sum(D(n+1:9)==2);
                        c3=sum(C(n+1:9)==3);
                        d3=sum(D(n+1:9)==3);

                        E=[ones(1,3-c1) 2*ones(1,3-c2) 3*ones(1,3-c3) C(n+1:9)];%����C
                        F=[ones(1,3-d1) 2*ones(1,3-d2) 3*ones(1,3-d3) D(n+1:9)];%����C
                        ex1=E(1,1:(9-c1-c2-c3));%ȡ������λ����֮ǰ��Ԫ�طŵ�ex1��ex2��
                        ex2=F(1,1:(9-c1-c2-c3));
                        ex1=ex1(randperm(numel(ex1)));
                        ex2=ex2(randperm(numel(ex2)));
                        E=[ex1 E(n+1:9)];
                        F=[ex1 F(n+1:9)];
            %            %������Ⱥ
                         ChromNew(SelNum(mm),:)=E;
                         ChromNew(SelNum(mm+1),:)=F;
            %              Chrom(SelNum(mm),:)=ChromNew(SelNum(mm),:);
            %              Chrom(SelNum(mm+1),:)=ChromNew(SelNum(mm+1),:);
            %             
                 end
             end% % %��ֹ��������� ʵ���˽��棬���½��б������





            % % %--------------------------------------------------------------------------
            % % %��ֹ��������� ʵ���˽��棬���½��б������
            % % %--------------------------------------------------------------------------
            % %����
            ChromNew=Chrom;

            for i=best_flag+1:NIND  %�Ƿ����
                mt=rand;
              if MUTR>mt;     
                 Pos1=unidrnd(WNumber);%����λ��
                 Pos2=unidrnd(WNumber);

             %����λ�ò���ͬ
              while Pos1==Pos2      
                    Pos2=unidrnd(WNumber);
              end 

             %ȡ����
               S=Chrom(i,:);

               %����
               temp=S(Pos1);
               S(Pos1)=S(Pos2);
               S(Pos2)=temp;

               ChromNew(i,:)=S;
             end
            end
            Chrom=ChromNew;

            time_opt(:,generation)=T_qunti;%ʱ����������洢N����Ⱥ�и���Ⱦɫ���ʱ��

            % % %--------------------------------------------------------------------------
            % % %��ֹ��������� ʵ�ֱ���
            % % %--------------------------------------------------------------------------
            pp=T_qunti==min_time;%pp��¼T_qunti������Сʱ�������ͬ�ĸ���������Ϊ20*1�ľ���

            %���½��иô���������
%                    figure(1)% ����figure1 ��ͼ���ڣ���ʾȺ�����������ʱ���ƽ��ֵ�任
%                    plot(generation,sum(pp),'bo')
%                    plot(generation,mean(T_qunti),'rs') 
%                    hold on

            end

%             display('���Ÿ���Ϊ��')
            Chrom_best=Chrom(1,:) %��ʾ���Ÿ����Ⱦɫ����룬ÿһ������ʱ�������Ÿ��������Ⱥ��ĵ�һ��
%             display('���żӹ�ʱ��Ϊ:')
            min_time
%             display('������Ӧ���Ÿ���ļӹ�˳��Ϊ��')
            P_best=P
%             figure(2)
%             for sl=0:999
%                 plot((sl+0.05):0.05:(1+sl),(time_opt(:,sl+1))','ro')
%                 hold on
%             end

            outdata
            loop
            

end
