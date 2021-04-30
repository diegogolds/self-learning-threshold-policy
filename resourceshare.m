B = 41; %maximum number of tasks per server pool (much larger than lambda). 
N = 500; %number of server pools.

%% THRESHOLD:
Qthr = zeros(1, B); %average occupancy state.
Tf = 0;
for j = 1 : 15
    load(strcat('thr', num2str(j)), 'T', 'S', 'arrivals');
    dT = diff(T);
    Qthr = Qthr + dT * S(1 : end - 1, :);
    Tf = Tf + T(end) - T(1);
end
Qthr = Qthr / (Tf * N);
x = 1 : B - 1;
Zthr = diff(Qthr) .* x;
Zthr = Zthr / sum(Zthr);
%Histogram;
b = zeros(1, 3 * (B - 1) + 2);
H = zeros(1, 3 * (B - 1) + 2);
for j = 1 : B - 1
    b(1 + 3 * j - 2) = j - 0.5;
    b(1 + 3 * j - 1) = j;
    b(1 + 3 * j) = j + 0.5;
    H(1 + 3 * j - 2) = Zthr(j);
    H(1 + 3 * j - 1) = Zthr(j);
    H(1 + 3 * j) = Zthr(j);
end
b(1) = 0.5;
b(3 * (B - 1) + 2) = B - 0.5;
H = 3 * H / sum(H);
%Plot:
H = flip(H, 2);
plot(b, H);
hold on;
b = 1 : B - 1;
c = round(1 ./ b, 3);
c = flip(c);
set(gca,'XTick', b);
set(gca,'XTickLabel', c);

%% JSQ:
Qjsq = zeros(1, B); %average of occupancy state.
Tf = 0;
for j = 1 : 15
    load(strcat('jsq', num2str(j)), 'T', 'S', 'arrivals');
    dT = diff(T);
    Qjsq = Qjsq + dT * S(1 : end - 1, :);
    Tf = Tf + T(end) - T(1);
end
Qjsq = Qjsq / (Tf * N);
x = 1 : B - 1;
Zjsq = diff(Qjsq) .* x;
Zjsq = Zjsq / sum(Zjsq);
%Histogram;
b = zeros(1, 3 * (B - 1) + 2);
H = zeros(1, 3 * (B - 1) + 2);
for j = 1 : B - 1
    b(1 + 3 * j - 2) = j - 0.5;
    b(1 + 3 * j - 1) = j;
    b(1 + 3 * j) = j + 0.5;
    H(1 + 3 * j - 2) = Zjsq(j);
    H(1 + 3 * j - 1) = Zjsq(j);
    H(1 + 3 * j) = Zjsq(j);
end
b(1) = 0.5;
b(3 * (B - 1) + 2) = B - 0.5;
H = 3 * H / sum(H);
%Plot:
H = flip(H, 2);
plot(b, H);
hold on;
b = 1 : B - 1;
c = round(1 ./ b, 3);
c = flip(c);
set(gca,'XTick', b);
set(gca,'XTickLabel', c);

%% RANDOM:
load('rnd1');
Qrnd = zeros(1, B); %average occupancy state.
Tf = 0;
for j = 1 : 5
    load(strcat('rnd', num2str(j)), 'T', 'S');
    dT = diff(T);
    Qrnd = Qrnd + dT * S(1 : end - 1, :);
    Tf = Tf + T(end) - T(1);
end
Qrnd = Qrnd / (Tf * N);
x = 1 : B - 1;
Zrnd = diff(Qrnd) .* x;
Zrnd = Zrnd / sum(Zrnd);
%Histogram;
b = zeros(1, 3 * (B - 1) + 2);
H = zeros(1, 3 * (B - 1) + 2);
for j = 1 : B - 1
    b(1 + 3 * j - 2) = j - 0.5;
    b(1 + 3 * j - 1) = j;
    b(1 + 3 * j) = j + 0.5;
    H(1 + 3 * j - 2) = Zrnd(j);
    H(1 + 3 * j - 1) = Zrnd(j);
    H(1 + 3 * j) = Zrnd(j);
end
b(1) = 0.5;
b(3 * (B - 1) + 2) = B - 0.5;
H = 3 * H / sum(H);
%Plot:
H = flip(H, 2);
plot(b, H);
hold on;
b = 1 : B - 1;
c = round(1 ./ b, 3);
c = flip(c);
set(gca,'XTick', b);
set(gca,'XTickLabel', c);

%% POWER-OF-2:
load('pwr1');
Qpwr = zeros(1, B); %average occupancy state.
Tf = 0;
for j = 1 : 5
    load(strcat('pwr', num2str(j)), 'T', 'S');
    dT = diff(T);
    Qpwr = Qpwr + dT * S(1 : end - 1, :);
    Tf = Tf + T(end) - T(1);
end
Qpwr = Qpwr / (Tf * N);
x = 1 : B - 1;
Zpwr = diff(Qpwr) .* x;
Zpwr = Zpwr / sum(Zpwr);
%Histogram;
b = zeros(1, 3 * (B - 1) + 2);
H = zeros(1, 3 * (B - 1) + 2);
for j = 1 : B - 1
    b(1 + 3 * j - 2) = j - 0.5;
    b(1 + 3 * j - 1) = j;
    b(1 + 3 * j) = j + 0.5;
    H(1 + 3 * j - 2) = Zpwr(j);
    H(1 + 3 * j - 1) = Zpwr(j);
    H(1 + 3 * j) = Zpwr(j);
end
b(1) = 0.5;
b(3 * (B - 1) + 2) = B - 0.5;
%Plot:
H = flip(H, 2);
plot(b, H);
hold on;
b = 1 : B - 1;
c = round(1 ./ b, 3);
c = flip(c);
set(gca,'XTick', b);
set(gca,'XTickLabel', c);

legend('Threshold', 'JSQ', 'Random', 'Power-of-2');
