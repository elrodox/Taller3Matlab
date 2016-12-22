%definiciones inicales
lambda = 4; % 1 cliente cada 4 segundos promedio.
muGamma = 1; % 2.1 segundos/persona promedio de tiempo atencion ambos servidores
nGamma = 2;
% cantClientes = 100;
% cliente = zeros(1,cantClientes);
cliente(1,1000000)=Cliente();

%cosas aleatorias 
% intervaloInicioCola = exprnd(lambda, 1, cantClientes); % arreglo de intervalos de tiempo aleatorios en que llega una persona
% intervaloAtencion = gammaPropia(2, mu, cantClientes); % arreglo de intervalos de tiempo aleatorios en que atienden a dos persona

% cliente(1) = Cliente();
% cliente(1).inicioCola = intervaloInicioCola(i); %llego al tiempo 00:00
% cliente(1).salidaCola = cliente(1).inicioCola + 0; %se atendio altiro
% cliente(1).salidaSistema = cliente(1).salidaCola + intervaloAtencion(1);
% cliente(1).tiempoTotalSistema = cliente(1).salidaSistema - cliente(1).inicioCola;
% cliente(1).tiempoCola = cliente(1).salidaCola - cliente(1).inicioCola;
% 
% cliente(2) = Cliente();
% cliente(2).inicioCola = 0; %llego al tiempo 00:00
% cliente(2).salidaCola = cliente(2).inicioCola + 0; %se atendio altiro
% cliente(2).salidaSistema = cliente(2).salidaCola + intervaloAtencion(2);
% cliente(2).tiempoTotalSistema = cliente(2).salidaSistema - cliente(2).inicioCola;
% cliente(2).tiempoCola = cliente(2).salidaCola - cliente(2).inicioCola;

server(1) = Servidor;
server(1).tiempoOcupado = 0;
server(1).ultimaSalidaSistema = 0;
% server(1).clientCount = 0;

server(2) = Servidor;
server(2).tiempoOcupado = 0;
server(2).ultimaSalidaSistema = 0;
% server(2).clientCount = 0;

tiempoLimite = 400;
tiempoTotal = 0;
i = 1;
inicioColaClientePrevio = 0;
while( tiempoTotal < tiempoLimite )
    cliente(i) = Cliente;
    intervaloInicioCola = exprnd(lambda);
    cliente(i).inicioCola = inicioColaClientePrevio + intervaloInicioCola;
    
    % buscando el servidor que se desocupó (o que se desocupará) primero.
    if( server(1).ultimaSalidaSistema <= server(2).ultimaSalidaSistema)
        idxServer = 1;
    else
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
    end
    intervaloAtencion = gammaPropia(nGamma, muGamma);
    cliente(i).salidaSistema = cliente(i).salidaCola + intervaloAtencion;
    cliente(i).tiempoTotalSistema = cliente(i).salidaSistema - cliente(i).inicioCola;
    cliente(i).tiempoCola = cliente(i).salidaCola - cliente(i).inicioCola;

%     server(idxServer).ultimoCliente = cliente(i);
    server(idxServer).tiempoOcupado = server(idxServer).tiempoOcupado + intervaloAtencion;
%     server(idxServer).clientCount = server(idxServer).clientCount + 1;
    
    % index de server que tuvo la última salida más tarde
    if( server(1).ultimaSalidaSistema >= server(2).ultimaSalidaSistema)
        idxServer = 1;
    else
        idxServer = 2;
    end
    
    tiempoTotal = max([tiempoTotal cliente(i).salidaSistema server(idxServer).ultimaSalidaSistema]);
    i = i+1;
    inicioColaClientePrevio = cliente(i).inicioCola;
end
cantClientes = i;

promClientesEnCola = 0; % 2
promTiempoSistema = 0; % 3
promTiempoCola = 0; % 4
porcentajeOcupacionServer1 = 0; % 5
porcentajeOcupacionServer2 = 0; % 5

for i=1: cantClientes
    if( cliente(i).tiempoCola > 0 )
        promClientesEnCola = promClientesEnCola + 1;
    end
    promTiempoSistema = promTiempoSistema + cliente(i).tiempoTotalSistema;
    promTiempoCola = promTiempoCola + cliente(i).tiempoCola;
end

promClientesEnCola = promClientesEnCola/cantClientes; % 2
promTiempoSistema = promTiempoSistema/cantClientes; % 3
promTiempoCola = promTiempoCola/cantClientes; % 4

% buscando el servidor que se desocupó (o que se desocupará) último.
if( server(1).ultimaSalidaSistema >= server(2).ultimaSalidaSistema)
    idxServer = 1;
else
    idxServer = 2;
end
tiempoTotal = server(idxServer).ultimaSalidaSistema - cliente(1).inicioCola;
porcentajeOcupacionServer1 = server(1).tiempoOcupado / tiempoTotal;
porcentajeOcupacionServer2 = server(2).tiempoOcupado / tiempoTotal;

cantClientes
promClientesEnCola % 2
promTiempoSistema % 3
promTiempoCola % 4
porcentajeOcupacionServer1 % 5
porcentajeOcupacionServer2 % 5


