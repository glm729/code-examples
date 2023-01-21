#!/usr/bin/env ruby


# Function definitions
# -----------------------------------------------------------------------------

# Get the split output from the update command
def cmdUpdate
  return %x_sudo apt update 2>/dev/null_.rstrip.split(/\n/)
end

# Check the value of the last line to determine number of packages to upgrade
def checkLast(last)
  return 0 if last === "All packages are up to date."
  match = last.match(/^(?<n>\d+) packages? can be upgraded/)
  return match[:n].to_i if not match.nil?
  raise RuntimeError, "\033[7;31mMessage not recognised:\033[0m\n#{last}"
end

# Ask the user whether to upgrade or not (recursive)
def isUpgrade
  print("\033[7;33mUpgrade packages? [y/n]\033[0m  ")
  is = gets.chomp.downcase
  while not ["y", "n"].include?(is)
    print("\033[7;33mPlease enter only y or n\033[0m\n")
    is = (isUpgrade) ? "y" : "n"
  end
  return is === "y"
end

# Check which packages can be upgraded
def checkUpgradable
  response = %x_apt list --upgradable 2>/dev/null_.split(/\n/)[(1..-1)]
  return response.map{|e| e.match(/^([^\/]+)(?=\/)/)[1]}.sort
end


# Operations
# -----------------------------------------------------------------------------

print("\033[7;34mUpdating package lists....\033[0m\n")

cl = checkLast(cmdUpdate().last)

if cl === 0
  print("\033[7;32mNothing to upgrade\033[0m\n")
  exit 0
end

s = (cl === 1) ? '' : "s"
print("\033[7;33m#{cl} package#{s} to upgrade, fetching list....\033[0m\n")

u = checkUpgradable().join("\n  ")
print("\033[7;34mPackage#{s} to be upgraded:\033[0m\n  #{u}\n")

if isUpgrade()
  print("\033[7;36mUpgrading packages\033[0m\n")
  system("sudo apt -y dist-upgrade")
end

print("\033[7;32mEnd of operations.\033[0m\n")
exit 0
