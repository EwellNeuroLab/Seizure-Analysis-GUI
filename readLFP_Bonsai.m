function L = readLFP_Bonsai(path,nameVoltageFile,nameTimeStampFile,NumberOfChannels)

%read timestamps:
     id = fopen([path,'\',nameTimeStampFile]);
     temp = fread(id, [2, Inf], 'uint32'); %open ephys and video 
     temp = transpose(temp);
L.t = temp; clear temp;

%read amp data (voltage):
id = fopen([path,'\',nameVoltageFile]);
temp = fread(id, [NumberOfChannels, Inf], 'uint16');
temp = transpose(temp); %each row corresponds to a channel
L.d = temp; clear temp;

for i = 1:NumberOfChannels;
%uint16 format ranges between [0 65535]
%shift data to real 0 value, that is ((65535+1)/2 = 32768)
L.d(:,i) = L.d(:,i)-32768;

%convert bits into uV using the OE conversion factor
L.d(:,i) = L.d(:,i)*0.195;
end

