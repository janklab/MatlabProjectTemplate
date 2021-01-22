function make_doc
% Build these doc sources into the final doc/ directory
%
% make_doc
% make_doc --preview
% make_doc --build-only
%
% This will require special configuration on Windows to get it working.
%
% Requires mkdocs to be installed. See https://www.mkdocs.org/.

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
  system('mkdocs serve');
else
  system2('mkdocs build');
  if action == "install"
    rmdir2('../doc', 's');
    copyfile2('_site/*.*', '../doc');
  end
end

end
