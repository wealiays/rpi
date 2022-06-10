#!/bin/bash

#Color set
bold_bluebackground="\e[1;44;4m"
black_on_green="\e[30;42m"
red_background = "\e[41m"
endcolor="\e[0m"

if [ -f /etc/os-release ] && grep -q "raspbian" /etc/os-release; then
        # Remove extra packages
        echo "${bold_bluebackground}******** Removing extra packages ********${endcolor}"
        sudo apt-get purge -y wolfram-engine
        sudo apt-get purge -y libreoffice*
        sudo apt-get clean
        sudo apt-get autoremove

        # Update and upgrade any existing packages
        echo "${bold_bluebackground}******** Updating current packages********${endcolor}"
        sudo apt update && sudo apt upgrade

        # Install OpenCV Dependencies
        echo "${bold_bluebackground}******** Checking OpenCV Dependencies ********${endcolor}"
        sudo apt-get install -y \
                        libjpeg-dev \
                        libtiff5-dev \
                        libjasper-dev \
                        libpng-dev \
                        libavcodec-dev \
                        libavformat-dev \
                        libswscale-dev \
                        libv4l-dev \
                        libxvidcore-dev \
                        libx264-dev \
                        libfontconfig1-dev \
                        libcairo2-dev \
                        libgdk-pixbuf2.0-dev \
                        libpango1.0-dev \
                        libgtk2.0-dev \
                        libgtk-3-dev \
                        libatlas-base-dev \
                        gfortran \
                        libhdf5-dev \
                        libhdf5-serial-dev \
                        libhdf5-103 \
                        libqt5gui5 \
                        libqt5webkit5 \
                        libqt5test5 \
                        python3-pyqt5 \
                        python3-dev

        # Install OpenVino Dependencies
        echo "${bold_bluebackground}******** Checking OpenVINO Dependencies ********${endcolor}"

                sudo -E apt update
                sudo -E apt-get install -y \
                                build-essential \
                                curl \
                                wget \
                                libssl-dev \
                                ca-certificates \
                                git \
                                libboost-regex-dev \
                                libgtk2.0-dev \
                                pkg-config \
                                unzip \
                                automake \
                                libtool \
                                autoconf \
                                libcairo2-dev \
                                libpango1.0-dev \
                                libglib2.0-dev \
                                libgtk2.0-dev \
                                libswscale-dev \
                                libavcodec-dev \
                                libavformat-dev \
                                libgstreamer1.0-0 \
                                gstreamer1.0-plugins-base \
                                libusb-1.0-0-dev \
                                libopenblas-dev \
                                libgtk-3-dev \
                                libcanberra-gtk* \

                if apt-cache search --names-only '^libpng12-dev'| grep -q libpng12; then
                        sudo -E apt-get install -y libpng12-dev
                else
                        sudo -E apt-get install -y libpng-dev
                fi

        #Install pip
        echo "${bold_bluebackground}******** Installing pip ********${endcolor}"
        wget https://bootstrap.pypa.io/get-pip.py
        sudo python get-pip.py
        sudo python3 get-pip.py
        sudo rm -rf ~/.cache/pip

	#Install GitHub CLI for cred caching
        echo "${bold_bluebackground}******** Installing GitHub CLI ********${endcolor}"
        curl -fsSl https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh

        # Install cmake
        # cmake 3.13 or higher is required to build OpenVINO
        echo "${bold_bluebackground}******** Checking cmake ********${endcolor}"
        current_cmake_version=$(cmake --version | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,4\}[0-9][^.]\).*/\1/p')
        required_cmake_ver=3.22
        if [ ! "$(printf '%s\n' "$required_cmake_ver" "$current_cmake_version" | sort -V | head -n1)" = "$required_cmake_ver" ]; then
                echo "${bold_bluebackground}Installing cmake...."
                wget "https://github.com/Kitware/CMake/releases/download/v3.22.5/cmake-3.22.5.tar.gz"
                tar xf cmake-3.22.5.tar.gz
                (cd cmake-3.22.5 && ./bootstrap --parallel="$(nproc --all)" && make --jobs="$(nproc --all)" && sudo make install)
                rm -rf cmake-3.22.5 cmake-3.22.5.tar.gz
        else
                echo "${bold_bluebackground}cmake already installed and latest version${endcolor}"
        fi

        echo " "
        echo " "
        echo "${black_on_green}########## All scripts completed! ##########${endcolor}"
        echo " "
        echo " "
else
        echo "${red_background}Unsupported OS${endcolor}"
fi
