#!/usr/bin/awk -f


# In a perfect world, I wouldn't need to store most lines of the input file in memory.

BEGIN{
    current_directory = "/"
    DISK_SIZE = 70000000
    UPDATE_SIZE = 30000000
    size_of_smallest_eligible_directory = DISK_SIZE
}

/^\$ cd/ {
    # Determine working directory
    directory_moved_to = $3
    if(directory_moved_to == "/"){
        current_directory = directory_moved_to
    } else if(directory_moved_to == ".."){
        sub(/[^/]+\/$/, "", current_directory)
    } else {
        current_directory = current_directory "" directory_moved_to "/"
    }
    # Store unique working directories
    if(!(current_directory in dirs_visited)){
        dirs_visited[current_directory]
    }
    next
}

# Array:
#   Keys are the file paths
#   Values are the sizes
#
# Files are unique, so I suppose it doesn't make a difference
# whether the key is overwritten by itself when duplicate values appear.
!(/^dir / || /\$ ls/){
    file_size = $1
    file_name = $2
    full_path = current_directory "" file_name
    file_sizes[full_path] = file_size
}

END{
    # Find the total size of each directory
    for(dir in dirs_visited){
        dir_pattern = "^" dir
        for(file in file_sizes){
            if(file ~ dir_pattern){
                dirs_visited[dir] += file_sizes[file]
            }
        }
        dir_size = dirs_visited[dir]
        # Answer the question to scenario 1
        if(dir_size <= 100000){
            total += dir_size
        }
    }
    # Answer the question to scenario 2
    free_disk_space = DISK_SIZE - dirs_visited["/"]
    additional_space_required = UPDATE_SIZE - free_disk_space
    for(dir in dirs_visited){
        dir_size = dirs_visited[dir]
        if(dir_size >= additional_space_required && dir_size <= size_of_smallest_eligible_directory){
            size_of_smallest_eligible_directory = dir_size
        }
    }
    print "Total size of all directories whose individual sizes are under 100k:", total
    print "Size of smallest directory that would free enough space for the update:", size_of_smallest_eligible_directory
}

