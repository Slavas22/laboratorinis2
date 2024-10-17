clear all    
close all    

% Sukuriami duomenys
x = 0.1: 1/22: 1;    % Sukuriamas 20 skaičių vektorius nuo 0.1 iki 1
y = ((1 + 0.6 * sin(2 * pi * x / 0.7)) + 0.3 * sin(2 * pi * x)) / 2;    % Apskaičiuojama norima išėjimo reikšmė

figure(1)    
plot(x, y)    
grid on    

% Mokymų skaičius
mokymu_sk = 1500;    % Nustatomas mokymų ciklų skaičius

% Pirmas sluoksnis
w11_1 = rand(1); w21_1 = rand(1);    % Atsitiktiniai svoriai pirmajam sluoksniui
w31_1 = rand(1); w41_1 = rand(1);    % atsitiktiniai svoriai
b1_1 = rand(1); b2_1 = rand(1);    % Atsitiktiniai svoriai bendrai sumai
b3_1 = rand(1); b4_1 = rand(1);    % atsitiktiniai svoriai bendrai sumai

% Antras sluoksnis
w11_2 = rand(1); w12_2 = rand(1); w13_2 = rand(1); w14_2 = rand(1);    % Atsitiktiniai svoriai antrajam sluoksniui
b1_2 = rand(1);    % Atsitiktinis svoris bendrai sumai
eta = 0.1;    % Mokymosi greitis
Y = zeros(1, length(x));    % Inicializuojamas išėjimo vektorius su nulinėmis reikšmėmis

% Perceptronas
for j = 1:mokymu_sk    % Mokymų ciklas
    for i = 1:length(x)    % Kiekvienai įėjimo reikšmei
        
        % Pirmas paslėptasis sluoksnis
        v1_1 = w11_1 * x(i) + b1_1;    % Apskaičiuojama bendra suma pirmam neuronui
        v2_1 = w21_1 * x(i) + b2_1;    % Apskaičiuojama bendra suma antram neuronui
        v3_1 = w31_1 * x(i) + b3_1;    % Apskaičiuojama bendra suma trečiam neuronui
        v4_1 = w41_1 * x(i) + b4_1;    % Apskaičiuojama bendra suma ketvirtam neuronui

        % Paslėptojo sluoksnio aktyvavimo funkcija
        y1_1 = tanh(v1_1);    % Hiperbolinio tangento funkcija pirmam neuronui
        y2_1 = tanh(v2_1);    % Hiperbolinio tangento funkcija antram neuronui
        y3_1 = tanh(v3_1);    % Hiperbolinio tangento funkcija trečiam neuronui
        y4_1 = tanh(v4_1);    % Hiperbolinio tangento funkcija ketvirtam neuronui
        
        % Antras išėjimo sluoksnis
        v1_2 = y1_1 * w11_2 + y2_1 * w12_2 + y3_1 * w13_2 + y4_1 * w14_2 + b1_2;    % Apskaičiuojama bendra suma išėjimo neuronui
        
        % Išėjimo sluoksnio aktyvavimo funkcija
        y1_2 = v1_2;    % Tiesinė aktyvavimo funkcija (tiesiog priskiriame)
        Y(i) = y1_2;    % Išsaugome išėjimo reikšmę
        
        % Klaida
        e = y(i) - y1_2;    % Apskaičiuojama klaida
        
        % Svorio atnaujinimas
        delta1_2 = e;    % Klaida
        
        % Paslėptojo sluoksnio klaidos gradientas
        delta1_1 = (1 - tanh(v1_1)^2) * delta1_2 * w11_2;    % Pirmo neurono gradientas
        delta2_1 = (1 - tanh(v2_1)^2) * delta1_2 * w12_2;    % Antro neurono gradientas
        delta3_1 = (1 - tanh(v3_1)^2) * delta1_2 * w13_2;    % Trečio neurono gradientas
        delta4_1 = (1 - tanh(v4_1)^2) * delta1_2 * w14_2;    % Ketvirto neurono gradientas
        
        % Atnaujinami svoriai
        w11_2 = w11_2 + eta * delta1_2 * y1_1;    % Atnaujinamas svoris pirmam išėjimo neuronui
        w12_2 = w12_2 + eta * delta1_2 * y2_1;    % Atnaujinamas svoris antram išėjimo neuronui
        w13_2 = w13_2 + eta * delta1_2 * y3_1;    % Atnaujinamas svoris trečiam išėjimo neuronui
        w14_2 = w14_2 + eta * delta1_2 * y4_1;    % Atnaujinamas svoris ketvirtam išėjimo neuronui
        b1_2 = b1_2 + eta * delta1_2;    % Atnaujinamas svoris išėjimo sluoksniui
        
        % Paslėptojo sluoksnio svorių atnaujinimas
        w11_1 = w11_1 + eta * delta1_1 * x(i);    % Atnaujinamas svoris pirmam paslėptojo sluoksnio neuronui
        w21_1 = w21_1 + eta * delta2_1 * x(i);    % Atnaujinamas svoris antram paslėptojo sluoksnio neuronui
        w31_1 = w31_1 + eta * delta3_1 * x(i);    % Atnaujinamas svoris trečiam paslėptojo sluoksnio neuronui
        w41_1 = w41_1 + eta * delta4_1 * x(i);    % Atnaujinamas svoris ketvirtam paslėptojo sluoksnio neuronui
        b1_1 = b1_1 + eta * delta1_1;    % Atnaujinamas bias svoris pirmam paslėptojo sluoksnio neuronui
        b2_1 = b2_1 + eta * delta2_1;    % Atnaujinamas bias svoris antram paslėptojo sluoksnio neuronui
        b3_1 = b3_1 + eta * delta3_1;    % Atnaujinamas bias svoris trečiam paslėptojo sluoksnio neuronui
        b4_1 = b4_1 + eta * delta4_1;    % Atnaujinamas bias svoris ketvirtam paslėptojo sluoksnio neuronui
    end
end

hold on    
plot(x, Y);    
legend('Pradinis', 'Gautas')    
hold off    

% Testavimas 
test_x = linspace(0.1, 1, 200);  
test_y = ((1 + 0.6 * sin(2 * pi * test_x / 0.7)) + 0.3 * sin(2 * pi * test_x)) / 2; 
Y_test = zeros(1, length(test_x));

for i = 1:length(test_x)
    % Pirmas paslėptasis sluoksnis
    v1_1 = w11_1 * test_x(i) + b1_1;
    v2_1 = w21_1 * test_x(i) + b2_1;
    v3_1 = w31_1 * test_x(i) + b3_1;
    v4_1 = w41_1 * test_x(i) + b4_1;
    
    % Paslėptojo sluoksnio aktyvavimo funkcija
    y1_1 = tanh(v1_1);
    y2_1 = tanh(v2_1);
    y3_1 = tanh(v3_1);
    y4_1 = tanh(v4_1);
    
    % išėjimo sluoksnis
    v1_2 = y1_1 * w11_2 + y2_1 * w12_2 + y3_1 * w13_2 + y4_1 * w14_2 + b1_2;
    
    % Išėjimo sluoksnio aktyvavimo funkcija
    y1_2 = v1_2;
    Y_test(i) = y1_2;
end

figure(2)
plot(test_x, test_y, 'b', test_x, Y_test, 'r--')
legend('Norima reikšmė', 'Prognozuota reikšmė')
title('Testavimo rezultatai')
