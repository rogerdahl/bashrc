# Docker

# Install Docker CE
docker_install() {
  sudo apt_get update

  sudo apt_get install -y \
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

  sudo apt_get update
  sudo apt_get install -y docker-ce

  sudo usermod -aG docker $USER
  newgrp docker
}

# Install command completion for bash
docker_install_completion() {
  sudo curl -L \
    https://raw.githubusercontent.com/docker/compose/1.28.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
}

# Spin up a Linux Mint container for dangerous experiments.
docker_mint() {
  docker pull linuxmintd/mint19-amd64
  docker run -d linuxmintd/mint19-amd64
}
