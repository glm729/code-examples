#!/usr/bin/env python3


# Imports
# -----------------------------------------------------------------------------


import re
import subprocess as sp


# Function definitions
# -----------------------------------------------------------------------------


def cmd_update():
    op = sp.run("sudo apt update".split(" "), capture_output = True).stdout
    return "".join(chr(o) for o in op).rstrip().split("\n")


def check_last(last):
    if last == "All packages are up to date.":
        return 0
    match = re.match("^(?P<n>\d+) packages? can be upgraded", last)
    if match is None:
        print("\033[7;31mMessage not recognised:\033[0m\n%s" % last)
        raise RuntimeError("Message not recognised")
    return match["n"]


def is_upgrade():
    upgrade = input("\033[7;33mUpgrade packages? [y/n]:\033[0m  ").lower()
    while not upgrade in ["y", "n"]:
        print("\033[7;35mPlease enter only y or n\033[0m")
        upgrade = "y" if is_upgrade() else "n"
        pass
    return upgrade == "y"


def check_upgradable():
    cmd = "apt list --upgradable".split(" ")
    run = sp.run(cmd, capture_output = True).stdout
    res = "".join(chr(c) for c in run).rstrip().split("\n")[1:]
    fin = map(lambda x : re.match("^([^\/]+)(?=\/)", x).group(1), res)
    return list(fin)


# Operations
# -----------------------------------------------------------------------------

print("\033[7;34mUpdating package lists....\033[0m")

cl = check_last(cmd_update()[-1])

if cl == 0:
    print("\033[7;32mNothing to upgrade\033[0m")
    exit(0)
    pass

s = '' if cl == 1 else "s"

ugm = "\033[7;33m{cl} package{s} to upgrade, fetching list....\033[0m"
print(ugm.format(cl = cl, s = s))

u = check_upgradable().join("\n  ")
print("\033[7;34mPackages to be upgraded:\033[0m\n  {u}".format(u = u))

if is_upgrade():
    print("\033[7;36mUpgrading packages\033[0m")
    sp.run("sudo apt -y dist-upgrade".split(" "))
    pass

print("\033[7;32mEnd of operations\033[0m")
exit(0)
