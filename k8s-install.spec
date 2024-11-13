Name: k8s-install
Version: 1.1.0
Release: 2
Summary: Cloundnative Infrastructure Install and Setup
License: ASL 2.0
BuildArch: noarch
Source0: %{name}.tgz
Requires: bash

%description
Use this package when you can reach yum and ctyun harbor by network
Source tgz is generated by publish script and  rpm is published in yum
By default it use kubeadm --init command to setup k8s.
You can edit config/kubeadm-template.yaml and uncomment related lines to use config file setup

%prep
%setup -n %{name}

%install
install -d $RPM_BUILD_ROOT/%{_bindir}
install -d $RPM_BUILD_ROOT%{_sysconfdir}/%{name}
install -p -m 755 k8s-install $RPM_BUILD_ROOT/%{_bindir}/
install -p -m 755 config/* $RPM_BUILD_ROOT/%{_sysconfdir}/%{name}/
install -p -m 755 variable.sh $RPM_BUILD_ROOT/%{_bindir}/

%files
%attr(0755,root,root) %{_bindir}/*
%attr(0644,root,root) %{_sysconfdir}/%{name}/*

%changelog
* Tue Nov 12 2024 MinLiu<lium110@chinatelecom.cn> - 1.1.0-2
- fix bugs
* Tue Oct 15 2024 MinLiu<lium110@chinatelecom.cn> - 1.1.0-1
- update the flannel image repository for the aarch64 architecture.
* Mon Oct 14 2024 MinLiu<lium110@chinatelecom.cn> - 1.1.0-1
- update k8s-install to accommodate multiple Kubernetes versions and various operating systems.
* Fri Feb 17 2023 LeonWang<wangl29@chinatelecom.cn> - 0.1-1
- initial V0.1 for OBS build rpm package