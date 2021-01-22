function make_doc
% Build these doc sources into the final doc/ directory
%
% This will only work on Linux or Mac, not Windows.
%
% Requires Ruby and Bundler to be installed.

%#ok<*STRNU>

import mypackage.internal.util.*

RAII.cd = withcd(fileparts(mfilename('fullpath')));

system2('bundle install >/dev/null');
system2('bundle exec jekyll build');
rmdir2('../doc', 's');
copyfile2('_site/*.*', '../doc');

end