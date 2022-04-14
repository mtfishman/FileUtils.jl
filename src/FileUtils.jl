module FileUtils

using DeepDiffs
using Pkg

export replace_in_file, replace_in_files, map_filenames, replace_filenames, max_version

function _replace_in_files(filenames, replacement; showdiffs)
  for filename in filenames
    !isfile(filename) && continue
    replace_in_file(filename, replacement; showdiffs)
  end
  return nothing
end

function replace_in_file(filename, replacement; showdiffs=true)
  txt = read(filename, String)
  open(filename, "w") do f
    write(f, replace(txt, replacement))
  end
  if showdiffs
    txt_final = read(filename, String)
    diff = deepdiff(txt, txt_final)
    println(filename)
    removed_lines = removed(diff)
    added_lines = added(diff)
    txt_lines = split(txt, "\n")
    txt_final_lines = split(txt_final, "\n")
    @assert removed_lines == added_lines
    for n in 1:length(removed_lines)
      line_diff = deepdiff(txt_lines[removed_lines[n]], txt_final_lines[added_lines[n]])
      println("Line $(removed_lines[n]): ", line_diff)
    end
    println()
  end
  return nothing
end

function _replace_in_files_recursive(path, replacement; ignore_dirs, showdiffs)
  for (root, dirs, files) in walkdir(path)
    if !any(ignore_dir -> contains(root, ignore_dir), ignore_dirs)
      _replace_in_files(joinpath.(root, files), replacement; showdiffs=showdiffs)
    end
  end
  return nothing
end

function replace_in_files(path, replacement; ignore_dirs=[], recursive=false, showdiffs=true)
  if recursive
    _replace_in_files_recursive(path, replacement; ignore_dirs=ignore_dirs, showdiffs=showdiffs)
  else
    files = readdir(path)
    _replace_in_files(joinpath.(path, files), replacement; showdiffs=showdiffs)
  end
  return nothing
end

function map_filenames(f, path=pwd(); filter=Returns(true), force=false)
  files = Base.filter(filter, readdir(path))
  for (i, file) in enumerate(files)
    old_filename = joinpath(path, file)
    new_filename = joinpath(path, f(file))
    println(old_filename, " => ", new_filename)
    if old_filename ≠ new_filename
      mv(old_filename, new_filename; force=force)
    end
  end
  return nothing
end

function replace_filenames(replacement, args...; kwargs...)
  return map_filenames(file -> replace(file, replacement), args...; kwargs...)
end

# TODO: move to a package called PkgUtils?
function max_version(depot_path::AbstractString, pkgname::AbstractString)
  path = joinpath(depot_path, "registries", "General",
                  first(pkgname, 1), pkgname, "Versions.toml")
  if isfile(path)
    return maximum(VersionNumber.(keys(Pkg.TOML.parse(read(path, String)))))
  end
  return v"0.0.0"
end

max_version(pkgname::AbstractString) = maximum(max_version.(DEPOT_PATH, pkgname))

end
