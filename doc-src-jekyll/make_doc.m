function make_doc
% Build these doc sources into the final doc/ directory
%
% This will only work on Linux or Mac, not Windows.
%
% Requires Ruby and Bundler to be installed.

%#ok<*STRNU>

import mypackage.internal.util.*

RAII.cd = withcd(fileparts(mfilename('fullpath')));

[status, output] = system('ruby --version'); %#ok<ASGLU>
if status ~= 0
  if ispc
    installMsg = "Please install it from https://rubyinstaller.org/.";
  elseif ismac
    installMsg = "Please install it using Homebrew: `brew install ruby bundler`";
  else
    installMsg = "Please install it using your OS's package manager.";
  end
  error("It doesn't look like you have Ruby installed.\n%s\n%s", ...
    "Ruby is required for building these docs.", installMsg);
end

system2('bundle install >/dev/null');
system2('bundle exec jekyll build');
rmdir2('../doc', 's');
copyfile2('_site/*.*', '../doc');

end