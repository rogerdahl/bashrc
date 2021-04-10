# Docker

# Install Docker CE
docker_install() {
  pkg_install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

  # Trust Docker's public key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # Add the repo.
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(
    . /etc/os-release
    echo "$UBUNTU_CODENAME"
  ) stable"

  pkg_install docker-ce

  sudo usermod -aG docker $USER
  newgrp docker
}

# Install command completion for bash
docker_install_completion() {
  sudo curl -L \
    https://raw.githubusercontent.com/docker/compose/1.28.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
}

# Spin up a Linux Mint container and log into it.
docker_mint() {
  mint_image='linuxmintd/mint19-amd64:latest'
  docker pull "$mint_image"
  container_id="$(docker run --detach --tty "$mint_image")"

  docker exec -it "$container_id" bash -c '
    cd /root
    echo > .bashrc ". \"$HOME/bin/bashrc.d/init.sh\""
    echo >> .bashrc "cd"
    mkdir bin

    sudo apt-get update --yes
    sudo apt-get dist-upgrade --yes
    sudo apt-get autoclean --yes
    sudo apt-get autoremove --purge --yes
  '

  docker cp "$BASHRC_DIR" "$container_id:/root/bin/bashrc.d"
  docker cp "$BASHRC_DIR/../update.sh" "$container_id:/root/bin"

  docker exec --interactive --tty "$container_id" bash -c -i '
    update.sh
  '
}

# Snapshot save and restore
docker_snap() {
  docker checkpoint
}

docker_restore() {
  checkpoint_name="$1"
  destination_dir="$2"
  docker start --checkpoint "$checkpoint_name" --checkpoint-dir "$destination_dir"
}

docker-stop-all() { docker stop $(docker ps -q); }

docker-shell() { docker exec -it $(docker-last) bash $@; }

docker-ls() { docker exec -it $(docker-last) ls -al /root; }

docker-last() {
  read -ra id_arr <<<$(docker ps -q)
  printf "%s" "$id_arr"
}
