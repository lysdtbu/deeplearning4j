#!/bin/bash
SCL_ENABLE="devtoolset-7"
yum -y update && yum -y install centos-release-scl-rh epel-release
yum -y install $SCL_ENABLE rh-java-common-ant boost-devel ccache clang gcc-c++ gcc-gfortran java-1.8.0-openjdk-devel ant python python36-devel python36-pip swig file which wget unzip tar bzip2 gzip xz patch autoconf-archive automake make libtool bison flex perl nasm alsa-lib-devel freeglut-devel gtk2-devel libusb-devel libusb1-devel curl-devel expat-devel gettext-devel openssl-devel bzip2-devel zlib-devel SDL-devel libva-devel libxkbcommon-devel libxkbcommon-x11-devel xcb-util* fontconfig-devel libffi-devel ragel ocl-icd-devel GeoIP-devel pcre-devel ssdeep-devel yajl-devel
sed -i 's/_mm512_abs_pd (__m512 __A)/_mm512_abs_pd (__m512d __A)/g' /opt/rh/devtoolset-7/root/usr/lib/gcc/x86_64-redhat-linux/7/include/avx512fintrin.h
source scl_source enable $SCL_ENABLE || true
curl -LO https://github.com/Kitware/CMake/releases/download/v3.16.6/cmake-3.16.6-Linux-x86_64.tar.gz
curl -LO https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
curl -LO https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.18.3.tar.gz
tar -xzf cmake-3.16.6-Linux-x86_64.tar.gz -C /opt/
tar -xzf apache-maven-3.6.3-bin.tar.gz -C /opt/
tar -xzf git-2.18.3.tar.gz
pushd git-2.18.3; make -j2 prefix=/usr/local/; make -j2 prefix=/usr/local/ install; popd
ln -sf /usr/bin/python3.6 /usr/bin/python3
ln -sf /opt/cmake-3.16.6-Linux-x86_64/bin/* /usr/bin/
ln -sf /opt/apache-maven-3.6.3/bin/mvn /usr/bin/mvn


export PATH=/opt/protobuf/bin:/opt/cmake/bin:$PATH
mvn --version
cmake --version
protoc --version
export PATH=/opt/protobuf/bin:/opt/cmake/bin:$PATH
#export LIBGOMP_PATH=/usr/lib/gcc/x86_64-linux-gnu/5.5.0/libgomp.so
# NOTE: Complete hack. Find better way later. This moves libgomp.so to a directory where javacpp can find it.
# For linux, this can be found here: https://github.com/eclipse/deeplearning4j/blob/master/nd4j/nd4j-backends/nd4j-backend-impls/nd4j-native-preset/src/main/java/org/nd4j/nativeblas/Nd4jCpuPresets.java#L150
# Note also, that the g++ --version as of this writing (May 3,2021) currently returns 5.5.0. This will need to be changed in other versions if there is an update.
#sudo cp "${LIBGOMP_PATH}" /usr/lib
sudo apt-get -y autoremove
sudo apt-get -y clean
# download libnd4j from a url and set it up if LIBND4J_FILE_NAME is defined
bash ./bootstrap-libnd4j-from-url.sh
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$OPENBLAS_PATH"
if [ "$PERFORM_RELEASE" == 1 ]; then
          bash ${GITHUB_WORKSPACE}/release-specified-component.sh "${RELEASE_VERSION}" "${SNAPSHOT_VERSION}" "${RELEASE_REPO_ID}" "${command}"
         else
             echo "Running build and deploying to snapshots"
             eval "${COMMAND}"
fi