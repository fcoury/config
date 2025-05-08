# Check if Java is installed
if test -d /opt/homebrew/opt/openjdk
  fish_add_path /opt/homebrew/opt/openjdk/bin
    set JAVA_HOME /opt/homebrew/opt/openjdk
else if test -d /usr/libexec/java_home
    set JAVA_HOME (java_home)
end
