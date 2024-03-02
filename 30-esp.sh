# ESP32

# Install for pyenv.
# Run in the root of the project.
_esp_idf_path="$HOME/sdk/esp-idf"

is_dir "$_esp_idf_path" && {
  # Must be run from the same Python environment that it was installed in.
  # It's probably best to keep a separate venv only for ESP-IDF and set set it in the
  # root of ESP-IDF projects.
  ESP_IDF_PATH="$_esp_idf_path"
  IDF_PYTHON_ENV_PATH="$_esp_idf_path/venv"
  # Activate ESP-IDF environment with "get-idf"
  alias get-idf='. $ESP_IDF_PATH/export.sh'
  PY_ESP_IDF_VENV="esp-idf"

  export IDF_PYTHON_ENV_PATH
  export ESP_IDF_PATH
  export PY_ESP_IDF_VENV
}

function esp-idf-install() {
  [[ -f "./sdkconfig" ]] || {
    echo 'Run this command in the root of an ESP-IDF project'
    echo '(Checked for and did not find "./sdkconfig")'
    return 1
  }
  pyenv-setup
  pyenv-is-installed-venv "$PY_ESP_IDF_VENV" || {
    PY_LATEST_VER="$(pyenv-find-latest-py-ver)"
    pyenv-install-venv "$PY_LATEST_VER" "$PY_PY_ESP_IDF_VENV"
  }
  pyenv local "$PY_PY_ESP_IDF_VENV"
  "$ESP_IDF_PATH/install.sh"
  pip-wheel
  . "$ESP_IDF_PATH/export.sh"
}

function esp-idf-install-pip-deps() {
  pip-install-core-packages
  pip install \
    "gdbgui==0.13.2.0" \
    "pygdbmi<=0.9.0.2" \
    "reedsolo>=1.5.3,<=1.5.4" \
    "bitstring>=3.1.6" \
    "ecdsa>=0.16.0"
}

# Dark mode for menuconfig
#idf.py menuconfig --style monochrome
export MENUCONFIG_STYLE='monochrome'

# ESP8266
#padd "/home/dahl/hdd/sdk/esp8266/xtensa-lx106-elf/bin"
#export ESP_ROOT="/home/dahl/hdd/sdk/esp8266"
##export SDK_PATH="/mnt/int-4.0-hgst/dev_sdk/esp8266_sdk/ESP8266_RTOS_SDK"
##export BIN_PATH="/mnt/int-4.0-hgst/dev_sdk/esp8266_sdk/ESP8266_RTOS_SDK/bin"
