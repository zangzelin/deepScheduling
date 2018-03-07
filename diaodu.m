clear;
clc;


for loop = 1:1000

            % init %种群初始化，种群大小为20
            %--------------------------种群初始化------------------------------------%
            seed=[1 1 1 2 2 2 3 3 3 ];%种子
            Chrom=zeros(20,9);%预定义零矩阵，用于存数20个染色体

            for i=1:20
                Chrom(i,:)=seed(randperm(numel(seed)));%生成染色体并赋到矩阵各行
            end

             NIND=20;%种群大小20
             WNumber=9;%染色体长度为9
             XOVR=0.2;%交叉概率=0.6
             MUTR=0.03;
             gongjian_1=[11 3 randi(20); 12 2 randi(20); 13 1 randi(20)];
             gongjian_2=[21 2 randi(20); 22 1 randi(20); 23 3 randi(20)];
             gongjian_3=[31 1 randi(20); 32 3 randi(20); 33 2 randi(20)];
             time_opt=zeros(20,800);% 预定义20*100的矩阵存储100代种群中的各个个体时间
            for generation=1:1000

            %%以下进行解码、计算适应度、选择————————————

            %%解码求适应度 计算最短时间
            P=zeros(9,1);
            M=zeros(9,1);
            T=zeros(9,1);
            t_bz=zeros(3,3);
            T_qunti=zeros(20,1);
            %该函数用来1 :计算种群中各个染色体的时间，最终结果为20*1的矩阵，代表各个染色体对应的时间
            %          2 :通过选择生成新的种群，其中，最优个体直接保留
            %  将该时间放到20行100矩阵中，每一列代表一代中的20个个体的时间
            for i=1:20         %%群体中的20个染色体分别求时间   
                 a=1; b=1;c=1;%定义a b c 用于确定工序矩阵、机床矩阵以及时间矩阵
                 t1=0;t2=0;t3=0;%初始化机床1 机床2 机床3 的值
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
                end  %解码完成 求出P M T
                %% 以下计算每个染色体的时间

                for k=1:9
                    if M(k)==1
                        x=floor(P(k)/10);% x为工件号
                        y=rem(P(k),10);% y为工序号
                        if y==1%显然，如果该工序为第一个工序，则M1机床时间t1直接为当前时间加上该工序的时间
                            t1=t1+T(k);
                            t_bz(x,y)=t1;%第32行,在程序初始化过程中已经预定义t_bz=zeros(3,3);t_bz即为3*3的零矩阵，用于存储各个工序在机床上对应的机床时间，行数代表工件号，列数代表工序
                        else %如果该工序不是第一个工序：temp1为一个中间变量，元素为该机床当前的时间t1、以及该工件上一工序所在机床的对应机床时间
                            temp1=[ t1 t_bz(x,y-1)];
                            t1=max(temp1)+T(k);%。选择两者之中的较大值，即为该工件在1机床上（2 3机床同理）上对应的机床时间
                            t_bz(x,y)=t1;%将该时间赋值到时间矩阵
                        end
                    elseif M(k)==2
                          x=floor(P(k)/10);% x为工件号
                          y=rem(P(k),10); % y为工序号
                        if y==1   % 如果为该工件的第一个工序，则该机床时间为其前一时刻时间+该道工序的时间
                            t2=t2+T(k);
                            t_bz(x,y)=t2;
                        else    %如果该工序不是第一道工序
                             temp2=[ t2 t_bz(x,y-1)];
                             t2=max(temp2)+T(k);
                             t_bz(x,y)=t2; 
                        end
                    elseif M(k)==3
                          x=floor(P(k)/10);% x为工件号
                          y=rem(P(k),10); % y为工序号
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
                   temp=[t1 t2 t3];%很显然，该染色体对应的加工时间就是三个机床时间的最大值
                   t=max(temp);      %得出该染色体对应的加工时间
                   T_qunti(i,1)=t;   %将该染色体对应的时间赋值给时间矩阵，种群中20个染色体的时间就欧了
            time_add=sum(T_qunti); %计算出种群中各个染色体总时间和
            time_indiv=T_qunti/time_add; %计算每一个个体与总时间的比值
            min_time=min(T_qunti);%该代种群中时间最短的个体时间
            end %%截至该句，计算出每个染色体的时间
            % 
            % 

            %以下执行*选择*操作 ---.>稳态复制的方法
            next_pop=Chrom;%初始化群体
            best_flag=0;
              for tt=1:20
                if T_qunti(tt,1)==min_time %如果该个体为截止到当前代最好的个体，则保留
                   best_flag=best_flag+1;
                   next_pop(best_flag,:)=Chrom(tt,:);
                   time_indiv(tt,:)=2;% 如果该个体为该代中最优，则将该个体直接复制到下一代，然后将time_indiv赋值为2，以避开交叉和变异
                end
              end

            flag=best_flag;
            while flag<20
                for z=1:20 %下一代群体的前flag个个体直接取上一带的最佳个体，剩下的个体用随即方法选择
                    sj=rand;
                    if  time_indiv(z,1)<sj %如果随机数大于第i个染色体的概率，认为该染色体较好，保留
                        next_pop(flag+1,:)=Chrom(z,:);
                        flag=flag+1;
                    end
                end
            end
            Chrom=next_pop;


            % % 
            % % % %--------------------------------------------------------------------------
            % % % %截止到该行语句 实现了选择、计算适应度、解码，一下进行交叉和变异
            % % % %--------------------------------------------------------------------------
            % % % % % % % % %交叉
            SelNum=randperm(NIND);
             %交叉个体组个数
            %  Num=NIND/2;
            %  Num=2*fix(Num);
            ChromNew=Chrom;

             for mm=(20-best_flag):19
                 rd=rand;
                 if XOVR>rd;

                        %取交换的个体;
                        if best_flag==20% 如果该种群最优个体达到最大，跳出交叉
                            break
                        end
                        S1=Chrom(SelNum(mm),:);
                        S2=Chrom(SelNum(mm+1),:);
                        A=S1;
                        B=S2;
                         %交叉点--postion
                        n=fix(9*rand);
                        C=[A(1:n) B(n+1:9)];
                        D=[B(1:n) A(n+1:9)];

                        c1=sum(C(n+1:9)==1);
                        d1=sum(D(n+1:9)==1);
                        c2=sum(C(n+1:9)==2);
                        d2=sum(D(n+1:9)==2);
                        c3=sum(C(n+1:9)==3);
                        d3=sum(D(n+1:9)==3);

                        E=[ones(1,3-c1) 2*ones(1,3-c2) 3*ones(1,3-c3) C(n+1:9)];%重排C
                        F=[ones(1,3-d1) 2*ones(1,3-d2) 3*ones(1,3-d3) D(n+1:9)];%重排C
                        ex1=E(1,1:(9-c1-c2-c3));%取出交叉位及其之前的元素放到ex1和ex2中
                        ex2=F(1,1:(9-c1-c2-c3));
                        ex1=ex1(randperm(numel(ex1)));
                        ex2=ex2(randperm(numel(ex2)));
                        E=[ex1 E(n+1:9)];
                        F=[ex1 F(n+1:9)];
            %            %放入新群
                         ChromNew(SelNum(mm),:)=E;
                         ChromNew(SelNum(mm+1),:)=F;
            %              Chrom(SelNum(mm),:)=ChromNew(SelNum(mm),:);
            %              Chrom(SelNum(mm+1),:)=ChromNew(SelNum(mm+1),:);
            %             
                 end
             end% % %截止到该行语句 实现了交叉，以下进行变异操作





            % % %--------------------------------------------------------------------------
            % % %截止到该行语句 实现了交叉，以下进行变异操作
            % % %--------------------------------------------------------------------------
            % %变异
            ChromNew=Chrom;

            for i=best_flag+1:NIND  %是否变异
                mt=rand;
              if MUTR>mt;     
                 Pos1=unidrnd(WNumber);%变异位置
                 Pos2=unidrnd(WNumber);

             %变异位置不相同
              while Pos1==Pos2      
                    Pos2=unidrnd(WNumber);
              end 

             %取数据
               S=Chrom(i,:);

               %交换
               temp=S(Pos1);
               S(Pos1)=S(Pos2);
               S(Pos2)=temp;

               ChromNew(i,:)=S;
             end
            end
            Chrom=ChromNew;

            time_opt(:,generation)=T_qunti;%时间矩阵，用来存储N代种群中各个染色体的时间

            % % %--------------------------------------------------------------------------
            % % %截止到该行语句 实现变异
            % % %--------------------------------------------------------------------------
            pp=T_qunti==min_time;%pp记录T_qunti中与最小时间个体相同的个体数量（为20*1的矩阵）

            %以下进行该代结果的输出
%                    figure(1)% 定义figure1 绘图窗口，显示群体进化过程中时间的平均值变换
%                    plot(generation,sum(pp),'bo')
%                    plot(generation,mean(T_qunti),'rs') 
%                    hold on

            end

%             display('最优个体为：')
            Chrom_best=Chrom(1,:) %显示最优个体的染色体编码，每一代进化时都将最优个体放置在群体的第一行
%             display('最优加工时间为:')
            min_time
%             display('解码后对应最优个体的加工顺序为：')
            P_best=P
%             figure(2)
%             for sl=0:999
%                 plot((sl+0.05):0.05:(1+sl),(time_opt(:,sl+1))','ro')
%                 hold on
%             end

            outdata
            loop
            

end
