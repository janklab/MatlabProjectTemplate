classdef globals
  % Global library properties and settings for myproject.
  %
  % Note that if you want to change the settings, you can't do this:
  %
  %    mypackage.globals.settings.someSetting = 42;
  %
  % That will break due to how Matlab Constant properties work. Instead, you need
  % to first grab the Settings object and store it in a variable, and then work
  % on that:
  %
  %    s = mypackage.globals.settings;
  %    s.someSetting = 42;
  
  properties (Constant)
    % Path to the root directory of this __myproject__ distribution.
    distroot = string(fileparts(fileparts(fileparts(mfilename('fullpath')))));
    % Global settings for mypackage.
    settings = mypackage.Settings.discover
  end
  
  methods (Static)
    
    function out = version
      % The version of the __myproject__ library
      %
      % Returns a string.
      persistent val
      if isempty(val)
        versionFile = fullfile(mypackage.globals.distroot, 'VERSION');
        val = strtrim(mypackage.internal.util.readtext(versionFile));
      end
      out = val;
    end
    
    function initialize
      % Initialize this library/package
      mypackage.internal.initializePackage;
    end
    
  end
  
end

