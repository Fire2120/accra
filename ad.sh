---
- name: Prepare RHEL servers for Active Directory
  hosts: all
  become: true
  gather_facts: true

  vars:
    ad_domain: "home.local"
    ad_realm: "home.local"

  tasks:

    - name: Install Active Directory integration packages
      ansible.builtin.dnf:
        name:
          - realmd
          - sssd
          - sssd-ad
          - sssd-tools
          - adcli
          - krb5-workstation
          - samba-common-tools
          - oddjob
          - oddjob-mkhomedir
          - authselect
          - chrony
        state: present
        update_cache: true

    - name: Enable and start chronyd
      ansible.builtin.systemd:
        name: chronyd
        enabled: true
        state: started

    - name: Enable and start oddjobd
      ansible.builtin.systemd:
        name: oddjobd
        enabled: true
        state: started

    - name: Discover Active Directory domain
      ansible.builtin.command:
        cmd: "realm discover {{ home.local }}"
      register: realm_discover
      changed_when: false

    - name: Display AD discovery information
      ansible.builtin.debug:
        var: realm_discover.stdout_lines

    - name: Check current realm membership
      ansible.builtin.command:
        cmd: realm list
      register: realm_list
      changed_when: false

    - name: Display current realm membership
      ansible.builtin.debug:
        var: realm_list.stdout_lines
