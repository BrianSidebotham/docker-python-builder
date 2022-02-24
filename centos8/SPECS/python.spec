
%define python_major_version %(/bin/echo '%{python_version}' | cut -d '.' -f1)
%define python_minor_version %(/bin/echo '%{python_version}' | cut -d '.' -f2)
%define python_patch_version %(/bin/echo '%{python_version}' | cut -d '.' -f3)
%define python_significant_version %{python_major_version}.%{python_minor_version}
%define python_contracted_version %{python_major_version}%{python_minor_version}
%define package_name python%{python_contracted_version}
%define install_directory /opt/%{package_name}


Name:    %{package_name}
Version: %{python_version}
Release: 1%{?dist}
Summary: Wanless Systems Python %{python_contracted_version}
License: PSF
Source0: https://www.python.org/ftp/python/%{version}/Python-%{python_version}.tar.xz

BuildRequires: openssl-devel
BuildRequires: ncurses-devel
BuildRequires: readline-devel
BuildRequires: libarchive-devel
BuildRequires: libffi-devel
BuildRequires: libuuid-devel
BuildRequires: xz-devel
BuildRequires: bzip2-devel
BuildRequires: sqlite-devel
BuildRequires: make
BuildRequires: sqlite-devel
BuildRequires: zlib-devel
BuildRequires: gdbm-devel

Requires: bzip2
Requires: gdbm
Requires: libarchive
Requires: libffi
Requires: libuuid
Requires: ncurses
Requires: openssl
Requires: readline
Requires: xz
Requires: zlib
Requires: sqlite

# Do not try to determine dependencies automatically. Otherwise the RPM tools come across .py files
# with shebang's that point to /usr/local/bin/python and that becomes a dependency. As we're
# installing python, that's a bit of a crap dependency!
AutoReq: no

# Byte compiling python is broken because of assumptions made in
# /usr/lib/rpm/brp-python-bytecompile so we redefine the os post
# install method to exclude the call to it. Made from /usr/lib/rpm/redhat/macros
%global __os_install_post    \
    /usr/lib/rpm/brp-compress \
    %{!?__debug_package:/usr/lib/rpm/brp-strip %{__strip}} \
    /usr/lib/rpm/brp-strip-static-archive %{__strip} \
    /usr/lib/rpm/brp-strip-comment-note %{__strip} %{__objdump} \
%{nil}

%description
Python %{python_contracted_version} separated install (use %{install_directory}/bin/python%{python_contracted_version})

%prep
tar -C %{_builddir} -xf %{SOURCE0}

%build
cd %{_builddir}/Python-%{python_version}

LDFLAGS="-Wl,-rpath=\\\$\$ORIGIN/../lib" \
CFLAGS="${RPM_OPT_FLAGS}" \
./configure --prefix=%{install_directory} \
            --enable-shared \
            --enable-optimizations \
            --with-system-ffi \
            --with-ensurepip=yes \
            --enable-loadable-sqlite-extensions=yes

LDFLAGS="-Wl,-rpath=\\\$\$ORIGIN/../lib" \
CFLAGS="${RPM_OPT_FLAGS}" \
make %{?_smp_mflags}

%install
cd %{_builddir}/Python-%{python_version}
mkdir -p %{buildroot}
LDFLAGS="-Wl,-rpath=\\\$\$ORIGIN/../lib" \
CFLAGS="${RPM_OPT_FLAGS}" \
make DESTDIR=%{buildroot} install

%clean
rm -rf %{buildroot}

%files
%{install_directory}/*

%post

chmod 775 %{install_directory}/lib
chmod 775 %{install_directory}/lib/python%{python_significant_version}
chmod 775 %{install_directory}/lib/python%{python_significant_version}/site-packages

# Make sure we have pip available on the target machine
if [ ! -d "%{install_directory}/lib/python%{python_significant_version}/site-packages/pip" ]; then
    %{install_directory}/bin/python%{python_contracted_version} -m ensurepip
    if [ $? -ne 0 ]; then
        echo "Failed to run ensurepip!" >&2
        exit 1
    fi
fi

proxy_setting=""
# Decide if we need to use a proxy or not depending on the https_proxy environment variable.
if [ "${https_proxy}X" != "X" ]; then
    proxy_setting="--proxy ${https_proxy}"
fi

# Make sure pip is upgraded on install, so the installed pip works
%{install_directory}/bin/python3 -m pip install ${proxy_setting} requests
if [ $? -ne 0 ]; then
    echo "Error installing requests package!" >&2
    exit 1
fi

# Make sure we have upgraded pip because it's moved a long way
%{install_directory}/bin/python3 -m pip install ${proxy_setting} --upgrade pip
if [ $? -ne 0 ]; then
    echo "Error upgrading pip package!" >&2
    exit 1
fi

# Wheel allows us to use many pre-built versions of the libraries for our architecture rather than having to
# resort to installing gcc and development libraries in order to be able to install various pip packages.
%{install_directory}/bin/python3 -m pip install ${proxy_setting} --upgrade wheel
if [ $? -ne 0 ]; then
    echo "Error upgrading wheel package!" >&2
    exit 1
fi
