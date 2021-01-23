function mypackage_make(target, varargin)
% Build tool for mypackage

%#ok<*STRNU>

arguments
  target (1,1) string
end
arguments (Repeating)
  varargin
end

if target == "build"
  mypackage_build;
elseif target == "buildmex"
  mypackage_build_all_mex;
elseif target == "doc-src"
  make_package_docs --src
elseif target == "doc"
  make_package_docs;
elseif target == "doc-preview"
  preview_docs;
elseif target == "m-doc"
  mypackage_make doc;
  make_mdoc;
elseif target == "toolbox"
  mypackage_make m-doc;
  mypackage_package_toolbox;
elseif target == "clean"
  make_clean
elseif target == "test"
  mypackage_launchtests
elseif target == "dist"
  mypackage_make build
  mypackage_make m-doc
  make_dist
elseif target == "simplify"
  make_simplify
elseif target == "util-shim"
  pkg = varargin{1};
  make_util_shim(pkg);
else
  error("Undefined target: %s", target);
end

end

function make_mdoc
rmrf('build/M-doc')
mkdir2('build/M-doc')
copyfile2('doc/*', 'build/M-doc')
if isfile('build/M-doc/feed.xml')
  delete('build/M-doc/feed.xml')
end
end

function preview_docs
import mypackage.internal.util.*;
RAII.cd = withcd('docs');
make_doc --preview
end

function make_dist
program = "myproject";
distName = program + "-" + mypackage.globals.version;
verDistDir = fullfile("dist", distName);
distfiles = ["build/Mcode" "doc" "lib" "examples" "README.md" "LICENSE" "CHANGES.txt"];
rmrf([verDistDir, distName+".tar.gz", distName+".zip"])
if ~isfolder('dist')
  mkdir2('dist')
end
mkdir2(verDistDir)
copyfile2(distfiles, verDistDir)
RAII.cd = withcd('dist');
tar(distName+".tar.gz", distName)
zip(distName+".zip", distName)
end

function make_clean
rmrf(strsplit("dist/* build docs/site docs/_site M-doc test-output", " "));
end

function make_simplify
rmrf(strsplit(".circleci .travis.yml azure-pipelines.yml src lib/java/MyCoolProject-java", " "));
end

function make_package_docs(varargin)
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

function make_util_shim(pkg)
shimsDir = fullfile(reporoot, 'dev-kit', 'util-shims');
relpkgpath = strjoin(strcat("+", strsplit(pkg, ".")));
pkgdir = fullfile(fullfile(reporoot, 'Mcode'), relpkgpath);
if ~isfolder
  error('Package folder does not exist: %s', pkgdir);
end
privateDir = fullfile(pkgdir, 'private');
if ~isfolder(privateDir)
  mkdir(privateDir);
end
copyfile2(fullfile(shimsDir, '*.m'), privateDir);
fprintf('Util-shimmed package %s', pkg);
end
