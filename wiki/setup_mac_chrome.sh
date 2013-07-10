sudo mkdir -p /Library/Internet\ Plug-Ins/disabled
sudo mv /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin /Library/Internet\ Plug-Ins/disabled
sudo ln -sf /System/Library/Java/Support/Deploy.bundle/Contents/Resources/JavaPlugin2_NPAPI.plugin /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
sudo ln -sf /System/Library/Frameworks/JavaVM.framework/Commands/javaws /usr/bin/javaws
