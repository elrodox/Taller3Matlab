function result = gammaPropia(n, lambda, cant)
%GAMMAPROPIA Summary of this function goes here
%   Detailed explanation goes here
    result = zeros(1, cant);
    for i=1:cant
        result(i) = -log(prod(rand(1,n)))/lambda;
    end
end

