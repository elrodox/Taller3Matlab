classdef Servidor
    %CLIENTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ultimaSalidaSistema
        ultimoCliente
        clientes
        tiempoOcupado = 0;
        clientCount = 0;
    end
    
    methods
        function addClient(obj, client)
            obj.clientCount = obj.clientCount+1;
            obj.clientes(obj.clientCount) = client;
        end
    end
    
end
