#!/bin/sh
#!/bin/sh

#setup objj bin and Frameworks path
if test -n "$OBJJ_FRAMEWORKS_PATH";
then
	defaultPath="$OBJJ_FRAMEWORKS_PATH";
else
	defaultPath="/usr/local/narwhal/packages/cappuccino/Frameworks";
fi

if test -n "$OBJJ_BIN_PATH";
then
	defaultBinFolderPath="$OBJJ_BIN_PATH";
else
	defaultBinFolderPath="/usr/local/narwhal/bin";
fi

### copy cappuccino frameworks
if test -n "$OBJJ_FRAMEWORKS_PATH";
then
echo "Use Cappuccino Installation at '$defaultPath'";
echo "Check Cappuccino Frameworks ...";

if test -d "$defaultPath";
then
#	if test "$defaultPath" -nt ./Frameworks;
#	then
#		rm -rf ./Frameworks; cp -rf $defaultPath .;
#		echo "Copied Cappuccino Frameworks from location '$defaultPath'";
#	else
#		echo "Cappuccino Frameworks are up-to-date";
#	fi
	rm -rf ./Frameworks; cp -rf $defaultPath .;
	echo "Copied Cappuccino Frameworks from location '$defaultPath'";
fi

### copy the objective-j runtime
if test -d "$OBJJ_RUNTIME_PATH";
then
	cp -rf $OBJJ_RUNTIME_PATH/* Frameworks/
fi

## copy custom frameworks or files to Frameworks
cp -rf $CUSTOM_FRAMEWORKS Frameworks/


### setup PATH for binaries we need
if test -d "$defaultBinFolderPath";
then
	PATH=${PATH}:$defaultBinFolderPath;
fi

if test -d "$NARWHAL_BIN_PATH";
then
	PATH=${PATH}:$NARWHAL_BIN_PATH;
fi

echo "Check Interface Builder Files ....";


### for xib files
xibFiles=$(find . -type f -name "*.xib");
for xibFile in $xibFiles; do
 cibFile=$(echo $xibFile | sed -e 's/\.xib$/.cib/');
 test $xibFile -nt $cibFile && nib2cib $xibFile || echo "Interface Builder File '$cibFile' is up-to-date";
done;

### for nib files
nibFiles=$(find . -type d -name "*.nib");
for nibFile in $nibFiles; do
 	cibFile=$(echo $nibFile | sed -e 's/\.nib$/.cib/');
	test $nibFile -nt $cibFile && nib2cib $nibFile || echo "Interface Builder File \'$cibFile\' is up-to-date";
done;
else
	echo "Please setup your build settings key 'OBJJ_FRAMEWORKS_PATH' with your objj framework path";
	echo "The default path is '/usr/local/narwhal/packages/cappuccino'"
	echo "Also setup the build settings key 'OBJJ_BIN_PATH' with your objj bin path";
	error 1;
fi

### convert CoreData model files
xcdmodels=$(find . -type d -name "*.xcdatamodel");
for xcdmodel in $xcdmodels; do
	xccpdfile=$(echo $xcdmodel | sed -e 's/\.xcdatamodel$/.xccpd/');
	/Developer/usr/bin/momc $xcdmodel $xccpdfile
	plutil -convert xml1 $xccpdfile
done;
