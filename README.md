# `rules_ansible`

`rules_ansible` is a Bazel ruleset for running
[Ansible](https://github.com/ansible/ansible) playbooks via Bazel.

## Why?

The impetus for `rules_ansible` was _not_ for running machine-generated
playbooks. (Of course, nothing is stopping you; you do you. But Ansible is quite
expressive on its own.) The point was to have Bazel manage the Ansible tool
itself.

Ansible is typically distributed as a Python wheel and installed from PyPI with
`pip`. In addition, extensions to Ansible, called "collections", are distributed
separately and installed with `ansible-galaxy`. In order to manage the precise
version of Ansible _and its collections_ in your Ansible config repo, you've got
your work cut out for you. `venv` itself isn't enough to wrangle the
collections. You have to run Ansible with just the right environment vars and
flags to keep things hermetic. You might even consider using a container, which
is somewhat heavy-handed.

Bazel is good at wrangling these sorts of things. Furthermore, if you're already
using Bazel in your shop, it is much preferred to do this with Bazel, for
consistency at the very least.

If running Ansible were as simple as installing a Python wheel, this wouldn't
justify a custom ruleset; you could just use `rules_python` in the usual way.
The collections are the rub. Getting them installed within Bazel in a hermetic
fashion requires a custom rule at the very least, then a somewhat awkward
invocation of `ansible-playbook` so it can find those collections. In for a
penny, in for a pound: a custom ruleset was born.

## How?

See the `examples` directory.
