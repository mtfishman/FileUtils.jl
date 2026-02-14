module FileUtils

using DeepDiffs
using Pkg

export replace_in_file, replace_in_files, map_filenames, replace_filenames, max_version

function _replace_in_files(replacement, filenames; showdiffs)
    for filename in filenames
        !isfile(filename) && continue
        replace_in_file(replacement, filename; showdiffs)
    end
    return nothing
end

function replace_in_file(replacement, filename; showdiffs = true)
    txt = read(filename, String)
    open(filename, "w") do f
        return write(f, replace(txt, replacement))
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
            line_diff =
                deepdiff(txt_lines[removed_lines[n]], txt_final_lines[added_lines[n]])
            println("Line $(removed_lines[n]): ", line_diff)
        end
        println()
    end
    return nothing
end

function _replace_in_files_recursive(replacement, path; ignore_dirs, showdiffs)
    for (root, dirs, files) in walkdir(path)
        if !any(ignore_dir -> contains(root, ignore_dir), ignore_dirs)
            _replace_in_files(replacement, joinpath.(root, files); showdiffs = showdiffs)
        end
    end
    return nothing
end

"""
    replace_in_files(replacement::Pair{String, String}, path::String = pwd(); ignore_dirs = [".git"], recursive = true, showdiffs = true)

# Examples

```julia
replace_in_files("@show" => "@test")
```
"""
function replace_in_files(
        replacement, path = pwd(); ignore_dirs = [".git"], recursive = true, showdiffs = true
    )
    if recursive
        _replace_in_files_recursive(replacement, path; ignore_dirs, showdiffs)
    else
        files = readdir(path)
        _replace_in_files(replacement, joinpath.(path, files); showdiffs)
    end
    return nothing
end

"""
    map_filenames(f::Function, path = pwd(); filter_filenames = Returns(true), force = false)

# Examples

```julia
map_filenames(
    filename -> replace(filename, ".txt" => ".txt.backup");
    filter_filenames = startswith("example_")
)
```
"""
function map_filenames(f, path = pwd(); filter_filenames = Returns(true), force = false)
    files = Base.filter(filter_filenames, readdir(path))
    for (i, file) in enumerate(files)
        old_filename = joinpath(path, file)
        new_filename = joinpath(path, f(file))
        println(old_filename, " => ", new_filename)
        if old_filename ≠ new_filename
            mv(old_filename, new_filename; force = force)
        end
    end
    return nothing
end

"""
    replace_filenames(replacement::Pair{String, String}, path = pwd(); filter = Returns(true), force = false)

# Examples

```julia
replace_filenames(".txt" => ".txt.backup")
```
"""
function replace_filenames(replacement, path = pwd(); kwargs...)
    return map_filenames(file -> replace(file, replacement), path; kwargs...)
end

# TODO: move to a package called PkgUtils?
function max_version(depot_path::AbstractString, pkgname::AbstractString)
    path = joinpath(
        depot_path,
        "registries",
        "General",
        first(pkgname, 1),
        pkgname,
        "Versions.toml"
    )
    if isfile(path)
        return maximum(VersionNumber.(keys(Pkg.TOML.parse(read(path, String)))))
    end
    return v"0.0.0"
end

"""
    max_version(pkgname)

# Examples

```julia
max_version("ITensors")
```
"""
max_version(pkgname::AbstractString) = maximum(max_version.(DEPOT_PATH, pkgname))

end
