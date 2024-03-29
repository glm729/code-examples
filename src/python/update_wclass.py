#!/usr/bin/env python3


# Imports
# -----------------------------------------------------------------------------


import re
import subprocess as sp
from Message import Message


# Class definition
# -----------------------------------------------------------------------------


class Updater:

    def __init__(self):
        self.cmd_apt_update = ["sudo", "apt", "update"]
        self.cmd_apt_list = ["apt", "list", "--upgradable"]
        self.cmd_apt_upgrade = ["sudo", "apt", "-y", "full-upgrade"]
        self.rex_apt_list = re.compile("^([^\/]+)(?=\/)")
        self.rex_get_n = re.compile("^(?P<n>\d+) packages? can be upgraded")

    def apt_update(self):
        Message("Updating package lists...", form="info").print()
        output = sp.run(self.cmd_apt_update, capture_output=True).stdout
        text = ''.join(chr(c) for c in output).rstrip().split("\n")
        self.result_update = text
        return text

    def apt_list(self):
        output = sp.run(self.cmd_apt_list, capture_output=True).stdout
        text = ''.join(chr(c) for c in output).rstrip().split("\n")[1:]
        func = lambda x: self.rex_apt_list.match(x).group(1)
        result_list = list(map(func, text))
        pretty_list = f'\n{9 * " "}'.join(result_list)
        self.result_list = result_list
        _msg = f'Package{self.s} to upgrade:\n{9 * " "}{pretty_list}'
        Message(_msg, form="ok").print()
        return result_list

    def _get_n_from_last(self):
        last = self.result_update[len(self.result_update) - 1]
        if last == "All packages are up to date.":
            return 0
        if (match := self.rex_get_n.match(last)) is not None:
            return int(match["n"])
        _msg = f'\033[7;31m ERROR \033[0m Message not recognised:\n{last}'
        Message(_msg, form="exit").print()
        raise RuntimeError("apt update message not recognised")

    def check_update(self):
        n = self._get_n_from_last()
        self.s = '' if n == 1 else "s"
        self.num_upgrade = n
        if n > 0:
            _msg = f'{n} package{self.s} to upgrade, fetching list...'
            Message(_msg, form="info").print()
            self.apt_list()
        else:
            Message("Nothing to upgrade", form="ok").print()
        return n

    def apt_upgrade(self):
        if self.is_upgrade():
            Message(f'Upgrading package{self.s}', form="ok").print()
            sp.run(self.cmd_apt_upgrade)

    def is_upgrade(self):
        msg = Message(f'Upgrade package{self.s}? [y/n]: ', form="input").text
        upgrade = input(msg).lower()
        while not upgrade in ["y", "n"]:
            Message("Please enter only y or n", form="warn").print()
            upgrade = "y" if is_upgrade() else "n"
        return upgrade == "y"


# Operations
# -----------------------------------------------------------------------------


# Initialise the updater
runner = Updater()

# Run apt update and check
runner.apt_update()
runner.check_update()

# If at least one package to upgrade, run the upgrade
if runner.num_upgrade > 0:
    runner.apt_upgrade()
    Message("End of operations", form="ok").print()

# All done
exit(0)
