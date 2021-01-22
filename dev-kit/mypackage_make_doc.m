function mypackage_make_doc(varargin)
% Builds the project documentation
%
% mypackage_make_doc
% mypackage_make_doc --src
%
% The --src flag causes it to build only the doc sources, and skip the step of
% building the final docs in doc/.

%#ok<*STRNU>

doOnlySrc = ismember('--src', varargin);
  
build_docs;
if ~doOnlySrc
  build_doc;
end

end

function build_docs
% Build the generated parts of the doc sources
RAII.cd = withcd(reporoot); 
docsDir = fullfile(reporoot, 'docs');
% Copy over examples
docsExsDir = fullfile(docsDir, 'examples');
if isfolder(docsExsDir)
  rmdir2(docsExsDir, 's');
end
copyfile('examples', fullfile('docs', 'examples'));
% TODO: Generate API Reference
end

function build_doc
% Build the final doc files
RAII.cd = withcd(fullfile(reporoot, 'docs'));
make_doc;
delete('../doc/make_doc*');
end