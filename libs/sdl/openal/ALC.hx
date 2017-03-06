package openal;

typedef Device  = hl.Abstract<"alc_device">;
typedef Context = hl.Abstract<"alc_context">;

@:hlNative("sdl","alc_")
extern class ALC {
	// Context management
	public static function createContext      (device  : Device, attrlist : hl.Bytes) : Context;
	public static function makeContextCurrent (context : Context) : Bool;
	public static function processContext     (context : Context) : Void;
	public static function suspendContext     (context : Context) : Void;
	public static function destroyContext     (context : Context) : Void;
	public static function getCurrentContext  () : Context;
	public static function getContextsDevice  (context : Context) : Device;

	// Device management
	public static function openDevice  (devicename : hl.Bytes) : Device;
	public static function closeDevice (device : Device) : Bool;

	// Error support
	public static function getError (device : Device) : Int;

	// Extension support
	public static function loadExtensions     (device : Device);
	public static function isExtensionPresent (device : Device, extname : hl.Bytes)  : Bool;
	public static function getEnumValue       (device : Device, enumname : hl.Bytes) : Int;

	// Query function
	public static function getString   (device : Device, param : Int) : hl.Bytes;
	public static function getIntegerv (device : Device, param : Int, size : Int, values : hl.Bytes) : Void;

	// Capture function
	public static function captureOpenDevice  (devicename : hl.Bytes, frequency : Int, format : Int, buffersize : Int) : Device;
	public static function captureCloseDevice (device : Device) : Bool;
	public static function captureStart       (device : Device) : Void;
	public static function captureStop        (device : Device) : Void;
	public static function captureSamples     (device : Device, buffer : hl.Bytes, samples : Int) : Void;

	// ------------------------------------------------------------------------
	// Constants
	// ------------------------------------------------------------------------

	public static inline var FALSE                            = 0;
	public static inline var TRUE                             = 1;

	// Context attributes
	public static inline var FREQUENCY                        = 0x1007;
	public static inline var REFRESH                          = 0x1008;
	public static inline var SYNC                             = 0x1009;
	public static inline var MONO_SOURCES                     = 0x1010;
	public static inline var STEREO_SOURCES                   = 0x1011;

	// Errors
	public static inline var NO_ERROR                         = 0;
	public static inline var INVALID_DEVICE                   = 0xA001;
	public static inline var INVALID_CONTEXT                  = 0xA002;
	public static inline var INVALID_ENUM                     = 0xA003;
	public static inline var INVALID_VALUE                    = 0xA004;
	public static inline var OUT_OF_MEMORY                    = 0xA005;

	// Runtime ALC version
	public static inline var MAJOR_VERSION                    = 0x1000;
	public static inline var MINOR_VERSION                    = 0x1001;

	// Context attribute list properties
	public static inline var ATTRIBUTES_SIZE                  = 0x1002;
	public static inline var ALL_ATTRIBUTES                   = 0x1003;

	// Device strings
	public static inline var DEFAULT_DEVICE_SPECIFIER         = 0x1004;
	public static inline var DEVICE_SPECIFIER                 = 0x1005;
	public static inline var EXTENSIONS                       = 0x1006;

	// Capture extension
	public static inline var EXT_CAPTURE                      = 1;
	public static inline var CAPTURE_DEVICE_SPECIFIER         = 0x310;
	public static inline var CAPTURE_DEFAULT_DEVICE_SPECIFIER = 0x311;
	public static inline var CAPTURE_SAMPLES                  = 0x312;

	// Enumerate All extension
	public static inline var ENUMERATE_ALL_EXT                = 1;
	public static inline var DEFAULT_ALL_DEVICES_SPECIFIER    = 0x1012;
	public static inline var ALL_DEVICES_SPECIFIER            = 0x1013;

	// ----------------------------------------------------------------------------
	// ALC_LOKI_audio_channel
	// ----------------------------------------------------------------------------

	public static inline var CHAN_MAIN_LOKI                   = 0x500001;
	public static inline var CHAN_PCM_LOKI                    = 0x500002;
	public static inline var CHAN_CD_LOKI                     = 0x500003;

	// ----------------------------------------------------------------------------
	// ALC_EXT_disconnect
	// ----------------------------------------------------------------------------

	public static inline var CONNECTED                        = 0x313;

	// ----------------------------------------------------------------------------
	// ALC_EXT_thread_local_context
	// ----------------------------------------------------------------------------

	public static function setThreadContext(context : Context) : Bool;
	public static function getThreadContext() : Context;

	
	// ----------------------------------------------------------------------------
	// ALC_SOFT_loopback
	// ----------------------------------------------------------------------------

	public static inline var FORMAT_CHANNELS_SOFT             = 0x1990;
	public static inline var FORMAT_TYPE_SOFT                 = 0x1991;

	// Sample types
	public static inline var BYTE_SOFT                        = 0x1400;
	public static inline var UNSIGNED_BYTE_SOFT               = 0x1401;
	public static inline var SHORT_SOFT                       = 0x1402;
	public static inline var UNSIGNED_SHORT_SOFT              = 0x1403;
	public static inline var INT_SOFT                         = 0x1404;
	public static inline var UNSIGNED_INT_SOFT                = 0x1405;
	public static inline var FLOAT_SOFT                       = 0x1406;

	// Channel configurations
	public static inline var MONO_SOFT                        = 0x1500;
	public static inline var STEREO_SOFT                      = 0x1501;
	public static inline var QUAD_SOFT                        = 0x1503;
	public static inline var _5POINT1_SOFT                    = 0x1504;
	public static inline var _6POINT1_SOFT                    = 0x1505;
	public static inline var _7POINT1_SOFT                    = 0x1506;
	

	public static function loopbackOpenDeviceSoft      (devicename : hl.Bytes) : Device;
	public static function isRenderFormatSupportedSoft (device : Device, freq : Int, channels : Int, type : Int);
	public static function renderSamplesSoft           (device : Device, buffer : hl.Bytes, samples : Int);

	// ----------------------------------------------------------------------------
	// ALC_EXT_DEFAULT_FILTER_ORDER
	// ----------------------------------------------------------------------------

	public static inline var ALC_DEFAULT_FILTER_ORDER         = 0x1100;

	// ----------------------------------------------------------------------------
	// ALC_SOFT_pause_device
	// ----------------------------------------------------------------------------

	public static function devicePauseSoft  (device : Device);
	public static function deviceResumeSoft (device : Device);

	// ----------------------------------------------------------------------------
	// ALC_SOFT_HRTF
	// ----------------------------------------------------------------------------

	public static inline var HRTF_SOFT                        = 0x1992
	public static inline var DONT_CARE_SOFT                   = 0x0002
	public static inline var HRTF_STATUS_SOFT                 = 0x1993
	public static inline var HRTF_DISABLED_SOFT               = 0x0000
	public static inline var HRTF_ENABLED_SOFT                = 0x0001
	public static inline var HRTF_DENIED_SOFT                 = 0x0002
	public static inline var HRTF_REQUIRED_SOFT               = 0x0003
	public static inline var HRTF_HEADPHONES_DETECTED_SOFT    = 0x0004
	public static inline var HRTF_UNSUPPORTED_FORMAT_SOFT     = 0x0005
	public static inline var NUM_HRTF_SPECIFIERS_SOFT         = 0x1994
	public static inline var HRTF_SPECIFIER_SOFT              = 0x1995
	public static inline var HRTF_ID_SOFT                     = 0x1996

	public static function getStringiSoft  (device : Device, param : Int, index : Int) : hl.Bytes;
	public static function resetDeviceSoft (device : Device, attribs : hl.Bytes) : Bool;

}
