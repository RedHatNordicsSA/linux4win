# Management of servers using RHEL System Roles
RHEL System Roles is a collection of Ansible roles and modules. RHEL System Roles provide a consistent configuration interface to remotely manage multiple RHEL systems.

On Red Hat Enterprise Linux 8 the following roles are currently supported:

- kdump
- network
- selinux
- storage
- certificate
- kernel_settings
- logging
- metrics
- nbde_client and nbde_server
- timesync
- tlog

### Ansible prerequisites

:exclamation: It is recommended to finish [assignment4](assign4.md) before continuing with this module. If you did, please skip ahead to the next section [Installing RHEL System Roles](#installing-rhel-system-roles).

If you havn't done [assignment4](assign4.md) you need to perform the following steps to install and setup Ansible on your first RHEL server, the Ansible Control Node.

Install Ansible:

```
sudo dnf install ansible -y
```

Create an Ansible host file (inventory). We'll use the default Ansible hosts file in this excercise:

```
sudo cp /etc/ansible/hosts /etc/ansible/hosts.backup
```

So now we have a backup file we can lookup if needed. Now it is time to fill the file with simple context. Type below commands to put your Red Hat Enterprise Linux server into the inventory file:

```
sudo su -
echo "[linux]" > /etc/ansible/hosts
echo "ip.address.of.linuxserver1" >>/etc/ansible/hosts
echo "ip.address.of.linuxserver2" >>/etc/ansible/hosts
exit
```

:exclamation: Please note the double ```>>``` on the two last lines.

Using passwords mid-automation can be troublesome. Let's generate SSH keys the Ansible Control Node can use.

:boom: Do not enter a password for the key. Type below command (just press enter for all questions):

```q
ssh-keygen
```

Copy the key to your servers by running below command:

```
for i in $(ansible --list-hosts linux |grep -v : |xargs); do ssh-copy-id rhel@$i; done
```

Now try running an ad-hoc command on all RHEL servers and verify that the key works:

```
ansible linux -m shell -a 'cat /etc/redhat-release'
```

If all servers responded correctly the Ansible prerequisites are met and you're now ready to continue with the next section.

### Installing RHEL System Roles

All roles included are provided by the `rhel-system-roles` package. Install using the `Terminal` option in the `Web Console` on the Ansible Control Node.

```bash
sudo dnf install rhel-system-roles
```

:exclamation: Earlier in this assignment you also installed `ansible`. This is a prerequisite for using RHEL System Roles.

With `rhel-system-roles` installed, try having a look at the documentation under `/usr/share/doc/rhel-system-roles/SUBSYSTEM/` and also find example playbooks. Here's an example:

```bash
cat /usr/share/doc/rhel-system-roles/selinux/example-selinux-playbook.yml
```

Also try to look at the Ansible roles themselves.

```bash
head /usr/share/ansible/roles/rhel-system-roles.timesync/tasks/main.yml
```

```yaml
---
- name: Check if only NTP is needed
  set_fact:
    timesync_mode: 1
  when: timesync_ptp_domains|length == 0

- name: Check if single PTP is needed
  set_fact:
    timesync_mode: 2
```

### Configure linux servers using RHEL System Roles

It's time to use the System Roles. Try to configure time services on the RHEL servers using the `timesync` system role.

Create a simple playbook to configure a fixed set of time servers on your RHEL servers:

```bash
cat > timesync-playbook.yml << EOF
---
- hosts: linux
  vars:
    timesync_ntp_servers:
      - hostname: 0.pool.ntp.org
        iburst: yes
      - hostname: 1.pool.ntp.org
        iburst: yes
      - hostname: 2.pool.ntp.org
        iburst: yes
      - hostname: 3.pool.ntp.org
        iburst: yes
  roles:
    - rhel-system-roles.timesync
EOF
```

Try executing the playbook. Since modifying system services requires eleveted permissions make sure to include the `--become` option (if not already included in playbook).

```bash
ansible-playbook timesync-playbook.yml --become
```

The output will show all tasks from the playbook. We can see that the valid NTP provider for each system is installed and configured. Since all linux servers in this lab are RHEL 8 `chronyd` is configured, but this would have been different if other OS versions were included.

Try running a command on all servers verifying that the `chrony` configuration is updated.

```bash
ansible linux -m shell -a 'head /etc/chrony.conf'
```

Neat! It's a simple example, but this highlights a key benefit of RHEL System Roles. In this case all servers are RHEL 8 so `chrony` was configured, but if you're dealing with mulitiple major versions of RHEL the same playbook can be used to configure different NTP providers depending on OS version.

### Configure performance monitoring using RHEL System Roles

A perhaps more exciting system role is `rhel-system-roles.metrics`. The metrics System Role configures performance analysis services for managed hosts using Performance Co-Pilot (pcp).

Try creating another playbook, again targeting the RHEL servers and now include the `rhel-system-roles.metrics` role.

```bash
cat > metrics-playbook.yml << EOF
---
- hosts: linux
  vars:
    metrics_retention_days: 5
  roles:
    - rhel-system-roles.metrics
EOF
```

Try executing the playbook to configure metrics recording for all RHEL servers in the lab.

```bash
ansible-playbook metrics-playbook.yml --become
```

Try checking the status of the `pmcd` service:

```
systemctl status pmcd.service
```

Cool! Performance metrics recording with Performance Co-Pilot (PCP) is running on the servers.

#### Performance metrics visualization

But what about visualizing those metrics? No problem! The `rhel-system-roles.metrics` role supports configuring Grafana for visualization.

Try creating another playbook. This time you will only target the first server, the server acting Ansible control node. Use the same role `rhel-system-roles.metrics`, but pass different variables to the role. The example below will configure Grafana, Redis and also start to monitor both your servers.

:exclamation: Remember to update `metrics_monitored_hosts` with the IP addresses of your RHEL servers.

```bash
cat > metrics-graph-playbook.yml << EOF
---
- hosts: localhost
  vars:
    metrics_graph_service: yes
    metrics_query_service: yes
    metrics_retention_days: 5
    metrics_monitored_hosts: ["ip.address.of.linuxserver1", "ip.address.of.linuxserver2"]
  roles:
    - rhel-system-roles.metrics
EOF
```

Try executing the playbook on your Ansible control node. Note how only localhost is targeted by Ansible and how the additional services are configured by the role.

```bash
ansible-playbook metrics-graph-playbook.yml --become
```

Still on the Ansible control node, try to check the status of the `grafana-server` and `redis` services.

```bash
systemctl status grafana-server.service redis.service
```

Both services should be running - great! Try accessing the Grafana web UI to verify.

In your browser, go to `http://ip-address-linuxserver1:3000`

For the first login, use `admin:admin` as credentials. Grafana then prompts you to set a new password. More information can be in the [documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/monitoring_and_managing_system_status_and_performance/setting-up-graphical-representation-of-pcp-metrics_monitoring-and-managing-system-status-and-performance#accessing-the-grafana-web-UI_setting-up-graphical-representation-of-pcp-metrics).

Try navigating the default Dashboards in Grafana for a view on the performance metrics being collected.

This concludes the RHEL System Roles assignment. Here's a few links with more information:

* [Getting started with RHEL System Roles](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_basic_system_settings/getting-started-with-system-administration_configuring-basic-system-settings#getting-started-with-rhel-system-roles_getting-started-with-system-administration)
* [Red Hat Knowledgebase article - RHEL System Roles](https://access.redhat.com/articles/3050101)
* [Linux System Roles upstream project](https://linux-system-roles.github.io/)

Continue to [assignment 7](assign7.md)

Back to [index](thews.md)
