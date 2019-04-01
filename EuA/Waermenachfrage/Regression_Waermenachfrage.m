%% VU Energiemodelle - Übung Regression (Wärmenachfrage)
% Michael Hartner, Andreas Fleischhacker

%% 
% Löscht Command Window, alle Variablen aus dem Workspace und schließt 
% all Abbildungen
clc 
clear all 
close all 

%% 
% Lädt das bereits erzeugte File "data_heat", das den 
% Daten in dem File "Waermenachfrage_stuendlich_Feiertage.xls" entspricht.
% Der Befehl zum Laden eines datasets kann mit 
% data_heat=dataset('XLSFile','Waermenachfrage_Uebung1.xls') druchgeführt 
% werden. Da das Laden aus XLSFile weitaus mehr Zeit in Anspruch nimmt, als 
% das Laden aus bereits bestehenden .mat-Files wurde dieser Befehl nicht
% angewendet.

load data_heat.mat 

%% Deskriptive Darstellungen
% Zunächst sollten die Daten analysiert werden um mögliche Zusammenhänge
% bereits vor Erstellung eines Modells zu identifizieren. Die gewonnen
% Erkenntnisse helfen bei der Modellierung der Zusammenhänge.

%%
% Hier wird die Nachfrage gegen die Temperatur geplottet - es zeigt sich
% ein Zusammenhang, aber auch gewisse Abweichungen! Die 
% Spalten des Datasets werden über den "." angesprochen. "data_heat.Temp"
% liefert also alle Einträge der Spalte Temp im Dataset "data_heat". 
% VORSICHT!!! Sie benötigen den "." (Punktoperator) auch für elementeweise 
% Rechenoperationen. "." kann also unterschiedliche Bedeutungen haben. 
% Um etwa jeden Eintrag in einem Vektor oder einer Matrix x zu quadrieren 
% schreiben Sie x.^2
figure()  
scatter(data_heat.Temp,data_heat.Nachfrage);

%% 
% Hinzufügen der Titel- und Achsenbeschriftungen.
title('Scatterplot: Temperatur vs. Nachfrage')
xlabel('Temperatur [°]')
ylabel('Nachfrage [MW]')

%%
% Hinzufügen eines "Grids" in der Abbildung. 
grid on 

%%
% Ursprünglich war eine Anlayse der Auswirkungen von Feiertagen angedacht -
% aufgrund von Zeitgründen wird diese aber in dieser Übung nicht
% durchgeführt, sondern nur auf die wesentlichsten Zusammenhänge
% eingegangen. Der folgende Bereich ist deshalb auskommentiert.

figure
boxplot(data_heat.Nachfrage,data_heat.Feiertage);
d_f=mean(data_heat.Nachfrage(logical(data_heat.Feiertage)));
d_w=mean(data_heat.Nachfrage(logical(1-data_heat.Feiertage)));

%%
% Hier wird ein Boxplot der Nachfrage zu jedem Wochentag erstellt. Zur
% Erläuterung der Darstellung in Boxplots geben Sie im Command Window
% "doc boxplot" ein. Auch die Auswirkung der Wochentage wird in den 
% Regressionsmodellen der Übung nicht berücksichtigt.

figure
boxplot(data_heat.Nachfrage,data_heat.Wochentag);
xlabel('Wochentag - beginnend mit Sonntag = 1 bis Samstag = 7')
ylabel('Nachfrage [MW]')
title('Verteilung der Nachfrage an unterschiedlichen Wochentagen')

%%
% Hier wird ein Boxplot zur Veranschaulichung der Verteilung der Nachfrage
% über die Stunden des Tages erstellt.
figure
boxplot(data_heat.Nachfrage,data_heat.Stunde);
xlabel('Stunde')
ylabel('Nachfrage [MW]')
title('Verteilung der Nachfrage an Stunden des Tages über ein Jahr')

%%
% Hier wird die Verteilung der Temperatur über die Stunden des Tages
% gezeigt. Daraus ist ersichtlich, dass die Temperatur nicht alleine für
% die unterschiedlichen Nachfrageniveaus über den Tag verantwortlich sind
figure
boxplot(data_heat.Temp,data_heat.Stunde);
xlabel('Stunde')
ylabel('Temperatur [°C]')
title('Verteilung der Temperatur an Stunden des Tages über ein Jahr')

%% Tipps für die Datenaufbereitung
% Hier werden Hinweise gegeben, wie Sie für die spätere Auswertung der
% Tabelle den Beobachtungszeitraum definieren können. Es handelt sich nur
% um einen Vorschlag, es können auch andere Herangehensweisen gewählt
% werden.
%
% Definition des Beobachtungszeitraums durch Erstellung eines Vektors mit 
% den gesuchten Messpunkten.
t_test=[1680:1775,6480:6575]; 

%%
% Beispiel: Auswahl aller Temperaturdaten, die in den Beobachtungszeitraum
% fallen - die Variable t_test fungiert hier als Index zur Auswahl der
% Datenpunkte. Die Variable temp_test enhält nun alle Temperaturmessungen 
% im Beobachtungszeitraum
temp_test=data_heat.Temp(t_test); 

%%
% Auswahl der zu einer gewissen Stunde (hier für Stunde 7) gehörenden 
% Datenpunkte für Beispiel erstellen. Der Befehel "data_heat.Stunde==7" 
% erzeugt einen logischen Vektor (Werte 0 oder 1) der als Index für die
% Auswahl der Daten verwendet werden kann. Mit dem ":" nach dem Komma
% werden alle Spalten des Datasets ausgewählt. Die Variable
% "data_Stunde_7" enthält nun nur mehr jene Messungen, die zur Stunde 7 
% durchgeführt wurden.
data_Stunde_7=data_heat(data_heat.Stunde==7,:); 

%% Durchführung der Regressionsanalysen
% Ab hier sind die Analysen durchzuführen.
% Vorschlag: Verwenden Sie für Ihre Analysen den Befehl "fitlm". Für die
% Online-Hilfe zu dem Befehl geben Sie einfach doc fitlm in das Command
% Window ein. Sehr hilfreich ist auch das File "Interpret Linear Regression
% Results", dass Sie in den Unterlagen zu der Übung finden. Einen Großteil
% der Syntax bzw. ganze Codeabschnitte können Sie aus dem Beispiel-File zur
% Abschätzung der Einflussfaktoren auf Strompreise (ebenfalls in den
% Übungsunterlagen) übernehmen. 
%
% Sie können das abzugebene Protokoll mithilfe von Matlab Publishing 
% erstellen: <https://de.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html>
% 
% Viel Erfolg bei der Übung!

