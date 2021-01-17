classdef globals
  % Global library properties and settings for SLF4M
  
  properties (Constant)
    % Path to the root directory of this __myproject__ distribution
    distroot = string(fileparts(fileparts(fileparts(mfilename('fullpath')))));
  end
  
  methods (Static)
    
    function out = version
      % The version of the __myproject__ library
      %
      % Returns a string.
      persistent val
      if isempty(val)
        versionFile = fullfile(mypackage.globals.distroot, 'VERSION');
        val = strtrim(mypackage.internal.readtext(versionFile));
      end
      out = val;
    end
    
    function initialize
      % Initialize this library/package
      mypackage.internal.initializePackage;
    end
    
  end
  
end

