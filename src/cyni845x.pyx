# -*- coding: utf-8 -*-
"""
Created on Sun Nov 06 11:02:31 2011

@author: prod_test
"""

import numpy as np
cimport numpy as np
from ni845x cimport *

DEF MAX_SIZE = 1024
DEF DEV_SIZE = 256

DTYPEuc = np.uint8
ctypedef np.uint8_t DTYPEuc_t

class Ni845xError(Exception):
    def __init__(self, status_code):

        cdef bytes message
        cdef char status_string[MAX_SIZE]
        
        ni845xStatusToString(status_code, MAX_SIZE, status_string)
        message = status_string
        
        Exception.__init__(self, message)
        
def errChk(err):
    if err:
        raise Ni845xError(err)
    
cdef class device:
    """
    Exposes NI-845x device to Python.
    
    Note:
    Currently exposes only the basic I2C API.
    """

    cdef uInt32 _DeviceHandle
    cdef uInt32 _I2CHandle
    cdef bytes _name
    cdef object devices_list
    
    def __cinit__(self):

        cdef char NextDevice[DEV_SIZE]
        cdef uInt32 FindDeviceHandle
        cdef uInt32 NumberFound
        
        self._DeviceHandle = 0
        self._I2CHandle = 0
        
        #
        # find the first device
        #
        errChk(ni845xFindDevice(NextDevice, &FindDeviceHandle, &NumberFound))
            
        self.devices_list = [NextDevice]
        
        for i in range(NumberFound-1):
            errChk(ni845xFindDeviceNext(FindDeviceHandle, NextDevice))
                
            self.devices_list.append(NextDevice)
        
        self._name = self.devices_list[0]
        
    property devices:
        """
        List availabe devices.
        """
        
        def __get__(self):
            return self.devices_list
            
    def open(self, name=None):
        """
        Open a handle to the ni845x interface.

        Parameters
        ----------
            name : Name of device to open. If none, open the first device.

        Returns
        -------
            None
        """

        #
        # open device handle
        #
        if not name:
            name = self._name
        
        cdef bytes pyname = name#.decode('UTF-8', 'strict')
        cdef char *FirstDevice = pyname

        err = ni845xOpen(FirstDevice, &self._DeviceHandle)
        if err:
            raise Ni845xError(err)

        self._name = name
        
    def __dealloc__(self):
        self.I2cClose()

    def close(self):
        """
        Release the handles to the ni845x interface.

        Parameters
        ----------
            None

        Returns
        -------
            None
        """

        if not self._DeviceHandle:
            ni845xClose(self._DeviceHandle)

        self._DeviceHandle = 0

    def I2cConfig(
            self,
            size=kNi845xI2cAddress7Bit,
            address=0,
            clock_rate=100
            ):
        """
        Set the ni845x I2C configuration.
        
        Parameters
        ----------
            size : Configuration address size (default 7Bit).
            address : Configuration address (default 0).
            clock_rate : Configuration clock rate in kilohertz (default 100).

        Returns
        -------
            None
        """
        
        #
        # create configuration reference
        #
        errChk(ni845xI2cConfigurationOpen(&self._I2CHandle))
        
        #
        # configure configuration properties
        #
        errChk(ni845xI2cConfigurationSetAddressSize(self._I2CHandle, size))
        errChk(ni845xI2cConfigurationSetAddress(self._I2CHandle, address))
        errChk(ni845xI2cConfigurationSetClockRate(self._I2CHandle, clock_rate))
        
    def I2cClose(self):
        """
        Release the handles to the ni845x I2C interface.

        Parameters
        ----------
            None

        Returns
        -------
            None
        """

        if self._I2CHandle:
            ni845xI2cConfigurationClose(self._I2CHandle)
            
        if self._DeviceHandle:
            ni845xClose(self._DeviceHandle)

        self._I2CHandle = 0
        self._DeviceHandle = 0

    def I2cRead(
            self,
            num_bytes_to_read
            ):
        """
        Reads an array of data from an I2C slave device.

        Parameters
        ----------
            num_bytes_to_read : The number of bytes to read. This must be nonzero.

        Returns
        -------
            Numpy array of type unsigned char where the bytes that have been read are stored
            The length of the array is the actual number of bytes read.
            
        """
        
        cdef np.ndarray[DTYPEuc_t, ndim=1] np_rd_data = np.zeros((num_bytes_to_read,), dtype=DTYPEuc)
        cdef uInt32 actual_bytes_read
        
        errChk(
            ni845xI2cRead(
                self._DeviceHandle,
                self._I2CHandle,
                num_bytes_to_read,
                &actual_bytes_read,
                <uInt8 *>np_rd_data.data
                )
            )
        
        return np_rd_data[:actual_bytes_read]
        
    def I2cWrite(
            self,
            write_data
            ):
        """
        Write an array of data to an I2C slave device.

        Parameters
        ----------
            write_data : Array of bytes to be written. Should be convertible to numpy array of
                    type unsigned char.

        Returns
        -------
            None
            
        """
        
        cdef np.ndarray[DTYPEuc_t, ndim=1] np_wr_data
        
        np_wr_data = np.array(write_data, dtype=DTYPEuc).flatten()

        errChk(
            ni845xI2cWrite(
                self._DeviceHandle,
                self._I2CHandle,
                np_wr_data.size,
                <uInt8 *>np_wr_data.data
                )
            )

    def I2cWriteRead(
            self,
            write_data,
            num_bytes_to_read
            ):
        """
        Performs a write followed by read (combined format) on an I2C slave device.

        Parameters
        ----------
            write_data : Array of bytes to be written. Should be convertible to numpy array of
                    type unsigned char.

            num_bytes_to_read : The number of bytes to read. This must be nonzero.

        Returns
        -------
            Numpy array of type unsigned char where the bytes that have been read are stored.
            The length of the array is the actual number of bytes read.
            
        """
        
        
        cdef np.ndarray[DTYPEuc_t, ndim=1] np_wr_data
        cdef np.ndarray[DTYPEuc_t, ndim=1] np_rd_data = np.zeros((num_bytes_to_read,), dtype=DTYPEuc)
        cdef uInt32 actual_bytes_read
        
        np_wr_data = np.array(write_data, dtype=DTYPEuc).flatten()

        errChk(
            ni845xI2cWriteRead(
                self._DeviceHandle,
                self._I2CHandle,
                np_wr_data.size,
                <uInt8 *>np_wr_data.data,
                num_bytes_to_read,
                &actual_bytes_read,
                <uInt8 *>np_rd_data.data
                )
            )

        return np_rd_data[:actual_bytes_read]

