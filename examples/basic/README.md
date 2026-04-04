# Basic example

See the `BUILD.bazel` file. It's very simple. It loads the playbook and the
inventory. Edit `inventory.yaml` to reference a host you own (or override it
with `-i`; see below). Then you can just run the `ansible_playbook` target:

```shell
bazel run //examples/basic:my_playbook
```

You can add any `ansible-playbook` flags to the command line that you may want:

```shell
# Trailing comma is necessary if using `-i` to specify a single host.
bazel run //examples/basic:my_playbook -- --check --diff -i some_host.mydomain.com,
```
