classdef LibraryInitializer
  % Initializer for the this library.
  %
  % This exists as a class so we can use the trick of using it as a dependency
  % of our functions to cause it to be implicitly run. Its only purpose is to
  % initialize the library as a side effect when an instance of it is
  % constructed.
  
  methods
    
    function this = LibraryInitializer()
      logger.internal.LibraryInitializer.initLibrary;
    end
    
  end
  
  methods (Static)
    
    function initLibrary()
      % Initialize this library
      %
      % This function must be called once before you use this library.
      %
      % It is safe to call this function multiple times; it is idempotent.
      
      thisFile = mfilename('fullpath');
      distDir = fileparts(fileparts(fileparts(fileparts(thisFile))));
      libDir = fullfile(distDir, 'lib');
      
      % Load Dispstr
      matlabLibDir = fullfile(libDir, 'matlab');
      dispstrMcodeDir = fullfile(matlabLibDir, 'dispstr', 'dispstr-1.1.1', 'Mcode');
      mPath = strsplit(path, pathsep);
      if ~ismember(dispstrMcodeDir, mPath)
        addpath(dispstrMcodeDir);
      end
      
      % Compatibility shims
      % TODO: Replace "eq" logic with lt/ge logic
      
      matlabRel = ['R' version('-release')];
      shimsDir = fullfile(libDir, 'shims', 'eq', matlabRel);
      if isfolder(shimsDir)
        javaShimsDir = fullfile(shimsDir, 'java');
        % TODO: Replace this with dir('.../**/*.jar') globbing logic
        subdirs = readdir(javaShimsDir);
        for iLib = 1:numel(subdirs)
          thisLibDir = fullfile(javaShimsDir, subdirs{iLib});
          files = readdir(thisLibDir);
          for iFile = 1:numel(files)
            file = files{iFile};
            if endsWith(lower(file), '.jar')
              javaaddpath(fullfile(thisLibDir, file));
            end
          end
        end
      end
      
      logger.Log4jConfigurator.configureBasicConsoleLogging()
      
    end
    
    function out = readdir(pth)
      d = dir(pth);
      d(ismember({d.name}, {'.','..'})) = [];
      out = {d.name};
    end
    
  end
  
end

