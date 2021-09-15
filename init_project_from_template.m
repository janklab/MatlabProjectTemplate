function init_project_from_template(varargin)
% Initialize this project from the MatlabProjectTemplate template

%#ok<*STRNU>
%#ok<*AGROW>
%#ok<*DEFNU>

% Parse options

doDev = false;

for i = 1:numel(varargin)
  switch varargin{i}
    case {'-d', '--dev'}
      doDev = true;
    otherwise
      error('Invalid option: %s', varargin{i});
  end
end

% Init empty variables just so we can use tab-completion while working on this
% script

PROJECT = [];
PROJECT_MATLAB_VERSION = [];
PACKAGE = [];
GHUSER = [];
PROJECT_EMAIL = [];
DOCTOOL = [];
PROJECT_AUTHOR = [];
PROJECT_SUMMARY = [];
PROJECT_DESCRIPTION = [];
AUTHOR_HOMEPAGE = [];

% Get going

reporoot = string(fileparts(mfilename('fullpath')));
RAII.cd = withcd(reporoot); 

info = project_settings;
f = fieldnames(info);
for i = 1:numel(f)
  if isstring(info.(f{i})) || ischar(info.(f{i}))
    info.(f{i}) = char(info.(f{i}));
  else
    error('Bad value for %s: Must be a string', f{i});
  end
end

% Validate project options

validFields = {'PROJECT', 'PROJECT_MATLAB_VERSION', 'PACKAGE', 'GHUSER', ...
  'PROJECT_EMAIL', 'DOCTOOL', 'PROJECT_AUTHOR', 'PROJECT_SUMMARY', ...
  'PROJECT_DESCRIPTION', 'AUTHOR_HOMEPAGE'};
missingFields = setdiff(validFields, fieldnames(info));
if ~isempty(missingFields)
  error(['Missing fields in project_settings.m: %s.\n' ...
    'You didn''t delete stuff from that file, did you?'], strjoin(missingFields, ', '));
end
badFields = setdiff(fieldnames(info), validFields);
if ~isempty(badFields)
  fprintf('WARNING: Ignoring unrecognized fields in project_settings.m: %s\n', ...
    strjoin(badFields, ', '));
end

copyStructFieldsIntoWorkspace(info);

docSiteDir = "docs-src-" + DOCTOOL;
if ~isfolder(docSiteDir)
  error(['Invalid choice for DOCTOOL: %s\nValid choices are: ' ...
    'jekyll, mkdocs, gh-pages, gh-pages-raw'], DOCTOOL);
end

badHtmlChars = '<>&';
htmlFields = ["PROJECT_SUMMARY", "PROJECT_DESCRIPTION", "AUTHOR_HOMEPAGE"];
for i = 1:numel(htmlFields)
  if any(ismember(info.(htmlFields{i}), badHtmlChars))  
    error("%s may not contain %s", htmlFields{i}, badHtmlChars);
  end
end

PACKAGE_CAP = [upper(PACKAGE(1)) PACKAGE(2:end)];
PACKAGE_UPPER = upper(PACKAGE);

% Do work!

echo
echo("Initializing project " + PROJECT);

echo
echo("Generating a GUID for your project's Toolbox...")
PROJECT_GUID = char(toString(java.util.UUID.randomUUID));

% Munge the source code and documentation

mv("Mcode/+mypackage/+internal/MypackageBase.m", "Mcode/+mypackage/+internal/"+PACKAGE_CAP+"Base.m");
mv("Mcode/+mypackage/+internal/MypackageBaseHandle.m", "Mcode/+mypackage/+internal/"+PACKAGE_CAP+"BaseHandle.m");
mv("Mcode/+mypackage", "Mcode/+"+PACKAGE)
mv("src/java/myproject-java/src/main/java/com/example/mypackage",  "src/java/myproject-java/src/main/java/com/example/"+PACKAGE)
mv("src/java/myproject-java", "src/java/"+PROJECT+"-java")

fileGlobsToMunge = regexp(".gitignore Makefile *.md */*.md */*.adoc */*.yml " ...
  + "myproject.prj.in */*.m */*/*.m */*/*/*.m */*/*/*/*.m src/java/*/*.xml " ...
  + "src/java/*/*/*/*/*/*/*/*.java azure-pipelines.yml .travis.yml " ...
  + ".circleci/config.yml dev-kit/*.m dev-kit/*.sh dev-kit/run_matlab " ...
  + "dev-kit/private/*.m mypackage_toolbox_info.m " ...
  + "dev-kit/make_release dev-kit/*.m CHANGES.md info.xml doc-project/*.txt doc-project/*.md", ' +', 'split');
filesToMunge = unique(fileglob2abspath(fileGlobsToMunge));
replacements = {
  "__myproject__" PROJECT
  "__myprojectemail__" PROJECT_EMAIL
  "__myprojectguid__" PROJECT_GUID
  "__myproject_matlab_version__" PROJECT_MATLAB_VERSION
  "__myghuser__" GHUSER
  "__YOUR_NAME_HERE__" PROJECT_AUTHOR
  "__myproject_summary__" PROJECT_SUMMARY
  "__myproject_description__" PROJECT_DESCRIPTION
  "__author_homepage__" AUTHOR_HOMEPAGE
  "myproject" PROJECT
  "mypackage" PACKAGE
  "MYPACKAGE" PACKAGE_UPPER
  "myghuser" GHUSER
  "Mypackage" PACKAGE_CAP
  "R2019b" PROJECT_MATLAB_VERSION
  };
mungefiles(filesToMunge, replacements);
copyfile2('MatlabProjectTemplate/project-README.md', 'README.md')
if ~doDev
  replacements= {
    "# start_MPT_targets.*# end_MPT_targets" ""
  };
  ciConfigFiles = [".travis.yml", ".circleci/config.yml", "azure-pipelines.yml"];
  mungefiles(ciConfigFiles, replacements, "regex");
end

for f = fileglob2abspath({'*mypackage*', 'dev-kit/*mypackage*', 'dev-kit/private/*mypackage*'})
  relFile = strrep(f, reporoot+filesep, '');
  newName = strrep(relFile, 'mypackage', PACKAGE);
  mv(relFile, newName);
end
delete('LICENSE-MatlabProjectTemplate.md')
delete('LICENSE')
mv('myproject-LICENSE', 'LICENSE')
delete('CHANGES.md')
mv('myproject-CHANGES.md', 'CHANGES.md')

if ~doDev
  delete('rollback_init')
end

rmdir2('docs', 's');
copyfile2("docs-src-"+DOCTOOL, 'docs');
for f = ["docs-src-jekyll" "docs-src-gh-pages" "docs-src-gh-pages-raw" "docs-src-mkdocs"]
  rmdir2(f, 's');
end

rmdir2('doc', 's')
mkdir('doc')

writetext(PROJECT_MATLAB_VERSION, '.matlab_version')
writetext("0.1.0", "VERSION")
movefile('myproject.prj.in', PROJECT+".prj.in")

echo
echo("Project "+PROJECT+" is initialized.")
echo("See MatlabProjectTemplate/README.md for more info.")
echo
echo("Happy hacking!")
echo

% This message will self-destruct in 5 seconds. 5... 4... 3... 2... 1...
delete([mfilename('fullpath') '.m'])

end

function mungefiles(files, replacements, replacementType)
arguments
  files (1,:) string
  replacements cell
  replacementType (1,1) string = "string"
end
for file = files
  origTxt = readtext(file);
  txt = origTxt;
  for i = 1:size(replacements, 1)
    [old, new] = replacements{i,:};
    if replacementType == "string"
      txt = strrep(txt, old, new);
    elseif replacementType == "regex"
      txt = regexprep(txt, old, new);
    else
      error('Invalid replacementType: %s', replacementType);
    end
  end
  writetext(txt, file);
end
end

function out = fileglob2abspath(pats)
arguments
  pats string
end
names = string([]);
abspaths = string([]);
for i = 1:numel(pats)
  d = dir(pats(i));
  name = string({d.name});
  abspath = fullfile(string({d.folder}), name);
  names = [names name];
  abspaths = [abspath abspaths];
end
out = abspaths;
end

function echo(fmt, varargin)
if nargin == 0
  fprintf('\n');
  return
end
fprintf([char(fmt) '\n'], varargin{:});
end

function copyStructFieldsIntoWorkspace(s)
fields = fieldnames(s);
for i = 1:numel(fields)
  assignin('caller', fields{i}, s.(fields{i}));
end
end

function copyfile2(src, dest, varargin)
% A version of copyfile that raises an error on failure
[ok,msg] = copyfile(src, dest, varargin{:});
if ~ok
  error('Failed copying file "%s" to "%s": %s', src, dest, msg);
end
end

function mkdir2(varargin)
% A version of mkdir that raises error on failure
[ok,msg] = mkdir(varargin{:});
if ~ok
  if nargin == 1
    target = varargin{1};
  else
    target = fullfile(varargin{:});
  end
  error('Failed creating directory "%s": %s', target, msg);
end
end

function rmdir2(dir, varargin)
% A version of rmdir that raises errors on failure
[ok,msg] = rmdir(dir, varargin{:});
if ~ok
  error('rmdir of "%s" failed: %s', dir, msg);
end
end

function out = system2(cmd)
% A version of system that raises an error on failure
if nargout == 0
  ok = system(cmd);
else
  [ok,out] = system(cmd);
end
if ~ok
  error('Command failed. Command: %s', cmd);
end
end

function out = withcd(dir)
% Temporarily change to a new directory
origDir = pwd;
cd(dir);
out.RAII = onCleanup(@() cd(origDir));
end

function mv(source, dest)
% A version of movefile that raises an error on failure
[ok,msg] = movefile(source, dest);
if ~ok
  error('Failed moving "%s" to "%s": %s', source, dest, msg);
end
end

function out = readtext(file, encoding)
% Read the contents of a text file as a string
%
% This is analagous to Matlab's readcsv and readtable, and exists because Matlab
% doesn't provide a basic file-slurping mechanism.

arguments
  file (1,1) string
  encoding (1,1) string = 'UTF-8' % TODO: auto-detect file encoding via sniffing
end
[fid,msg] = fopen(file, 'r', 'n', encoding);
if fid < 1
  error('Failed opening file %s: %s', file, msg);
end
RAII.fh = onCleanup(@() fclose(fid));
c = fread(fid, Inf, 'uint8=>char');
out = string(c');
end

function writetext(text, file, encoding)
arguments
  text (1,1) string
  file (1,1) string
  encoding (1,1) string = 'UTF-8'
end
[fid,msg] = fopen(file, 'w', 'n', encoding);
if fid < 1
  error('Failed opening file %s: %s', file, msg);
end
RAII.fh = onCleanup(@() fclose(fid));
fprintf(fid, '%s', text);
end
