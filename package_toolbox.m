function package_toolbox
% Packages this toolbox as a Matlab Toolbox .mltbx file
%
% package_toolbox
%
% The project must be loaded on to the Matlab path in order for this to work.

tbxInfo = toolbox_info;
tbxName = tbxInfo.name;

if ~isfolder('dist')
  mkdir('dist');
end

% Munge the project file
% Toolboxes don't support "-<pre>" suffixes in versions
tbxVer = tbxInfo.version;
baseTbxVer = regexprep(tbxVer, '-.*', '');

prjInFile = sprintf('%s.prj.in', tbxName);
prjFile = sprintf('%s.prj', tbxName);
prjTxt = fileread(prjInFile);
prjTxt = strrep(prjTxt, '${PROJECT_VERSION}', baseTbxVer);
spew(prjFile, prjTxt);

% I can't control the output file name from the project file, so we have to move
% it ourselves
builtFile = [tbxName '.mltbx'];
targetFile = sprintf('dist/%s-%s.mltbx', tbxName, tbxVer);
if isfile(targetFile)
  delete(targetFile);
end

matlab.addons.toolbox.packageToolbox(prjFile);
movefile(builtFile, targetFile);
delete(prjFile);

fprintf('%s packaged to %s\n', tbxName, targetFile);

end

function spew(file, txt)
[fid,msg] = fopen(file, 'w');
RAII.fid = onCleanup(@() fclose(fid));
if fid < 1
  error('Failed opening file %s for writing: %s', file, msg);
end
fprintf(fid, '%s', txt);
end