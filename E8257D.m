classdef E8257D
    properties
       visaAddress;
       v;
    end
    
    methods
        function obj = E8257D(ip_addr)
            obj.v = visadev(['TCPIP0::' ip_addr '::inst0::INSTR']);
            % Buffer size must precede open command
            % set(pxa,'InputBufferSize', 640000);
            % set(obj.v,'OutputBufferSize', 640000);
            writeline(obj.v, '*CLS');
            % Check to ensure the error queue is clear. Response is "+0, No Error"
            writeline(obj.v, 'SYST:ERR?');
            errIdentifyStart = readline(obj.v);
            if (isvalid(obj.v) == 0)
                obj.deInit();
                error('Cannot instantiate Agilent E8257D');
            end
            obj.setModulation(0);
        end

        function rsp = sendResp(obj, cmd)
            obj.sendCommand(cmd);
            rsp = readline(obj.v);
        end

        function sendCommand(obj, cmd)
            writeline(obj.v, cmd)
        end

        function reset(obj)
            obj.sendCommand('SYST:PRES');
        end

        function waitUntilDone(obj)
            thresh = 10000;
            n = 0;
            while ~str2double(obj.sendResp('*OPC?'))
                n = n + 1;
                if n > thresh
                    warning('PSG timeout occured')
                    break
                end
            end
        end

        function setRFPower(obj, powdBm)
            obj.sendCommand(strcat("SOUR:POW:LEV ", num2str(powdBm), "dbm"));
        end

        function setCWFrequency(obj, freq)
             obj.sendCommand(strcat("SOUR:FREQ:CW ", num2str(freq)));
        end

        function setOutput(obj, bool)
            if bool
                obj.sendCommand('OUTP:STATE 1');
            else
                obj.sendCommand('OUTP:STATE 0');
            end
        end

        function setModulation(obj, bool)
            if bool
                obj.sendCommand('OUTP:MOD:STAT 1');
            else
                obj.sendCommand('OUTP:MOD:STAT 0');
            end
        end

        function bool = deInit(obj)
            if(isvalid(obj.v) == 1)
                obj.reset();
                obj.setModulation(0);
                clear obj.v;
                bool = 1;
            else
                bool = 0;
            end
        end

    end
end