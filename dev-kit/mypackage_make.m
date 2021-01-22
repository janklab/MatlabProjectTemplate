function mypackage_make(target)
% Build tool for mypackage

%#ok<*STRNU>

arguments
  target (1,1) string
end

if target == "build"
  mypackage_build;
elseif target == "buildmex"
  mypackage_build_all_mex;
elseif target == "doc-src"
  mypackage_make_doc --src
elseif target == "doc"
  mypackage_make_doc;
elseif target == "m-doc"
  mypackage_make_doc;
  make_mdoc;
elseif target == "toolbox"
  mypackage_make_doc;
  make_mdoc;
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
