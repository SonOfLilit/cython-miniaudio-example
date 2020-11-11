cdef extern from "miniaudio_define.h":
    pass

cdef extern from "miniaudio.h":
    ctypedef int ma_uint32
    cdef enum device_type:
        playback "ma_device_type_playback"
    ctypedef void (* ma_device_callback_proc)(ma_device* pDevice, void* pOutput, const void* pInput, ma_uint32 frameCount)
    ctypedef ma_uint32 ma_format
    cdef int ma_format_f32
    ctypedef struct ma_playback:
        ma_format format
        ma_uint32 channels
    ctypedef struct ma_device_config:
        ma_device_callback_proc dataCallback
        ma_playback playback
        void* pUserData

    ma_device_config ma_device_config_init(device_type deviceType)
    ctypedef struct ma_device:
        void* pUserData
    ctypedef int ma_result
    ctypedef struct ma_context:
        pass
    ma_result ma_device_init(ma_context* pContext, const ma_device_config* pConfig, ma_device* pDevice)
    
    cdef int MA_SUCCESS
    ma_result ma_device_start(ma_device* pDevice)
    void ma_device_uninit(ma_device* pDevice)
