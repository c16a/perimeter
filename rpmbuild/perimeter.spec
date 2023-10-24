Name:           perimeter
Version:        1.0.0
Release:        1%{?dist}
Summary:        Very cool app
BuildArch:      x86_64
URL:            https://github.com/c16a/perimeter
License:        MIT
Source0:        %{name}-%{version}.tar.gz

Requires:       bash

%description
Cross platform API testing environment

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/%{_bindir}/%{name}
cp %{name} $RPM_BUILD_ROOT/%{_bindir}/%{name}
cp -R lib $RPM_BUILD_ROOT/%{_bindir}/%{name}
cp -R data $RPM_BUILD_ROOT/%{_bindir}/%{name}

desktop-file-install %{name}.desktop

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/%{name}
/usr/share/applications/