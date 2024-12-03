clc;            
clear all;      
close all;      


x = 0.1:1/22:1; % Sukuria vektorių nuo 0.1 iki 1 su žingsniu 1/22, turintį 22 taškus  
y = ((1 + 0.6*sin(2*pi*x/0.7)) + 0.3*sin(2*pi*x))/2; % Tikslinė funkcija  
figure(1)  
plot(x, y, 'b-', 'LineWidth', 2) % Vaizduoja tikslinę funkciją mėlyna linija  
grid on; % Įjungiame tinklelį grafike  
hold on; % Išlaiko esamą grafiką, kad galėtume pridėti kitus elementus  

% Pradiniai svoriai (atsitiktinai inicializuojami)  
w1 = randn(1); % Pirmos Gauso funkcijos svoris  
w2 = randn(1); % Antros Gauso funkcijos svoris  
b = randn(1);  % Bias (nuokrypis)  

% Gauso funkcijų parametrų nustatymas pagal pradines funkcijos grafikas  
c1 = 0.2;  % Pirmos Gauso funkcijos centras  
c2 = 0.9;  % Antros Gauso funkcijos centras  
r1 = 0.15; % Pirmos Gauso funkcijos spindulys  
r2 = 0.15; % Antros Gauso funkcijos spindulys  

% Mokymo parametrai  
eta = 0.01;                % Mokymosi greitis (learning rate)  
max_iter = 1000;         % Maksimalus iteracijų skaičius  
tolerance = 1e-6;         % Tolerancijos riba (klaidos ribinė reikšmė)  

% Inicijuojame klaidos vektorių, kad galėtume stebėti mokymą  
error_history = zeros(1, max_iter);  

% Mokymo procesas  
for j = 1:max_iter  
    total_error = 0; % Inicializuojame bendrą klaidą kiekvienai iteracijai  
    
    % Mokymas per visus duomenis  
    for n = 1:length(x)  
        % Gauso funkcijos skaičiavimas  
        F1 = exp(-((x(n)-c1)^2)/(2*(r1^2)));  
        F2 = exp(-((x(n)-c2)^2)/(2*(r2^2)));  
        
        % Tinklo išėjimo skaičiavimas su tiesine aktyvavimo funkcija  
        Y(n) = F1*w1 + F2*w2 + b; % tiesinė aktyvavimo funkcija  
        
        % Klaidos skaičiavimas  
        e = y(n) - Y(n);  
        total_error = total_error + e^2; % Sužymime kvadratinę klaidą  
        
        % Svorių atnaujinimas remiantis klaida ir mokymosi žingsniu  
        w1 = w1 + eta * e * F1;  
        w2 = w2 + eta * e * F2;  
        b  = b  + eta * e;  
    end  
    
    % Vidutinės kvadratinės klaidos (MSE) apskaičiavimas  
    mse = total_error / length(x);  
    error_history(j) = mse; % Išsaugome klaidą istorijoje  
    
    % Patikriname, ar klaida yra maža pakankamai  
    if mse < tolerance  
        fprintf('Mokymas sustabdytas po %d iteracijų, MSE: %f\n', j, mse);  
        error_history = error_history(1:j); % Ištriname nereikalingas klaidų reikšmes  
        break; % Išeiname iš mokymo ciklo  
    end  
    
    % Kiekvienų 1000 iteracijų spausdiname klaidos reikšmę  
    if mod(j, 1000) == 0  
        fprintf('Iteracija: %d, MSE: %f\n', j, mse);  
    end  
end  

% Rezultato vizualizavimas mokymo metu  
figure(2)  
plot(1:length(error_history), error_history, 'k-', 'LineWidth', 2)  
title('Klaidos istorija');  
xlabel('Iteracija');  
ylabel('Vidutinė kvadratinė klaida (MSE)');  
grid on;  

% Testavimo dalis  
x_test = 0.1:1/100:1;          % Sukuriame išplėstą įvesties vektorių testavimui  
Y_test = zeros(1, length(x_test)); % Inicializuojame tinklo išėjimo vektorių testui  

% Skaičiuojame tinklo išėjimą testavimo duomenims  
for i = 1:length(x_test)  
    F1_test = exp(-((x_test(i)-c1)^2)/(2*(r1^2)));  
    F2_test = exp(-((x_test(i)-c2)^2)/(2*(r2^2)));  
    Y_test(i) = F1_test*w1 + F2_test*w2 + b; % tiesinė aktyvavimo funkcija  
end  

% Vaizduojame mokymosi rezultatą  
figure(1)  
plot(x_test, Y_test, 'r--', 'LineWidth', 2) % Vaizduojame tinklo išėjimą raudona stipriomis linijomis  
hold off  
xlabel('Įvestis (x)');  
ylabel('Išėjimas (Y)');  
legend('Tikrasis atsakas', 'Prognozuotas atsakas', 'Location', 'best');  
title('Spindulio tipo bazinių funkcijų tinklas');  