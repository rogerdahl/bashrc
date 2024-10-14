# High DPI Support in Qt

# Qt 5.6 supports cross-platform high-DPI scaling for legacy applications, similar to the scaling done natively in macOS. This allows applications written for low DPI screens to run unchanged on high DPI devices. This feature is opt-in, and can be enabled using the following environment variables:
#    QT_AUTO_SCREEN_SCALE_FACTOR [boolean] enables automatic scaling, based on the monitor's pixel density. This won't change the size of point-sized fonts, since point is a physical measurement unit. Multiple screens may get different scale factors.
#    QT_SCALE_FACTOR [numeric] defines a global scale factor for the whole application, including point-sized fonts.
#    QT_SCREEN_SCALE_FACTORS [list] specifies scale factors for each screen. This won't change the size of point-sized fonts. The environment variable is mainly useful for debugging, or to work around monitors with wrong EDID information(Extended Display Identification Data).

#    The format can either be a semicolon-separated list of scale factors in the same order as QGuiApplication::screens(), or a semicolon-separated list of name=value pairs, where name is the same as QScreen::name().

# While the macOS style fully supports high-DPI, the Windows desktop style currently has some limitations with certain scale factors. In these cases, consider using the Fusion style instead, which supports high-DPI in all cases.

# Note: Non-integer scale factors may cause significant scaling/painting artifacts.
# The Qt::AA_EnableHighDpiScaling application attribute, introduced in Qt 5.6, enables automatic scaling based on the monitor's pixel density.
# The Qt::AA_DisableHighDpiScaling application attribute, introduced in Qt 5.6, turns off all scaling. This is intended for applications that require actual window system coordinates, regardless of environment variables. This attribute takes priority over Qt::AA_EnableHighDpiScaling.
# The QT_ENABLE_HIGHDPI_SCALING environment variable, introduced in Qt 5.14, enables automatic scaling based on the pixel density of the monitor. Replaces QT_AUTO_SCREEN_SCALE_FACTOR.
# The QT_SCALE_FACTOR_ROUNDING_POLICY environment variable and QGuiApplication::highDpiScaleFactorRoundingPolicy API, introduced in Qt 5.14, makes it possible to control if and how the device pixel ratio should be rounded to the nearest integer. This is relevant for configurations like Windows at 150% scale. Possible values are Round, Ceil, Floor, RoundPreferFloor, PassThrough. See the Qt::HighDpiScaleFactorRoundingPolicy enum documentation for a full description of the options.
# In Qt 5.4, there was an experimental implementation of high DPI scaling introduced via the QT_DEVICE_PIXEL_RATIO environment variable, that you could set to a numerical scale factor or auto. This variable was deprecated in Qt 5.6.

# ADD to my doc about scaling:
# Text rendered at the right size looks much better than text rendered too large, then resized to the right resolution.
# This works together with ~/.Xresources. I have Xft.dpi: 150 there now. All screens share the same value. Because resizing is done inthe NVIDIA control panel, which, I think, causes a final resize to be done on the side panels.

# Unset all QT env vars
qt-unset() {
  for f in $(env | grep -oP 'QT[^=]*'); do
    unset "$f";
  done
}

# Config QT env vars
qt-conf() {
#  export QT_SCALE_FACTOR=1.2
#  export QT_AUTO_SCREEN_SCALE_FACTOR=0
#  export QT_SCREEN_SCALE_FACTORS=1
#  export QT_ACCESSIBILITY=0
#  export QT4_IM_MODULE=ibus
#  export QT_IM_MODULE=ibus
  export QT_QPA_PLATFORMTHEME=qt5ct
#  export QT_PLATFORM_PLUGIN=gtk2
  # This style is the only one I've found that works for setting VirtualBox Manager to a dark theme.
  # It's best to set this directly on the virtualbox launch config, since this is not the style I
  # want for all QT apps.
#  export QT_STYLE_OVERRIDE=adwaita-dark
}

# Print QT env vars
qt-print() {
  printf 'Exported QT env vars:\n'
  env | grep '^QT_'
}

qt-unset
qt-conf

