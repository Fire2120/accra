---
- name: Copy file to nod
  hosts: all
  tasks:
  - name: Copy test.txt to node
    copy:
      src: /home/kayaato/automationlab/test.txt
      dest: /tmp
      mode: 0644
