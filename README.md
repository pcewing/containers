# Containers

General purpose container images for testing things across different Linux
distributions.

## Building

Use the makefile targets to build the images. For example, to build all of the
container images:

```bash
make all
```

## Running

### FZF Quick Launch Function

I recommend adding the following function to `~/.bashrc` or similar.

It will bring up an interactive `fzf` prompt to select from the available
images and then automatically run whatever is selected.

When the container is run, the current working directory on the host will be
mounted into the container as a volume at the same path and set as the working
directory inside of the container. The container is run as the user that was
created with the same name, uid, and gid when the image was built so there
should be no issues with file permissions when modifying files in the volume
inside of the container.

```
function dr() {
    local images selected_image shell

    images="$(docker image ls | grep -E "$(id -un)" | awk '{print $1}')"
    if [ -z "$images" ]; then
        yell "No container images found"
        return 1
    fi

    selected_image="$(echo "$images" | fzf)"
    if [ -z "$selected_image" ]; then
        return 0
    fi

    echo "Running container: $selected_image"
    docker run \
        -it \
        --name "$selected_image" \
        --hostname "$selected_image" \
        -u "$(id -un)" \
        -v "$(pwd):$(pwd)" \
        -w "$(pwd)" \
        --rm \
        "$selected_image" \
        bash
}
```

### Manually Running

See available containers using the `list` makefile target:

```bash
make list
```

Run the container:

```bash
docker run \
    -it \
    -u "$(id -un)" \
    -v "$(pwd):$(pwd)" \
    -w "$(pwd)" \
    "$(id -un)-ubuntu-22.04" \
    bash
```
