
# Fixes with Jetson :)

## Error: Problems with Nsight-Eclipse:

!ENTRY com.nvidia.cuda.ide.build 4 0 2020-12-04 11:24:45.564
!MESSAGE FrameworkEvent ERROR
!STACK 0
org.osgi.framework.BundleException: Could not resolve module: com.nvidia.cuda.ide.build [9]
  Unresolved requirement: Require-Bundle: org.eclipse.cdt.managedbuilder.core
    -> Bundle-SymbolicName: org.eclipse.cdt.managedbuilder.core; bundle-version="8.3.0.201409172108"; singleton:="true"
       org.eclipse.cdt.managedbuilder.core [108]
         Unresolved requirement: Require-Bundle: org.eclipse.cdt.core; bundle-version="[5.0.0,6.0.0)"
           -> Bundle-SymbolicName: org.eclipse.cdt.core; bundle-version="5.7.0.nvidia-qualifier"; singleton:="true"
              org.eclipse.cdt.core [88]
                Unresolved requirement: Require-Capability: osgi.ee; filter:="(&(osgi.ee=JavaSE)(version=1.7))"
                
                
## Solve:              
sudo apt install openjdk-8-jdk
nsight -vm /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java


## Error: Change Keyboard Layout

## Solve:
Preferences->Language Support -> Keyboard input method system -> IBUS

sudo dpkg-reconfigure keyboard-configuration

sudo apt-get install console-common
sudo dpkg-reconfigure console-data

## Error: Ubuntu login loop

hen you need to do chown username:username .Xauthority and try logging in (you may also need to do the same for for .ICEauthority).

Else, do ls -ld /tmp. Check for the first 10 letters in the left: they should read exactly so: drwxrwxrwt.

drwxrwxrwt 15 root root 4096 Nov 30 04:17 /tmp
Else, you need to do sudo chmod a+wt /tmp and check again.

If not both, I'd recommend you either

sudo dpkg-reconfigure lightdm
or uninstall, reinstall it.



