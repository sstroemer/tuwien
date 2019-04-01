%% VU Energiemodelle - �bung Regression (W�rmenachfrage)
% Michael Hartner, Andreas Fleischhacker

%% 
% L�scht Command Window, alle Variablen aus dem Workspace und schlie�t 
% all Abbildungen
clc 
clear all 
close all 

%% 
% L�dt das bereits erzeugte File "data_heat", das den 
% Daten in dem File "Waermenachfrage_stuendlich_Feiertage.xls" entspricht.
% Der Befehl zum Laden eines datasets kann mit 
% data_heat=dataset('XLSFile','Waermenachfrage_Uebung1.xls') druchgef�hrt 
% werden. Da das Laden aus XLSFile weitaus mehr Zeit in Anspruch nimmt, als 
% das Laden aus bereits bestehenden .mat-Files wurde dieser Befehl nicht
% angewendet.

load data_heat.mat 

%% Deskriptive Darstellungen
% Zun�chst sollten die Daten analysiert werden um m�gliche Zusammenh�nge
% bereits vor Erstellung eines Modells zu identifizieren. Die gewonnen
% Erkenntnisse helfen bei der Modellierung der Zusammenh�nge.

%%
% Hier wird die Nachfrage gegen die Temperatur geplottet - es zeigt sich
% ein Zusammenhang, aber auch gewisse Abweichungen! Die 
% Spalten des Datasets werden �ber den "." angesprochen. "data_heat.Temp"
% liefert also alle Eintr�ge der Spalte Temp im Dataset "data_heat". 
% VORSICHT!!! Sie ben�tigen den "." (Punktoperator) auch f�r elementeweise 
% Rechenoperationen. "." kann also unterschiedliche Bedeutungen haben. 
% Um etwa jeden Eintrag in einem Vektor oder einer Matrix x zu quadrieren 
% schreiben Sie x.^2
figure()  
scatter(data_heat.Temp,data_heat.Nachfrage);

%% 
% Hinzuf�gen der Titel- und Achsenbeschriftungen.
title('Scatterplot: Temperatur vs. Nachfrage')
xlabel('Temperatur [�]')
ylabel('Nachfrage [MW]')

%%
% Hinzuf�gen eines "Grids" in der Abbildung. 
grid on 

%%
% Urspr�nglich war eine Anlayse der Auswirkungen von Feiertagen angedacht -
% aufgrund von Zeitgr�nden wird diese aber in dieser �bung nicht
% durchgef�hrt, sondern nur auf die wesentlichsten Zusammenh�nge
% eingegangen. Der folgende Bereich ist deshalb auskommentiert.

figure
boxplot(data_heat.Nachfrage,data_heat.Feiertage);
d_f=mean(data_heat.Nachfrage(logical(data_heat.Feiertage)));
d_w=mean(data_heat.Nachfrage(logical(1-data_heat.Feiertage)));

%%
% Hier wird ein Boxplot der Nachfrage zu jedem Wochentag erstellt. Zur
% Erl�uterung der Darstellung in Boxplots geben Sie im Command Window
% "doc boxplot" ein. Auch die Auswirkung der Wochentage wird in den 
% Regressionsmodellen der �bung nicht ber�cksichtigt.

figure
boxplot(data_heat.Nachfrage,data_heat.Wochentag);
xlabel('Wochentag - beginnend mit Sonntag = 1 bis Samstag = 7')
ylabel('Nachfrage [MW]')
title('Verteilung der Nachfrage an unterschiedlichen Wochentagen')

%%
% Hier wird ein Boxplot zur Veranschaulichung der Verteilung der Nachfrage
% �ber die Stunden des Tages erstellt.
figure
boxplot(data_heat.Nachfrage,data_heat.Stunde);
xlabel('Stunde')
ylabel('Nachfrage [MW]')
title('Verteilung der Nachfrage an Stunden des Tages �ber ein Jahr')

%%
% Hier wird die Verteilung der Temperatur �ber die Stunden des Tages
% gezeigt. Daraus ist ersichtlich, dass die Temperatur nicht alleine f�r
% die unterschiedlichen Nachfrageniveaus �ber den Tag verantwortlich sind
figure
boxplot(data_heat.Temp,data_heat.Stunde);
xlabel('Stunde')
ylabel('Temperatur [�C]')
title('Verteilung der Temperatur an Stunden des Tages �ber ein Jahr')

%% Tipps f�r die Datenaufbereitung
% Hier werden Hinweise gegeben, wie Sie f�r die sp�tere Auswertung der
% Tabelle den Beobachtungszeitraum definieren k�nnen. Es handelt sich nur
% um einen Vorschlag, es k�nnen auch andere Herangehensweisen gew�hlt
% werden.
%
% Definition des Beobachtungszeitraums durch Erstellung eines Vektors mit 
% den gesuchten Messpunkten.
t_test=[1680:1775,6480:6575]; 

%%
% Beispiel: Auswahl aller Temperaturdaten, die in den Beobachtungszeitraum
% fallen - die Variable t_test fungiert hier als Index zur Auswahl der
% Datenpunkte. Die Variable temp_test enh�lt nun alle Temperaturmessungen 
% im Beobachtungszeitraum
temp_test=data_heat.Temp(t_test); 

%%
% Auswahl der zu einer gewissen Stunde (hier f�r Stunde 7) geh�renden 
% Datenpunkte f�r Beispiel erstellen. Der Befehel "data_heat.Stunde==7" 
% erzeugt einen logischen Vektor (Werte 0 oder 1) der als Index f�r die
% Auswahl der Daten verwendet werden kann. Mit dem ":" nach dem Komma
% werden alle Spalten des Datasets ausgew�hlt. Die Variable
% "data_Stunde_7" enth�lt nun nur mehr jene Messungen, die zur Stunde 7 
% durchgef�hrt wurden.
data_Stunde_7=data_heat(data_heat.Stunde==7,:); 

%% Durchf�hrung der Regressionsanalysen
% Ab hier sind die Analysen durchzuf�hren.
% Vorschlag: Verwenden Sie f�r Ihre Analysen den Befehl "fitlm". F�r die
% Online-Hilfe zu dem Befehl geben Sie einfach doc fitlm in das Command
% Window ein. Sehr hilfreich ist auch das File "Interpret Linear Regression
% Results", dass Sie in den Unterlagen zu der �bung finden. Einen Gro�teil
% der Syntax bzw. ganze Codeabschnitte k�nnen Sie aus dem Beispiel-File zur
% Absch�tzung der Einflussfaktoren auf Strompreise (ebenfalls in den
% �bungsunterlagen) �bernehmen. 
%
% Sie k�nnen das abzugebene Protokoll mithilfe von Matlab Publishing 
% erstellen: <https://de.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html>
% 
% Viel Erfolg bei der �bung!

