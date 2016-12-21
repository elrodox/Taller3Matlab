%definiciones inicales
lambda = 4; % 1 cliente cada 4 segundos promedio.
mu = 1; % 2.1 segundos/persona promedio de tiempo atencion ambos servidores
cantClientes = 100;
% cliente = zeros(1,cantClientes);
cliente(1,cantClientes)=Cliente();

%cosas aleatorias 
intervaloInicioCola = exprnd(lambda, 1, cantClientes); % arreglo de intervalos de tiempo aleatorios en que llega una persona
intervaloAtencion = gammaPropia(2, mu, cantClientes); % arreglo de intervalos de tiempo aleatorios en que atienden a dos persona

cliente(1) = Cliente();
cliente(1).inicioCola = 0; %llego al tiempo 00:00
cliente(1).salidaCola = cliente(1).inicioCola + 0; %se atendio altiro
cliente(1).salidaSistema = cliente(1).salidaCola + intervaloAtencion(1);
cliente(1).tiempoTotalSistema = cliente(1).salidaSistema - cliente(1).inicioCola;
cliente(1).tiempoCola = cliente(1).salidaCola - cliente(1).inicioCola;


cliente(2) = Cliente();
cliente(2).inicioCola = 0; %llego al tiempo 00:00
cliente(2).salidaCola = cliente(2).inicioCola + 0; %se atendio altiro
cliente(2).salidaSistema = cliente(2).salidaCola + intervaloAtencion(2);
cliente(2).tiempoTotalSistema = cliente(2).salidaSistema - cliente(2).inicioCola;
cliente(2).tiempoCola = cliente(2).salidaCola - cliente(2).inicioCola;

server(1) = Servidor;
server(1).tiempoOcupado = 0;
server(1).ultimoCliente = cliente(1);
server(1).tiempoOcupado = server(1).tiempoOcupado + intervaloAtencion(1);
server(1).clientCount = server(1).clientCount + 1;

server(2) = Servidor;
server(2).tiempoOcupado = 0;
server(2).ultimoCliente = cliente(2);
server(2).tiempoOcupado = server(1).tiempoOcupado + intervaloAtencion(2);
server(2).clientCount = server(1).clientCount + 1;


for i=3:cantClientes
    cliente(i) = Cliente;
    cliente(i).inicioCola = cliente(i-1).inicioCola + intervaloInicioCola(i);
    
    % buscando el servidor que se desocup� (o que se desocupar�) primero.
    if( server(1).ultimoCliente.salidaSistema <= server(2).ultimoCliente.salidaSistema)
        idxServer = 1;
    else
        idxServer = 2;
    end
    
    % si el cliente llego despu�s que sali� el ultimo cliente de dicho
    % server, entonces pasa directo, salt�ndose la cola
    if( server(idxServer).ultimoCliente.salidaSistema <= cliente(i).inicioCola )
        % el tiempo en la cola es 0.
        cliente(i).salidaCola = cliente(i).inicioCola;
    % sino a esperar en cola
    else 
        % el tiempo de salida de la cola es el mismo tiempo en que el
        % cliente que est� siendo atendido sale del sistema
        cliente(i).salidaCola = server(idxServer).ultimoCliente.salidaSistema;
    end
    cliente(i).salidaSistema = cliente(i).salidaCola + intervaloAtencion(i);
    cliente(i).tiempoTotalSistema = cliente(i).salidaSistema - cliente(i).inicioCola;
    cliente(i).tiempoCola = cliente(i).salidaCola - cliente(i).inicioCola;

    server(idxServer).ultimoCliente = cliente(i);
    server(idxServer).tiempoOcupado = server(idxServer).tiempoOcupado + intervaloAtencion(i);
    server(idxServer).clientCount = server(idxServer).clientCount + 1;
end

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

% buscando el servidor que se desocup� (o que se desocupar�) �ltimo.
if( server(1).ultimoCliente.salidaSistema >= server(2).ultimoCliente.salidaSistema)
    idxServer = 1;
else
    idxServer = 2;
end
tiempoTotal = server(idxServer).ultimoCliente.salidaSistema - cliente(1).inicioCola;
porcentajeOcupacionServer1 = server(1).tiempoOcupado / tiempoTotal;
porcentajeOcupacionServer2 = server(2).tiempoOcupado / tiempoTotal;


promClientesEnCola % 2
promTiempoSistema % 3
promTiempoCola % 4
porcentajeOcupacionServer1 % 5
porcentajeOcupacionServer2 % 5

