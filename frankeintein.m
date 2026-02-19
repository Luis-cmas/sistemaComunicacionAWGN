%codigo frankeistein
close all 
clear all

alfabeto = [0 5];
%tomando un alfabeto equiprobable
pdf=ones(1,length(alfabeto))/length(alfabeto);

%vemos las divisiones que tendra el alfabeto
umbral = abs(max(alfabeto)-min(alfabeto))/length(alfabeto);

for SNR=-20:.1:20
    N=1000;

    x = randsrc(1,N,[alfabeto;pdf]);%creamos la fuente
    pot_x=sum ((alfabeto.^2).*pdf);
    %codificacion (7,4)
    
    
    %SNR=10;

    pot_n=pot_x*10^(-SNR/10);
    ruido = randn(1,N)*sqrt(pot_n);%generamos ruido
    y=x+ruido;%agregamos ruido a la fuente al pasarlo por el canal

    %haciendo con alfabeto variable
    bit=zeros(1,length(y));
    %deteccion del bit
    for j=1:N
        for i=1:length(alfabeto)
            distancia = abs(y(j) - alfabeto(i));
            if (distancia <= umbral) 
                bit(j)=alfabeto(i);
            end


        end
    end
    
    error = sum(x~=bit);
    p_e=error/N ;
    hold on
    plot(SNR,p_e,'*');
    
    title('probabilidad de error')
    xlabel('SNR');
    ylabel('probabilidad de error');
end 
%obtenemos las matriz de probabilidades
m_p=zeros(length(alfabeto));
for k=1:length(alfabeto)
    for j=1:length(alfabeto)

        for i=1:N
            if(x(i)== bit(i) & x(i)==alfabeto(j))
                m_p(k,j)= m_p(k,j)+1;
            end
            
        end
    end
end
m_p = m_p/N;
disp('matriz de probabilidades');
m_p




[Ne,Ns] = size(m_p);
Pe=ones(Ne,1)/Ne;
He=-sum(Pe.*log2(Pe));
disp(['entropia de entrada(x)=' num2str(He) ' bits/simbolo']);

Ps=zeros(Ns,1);
for ks=1:Ns
    for ke=1:Ne
        Ps(ks)=Ps(ks)+Pe(ke)*m_p(ke,ks);
        
    end
end




Hs=-sum(Ps.*log2(Ps));
disp(['entropia de salida(y)=' num2str(Hs) ' bits/simbolo']);
