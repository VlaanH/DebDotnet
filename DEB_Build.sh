#!/bin/bash
rm data.tar.xz
rm control.tar.xz
rm data/usr/local/bin/*
rm $NamePrg.desktop

echo -e "\033[32mDependent:ar,dotnet core(3.1-and newer),md5sum\e[0m"

read -p "Name program?:" NamePrg
read -p "Binary file name?:" binaryFileName

#Getting settings
version=$(<settings/version)
echo -e "\e[31mVersion DEB: $version"

Project=$(<settings/PatchProject)
echo Patch Project: "$Project"

description=$(<settings/description)
echo description: "$description"

DotNetVersion=$(<settings/DotNetVersion)
echo DotNetVersion: "$DotNetVersion"

echo "Name program" $NamePrg
echo "binary File Name" $binaryFileName

Terminal=$(<settings/сonsoleProgram)
echo -e "Сonsole Program?(true/false): $Terminal\e[0m"


for (( i=1; i <= 50; i++ ))
do
echo -n "-"
done

echo
read -r -p "Press Enter if you are satisfied with the settings"


#create .dasktop
echo "[Desktop Entry]
Name=$NamePrg
Comment=$description
Exec=$NamePrg
Terminal=$Terminal
Icon=/usr/share/pixmaps/$NamePrg
Type=Application
StartupNotify=true 
Categories=GNOME;GTK;Utility;
">>data/usr/share/applications/$NamePrg.desktop






#create control
rm control/control
echo "Package: $NamePrg
Architecture: all
Description: $description
Maintainer: $NamePrg
Priority: extra
Section: misc
Version: $version
">>control/control


#create bin ln
cp image/image.png data/usr/share/pixmaps
mv data/usr/share/pixmaps/image.png data/usr/share/pixmaps/$NamePrg.png


ln -s /usr/share/$NamePrg/$binaryFileName data/usr/local/bin/$binaryFileName



#Build dotnet project

dotnet publish -r linux-x64 -p:PublishSingleFile=true --self-contained true $Project

cp -a $Project/bin/Debug/$DotNetVersion/linux-x64/publish/. data/usr/share/$NamePrg





#md5sum
rm control/md5sum
md5sum $Project/bin/Debug/$DotNetVersion/linux-x64/publish/* > control/md5sum


#Crate Tarball
cd control  
tar cfJ control.tar.xz *  
cd .. 
mv control/control.tar.xz control.tar.xz

cd data  
tar cfJ data.tar.xz *
cd .. 
mv data/data.tar.xz data.tar.xz 



#Crate .deb
ar -r "$NamePrg.$version".deb  debian-binary control.tar.xz data.tar.xz



rm data.tar.xz
rm control.tar.xz
rm -r "data/usr/share/$NamePrg"
rm data/usr/local/bin/*
rm -r "data/usr/share/pixmaps/$NamePrg.png"
rm data/usr/share/applications/$NamePrg.desktop

echo "ALL"
