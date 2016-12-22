
%definiciones inicales
lambda = 4; % 1 cliente cada 4 segundos promedio.
muGamma = 1.1; % 1.1 segundos/persona promedio de tiempo atencion ambos servidores
nGamma = 2;
cliente(1,10000)=Cliente();

server(1) = Servidor;
server(1).tiempoOcupado = 0;
server(1).ultimaSalidaSistema = 0;

server(2) = Servidor;
server(2).tiempoOcupado = 0;
server(2).ultimaSalidaSistema = 0;

tiempoLimite = 500;
tiempoTotal = 0;
i = 1;
inicioColaClientePrevio = 0;

sumaClientesEnCola = 0;
sumaTiempoSistema = 0; % 3
sumaTiempoCola = 0; % 4
sumaOcupacionServer1 = 0; % 5
sumaOcupacionServer2 = 0; % 5


while( tiempoTotal < tiempoLimite )
    cliente(i) = Cliente;
    intervaloInicioCola = exprnd(lambda);
    cliente(i).inicioCola = inicioColaClientePrevio + intervaloInicioCola;
    
    % buscando el servidor que se desocupó (o que se desocupará) primero.
    intervaloAtencion = gammaPropia(nGamma, muGamma);
    if( server(1).ultimaSalidaSistema <= server(2).ultimaSalidaSistema)
        sumaOcupacionServer1 = sumaOcupacionServer1 + intervaloAtencion;
        idxServer = 1;
    else
        sumaOcupacionServer2 = sumaOcupacionServer2 + intervaloAtencion;
        idxServer = 2;
    end
    
    % si el cliente llego después que salió el ultimo cliente de dicho
    % server, entonces pasa directo, saltándose la cola
    if( server(idxServer).ultimaSalidaSistema <= cliente(i).inicioCola )
        % el tiempo en la cola es 0.
        cliente(i).salidaCola = cliente(i).inicioCola;
    % sino a esperar en cola
    else 
        % el tiempo de salida de la cola es el mismo tiempo en que el
        % cliente que está siendo atendido sale del sistema
        cliente(i).salidaCola = server(idxServer).ultimaSalidaSistema;
        sumaClientesEnCola = sumaClientesEnCola + 1;
    end
    
    cliente(i).salidaSistema = cliente(i).salidaCola + intervaloAtencion;
    cliente(i).tiempoTotalSistema = cliente(i).salidaSistema - cliente(i).inicioCola;
    cliente(i).tiempoCola = cliente(i).salidaCola - cliente(i).inicioCola;
    
    sumaTiempoSistema = sumaTiempoSistema + cliente(i).tiempoTotalSistema;
    sumaTiempoCola = sumaTiempoCola + cliente(i).tiempoCola;

    server(idxServer).ultimaSalidaSistema = cliente(i).salidaSistema;
    server(idxServer).tiempoOcupado = server(idxServer).tiempoOcupado + intervaloAtencion;
    
    % index de server que tuvo la última salida más tarde
    
    if( server(1).ultimaSalidaSistema >= server(2).ultimaSalidaSistema)
        idxServer = 1;
    else
        idxServer = 2;
    end
    
    tiempoTotal = max([tiempoTotal cliente(i).salidaSistema server(idxServer).ultimaSalidaSistema]);
    inicioColaClientePrevio = cliente(i).inicioCola;
    i = i+1;
end
cantClientes = i;

promClientesEnCola = sumaClientesEnCola / cantClientes;
promTiempoSistema = sumaTiempoSistema / cantClientes;
promTiempoCola = sumaTiempoCola / cantClientes;


if( server(1).ultimaSalidaSistema >= server(2).ultimaSalidaSistema)
    idxServer = 1;
else
    idxServer = 2;
end
tiempoTotal = server(idxServer).ultimaSalidaSistema - cliente(1).inicioCola;
porcentajeOcupacionServer1 = sumaOcupacionServer1 / tiempoTotal; % 5
porcentajeOcupacionServer2 = sumaOcupacionServer2 / tiempoTotal; % 5


cantClientes % 1
promClientesEnCola % 2
promTiempoSistema % 3
promTiempoCola % 4
porcentajeOcupacionServer1 % 5
porcentajeOcupacionServer2% 5


% promCantClientesMonteCarlo(indexMonteCarlo) = cantClientes; % 1
% promClientesEnColaMonteCarlo(indexMonteCarlo) = promClientesEnCola; % 2
% promTiempoSistemaMonteCarlo(indexMonteCarlo) = promTiempoSistema; % 3
% promTiempoColaMonteCarlo(indexMonteCarlo) = promTiempoCola; % 4
% porcentajeOcupacionServer1MonteCarlo(indexMonteCarlo) = porcentajeOcupacionServer1; % 5
% porcentajeOcupacionServer2MonteCarlo(indexMonteCarlo) = porcentajeOcupacionServer2;% 5
% 
% end
% 
% mean(promCantClientesMonteCarlo)
% mean(promClientesEnColaMonteCarlo)
% mean(promTiempoSistemaMonteCarlo)
% mean(promTiempoColaMonteCarlo)
% mean(porcentajeOcupacionServer1MonteCarlo)
% mean(porcentajeOcupacionServer2MonteCarlo)
% 
