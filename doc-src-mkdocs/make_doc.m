function make_doc
% Build these doc sources into the final doc/ directory
%
% This will only work on Linux or Mac, not Windows.
%
% Requires mkdocs to be installed.

%#ok<*STRNU>

import mypackage.internal.util.*

RAII.cd = withcd(fileparts(mfilename('fullpath')));

system2('mkdocs build');
rmdir2('../doc', 's');
copyfile2('site/*.*', '../doc');

end