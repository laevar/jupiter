Summary:	Jupiter - Eee PC Support
Name:		jupiter-support-eee
Version:	0.0.13
Release:	4
License:	GPL
Group:		X11/Applications
Source0:	%{name}_%{version}.tar.gz
URL:		http://www.jupiterapplet.org/
Requires:	coreutils
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Hardware Control Interface for Eee PCs

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT%{_sysconfdir}/{default,acpi/events,acpi/actions}
install -d $RPM_BUILD_ROOT/var/jupiter
install -d "$RPM_BUILD_ROOT/usr/lib/jupiter/vendors/ASUSTeK Computer INC."

install "usr/lib/jupiter/vendors/ASUSTeK Computer INC./cpu-control" "$RPM_BUILD_ROOT/usr/lib/jupiter/vendors/ASUSTeK Computer INC./"
install etc/acpi/events/* $RPM_BUILD_ROOT%{_sysconfdir}/acpi/events/
install etc/acpi/actions/* $RPM_BUILD_ROOT%{_sysconfdir}/acpi/actions/
install etc/default/jupiter-support-eee $RPM_BUILD_ROOT/etc/default/jupiter-support-eee

%post
cat <<EOF
Note: Due to a packaging error in the previous version,
/etc/default/jupiter-support-eee may be moved to
/etc/default/jupiter-support-eee.rpmsave.

This issue should be self corrected in the package however, if you experience
an issue with your Eee PC where you find your FN keys no longer function
correctly, execute this command:

beesu mv /etc/default/jupiter-support-eee.rpmsaved /etc/default/jupiter-support-eee
EOF

if [ ! -e "/etc/default/jupiter-support-eee" ]; then
  cp /etc/default/jupiter-support-eee.rpmsaved /etc/default/jupiter-support-eee 2>/dev/null || true
fi

touch "/usr/lib/jupiter/vendors/ASUSTeK Computer INC./battery" || true
touch "/usr/lib/jupiter/vendors/ASUSTeK Computer INC./power" || true
chown -R root:root "/usr/lib/jupiter/vendors/ASUSTeK Computer INC./" || true
chmod -R 755 "/usr/lib/jupiter/vendors/ASUSTeK Computer INC./" || true

if [ "$(ps -ef | grep /acpid | grep -v grep)" ]; then
  /etc/init.d/acpid restart 2>/dev/null || true
fi

chown -R root:root /usr/lib/jupiter
chmod -R 755 /usr/lib/jupiter

%preun

%files
%defattr(644,root,root,755)
%dir  "/usr/lib/jupiter/vendors/ASUSTeK Computer INC."
%attr(755,root,root) "/usr/lib/jupiter/vendors/ASUSTeK Computer INC./cpu-control"
%attr(755,root,root) /etc/default/jupiter-support-eee
%dir /etc/acpi/actions
%attr(755,root,root) /etc/acpi/actions/*
%dir /etc/acpi/events
%attr(755,root,root) /etc/acpi/events/*
/etc/acpi/events/eeepc-hotkeys

%changelog
* Wed Apr 13 2011 Andrew Wyatt <andrew@fuduntu.org> 0.0.13-4
- Fix a glitch in the package that causes jupiter-support-eee to be moved.

* Sun Apr 03 2011 Andrew Wyatt <andrew@fuduntu.org> 0.0.13
- Work around the kernel handling FN-F3 (WIFI toggle) rather than sending it to userland as it should be..
