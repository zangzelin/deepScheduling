gongjian = [ gongjian_1; gongjian_2; gongjian_3 ] ;% 将工件列表组合，第一列表示i工件j工序，第二列表示加工机器，第三列表示需要的工时
gongjianzzl = gongjian;% 复制一个gongjian
gongjian1 = P_best;% 导入前文中的解

% 以最优解的顺序排列所有工件
for i = 1 : 9
    [I,J] = find(  gongjian1(i,1)== gongjian(:,1) ); 
    gongjian1(i,2:3) = gongjian(I,2:3);
    findma( I ) = i;
end
gongjian = gongjian1;


clear gongjianjiagongbiao gongjianjiangongshijian datain dataout

% 以工件的顺序， 为每个工件规定加工的机器

count1 = 1;
count2 = 1;
count3 = 1;
for i = 1:9
    if floor(gongjian(i,1)/10) == 1 
        gongjianjiagongbiao(1,count1) =  gongjian(i,2);
        gongjianjiangongshijian(1,count1) =  gongjian(i,3);
        in( 1,gongjian(i,2) ) = 1;
        count1 = count1+1;
    end
    
    if floor(gongjian(i,1)/10) == 2
        gongjianjiagongbiao(2,count2) =  gongjian(i,2);
        gongjianjiangongshijian(2,count2) =  gongjian(i,3);
          in( 2,gongjian(i,2) ) = 1;
        count2 = count2+1;
    end
    
    if floor(gongjian(i,1)/10) == 3
        gongjianjiagongbiao(3,count3) =  gongjian(i,2);
        gongjianjiangongshijian(3,count3) =  gongjian(i,3);
          in( 2,gongjian(i,2) ) = 1;
        count3 = count3+1;
    end
end

count1 = 1;
count2 = 1;
count3 = 1;

gognjiankongxian = [1,1,1];
jiqikongxian = [1,1,1];
run = [0,0,0];

for i  = 1 : min_time
    in = zeros( 3, 3 )    ;
    %%     
        if run(1) ==1
        jiqikongxian(1)  =1;
        gognjiankongxian(1) = 1;
    end    
    
    if run(2) == 1
        jiqikongxian(2)  =1;
        gognjiankongxian(2) = 1;
    end
    
    if run(3) == 1
        jiqikongxian(3)  =1;
        gognjiankongxian(3) = 1;
    end
    
    
    %% 
        
    if gognjiankongxian(1) == 1 && count1 < 4 && jiqikongxian( gongjianjiagongbiao(1,count1)) ==1 ;
        gognjiankongxian(1) = 0;
        jiqikongxian( gongjianjiagongbiao(1,count1)) =0;
        run(gongjianjiagongbiao(1,count1)) = gongjianjiangongshijian( 1,count1 )+1;
        in( 1,gongjianjiagongbiao(1,count1) ) = 1;
        count1 = count1 + 1;
    end
    
    if gognjiankongxian(2) == 1 && count2 < 4 && jiqikongxian( gongjianjiagongbiao(2,count2)) ==1 ;
        gognjiankongxian(2) = 0;
        jiqikongxian( gongjianjiagongbiao(2,count2)) =0;
        run(gongjianjiagongbiao(2,count2)) = gongjianjiangongshijian( 2,count2 )+1;
        in( 2,gongjianjiagongbiao(2,count2) ) = 1;
        count2 = count2 + 1;
    end
    
    if gognjiankongxian(3) == 1&& count3 < 4 && jiqikongxian( gongjianjiagongbiao(3,count3)) ==1 ;
        gognjiankongxian(3) = 0;
        jiqikongxian( gongjianjiagongbiao(3,count3)) =0;
        run(gongjianjiagongbiao(3,count3)) = gongjianjiangongshijian( 3,count3 )+1;
         in( 3,gongjianjiagongbiao(3,count3) ) = 1;
        count3 = count3 + 1;
    end

    

    
    run = run-1;
    
    run(run<0) = 0;
    in;
    
    datain(1,i) = jiqikongxian(1);
    datain(2,i) = jiqikongxian(2);
    datain(3,i) = jiqikongxian(3);
    datain(4,i) = run(1);
    datain(5,i) = run(2);
    datain(6,i) = run(3);
    datain(7:15,i) = gongjianzzl(:,1);
    datain(16:24,i) = gongjianzzl(:,2);
    datain(25:33,i) = gongjianzzl(:,3);
    dataout(:,i) = reshape(in,[9,1]);
    datain(1:3,:);
end
str = [ 'data\in' num2str(loop) '.csv'];
csvwrite( str , datain);
str = [ 'data\out' num2str(loop) '.csv'];
csvwrite( str , dataout);
