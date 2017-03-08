package openal;

abstract Buffer(Int) {
	public inline function toInt() : Int { return this; }
	public static inline function ofInt( v : Int ) : Buffer { return cast v; }
}

abstract Source(Int) {
	public inline function toInt() : Int { return this; }
	public static inline function ofInt( v : Int ) : Source { return cast v; }
}

abstract Effect(Int) {
	public inline function toInt() : Int { return this; }
	public static inline function ofInt( v : Int ) : Source { return cast v; }
}

abstract Filter(Int) {
	public inline function toInt() : Int { return this; }
	public static inline function ofInt( v : Int ) : Source { return cast v; }
}

abstract EffectSlot(Int) {
	public inline function toInt() : Int { return this; }
	public static inline function ofInt( v : Int ) : Source { return cast v; }
}

@:hlNative("sdl","al_")
extern class AL {
	public static function dopplerFactor   (value : hl.F32) : Void;
	public static function dopplerVelocity (value : hl.F32) : Void;
	public static function speedOfSound    (value : hl.F32) : Void;
	public static function distanceModel   (distanceModel : Int) : Void;

	// Renderer State management
	public static function enable    (capability : Int) : Void;
	public static function disable   (capability : Int) : Void;
	public static function isEnabled (capability : Int) : Bool;

	// State retrieval
	public static function getBooleanv (param : Int, values : hl.Bytes) : Void;
	public static function getIntegerv (param : Int, values : hl.Bytes) : Void;
	public static function getFloatv   (param : Int, values : hl.Bytes) : Void;
	public static function getDoublev  (param : Int, values : hl.Bytes) : Void;

	public static function getString   (param : Int) : hl.Bytes;
	public static function getBoolean  (param : Int) : Bool;
	public static function getInteger  (param : Int) : Int;
	public static function getFloat    (param : Int) : hl.F32;
	public static function getDouble   (param : Int) : hl.F64;

	// Error retrieval
	public static function getError() : Int;

	// Extension support
	public static function isExtensionPresent (extname : hl.Bytes) : Bool;
	public static function getEnumValue       (ename   : hl.Bytes) : Int;
	//public static function getProcAddress     (fname   : hl.Bytes) : Void*;

	// Set Listener parameters
	public static function listenerf  (param : Int, value  : hl.F32) : Void;
	public static function listener3f (param : Int, value1 : hl.F32, value2 : hl.F32, value3 : hl.F32) : Void;
	public static function listenerfv (param : Int, values : hl.Bytes) : Void;
	public static function listeneri  (param : Int, value  : Int) : Void;
	public static function listener3i (param : Int, value1 : Int, value2 : Int, value3 : Int) : Void;
	public static function listeneriv (param : Int, values : hl.Bytes) : Void;

	// Get Listener parameters
	public static function getListenerf  (param : Int) : hl.F32;
	public static function getListener3f (param : Int, value1 : hl.Ref<hl.F32>, value2 : hl.Ref<hl.F32>, value3 : hl.Ref<hl.F32>) : Void;
	public static function getListenerfv (param : Int, values : hl.Bytes) : Void;
	public static function getListeneri  (param : Int) : Int;
	public static function getListener3i (param : Int, value1 : hl.Ref<Int>, value2 : hl.Ref<Int>, value3 : hl.Ref<Int>) : Void;
	public static function getListeneriv (param : Int, values : hl.Bytes) : Void;

	// Source management
	public static function genSources    (n : Int, sources : hl.Bytes) : Void;
	public static function deleteSources (n : Int, sources : hl.Bytes) : Void;
	public static function isSource      (source : Source) : Bool;

	// Set Source parameters
	public static function sourcef  (source : Source, param : Int, value  : hl.F32) : Void;
	public static function source3f (source : Source, param : Int, value1 : hl.F32, value2 : hl.F32, value3 : hl.F32) : Void;
	public static function sourcefv (source : Source, param : Int, values : hl.Bytes) : Void;
	public static function sourcei  (source : Source, param : Int, value  : Int) : Void;
	public static function source3i (source : Source, param : Int, value1 : Int, value2 : Int, value3 : Int) : Void;
	public static function sourceiv (source : Source, param : Int, values : hl.Bytes) : Void;

	// Get Source parameters
	public static function getSourcef  (source : Source, param : Int) : hl.F32;
	public static function getSource3f (source : Source, param : Int, value1 : hl.Ref<hl.F32>, value2 : hl.Ref<hl.F32>, value3 : hl.Ref<hl.F32>) : Void;
	public static function getSourcefv (source : Source, param : Int, values : hl.Bytes) : Void;
	public static function getSourcei  (source : Source, param : Int) : Int;
	public static function getSource3i (source : Source, param : Int, value1 : hl.Ref<Int>, value2 : hl.Ref<Int>, value3 : hl.Ref<Int>) : Void;
	public static function getSourceiv (source : Source, param : Int, values : hl.Bytes) : Void;

	// Source controls
	public static function sourcePlayv   (n : Int, sources : hl.Bytes) : Void;
	public static function sourceStopv   (n : Int, sources : hl.Bytes) : Void;
	public static function sourceRewindv (n : Int, sources : hl.Bytes) : Void;
	public static function sourcePausev  (n : Int, sources : hl.Bytes) : Void;

	public static function sourcePlay   (source : Source) : Void;
	public static function sourceStop   (source : Source) : Void;
	public static function sourceRewind (source : Source) : Void;
	public static function sourcePause  (source : Source) : Void;

	// Queue buffers onto a source
	public static function sourceQueueBuffers   (source : Source, nb : Int, buffers : hl.Bytes) : Void;
	public static function sourceUnqueueBuffers (source : Source, nb : Int, buffers : hl.Bytes) : Void;

	// Buffer management
	public static function genBuffers    (n : Int, buffers : hl.Bytes) : Void;
	public static function deleteBuffers (n : Int, buffers : hl.Bytes) : Void;
	public static function isBuffer      (buffer : Buffer) : Bool;
	public static function bufferData    (buffer : Buffer, format : Int, data : hl.Bytes, size : Int, freq : Int) : Void;

	// Set Buffer parameters
	public static function bufferf  (buffer : Buffer, param : Int, value  : hl.F32) : Void;
	public static function buffer3f (buffer : Buffer, param : Int, value1 : hl.F32, value2 : hl.F32, value3 : hl.F32) : Void;
	public static function bufferfv (buffer : Buffer, param : Int, values : hl.Bytes) : Void;
	public static function bufferi  (buffer : Buffer, param : Int, value  : Int) : Void;
	public static function buffer3i (buffer : Buffer, param : Int, value1 : Int, value2 : Int, value3 : Int) : Void;
	public static function bufferiv (buffer : Buffer, param : Int, values : hl.Bytes) : Void;

	// Get Buffer parameters
	public static function getBufferf  (buffer : Buffer, param : Int) : hl.F32;
	public static function getBuffer3f (buffer : Buffer, param : Int, value1 : hl.Ref<hl.F32>, value2 : hl.Ref<hl.F32>, value3 : hl.Ref<hl.F32>) : Void;
	public static function getBufferfv (buffer : Buffer, param : Int, values : hl.Bytes) : Void;
	public static function getBufferi  (buffer : Buffer, param : Int) : Int;
	public static function getBuffer3i (buffer : Buffer, param : Int, value1 : hl.Ref<Int>, value2 : hl.Ref<Int>, value3 : hl.Ref<Int>) : Void;
	public static function getBufferiv (buffer : Buffer, param : Int, values : hl.Bytes) : Void;

	// ------------------------------------------------------------------------
	// Constants
	// ------------------------------------------------------------------------

	public static inline var NONE                                  = 0;
	public static inline var FALSE                                 = 0;
	public static inline var TRUE                                  = 1;

	public static inline var SOURCE_RELATIVE                       = 0x202;
	public static inline var CONE_INNER_ANGLE                      = 0x1001;
	public static inline var CONE_OUTER_ANGLE                      = 0x1002;
	public static inline var PITCH                                 = 0x1003;

	public static inline var POSITION                              = 0x1004;
	public static inline var DIRECTION                             = 0x1005;

	public static inline var VELOCITY                              = 0x1006;
	public static inline var LOOPING                               = 0x1007;
	public static inline var BUFFER                                = 0x1009;

	public static inline var GAIN                                  = 0x100A;
	public static inline var MIN_GAIN                              = 0x100D;
	public static inline var MAX_GAIN                              = 0x100E;
	public static inline var ORIENTATION                           = 0x100F;
	public static inline var SOURCE_STATE                          = 0x1010;

	// Source state values
	public static inline var INITIAL                               = 0x1011;
	public static inline var PLAYING                               = 0x1012;
	public static inline var PAUSED                                = 0x1013;
	public static inline var STOPPED                               = 0x1014;

	public static inline var BUFFERS_QUEUED                        = 0x1015;
	public static inline var BUFFERS_PROCESSED                     = 0x1016;

	public static inline var REFERENCE_DISTANCE                    = 0x1020;
	public static inline var ROLLOFF_FACTOR                        = 0x1021;
	public static inline var CONE_OUTER_GAIN                       = 0x1022;
	public static inline var MAX_DISTANCE                          = 0x1023;

	public static inline var SEC_OFFSET                            = 0x1024;
	public static inline var SAMPLE_OFFSET                         = 0x1025;
	public static inline var BYTE_OFFSET                           = 0x1026;
	public static inline var SOURCE_TYPE                           = 0x1027;

	// Source type value
	public static inline var STATIC                                = 0x1028;
	public static inline var STREAMING                             = 0x1029;
	public static inline var UNDETERMINED                          = 0x1030;

	// Buffer format specifier
	public static inline var FORMAT_MONO8                          = 0x1100;
	public static inline var FORMAT_MONO16                         = 0x1101;
	public static inline var FORMAT_STEREO8                        = 0x1102;
	public static inline var FORMAT_STEREO16                       = 0x1103;

	// Buffer query
	public static inline var FREQUENCY                             = 0x2001;
	public static inline var BITS                                  = 0x2002;
	public static inline var CHANNELS                              = 0x2003;
	public static inline var SIZE                                  = 0x2004;

	// Buffer state (private)
	public static inline var UNUSED                                = 0x2010;
	public static inline var PENDING                               = 0x2011;
	public static inline var PROCESSED                             = 0x2012;

	// Errors
	public static inline var NO_ERROR                              = 0;
	public static inline var INVALID_NAME                          = 0xA001;
	public static inline var INVALID_ENUM                          = 0xA002;
	public static inline var INVALID_VALUE                         = 0xA003;
	public static inline var INVALID_OPERATION                     = 0xA004;
	public static inline var OUT_OF_MEMORY                         = 0xA005;

	// Context strings
	public static inline var VENDOR                                = 0xB001;
	public static inline var VERSION                               = 0xB002;
	public static inline var RENDERER                              = 0xB003;
	public static inline var EXTENSIONS                            = 0xB004;

	// Context values
	public static inline var DOPPLER_FACTOR                        = 0xC000;
	public static inline var DOPPLER_VELOCITY                      = 0xC001;
	public static inline var SPEED_OF_SOUND                        = 0xC003;
	public static inline var DISTANCE_MODEL                        = 0xD000;

	// Distance model values
	public static inline var INVERSE_DISTANCE                      = 0xD001;
	public static inline var INVERSE_DISTANCE_CLAMPED              = 0xD002;
	public static inline var LINEAR_DISTANCE                       = 0xD003;
	public static inline var LINEAR_DISTANCE_CLAMPED               = 0xD004;
	public static inline var EXPONENT_DISTANCE                     = 0xD005;
	public static inline var EXPONENT_DISTANCE_CLAMPED             = 0xD006;

	// ------------------------------------------------------------------------
	// AL_LOKI_IMA_ADPCM_format
	// ------------------------------------------------------------------------

	public static inline var FORMAT_IMA_ADPCM_MONO16_EXT           = 0x10000;
	public static inline var FORMAT_IMA_ADPCM_STEREO16_EXT         = 0x10001;

	// ------------------------------------------------------------------------
	// AL_LOKI_IMA_ADPCM_format
	// ------------------------------------------------------------------------

	public static inline var FORMAT_WAVE_EXT                       = 0x10002;

	// ------------------------------------------------------------------------
	// AL_EXT_vorbis
	// ------------------------------------------------------------------------

	public static inline var FORMAT_VORBIS_EXT                     = 0x10003;

	// ------------------------------------------------------------------------
	// AL_LOKI_quadriphonic
	// ------------------------------------------------------------------------

	public static inline var FORMAT_QUAD8_LOKI                     = 0x10004;
	public static inline var FORMAT_QUAD16_LOKI                    = 0x10005;

	// ------------------------------------------------------------------------
	// AL_EXT_float32
	// ------------------------------------------------------------------------

	public static inline var FORMAT_MONO_FLOAT32                   = 0x10010;
	public static inline var FORMAT_STEREO_FLOAT32                 = 0x10011;

	// ------------------------------------------------------------------------
	// AL_EXT_double
	// ------------------------------------------------------------------------

	public static inline var FORMAT_MONO_DOUBLE_EXT                = 0x10012;
	public static inline var FORMAT_STEREO_DOUBLE_EXT              = 0x10013;

	// ------------------------------------------------------------------------
	// AL_EXT_MULAW
	// ------------------------------------------------------------------------

	public static inline var FORMAT_MONO_MULAW_EXT                 = 0x10014;
	public static inline var FORMAT_STEREO_MULAW_EXT               = 0x10015;

	// ------------------------------------------------------------------------
	// AL_EXT_ALAW
	// ------------------------------------------------------------------------

	public static inline var FORMAT_MONO_ALAW_EXT                  = 0x10016;
	public static inline var FORMAT_STEREO_ALAW_EXT                = 0x10017;

	// ------------------------------------------------------------------------
	// AL_EXT_MCFORMATS
	// ------------------------------------------------------------------------

	public static inline var FORMAT_QUAD8                          = 0x1204;
	public static inline var FORMAT_QUAD16                         = 0x1205;
	public static inline var FORMAT_QUAD32                         = 0x1206;
	public static inline var FORMAT_REAR8                          = 0x1207;
	public static inline var FORMAT_REAR16                         = 0x1208;
	public static inline var FORMAT_REAR32                         = 0x1209;
	public static inline var FORMAT_51CHN8                         = 0x120A;
	public static inline var FORMAT_51CHN16                        = 0x120B;
	public static inline var FORMAT_51CHN32                        = 0x120C;
	public static inline var FORMAT_61CHN8                         = 0x120D;
	public static inline var FORMAT_61CHN16                        = 0x120E;
	public static inline var FORMAT_61CHN32                        = 0x120F;
	public static inline var FORMAT_71CHN8                         = 0x1210;
	public static inline var FORMAT_71CHN16                        = 0x1211;
	public static inline var FORMAT_71CHN32                        = 0x1212;

	// ------------------------------------------------------------------------
	// AL_EXT_MULAW_MCFORMATS
	// ------------------------------------------------------------------------

	public static inline var FORMAT_MONO_MULAW                     = 0x10014;
	public static inline var FORMAT_STEREO_MULAW                   = 0x10015;
	public static inline var FORMAT_QUAD_MULAW                     = 0x10021;
	public static inline var FORMAT_REAR_MULAW                     = 0x10022;
	public static inline var FORMAT_51CHN_MULAW                    = 0x10023;
	public static inline var FORMAT_61CHN_MULAW                    = 0x10024;
	public static inline var FORMAT_71CHN_MULAW                    = 0x10025;

	// ------------------------------------------------------------------------
	// AL_EXT_IMA4
	// ------------------------------------------------------------------------

	public static inline var FORMAT_MONO_IMA4                      = 0x1300;
	public static inline var FORMAT_STEREO_IMA4                    = 0x1301;

	// ------------------------------------------------------------------------
	// AL_EXT_STATIC_BUFFER
	// ------------------------------------------------------------------------

	public static function bufferDataStatic(buffer : Buffer, format : Int, data : hl.Bytes, len : Int, freq : Int) : Void;

	// ------------------------------------------------------------------------
	// AL_EXT_source_distance_model
	// ------------------------------------------------------------------------

	public static inline var SOURCE_DISTANCE_MODEL                 = 0x200;

	// ------------------------------------------------------------------------
	// AL_SOFT_buffer_sub_data
	// ------------------------------------------------------------------------

	public static inline var BYTE_RW_OFFSETS_SOFT                  = 0x1031;
	public static inline var SAMPLE_RW_OFFSETS_SOFT                = 0x1032;

	public static function bufferSubDataSoft(buffer : Buffer, format : Int, data : hl.Bytes, offset : Int, length : Int) : Void;

	// ------------------------------------------------------------------------
	// AL_SOFT_loop_points
	// ------------------------------------------------------------------------

	public static inline var LOOP_POINTS_SOFT                      = 0x2015;

	// ------------------------------------------------------------------------
	// AL_EXT_FOLDBACK
	// ------------------------------------------------------------------------

	public static inline var FOLDBACK_EVENT_BLOCK                  = 0x4112;
	public static inline var FOLDBACK_EVENT_START                  = 0x4111;
	public static inline var FOLDBACK_EVENT_STOP                   = 0x4113;
	public static inline var FOLDBACK_MODE_MONO                    = 0x4101;
	public static inline var FOLDBACK_MODE_STEREO                  = 0x4102;

	public static function requestFoldbackStart(mode : Int, count : Int, length : Int, mem : hl.Bytes, callback : Int->Int->Void) : Void;
	public static function requestFoldbackStop() : Void;

	// ------------------------------------------------------------------------
	// ALC_EXT_DEDICATED
	// ------------------------------------------------------------------------

	public static inline var DEDICATED_GAIN                        = 0x0001;
	public static inline var EFFECT_DEDICATED_DIALOGUE             = 0x9001;
	public static inline var EFFECT_DEDICATED_LOW_FREQUENCY_EFFECT = 0x9000;

	// ------------------------------------------------------------------------
	// AL_SOFT_buffer_samples
	// ------------------------------------------------------------------------

	// Channel configurations 
	public static inline var MONO_SOFT                             = 0x1500;
	public static inline var STEREO_SOFT                           = 0x1501;
	public static inline var REAR_SOFT                             = 0x1502;
	public static inline var QUAD_SOFT                             = 0x1503;
	public static inline var _5POINT1_SOFT                         = 0x1504;
	public static inline var _6POINT1_SOFT                         = 0x1505;
	public static inline var _7POINT1_SOFT                         = 0x1506;

	// Sample types 
	public static inline var BYTE_SOFT                             = 0x1400;
	public static inline var UNSIGNED_BYTE_SOFT                    = 0x1401;
	public static inline var SHORT_SOFT                            = 0x1402;
	public static inline var UNSIGNED_SHORT_SOFT                   = 0x1403;
	public static inline var INT_SOFT                              = 0x1404;
	public static inline var UNSIGNED_INT_SOFT                     = 0x1405;
	public static inline var FLOAT_SOFT                            = 0x1406;
	public static inline var DOUBLE_SOFT                           = 0x1407;
	public static inline var BYTE3_SOFT                            = 0x1408;
	public static inline var UNSIGNED_BYTE3_SOFT                   = 0x1409;

	// Storage formats
	public static inline var MONO8_SOFT                            = 0x1100;
	public static inline var MONO16_SOFT                           = 0x1101;
	public static inline var MONO32F_SOFT                          = 0x10010;
	public static inline var STEREO8_SOFT                          = 0x1102;
	public static inline var STEREO16_SOFT                         = 0x1103;
	public static inline var STEREO32F_SOFT                        = 0x10011;
	public static inline var QUAD8_SOFT                            = 0x1204;
	public static inline var QUAD16_SOFT                           = 0x1205;
	public static inline var QUAD32F_SOFT                          = 0x1206;
	public static inline var REAR8_SOFT                            = 0x1207;
	public static inline var REAR16_SOFT                           = 0x1208;
	public static inline var REAR32F_SOFT                          = 0x1209;
	public static inline var _5POINT1_8_SOFT                       = 0x120A;
	public static inline var _5POINT1_16_SOFT                      = 0x120B;
	public static inline var _5POINT1_32F_SOFT                     = 0x120C;
	public static inline var _6POINT1_8_SOFT                       = 0x120D;
	public static inline var _6POINT1_16_SOFT                      = 0x120E;
	public static inline var _6POINT1_32F_SOFT                     = 0x120F;
	public static inline var _7POINT1_8_SOFT                       = 0x1210;
	public static inline var _7POINT1_16_SOFT                      = 0x1211;
	public static inline var _7POINT1_32F_SOFT                     = 0x1212;

	// Buffer attributes
	public static inline var INTERNAL_FORMAT_SOFT                  = 0x2008;
	public static inline var BYTE_LENGTH_SOFT                      = 0x2009;
	public static inline var SAMPLE_LENGTH_SOFT                    = 0x200A;
	public static inline var SEC_LENGTH_SOFT                       = 0x200B;

	public static function bufferSamplesSoft           (buffer : Buffer, samplerate : Int, internalformat : Int, samples : Int, channels : Int, type : Int, data : hl.Bytes) : Void;
	public static function bufferSubSamplesSoft        (buffer : Buffer, offset : Int, samples : Int, channels : Int, type : Int, data : hl.Bytes) : Void;
	public static function getBufferSamplesSoft        (buffer : Buffer, offset : Int, samples : Int, channels : Int, type : Int, data : hl.Bytes) : Void;
	public static function isBufferFormatSupportedSOFT (format : Int) : Bool;

	// ------------------------------------------------------------------------
	// AL_SOFT_direct_channels
	// ------------------------------------------------------------------------

	public static inline var DIRECT_CHANNELS_SOFT                  = 0x1033;

	// ------------------------------------------------------------------------
	// AL_EXT_STEREO_ANGLES
	// ------------------------------------------------------------------------

	public static inline var STEREO_ANGLES                         = 0x1030;

	// ------------------------------------------------------------------------
	// AL_EXT_SOURCE_RADIUS
	// ------------------------------------------------------------------------

	public static inline var SOURCE_RADIUS                         = 0x1031;

	// ------------------------------------------------------------------------
	// AL_SOFT_source_latency
	// ------------------------------------------------------------------------

	public static inline var SAMPLE_OFFSET_LATENCY_SOFT            = 0x1200;
	public static inline var SEC_OFFSET_LATENCY_SOFT               = 0x1201;

	public static function sourcedSoft       (source : Source, param : Int, value  : Float) : Void;
	public static function source3dSoft      (source : Source, param : Int, value1 : Float, value2 : Float, value3 : Float) : Void;
	public static function sourcedvSoft      (source : Source, param : Int, values : hl.Bytes) : Void;

	public static function getSourcedSoft    (source : Source, param : Int) : Float;
	public static function getSource3dSoft   (source : Source, param : Int, value1 : hl.Ref<Float>, value2 : hl.Ref<Float>, value3 : hl.Ref<Float>) : Void;
	public static function getSourcedvSoft   (source : Source, param : Int, values : hl.Bytes) : Void;

	public static function sourcei64Soft     (source : Source, param : Int, valueHi  : Int, valueLo : Int) : Void;
	public static function source3i64Soft    (source : Source, param : Int, value1Hi : Int, value1Lo : Int, value2Hi : Int, value2Lo : Int, value3Hi : Int, value3Lo : Int) : Void;
	public static function sourcei64vSoft    (source : Source, param : Int, values   : hl.Bytes) : Void;

	public static function getSourcei64Soft  (source : Source, param : Int, valueHi  : hl.Ref<Int>, valueLo : hl.Ref<Int>) : Void;
	public static function getSource3i64Soft (source : Source, param : Int, value1Hi : hl.Ref<Int>, value1Lo : hl.Ref<Int>, value2Hi : hl.Ref<Int>, value2Lo : hl.Ref<Int>, value3Hi : hl.Ref<Int>, value3Lo : hl.Ref<Int>) : Void;
	public static function getSourcei64vSoft (source : Source, param : Int, values   : hl.Bytes) : Void;

	// ------------------------------------------------------------------------
	// AL_SOFT_deferred_updates
	// ------------------------------------------------------------------------

	public static inline var DEFERRED_UPDATES_SOFT                 = 0xC002;

	public static function deferUpdatesSoft   () : Void;
	public static function processUpdatesSoft () : Void;

	// ------------------------------------------------------------------------
	// AL_SOFT_block_alignment
	// ------------------------------------------------------------------------

	public static inline var UNPACK_BLOCK_ALIGNMENT_SOFT           = 0x200C;
	public static inline var PACK_BLOCK_ALIGNMENT_SOFT             = 0x200D;

	// ------------------------------------------------------------------------
	// AL_SOFT_MSADPCM
	// ------------------------------------------------------------------------

	public static inline var FORMAT_MONO_MSADPCM_SOFT              = 0x1302;
	public static inline var FORMAT_STEREO_MSADPCM_SOFT            = 0x1303;

	// ------------------------------------------------------------------------
	// AL_EXT_BFORMAT
	// ------------------------------------------------------------------------

	public static inline var FORMAT_BFORMAT2D_8                    = 0x20021;
	public static inline var FORMAT_BFORMAT2D_16                   = 0x20022;	
	public static inline var FORMAT_BFORMAT2D_FLOAT32              = 0x20023;
	public static inline var FORMAT_BFORMAT3D_8                    = 0x20031;
	public static inline var FORMAT_BFORMAT3D_16                   = 0x20032;
	public static inline var FORMAT_BFORMAT3D_FLOAT32              = 0x20033;

	// ------------------------------------------------------------------------
	// AL_EXT_MULAW_BFORMAT
	// ------------------------------------------------------------------------

	public static inline var FORMAT_BFORMAT2D_MULAW                = 0x10031;
	public static inline var FORMAT_BFORMAT3D_MULAW                = 0x10032;

	// ------------------------------------------------------------------------
	// ALC_EXT_EFX
	// ------------------------------------------------------------------------

	// Listener properties.
	public static inline var METERS_PER_UNIT                       = 0x20004;

	// Source properties.
	public static inline var DIRECT_FILTER                         = 0x20005;
	public static inline var AUXILIARY_SEND_FILTER                 = 0x20006;
	public static inline var AIR_ABSORPTION_FACTOR                 = 0x20007;
	public static inline var ROOM_ROLLOFF_FACTOR                   = 0x20008;
	public static inline var CONE_OUTER_GAINHF                     = 0x20009;
	public static inline var DIRECT_FILTER_GAINHF_AUTO             = 0x2000A;
	public static inline var AUXILIARY_SEND_FILTER_GAIN_AUTO       = 0x2000B;
	public static inline var AUXILIARY_SEND_FILTER_GAINHF_AUTO     = 0x2000C;


	// Effect properties.

	// Reverb effect parameters
	public static inline var REVERB_DENSITY                        = 0x0001;
	public static inline var REVERB_DIFFUSION                      = 0x0002;
	public static inline var REVERB_GAIN                           = 0x0003;
	public static inline var REVERB_GAINHF                         = 0x0004;
	public static inline var REVERB_DECAY_TIME                     = 0x0005;
	public static inline var REVERB_DECAY_HFRATIO                  = 0x0006;
	public static inline var REVERB_REFLECTIONS_GAIN               = 0x0007;
	public static inline var REVERB_REFLECTIONS_DELAY              = 0x0008;
	public static inline var REVERB_LATE_REVERB_GAIN               = 0x0009;
	public static inline var REVERB_LATE_REVERB_DELAY              = 0x000A;
	public static inline var REVERB_AIR_ABSORPTION_GAINHF          = 0x000B;
	public static inline var REVERB_ROOM_ROLLOFF_FACTOR            = 0x000C;
	public static inline var REVERB_DECAY_HFLIMIT                  = 0x000D;

	// EAX Reverb effect parameters
	public static inline var EAXREVERB_DENSITY                     = 0x0001;
	public static inline var EAXREVERB_DIFFUSION                   = 0x0002;
	public static inline var EAXREVERB_GAIN                        = 0x0003;
	public static inline var EAXREVERB_GAINHF                      = 0x0004;
	public static inline var EAXREVERB_GAINLF                      = 0x0005;
	public static inline var EAXREVERB_DECAY_TIME                  = 0x0006;
	public static inline var EAXREVERB_DECAY_HFRATIO               = 0x0007;
	public static inline var EAXREVERB_DECAY_LFRATIO               = 0x0008;
	public static inline var EAXREVERB_REFLECTIONS_GAIN            = 0x0009;
	public static inline var EAXREVERB_REFLECTIONS_DELAY           = 0x000A;
	public static inline var EAXREVERB_REFLECTIONS_PAN             = 0x000B;
	public static inline var EAXREVERB_LATE_REVERB_GAIN            = 0x000C;
	public static inline var EAXREVERB_LATE_REVERB_DELAY           = 0x000D;
	public static inline var EAXREVERB_LATE_REVERB_PAN             = 0x000E;
	public static inline var EAXREVERB_ECHO_TIME                   = 0x000F;
	public static inline var EAXREVERB_ECHO_DEPTH                  = 0x0010;
	public static inline var EAXREVERB_MODULATION_TIME             = 0x0011;
	public static inline var EAXREVERB_MODULATION_DEPTH            = 0x0012;
	public static inline var EAXREVERB_AIR_ABSORPTION_GAINHF       = 0x0013;
	public static inline var EAXREVERB_HFREFERENCE                 = 0x0014;
	public static inline var EAXREVERB_LFREFERENCE                 = 0x0015;
	public static inline var EAXREVERB_ROOM_ROLLOFF_FACTOR         = 0x0016;
	public static inline var EAXREVERB_DECAY_HFLIMIT               = 0x0017;

	// Chorus effect parameters
	public static inline var CHORUS_WAVEFORM                       = 0x0001;
	public static inline var CHORUS_PHASE                          = 0x0002;
	public static inline var CHORUS_RATE                           = 0x0003;
	public static inline var CHORUS_DEPTH                          = 0x0004;
	public static inline var CHORUS_FEEDBACK                       = 0x0005;
	public static inline var CHORUS_DELAY                          = 0x0006;

	// Distortion effect parameters
	public static inline var DISTORTION_EDGE                       = 0x0001;
	public static inline var DISTORTION_GAIN                       = 0x0002;
	public static inline var DISTORTION_LOWPASS_CUTOFF             = 0x0003;
	public static inline var DISTORTION_EQCENTER                   = 0x0004;
	public static inline var DISTORTION_EQBANDWIDTH                = 0x0005;

	// Echo effect parameters
	public static inline var ECHO_DELAY                            = 0x0001;
	public static inline var ECHO_LRDELAY                          = 0x0002;
	public static inline var ECHO_DAMPING                          = 0x0003;
	public static inline var ECHO_FEEDBACK                         = 0x0004;
	public static inline var ECHO_SPREAD                           = 0x0005;

	// Flanger effect parameters
	public static inline var FLANGER_WAVEFORM                      = 0x0001;
	public static inline var FLANGER_PHASE                         = 0x0002;
	public static inline var FLANGER_RATE                          = 0x0003;
	public static inline var FLANGER_DEPTH                         = 0x0004;
	public static inline var FLANGER_FEEDBACK                      = 0x0005;
	public static inline var FLANGER_DELAY                         = 0x0006;

	// Frequency shifter effect parameters
	public static inline var FREQUENCY_SHIFTER_FREQUENCY           = 0x0001;
	public static inline var FREQUENCY_SHIFTER_LEFT_DIRECTION      = 0x0002;
	public static inline var FREQUENCY_SHIFTER_RIGHT_DIRECTION     = 0x0003;

	// Vocal morpher effect parameters
	public static inline var VOCAL_MORPHER_PHONEMEA                = 0x0001;
	public static inline var VOCAL_MORPHER_PHONEMEA_COARSE_TUNING  = 0x0002;
	public static inline var VOCAL_MORPHER_PHONEMEB                = 0x0003;
	public static inline var VOCAL_MORPHER_PHONEMEB_COARSE_TUNING  = 0x0004;
	public static inline var VOCAL_MORPHER_WAVEFORM                = 0x0005;
	public static inline var VOCAL_MORPHER_RATE                    = 0x0006;

	// Pitchshifter effect parameters
	public static inline var PITCH_SHIFTER_COARSE_TUNE             = 0x0001;
	public static inline var PITCH_SHIFTER_FINE_TUNE               = 0x0002;

	// Ringmodulator effect parameters
	public static inline var RING_MODULATOR_FREQUENCY              = 0x0001;
	public static inline var RING_MODULATOR_HIGHPASS_CUTOFF        = 0x0002;
	public static inline var RING_MODULATOR_WAVEFORM               = 0x0003;

	// Autowah effect parameters
	public static inline var AUTOWAH_ATTACK_TIME                   = 0x0001;
	public static inline var AUTOWAH_RELEASE_TIME                  = 0x0002;
	public static inline var AUTOWAH_RESONANCE                     = 0x0003;
	public static inline var AUTOWAH_PEAK_GAIN                     = 0x0004;

	// Compressor effect parameters
	public static inline var COMPRESSOR_ONOFF                      = 0x0001;

	// Equalizer effect parameters
	public static inline var EQUALIZER_LOW_GAIN                    = 0x0001;
	public static inline var EQUALIZER_LOW_CUTOFF                  = 0x0002;
	public static inline var EQUALIZER_MID1_GAIN                   = 0x0003;
	public static inline var EQUALIZER_MID1_CENTER                 = 0x0004;
	public static inline var EQUALIZER_MID1_WIDTH                  = 0x0005;
	public static inline var EQUALIZER_MID2_GAIN                   = 0x0006;
	public static inline var EQUALIZER_MID2_CENTER                 = 0x0007;
	public static inline var EQUALIZER_MID2_WIDTH                  = 0x0008;
	public static inline var EQUALIZER_HIGH_GAIN                   = 0x0009;
	public static inline var EQUALIZER_HIGH_CUTOFF                 = 0x000A;

	// Effect type
	public static inline var EFFECT_FIRST_PARAMETER                = 0x0000;
	public static inline var EFFECT_LAST_PARAMETER                 = 0x8000;
	public static inline var EFFECT_TYPE                           = 0x8001;

	// Effect types, used with the AL_EFFECT_TYPE property
	public static inline var EFFECT_NULL                           = 0x0000;
	public static inline var EFFECT_REVERB                         = 0x0001;
	public static inline var EFFECT_CHORUS                         = 0x0002;
	public static inline var EFFECT_DISTORTION                     = 0x0003;
	public static inline var EFFECT_ECHO                           = 0x0004;
	public static inline var EFFECT_FLANGER                        = 0x0005;
	public static inline var EFFECT_FREQUENCY_SHIFTER              = 0x0006;
	public static inline var EFFECT_VOCAL_MORPHER                  = 0x0007;
	public static inline var EFFECT_PITCH_SHIFTER                  = 0x0008;
	public static inline var EFFECT_RING_MODULATOR                 = 0x0009;
	public static inline var EFFECT_AUTOWAH                        = 0x000A;
	public static inline var EFFECT_COMPRESSOR                     = 0x000B;
	public static inline var EFFECT_EQUALIZER                      = 0x000C;
	public static inline var EFFECT_EAXREVERB                      = 0x8000;

	// Auxiliary Effect Slot properties.
	public static inline var EFFECTSLOT_EFFECT                     = 0x0001;
	public static inline var EFFECTSLOT_GAIN                       = 0x0002;
	public static inline var EFFECTSLOT_AUXILIARY_SEND_AUTO        = 0x0003;

	// NULL Auxiliary Slot ID to disable a source send.
	public static inline var EFFECTSLOT_NULL                       = 0x0000;


	// Filter properties.

	// Lowpass filter parameters
	public static inline var LOWPASS_GAIN                          = 0x0001;
	public static inline var LOWPASS_GAINHF                        = 0x0002;

	// Highpass filter parameters
	public static inline var HIGHPASS_GAIN                         = 0x0001;
	public static inline var HIGHPASS_GAINLF                       = 0x0002;

	// Bandpass filter parameters
	public static inline var BANDPASS_GAIN                         = 0x0001;
	public static inline var BANDPASS_GAINLF                       = 0x0002;
	public static inline var BANDPASS_GAINHF                       = 0x0003;

	// Filter type
	public static inline var FILTER_FIRST_PARAMETER                = 0x0000;
	public static inline var FILTER_LAST_PARAMETER                 = 0x8000;
	public static inline var FILTER_TYPE                           = 0x8001;

	// Filter types, used with the AL_FILTER_TYPE property
	public static inline var FILTER_NULL                           = 0x0000;
	public static inline var FILTER_LOWPASS                        = 0x0001;
	public static inline var FILTER_HIGHPASS                       = 0x0002;
	public static inline var FILTER_BANDPASS                       = 0x0003;

	public static function genEffects    (n : Int, effects : hl.Bytes) : Void;
	public static function deleteEffects (n : Int, effects : hl.Bytes) : Void;
	public static function isEffect      (effect : Effect) : Bool;
	public static function effecti       (effect : Effect, param : Int, iValue    : Int)      : Void;
	public static function effectiv      (effect : Effect, param : Int, piValues  : hl.Bytes) : Void;
	public static function effectf       (effect : Effect, param : Int, flValue   : hl.F32)   : Void;
	public static function effectfv      (effect : Effect, param : Int, pflValues : hl.Bytes) : Void;
	public static function getEffecti    (effect : Effect, param : Int)                       : Int;
	public static function getEffectiv   (effect : Effect, param : Int, piValues  : hl.Bytes) : Void;
	public static function getEffectf    (effect : Effect, param : Int)                       : hl.F32;
	public static function getEffectfv   (effect : Effect, param : Int, pflValues : hl.Bytes) : Void;

	public static function genFilters    (n : Int, filters : hl.Bytes) : Void;
	public static function deleteFilters (n : Int, filters : hl.Bytes) : Void;
	public static function isFilter      (filter : Filter) : Bool;
	public static function filteri       (filter : Filter, param : Int, iValue    : Int)      : Void;
	public static function filteriv      (filter : Filter, param : Int, piValues  : hl.Bytes) : Void;
	public static function filterf       (filter : Filter, param : Int, flValue   : hl.F32)   : Void;
	public static function filterfv      (filter : Filter, param : Int, pflValues : hl.Bytes) : Void;
	public static function getFilteri    (filter : Filter, param : Int)                       : Int;
	public static function getFilteriv   (filter : Filter, param : Int, piValues  : hl.Bytes) : Void;
	public static function getFilterf    (filter : Filter, param : Int)                       : hl.F32;
	public static function getFilterfv   (filter : Filter, param : Int, pflValues : hl.Bytes) : Void;

	public static function genAuxiliaryEffectSlots    (n : Int, effectslots : hl.Bytes) : Void;
	public static function deleteAuxiliaryEffectSlots (n : Int, effectslots : hl.Bytes) : Void;
	public static function isAuxiliaryEffectSlot      (effectslot : EffectSlot) : Bool;
	public static function auxiliaryEffectSloti       (effectslot : EffectSlot, param : Int, iValue    : Int)      : Void;
	public static function auxiliaryEffectSlotiv      (effectslot : EffectSlot, param : Int, piValues  : hl.Bytes) : Void;
	public static function auxiliaryEffectSlotf       (effectslot : EffectSlot, param : Int, flValue   : hl.F32)   : Void;
	public static function auxiliaryEffectSlotfv      (effectslot : EffectSlot, param : Int, pflValues : hl.Bytes) : Void;
	public static function getAuxiliaryEffectSloti    (effectslot : EffectSlot, param : Int) : Int;
	public static function getAuxiliaryEffectSlotiv   (effectslot : EffectSlot, param : Int, piValues  : hl.Bytes)  : Void;
	public static function getAuxiliaryEffectSlotf    (effectslot : EffectSlot, param : Int) : hl.F32;
	public static function getAuxiliaryEffectSlotfv   (effectslot : EffectSlot, param : Int, pflValues : hl.Bytes)  : Void;
}