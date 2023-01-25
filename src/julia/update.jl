#!/usr/bin/env julia


# Function definitions
# -----------------------------------------------------------------------------

function cmd_update()::Array{String,1}
  return readlines(pipeline(`sudo apt update`, stderr = devnull))
end

function check_last(last::String)::Union{Nothing,String}
  if last === "All packages are up to date."
    return nothing
  end
  local m = match(r"^(?<n>\d+) packages? can be upgraded", last)
  if isnothing(m)
    println("\e[7;31mMessage not recognised:\e[0m\n$last")
    error("Message not recognised")
  end
  return parse(Int64, m[:n])
end

function is_upgrade()::Bool
  local is::String
  print("\e[7;33mUpgrade packages? [y/n]:\e[0m  ")
  is = lowercase(readline(stdin))
  while !any(x -> x === is, ["y", "n"])
    print("\e[7;35mPlease enter only y or n\e[0m\n")
    is = is_upgrade() ? "y" : "n"
  end
  return is === "y"
end

function check_upgradable()::Array{String,1}
  local resp::Array{String,1}
  resp = readlines(pipeline(`apt list --upgradable`, stderr = devnull))[2:end]
  return sort(map(x::String -> match(r"^([^\/]+)(?=\/)", x), resp))
end


# Operations
# -----------------------------------------------------------------------------

println("\e[7;34mUpdating package lists....\e[0m")

cl = check_last(cmd_update()[end])

if isnothing(cl)
  println("\e[7;32mNothing to upgrade\e[0m")
  exit(0)
end

s = cl === 1 ? '' : "s"
println("\e[7;33m$cl package$s to upgrade, fetching list....\e[0m")

u = join(check_upgradable(), "\n  ")
println("\e[7;34mPackage$s to be upgraded:\e[0m\n  $u")

if is_upgrade()
  println("\e[7;36mUpgrading package$s\e[0m")
  pipeline(`sudo apt -y dist-upgrade`, stderr = devnull, stdout = stdout)
end

println("\e[7;32mEnd of operations\e[0m")
exit(0)
