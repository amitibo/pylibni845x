# -*- coding: utf-8 -*-
"""
Created on Sun Nov 06 10:30:18 2011

@author: prod_test
"""

cdef extern from "ni845x.h":
    
    ctypedef char int8
    ctypedef unsigned char uInt8
    ctypedef short int16
    ctypedef unsigned short uInt16
    ctypedef long int32
    ctypedef unsigned long uInt32

    cdef enum Local_Errors:
        kNi845xErrorNoError = 0
        kNi845xErrorInsufficientMemory = -301700
        kNi845xErrorInvalidResourceName = -301701
        kNi845xErrorInvalidClockRate = -301702
        kNi845xErrorTooManyScriptReads = -301703
        kNi845xErrorInvalidScriptReadIndex = -301704
        kNi845xErrorInvalidScriptReference = -301705
        kNi845xErrorInvalidDeviceId = -301706
        kNi845xErrorConnectionLost = -301707
        kNi845xErrorTimeout = -301708
        kNi845xErrorInternal = -301709
        kNi845xErrorInvalidConfigurationReference = -301710
        kNi845xErrorTooManyConfigurations = -301711
        kNi845xErrorInvalidActiveProperty = -301712
        kNi845xErrorInvalidParameter = -301713
        kNi845xErrorResourceBusy = -301714
        kNi845xErrorUnknown = -301719

    cdef enum General_Errors_from_device:
        kNi845xErrorBadOpcode = -301720
        kNi845xErrorUnknownStatus = -301721
        kNi845xErrorProtocolViolation = -301722

    cdef enum I2C_Errors_from_device:
        kNi845xErrorMasterBusFreeTimeout = -301740
        kNi845xErrorMasterAddressNotAcknowledged = -301742
        kNi845xErrorMasterDataNotAcknowledged = -301743
        kNi845xErrorMasterAddressArbitrationLost = -301744
        kNi845xErrorMasterDataArbitrationLost = -301745
        kNi845xErrorInvalidI2CPortNumber = -301746

    cdef enum Warnings:
        kNi845xWarningClockRateCoerced = 301700
        kNi845xWarningUnknown = 301719

    cdef enum I2C_Function_Arguments:
        kNi845xI2cAddress7Bit = 0
        kNi845xI2cAddress10Bit = 1
        kNi845xI2cNakFalse = 0
        kNi845xI2cNakTrue = 1

    #
    # DEVICE FUNCTION PROTOTYPES
    #
    int32 __stdcall ni845xFindDevice (
       char   *pFirstDevice,
       uInt32 *pFindDeviceHandle,
       uInt32 *pNumberFound
       )
    
    int32 __stdcall ni845xFindDeviceNext (
       uInt32 FindDeviceHandle,
       char *pNextDevice
       )
    
    int32 __stdcall ni845xCloseFindDeviceHandle(
       uInt32 FindDeviceHandle
       )
    
    int32 __stdcall ni845xOpen(
       char   *pResourceName,
       uInt32 *pDeviceHandle
       )
    
    int32 __stdcall ni845xClose (uInt32 DeviceHandle)
    
    int32 __stdcall ni845xDeviceLock (uInt32 DeviceHandle)
    
    int32 __stdcall ni845xDeviceUnlock (uInt32 DeviceHandle)
    
    void __stdcall ni845xStatusToString( 
       int32   StatusCode,
       uInt32  MaxSize,
       int8 *pStatusString
       )

    #
    # I2C BASIC API FUNCTION PROTOTYPES
    #
    int32 __stdcall ni845xI2cWrite (
       uInt32  DeviceHandle,
       uInt32  ConfigurationHandle,
       uInt32  WriteSize,
       uInt8  *pWriteData
       )
    
    int32 __stdcall ni845xI2cRead (
       uInt32   DeviceHandle,
       uInt32   ConfigurationHandle,
       uInt32   NumBytesToRead,
       uInt32  *pReadSize,
       uInt8   *pReadData
       )
    
    int32 __stdcall ni845xI2cWriteRead (
       uInt32   DeviceHandle,
       uInt32   ConfigurationHandle,
       uInt32   WriteSize,
       uInt8   *pWriteData,
       uInt32   NumBytesToRead,
       uInt32  *pReadSize,
       uInt8   *pReadData
       )
    
    int32 __stdcall ni845xI2cConfigurationOpen (uInt32  *pConfigurationHandle)
    
    int32 __stdcall ni845xI2cConfigurationClose (
       uInt32 ConfigurationHandle
       )
    
    int32 __stdcall ni845xI2cConfigurationSetPort (
       uInt32 ConfigurationHandle,
       uInt8  PortNumber
       )
    
    int32 __stdcall ni845xI2cConfigurationSetAddress (
       uInt32 ConfigurationHandle,
       uInt16 Address
       )
    
    int32 __stdcall ni845xI2cConfigurationSetClockRate (
       uInt32 ConfigurationHandle,
       uInt16 ClockRate
       )
    
    int32 __stdcall ni845xI2cConfigurationSetAddressSize (
       uInt32 ConfigurationHandle,
       int32  Size
       )
    
    int32 __stdcall ni845xI2cConfigurationGetPort (
       uInt32  ConfigurationHandle,
       uInt8  *pPort
       )
    
    int32 __stdcall ni845xI2cConfigurationGetAddress (
       uInt32   ConfigurationHandle,
       uInt16  *pAddress
       )
    
    int32 __stdcall ni845xI2cConfigurationGetClockRate (
       uInt32   ConfigurationHandle,
       uInt16  *pClockRate
       )
    
    int32 __stdcall ni845xI2cConfigurationGetAddressSize (
       uInt32  ConfigurationHandle,
       int32  *pSize
       )

