# What is notably new in RHEL 8

:exclamation: We need to perhaps make list shorter

- [**Red Hat Enterprise Linux 8 is distributed through two main repositories**](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/considerations_in_adopting_rhel_8/repositories_considerations-in-adopting-rhel-8)

Gone are the days of remebering what channels to enable for what kind of systems.
- [**Red Hat Enterprise Linux 8 introduces the concept of Application Streams**](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/considerations_in_adopting_rhel_8/application-streams_considerations-in-adopting-rhel-8)

Gone are the days of figuring our which channel contains what version of what software.
- [**New version of the YUM tool, which is based on the DNF technology (YUM v4).**](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/considerations_in_adopting_rhel_8/software-management_considerations-in-adopting-rhel-8#notable-changes-to-the-yum-stack_software-management)

But all previous yum commands still work, yum is an alias pointing to dnf

- [**RHEL 7 supported two implementations of the NTP protocol: ntp and chrony**](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/considerations_in_adopting_rhel_8/infrastructure-services_considerations-in-adopting-rhel-8)

chrony is an implementation of NTP and replaces the previous tools completely. ntpd is removed from our repositories.

