PyLibNI845x - a Python wrapper to the NI USB-8451 I2C and SPI interface
=======================================================================


PyLibNI845x provides a Python package ni845x that wraps the NI-845x driver software for Python using cython.
Currently only the basic I2C is implemented, you are welcomed to add to the code (the basic SPI and advanced interfaces)

Platforms
---------
The package  has been tested successfully with NI-845x software version 1.1 and 2.0 on windows XP.

Installation
------------
To install cyipopt you will need the following prerequisites:
* python 2.6+
* numpy
* cython
* C++ compiler

Python(x,y) (http://code.google.com/p/pythonxy/) is a great way to get all of these if you are satisfied with 32bit.
You will also need the drivers of the NI USB-4851 interface (http://sine.ni.com/nips/cds/view/p/lang/en/nid/202368).
Download the source files of PyLibNI845x and update 'setup.py' to point to the header and lib files of the NI-845x driver software.
Then, execute 'python setup.py install' from the command line.

Basic Usage
-----------
The ni845x Python package provides a single class: device
Here follows an example how to get the list of available devices:

    > from ni845x import device
    > dev = device()
    > print dev.devices

To open a handle to the first available device:

    > from ni845x import device
    > dev = device()
    > dev.open()


Basic I2C transactions:

    > from ni845x import device
    > dev = device()
    > dev.open()
    > dev.I2cConfig(address=0xA)
    > dev.I2cWrite('hello world')
    > read_data = dev.I2cRead(10)
    > read_data = dev.I2cWriteRead('hello world again', 20)

Thank-you to the people at <http://wingware.com/> for their policy of **free licenses for non-commercial open source developers**.

![wingware-logo](http://wingware.com/images/wingware-logo-180x58.png)

