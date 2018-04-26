
function y = pc1dSetthcikness(varargin);
% List of some variables names:
% (Open "temp.txt" to look for more)
% 
% Front (or rear) layers:
% CReflectance::m_Thick[0]    - First layer thickness in nm
% CReflectance::m_Index[0]    - First layer index
% CReflectance::m_Thick[1]    - Second layer thickness in nm
% CReflectance::m_Index[1]    - Second layer index
% CReflectance::m_Thick[2]    - Third layer thickness in nm
% CReflectance::m_Index[2]    - Third layer index
% 
% CDevice::m_FrontCharge      - Front charge in cm^-2 OR
% CDevice::m_FrontBarrier     - Front barrier (eV)
% CDevice::m_RearCharge       - Rear chareg in cm^-2 OR
% CDevice::m_RearBarrier      - Rear barrier in eV
% 
% Front and/or rear specular reflectance: 
% CReflectance::m_Internal1   - 1st (0-1)
% CReflectance::m_Internal2   - subsequent (0-1)
% 
% CRegion::m_Thickness        - Region thickness in cm (same variable name for all regions)
% CRegion::m_BkgndDop         - Region dopin in cm^-3 (same variable name for all regions)
% 
% CRegion::m_TauN             - SRH bulk electron lifetime (s)
% CRegion::m_TauP             - SRH bulk hole lifetime (s)
% CRegion::m_BulkEt           - SRH Et - Ei (eV)
% CRegion::m_FrontSn          - Front Sn parameter (cm/s)
% CRegion::m_FrontSp          - Front Sp parameter (cm/s)
% CRegion::m_FrontEt          - Front recombination trap level Et - Ei (eV)
% CRegion::m_FrontJo          - Front emitter recombination current parameter
% CRegion::m_RearSn           - (Similar for rear)
% CRegion::m_RearSp
% CRegion::m_RearEt
% CRegion::m_RearJo
%
% CLight::m_LambdaSS          - SS excitation wavelength
% CLight::m_LambdaTR1         - Transient excitation wavelength 1
% CLight::m_LambdaTR2         - Transient excitation wavelength 1
% CLight::m_IntensitySS       - SS excitation intensity
% CLight::m_IntensityTR1      - TR1 excitation intensity
% CLight::m_IntensityTR2      - TR2 excitation intensity
%
% CHANGING OUTPUT DATA
% Change the output data type by changing the variable 'In CData: GraphableQuantity g'
% You will also need to specify the line before the one you want to change, using a
% fourth parameter:
%
% pc1dSet(file,'In CData: GraphableQuantity g',N,preline)
%
% The preline parameter specifies x or y (1-4) data (coloumn 1-5 in the output data)
%
% CGraph::m_xquantity:        - xdata
% CGraph::m_yquantity[0]:     - ydata1
% CGraph::m_yquantity[0]:     - ydata2
% CGraph::m_yquantity[0]:     - ydata3
% CGraph::m_yquantity[0]:     - ydata4
%
% and N is a number specifying the type of data. Choose between the following:
%
% 2     'Distance from Front'
% 3	    'Electrostatic Potential'
% 4	    'Donor Doping Density'
% 5   	'Acceptor Doping Density'
% 6	    'Electron Density'
% 7	    'Hole Density'
% 8	    'Electric Field'
% 9	    'Charge Density'
% 10	'Electron Current Density'
% 11	'Hole Current Density'
% 12	'Total Current Density'
% 13	'Cumulative Photogeneration'
% 14	'Energy Gap (electrical)'
% 15	'Intrinsic Conc. (effective)'
% 16	'Minority Carrier Lifetime'
% 17	'Bulk Recombination Rate'
% 18	'Cumulative Recombination'
% 19	'Generation Rate'
% 20	'Electron Velocity'
% 21	'Hole Velocity'
% 22	'Electron Mobility'
% 23	'Hole Mobility'
% 24	'Excess Electron Density'
% 25	'Excess Hole Density'
% 26	'Excess Electrostatic Potential'
% 27	'Excess Charge Density'
% 28	'Electron Quasi-Fermi Energy'
% 29	'Hole Quasi-Fermi Energy'
% 30	'Conduction Band Edge'
% 31	'Valence Band Edge'
% 32	'Vacuum Energy'
% 33	'Resistivity'
% 34	'Conductivity'
% 35	'Cumulative Conductivity'
% 36	'Excess Conductivity'
% 37	'Cumulative Excess Conductivity'
% 38	'Diffusion Length'
% 39	'Electron Current'
% 40	'Hole Current'
% 41	'Total Current'
% 42	'Cross-Sectional Area'
% 43	'Dielectric Constant'
% 44	'Elapsed Time'
% 45	'Base Voltage'
% 46	'Base Current'
% 47	'Collector Voltage'
% 48	'Collector Current'
% 49	'Base Power'
% 50	'Collector Power'
% 51	'Primary Source Wavelength'
% 52	'External Quantum Efficiency'
% 53	'Internal Quantum Efficiency'
% 54	'Pri-Surface Reflectance'
% 55	'Pri-Surface Escape'
% 56	'Inverse IQE'
% 57	'Pri-Surface Absorption Length'
% 58	'Pri-Surface Refractive Index'
% 59	'Shunt #1 Voltage'
% 60	'Shunt #1 Current'
% 61	'Shunt #2 Voltage'
% 62	'Shunt #2 Current'
% 63	'Shunt #3 Voltage'
% 64	'Shunt #3 Current'
% 65	'Shunt #4 Voltage'
% 66	'Shunt #4 Current'
% 67	'Convergence Error'
% 68	'Excess Electron Density Ratio'
% 69	'Excess Hole Density Ratio'
% 70	'Excess pn Product Ratio'
% 71	'Excess Normalized pn Product'
% 72	'Electron Drift Current Density'
% 73	'Electron Diff. Current Density'
% 74	'Hole Drift Current Density'
% 75	'Hole Diff. Current Density'


file = varargin{1};
variable = varargin{2};
value = varargin{3};

% Convert to ascii:
dos(['convert_prm_to_ascii ' file ' temp.txt']);      
% Import data:
C = importdata('temp.txt');

if length(varargin) == 3;


for i=240:360;
    s = C{i};
    if (length(C{i})>=length(variable))
        if strcmp(s(1:length(variable)), variable)
            C{i} = [variable '=' num2str(value)];
        end
    end
end

end

if length(varargin) == 4;
    
preline = varargin{4};

for i=2:length(C)
    s_preline = C{i-1};
    s = C{i};
    if length(C{i-1}) >= length(preline)
        if strcmp(s_preline(1:length(preline)), preline)
            if (length(C{i})>=length(variable))
                if strcmp(s(1:length(variable)), variable)
                C{i} = [variable '=' num2str(value)];
                end
            end
        end
    end
end

end


% Write back to ascii-file
fid=fopen('temp.txt','wt');
[rows,cols]=size(C);
for i=1:rows
fprintf(fid,'%s,',C{i,1:end-1});
fprintf(fid,'%s\n',C{i,end});
end
fclose(fid);
        
% Convert back to prm-file
dos(['convert_ascii_to_prm' ' temp.txt ' file]);