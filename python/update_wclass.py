#!/usr/bin/env python3


# Imports
# -----------------------------------------------------------------------------


import re
import subprocess as sp


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
        self._msg("info", "Updating package lists...")
        output = sp.run(self.cmd_apt_update, capture_output=True).stdout
        text = ''.join(chr(c) for c in output).rstrip().split("\n")
        self.result_update = text
        return text

    def apt_list(self):
        output = sp.run(self.cmd_apt_list, capture_output=True).stdout
        text = ''.join(chr(c) for c in output).rstrip().split("\n")[1:]
        func = lambda x: self.rex_apt_list.match(x).group(1)
        result_list = list(map(func, text))
        pretty_list = f'\n{6 * " "}'.join(result_list)
        self.result_list = result_list
        self._msg("ok", f'Package{self.s} to upgrade:\n{6 * " "}{pretty_list}')
        return result_list

    def _get_n_from_last(self):
        last = self.result_update[len(self.result_update) - 1]
        if last == "All packages are up to date.":
            return 0
        if (match := self.rex_get_n.match(last)) is not None:
            return int(match["n"])
        print(f'\033[7;31m ERROR \033[0m Message not recognised:\n{last}')
        raise RuntimeError("apt update message not recognised")

    def check_update(self):
        n = self._get_n_from_last()
        self.s = '' if n == 1 else "s"
        self.num_upgrade = n
        if n > 0:
            self._msg(
                "info",
                f'{n} package{self.s} to upgrade, fetching list...')
            self.apt_list()
        else:
            self._msg("ok", "Nothing to upgrade")
        return n

    def apt_upgrade(self):
        if self.is_upgrade():
            sp.run(self.cmd_apt_upgrade)

    def is_upgrade(self):
        upgrade = input("\033[7;33mUpgrade packages? [y/n]:\033[0m  ").lower()
        while not upgrade in ["y", "n"]:
            print("\033[7;35mPlease enter only y or n\033[0m")
            upgrade = "y" if is_upgrade() else "n"
        return upgrade == "y"

    def _msg(self, ty, tx):
        fmt = {
            "exit": "\033[7;31m EXIT \033[0m ",
            "ok":   "\033[7;32m  OK  \033[0m ",
            "warn": "\033[7;33m WARN \033[0m ",
            "info": "\033[7;34m INFO \033[0m ",
            "data": "\033[7;36m DATA \033[0m "
        }
        print(f'{fmt[ty]}{tx}')
        pass


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

# All done
runner._msg("ok", "End of operations")
exit(0)
