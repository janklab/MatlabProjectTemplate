function initializePackage

% Do not re-initialize if already initialized
if getappdata(0, 'mypackage_is_initialized')
  return
end

% Don't depend on globals, to avoid circular dependency
%distroot = mypackage.globals.distroot;
distroot = string(fileparts(fileparts(fileparts(fileparts(mfilename('fullpath'))))));

% Java dependencies
libJava = fullfile(distroot, 'lib', 'java');
javaLibs = readdir(libJava);
for jlib = javaLibs
  jlibdir = fullfile(libJava, jlib);
  d = dir(fullfile(jlibdir, '*.jar'));
  for jar = {d.name}
    javaaddpath(fullfile(jlibdir, jar));
  end
end

% Matlab library dependencies
libMatlab = fullfile(distroot, 'lib', 'matlab');
mLibs = readdir(libMatlab);
for mlib = mLibs
  mlibdir = fullfile(libMatlab, mlib);
  % There's no standard layout for a Matlab project, so we use heuristics to guess
  % where they keep their source files
  candidateSubdirs = ["Mcode" "mcode" "src" "srcfiles"];
  for sub = candidateSubdirs
    if isfolder(fullfile(mlibdir, sub))
      addpath(fullfile(mlibdir, sub))
    end
  end
  d = dir(fullfile(mlibdir, '*.m'));
  if ~isempty(d)
    addpath(mlibdir);
  end
end


% Put any custom library initialization code here

% Mark library as initialized

setappdata(0, 'mypackage_is_initialized', true);

end

function out = readdir(theDir)
d = dir(theDir);
out = string(setdiff({d.name}, {'.' '..'}));
end