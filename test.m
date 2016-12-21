server1 = Servidor;
server2 = Servidor;

server1.ultimoCliente = 10;

cntServer = server1;
cntServer.ultimoCliente = 23;

server1.ultimoCliente
cntServer.ultimoCliente

%%

n = 1000;
cola = zeros(1, n);
lambda1 = 100; % llegada de 100 personas por minuto
lambda2 = 50; % el servidor se demora 1/30 minutos en atender una persona (2 segundos)




t = -log(prod(rand(1,n)))/lambda; % gamma
expo = -log(rand(1))/lambda; % exp


llegadas = exprnd(lambda1,1,n);
servidores = gamrnd();



cola(1) = max(llegadas(1) - servidor1(1), 0);
cont=0;
for i=2:n
%     cola(i) = max(llegadas(i) - servidor1(i), 0);
    cola(i) = max( cola(i-1) + llegadas(i) - servidor1(i), 0);
%     if(cola(i)>=100)
%     end
end
mean(cola)
figure()
plot(cola)