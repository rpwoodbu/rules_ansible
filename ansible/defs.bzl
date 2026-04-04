load("//ansible/private:collections.bzl", _ansible_collections = "ansible_collections")
load("//ansible/private:playbook.bzl", _ansible_playbook = "ansible_playbook")

ansible_collections = _ansible_collections
ansible_playbook = _ansible_playbook
