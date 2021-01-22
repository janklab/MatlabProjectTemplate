function make_doc(varargin)
% Build these doc sources into the final doc/ directory
%
% make_doc
% make_doc --preview
% make_doc --build-only
%
% This will only work on Linux or Mac, not Windows.
%
% Requires Ruby and Bundler to be installed, and available on your $PATH.

action = "install";
args = string(varargin);
if ismember("--preview", args)
  action = "preview";
elseif ismember("--build-only", args)
  action = "build";
end

%#ok<*STRNU>

import mypackage.internal.util.*

RAII.cd = withcd(fileparts(mfilename('fullpath')));

system2('bundle install >/dev/null');

if action == "preview"
  % Use plain system() and quash because we expect this to error out when user Ctrl-C's it
  try
    system('bundle exec jekyll serve');
  catch err %#ok<NASGU>
    % quash
    % Darn, that doesn't work... looks like Ctrl-C causes an un-catchable error?
  end
else
  system2('bundle exec jekyll build');
  if action == "install"
    rmdir2('../doc', 's');
    copyfile2('_site/*.*', '../doc');
  end
end

end