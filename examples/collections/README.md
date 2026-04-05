# Example with collections

See the `BUILD.bazel` file as well as the end of `MODULE.bazel` at the top of
the repo where collections are fetched. Edit `inventory.yaml` to reference a
host you own (or override it with `-i`; see below). Then you can just run the
`ansible_playbook` target:

```shell
bazel run //examples/collections:my_playbook
```

You can add any `ansible-playbook` flags to the command line that you may want:

```shell
# Trailing comma is necessary if using `-i` to specify a single host.
bazel run //examples/collections:my_playbook -- --check --diff -i some_host.mydomain.com,
```
