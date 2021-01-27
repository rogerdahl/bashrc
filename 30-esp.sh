# ESP32

# Install ESP32 ESP-IDF (SDK):
# Grab ESP-IDF from GitHub
# - Uncompress it to ~/sdk/esp-idf-<version>
# - Symlink to it from ~/sdk/esp-idf
# - $ pyenv shell 3.8.6
# - $ ~/sdk/esp-idf/install.sh
idf_dir="$HOME/sdk/esp-idf"
is_dir "$idf_dir" && {
  alias get-idf='. $idf_dir/export.sh'
#  echo 'Activate ESP-IDF environment with "get-idf"'
}

#padd "$HOME/bin/esp32/xtensa-esp32-elf/bin"
#export IDF_PATH="$HOME/bin/esp32/esp-idf"
#padd "$HOME/bin/espressif/ct/builds/xtensa-esp32-elf/bin"
#export IDF_PATH=$HOME/bin/espressif/esp-idf
#IDF_ADD_PATHS_EXTRAS="${IDF_PATH}/components/esptool_py/esptool:${IDF_PATH}/components/espcoredump:${IDF_PATH}/components/partition_table/"
#export PATH="${PATH}:${IDF_ADD_PATHS_EXTRAS}"

# ESP8266
#padd "/home/dahl/hdd/sdk/esp8266/xtensa-lx106-elf/bin"
#export ESP_ROOT="/home/dahl/hdd/sdk/esp8266"
##export SDK_PATH="/mnt/int-4.0-hgst/dev_sdk/esp8266_sdk/ESP8266_RTOS_SDK"
##export BIN_PATH="/mnt/int-4.0-hgst/dev_sdk/esp8266_sdk/ESP8266_RTOS_SDK/bin"

