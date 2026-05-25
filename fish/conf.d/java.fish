# Check if Java is installed
if test -d /opt/homebrew/opt/openjdk
  set JAVA_HOME /opt/homebrew/opt/openjdk
else if test -d /usr/libexec/java_home
  set JAVA_HOME (java_home)
end
