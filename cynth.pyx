import cython

from miniaudio cimport *
from libc.math cimport sin


cdef float amplitude = 0.2

cdef void data_callback(ma_device* pDevice, void* pOutput, const void* pInput, ma_uint32 frameCount) nogil:
    cdef float* output = <float*>pOutput
    cdef int phase = (<int*>pDevice.pUserData)[0]
    cdef int i
    if phase / 10000 % 2 == 0:
        amplitude = 0.
    else:
        amplitude = 0.1
    if phase > 100000:
        amplitude = 0.1
    for i in range(frameCount):
        output[2*i] = sin((i + phase) * 0.1) * amplitude
        output[2*i + 1] = sin((i + phase) * 0.1) * amplitude
    (<int*>pDevice.pUserData)[0] = phase + frameCount

cdef int phase = 0

cdef ma_device_config config = ma_device_config_init(device_type.playback);
config.playback.format   = ma_format_f32
config.playback.channels = 2
config.dataCallback      = data_callback
config.pUserData      = cython.address(phase)

cdef ma_device device;
if ma_device_init(NULL, &config, &device) != MA_SUCCESS:
    raise RuntimeError("failed to initialize")

ma_device_start(&device)

import time
try:
    while True:
        time.sleep(1)
finally:
    ma_device_uninit(&device)
