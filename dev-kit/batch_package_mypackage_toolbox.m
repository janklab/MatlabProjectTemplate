function batch_package_mypackage_toolbox
% An entry point for building the toolbox from a "matlab -batch" call
%
% This has error handling to set matlab's exit status appropriately.

try
  load_mypackage;
  package_mypackage_toolbox;
catch err
  fprintf('Error occurred:\n');
  fprintf('%s\n', getReport(err));
  exit(1);
end
