%% Read daily activity from Rodent Activity Detector
% This function reads the CSV output from the RAD, converts this data into a
% .mat file, and shows and actigram for the duration of the .csv file

InPath = 'K:\PIRtest';
InFile = 'PIR001_010300_00.CSV';
RatID = 'HD113';
LightsOn = '06:00:00';
OutPath = InPath;

function [ActData] = ReadRAD(OutPath, InPath, InFile, RatID, LightsOn)

% read csv
%columns: mm:dd:yyyy hh:mm:ss, elapsed time, device,
%batteryvoltage,PIRCount, PIRDuration, PIRCountChange,PIRDurationchange
fileID = fopen([InPath,'\',InFile]);
RADdata = textscan(fileID,'%{MM/dd/yyyy HH:mm:ss}D%{hh:mm:ss}T%f%f%f%f%f%f','Delimiter',',','HeaderLines',1);
fclose(fileID);

% write recording info 
ActData.RADnum = RADdata{3}(1); %device number of RAD
ActData.RatID = RatID; %RatID
ActData.LightsOn = LightsOn; %time of lights on
A = RADdata{1}(1); A.Format = 'dd-MMM-yyyy'; ActData.Date = A; 
A = RADdata{1}(1); A.Format = 'hh:mm:ss'; ActData.Start = A;
ActData.Dur = (RADdata{2}(end)); %recorded time
ActData.Times = RADdata{1}; % clock times
ActData.TimeElapsed = RADdata{2}; % elapsed time in recording
ActData.PIRCount = RADdata{5}; %
ActData.PIRDuration = RADdata{6};
ActData.PIRCountChange = RADdata{7};
ActData.PIRDurationChange = RADdata{8};
ActData.boutlength = ActData.PIRDurationChange./ActData.PIRCountChange; 

% make activity plot
figure
subplot(3,1,1) %activity counts
bar(ActData.Times,ActData.PIRCountChange)
ylabel('nr of bouts')
title(ActData.RatID)

subplot(3,1,2) %activity duration 
bar(ActData.Times,ActData.PIRDurationChange)
ylabel('activity duration (s)')

subplot(3,1,3)%boutlength
bar(ActData.Times,ActData.boutlength)
ylabel('bout length (s)')

% save outputs
Outname = ['RAD_',ActData.RatID,'_',datestr(ActData.Date,'dd-mm-yy')];
saveas(gcf,[OutPath,'\',Outname,'.tiff'])
save([OutPath,'\',Outname,'.mat'],'ActData');
end