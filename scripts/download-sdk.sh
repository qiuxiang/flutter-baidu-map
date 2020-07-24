#!/usr/bin/env bash

sdk_url="http://api.map.baidu.com/portal/sdk/api_filedownload?file_path=/Android/gp_6-1-3/BaiduLBS_Android_Vgp_6.1.3_33554432.zip"
curl "$sdk_url" -o sdk.zip
unzip -o sdk.zip
rm -r android/libs
mkdir android/libs
mv libs/BaiduLBS_Android.jar android/libs/
rm -r android/src/main/jniLibs
mv libs android/src/main/jniLibs
rm sdk.zip readme.txt
