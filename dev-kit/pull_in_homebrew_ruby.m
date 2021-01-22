function pull_in_homebrew_ruby
% Gets Homebrew's Ruby on to your $PATH in this Matlab session
%
% This searches for Homebrew and modifies your $PATH to get it and its ruby and
% bundler on it.
%
% Call this from your `startup.m` if you're a Mac Homebrew user. You'll probably
% need to do this if you're using the Jekyll or GitHub Pages documentation
% builder, because they rely on having a new Ruby and Bundler installed, and
% Homebrew is usually the way people do that on Macs.
%
% To use this, stick this in your startup.m (after getting dev-kit/ on your
% Matlab path):
%
% if ~ispc
%   pull_in_homebrew_ruby
% end

%#ok<*NBRAK>

if ispc
  fprintf("pull_in_homebrew_ruby: Homebrew doesn't exist on Windows. Not pulling it in.\n");
  return
end

installCandidates = [
  "/usr/local"
  ];
found = [];
for cand = installCandidates'
  if isfolder(cand+"/Cellar") && isfolder(cand+"/bin")
    found = cand;
    break
  end
end

if isempty(found)
  % No Homebrew installation detected
  return
end

p = strsplit(getenv('PATH'), ':');
rubyVer = '3.0.0'; % HACK. TODO: Detect dynamically.
needBinDirs = [cand+"/bin", cand+"/opt/ruby/bin", cand+"/lib/ruby/gems/"+rubyVer+"/bin"];
for binDir = needBinDirs
  if ~ismember(binDir, p)
    setenv('PATH', binDir+":"+getenv('PATH'));
  end
end

end
