module appwrite.enums.browser_permission;

/// BrowserPermission
enum BrowserPermission : string
{
    geolocation = "geolocation",
    camera = "camera",
    microphone = "microphone",
    notifications = "notifications",
    midi = "midi",
    push = "push",
    clipboardRead = "clipboard-read",
    clipboardWrite = "clipboard-write",
    paymentHandler = "payment-handler",
    usb = "usb",
    bluetooth = "bluetooth",
    accelerometer = "accelerometer",
    gyroscope = "gyroscope",
    magnetometer = "magnetometer",
    ambientLightSensor = "ambient-light-sensor",
    backgroundSync = "background-sync",
    persistentStorage = "persistent-storage",
    screenWakeLock = "screen-wake-lock",
    webShare = "web-share",
    xrSpatialTracking = "xr-spatial-tracking",
}
