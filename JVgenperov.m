
clear all
addpath('./sPC1d');
%pc1dSetthickness('perov.prm','CRegion::m_Thickness',top/1e7);
pc1dSet('perov.prm','In CData: GraphableQuantity g','46','CGraph::m_xquantity:');
pc1dSet('perov.prm','In CData: GraphableQuantity g','45','CGraph::m_yquantity[0]:');

tau=logspace (-3,0,100);
S = logspace (1,8,100);

Rs = linspace (1e-3,5,100);
shunt=logspace(2,5,100)/1000;
Rsh=1./shunt; 
Num = 50000;
LL = 0.1.*[1,3,10];
dl = 66;
JV = zeros(dl,2*Num);
%in = zeros(5*Num);
for i=1:1:Num,
%     r1 =10^(normrnd(-3,1.5));
%     r2 =10^(normrnd(4.5,7/4));r3 =10^(normrnd(4.5,7/4));r5 =10^(normrnd(2,0.5));r4 =10^normrnd(-1,1);

   r1 =10^(unifrnd(-6,0));% lifetime
   r2 =10^(unifrnd(3,7));r3 =10^(unifrnd(3,7));%SRV
   r5 =10^(unifrnd(1,3));%shunt
   r4 =10^unifrnd(-3,1);%series
   r6 = 10^unifrnd(0,6); %intrinsic carrier concentration
   r7 = unifrnd(1.5,3); %bandgap
   r8 = unifrnd (3,5);%electron affinity
    pc1dSetthickness('perov.prm','CRegion::m_TauP',(r1)/1e6);
    pc1dSetthickness('perov.prm','CRegion::m_TauN',(r1)/1e6);
    pc1dSetthickness('perov.prm','CRegion::m_FrontSp',(r2));
    pc1dSetthickness('perov.prm','CRegion::m_FrontSn',(r2));
    pc1dSetthickness('perov.prm','CRegion::m_RearSp',(r3));
    pc1dSetthickness('perov.prm','CRegion::m_RearSn',(r3));
    pc1dSet('perov.prm','CDevice::m_EmitterR',(r4)/1000);
    pc1dSet('perov.prm','CLumped::m_Value',1000/(r5));
    pc1dSetthickness('perov.prm','CMaterial::m_ni300',(r6));
    pc1dSetthickness('perov.prm','CMaterial::m_BandGap',(r7));
    pc1dSetthickness('perov.prm','CMaterial::m_Affinity',(r8));
    startTime = tic;

    for j= 1:length(LL)
         pc1dSet('perov.prm','CLight::m_IntensitySS',LL(j));
         pc1dSet('perov.prm','CLight::m_IntensityTR1',LL(j));
         pc1dSet('perov.prm','CLight::m_IntensityTR2',LL(j));
          

        [c d] = dos(['cmd-pc1d.exe perov.prm']);
    
 
        data = textscan(d,'%f%f%f%f%f%f%f%f%f%f%f%f%f','Headerlines',1);
        data = [data{:}];


           if length(data)<65
               continue
           end


              k= min(find(data(:,1)>0));
              if isempty(k)
                  continue
              end
              Voc=interp1(data(4:k,1),data(4:k,2),0);


            F=griddedInterpolant(data(4:k,2),data(4:k,1));
            vq(:,i) = log10(linspace(10^(0),10^(Voc),20))';
            Jq(:,i) = F(vq(:,i));    
            parin (:,i) = [log10(r1);log10(r2);log10(r3);log10(r4);log10(r5);log10(r6);r7;r8];

            JV(dl*j-dl+1:dl*j,2*i-1) =data(:,1);
            JV(dl*j-dl+1:dl*j,2*i) = data(:,2);
    end
           %do nothing
          
       
    
end


    
    
 
    
   
    dlmwrite('JV1.txt', JV,'delimiter', '\t','newline','pc')
   

m=1;

for i=1:1:Num,



       
       
     
    if ~all(JV(:,2*i-1));
        continue
    end
    for j= 1:length(LL)
        
        k= min(find(JV(dl*j-dl+1:dl*j,2*i-1)>0))+1;
        if k>66
            k=60;
        end
        if isempty(k)
            k=60;
        end
        F=griddedInterpolant(JV(dl*j-dl+3:dl*j-dl+k,2*i),JV(dl*j-dl+3:dl*j-dl+k,2*i-1));
        vv= linspace((0),(0.5),50)';

        JJ(50*j-50+1:50*j,m) = F(vv); 
    end
    parj(:,m)=parin (:,i);
    m = m+1;
    
    
%     F=griddedInterpolant(JV(4:k,2*i-2),JV(4:k,2*i-3));
%     vv= log10(linspace(10^(0),10^(1.1),50))';
%     JJ(:,i) = F(vv); 
    
       %do nothing
   
end

for j = 1: 150
   min1=  (min(JJ));
   max1=  (max(JJ));
   nJ(j,:) = (JJ(j,:)-min1)./(max1-min1);
end

dlmwrite('nJV1.txt', nJ,'delimiter', '\t','newline','pc')
 dlmwrite('Parin1.txt', parj,'delimiter', '\t','newline','pc')




