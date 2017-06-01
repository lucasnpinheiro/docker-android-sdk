FROM ubuntu:16.04

# Configure base folders.
ENV ANDROID_HOME /opt/android-sdk

# Update the base image with the required components.
RUN apt-get update \
  && apt-get install openjdk-8-jdk wget zip unzip git -y \
  && rm -rf /var/lib/apt/lists/*

# Download the Android SDK and unpack it to the destination folder.
ENV ANDROID_SDK_VERSION 3859397

RUN wget --quiet --output-document=sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
  && mkdir ${ANDROID_HOME} \
  && unzip -q sdk-tools.zip -d ${ANDROID_HOME} \
  && rm -f sdk-tools.zip

# Install the SDK components.
ENV ANDROID_BUILD_TOOLS_VERSION 25.0.3

#RUN mkdir ${HOME}/.android
#COPY repositories.cfg ${HOME}/.android
#RUN touch ${HOME}/.android/repositories.cfg \
#  && chown $RUN_USER:$RUN_USER ${HOME}/.android/repositories.cfg
RUN mkdir ${HOME}/.android \
  && echo "count=0" > ${HOME}/.android/repositories.cfg

RUN echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --list --verbose \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager --update \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'tools' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platform-tools' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'build-tools;'${ANDROID_BUILD_TOOLS_VERSION} \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'platforms;android-23' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;android;m2repository' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;google;m2repository' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2' \
  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2'
#  && echo y | ${ANDROID_HOME}/tools/bin/sdkmanager 'add-ons;addon-datalogic-sdk-v1-23-datalogic-23'

# Set the environmental variables
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
