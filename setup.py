# -*- coding: utf-8 -*-
"""
Created on Sun Nov 06 10:48:53 2011

@author: prod_test
"""

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
import numpy as np


PACKAGE_NAME = 'ni845x'
NI_ICLUDE_DIR=r'C:\Program Files\National Instruments\NI-845x\MS Visual C'
NI_LIB='ni845x'
IPOPT_LIB_DIR=r'C:\Program Files\National Instruments\NI-845x\MS Visual C'

setup(
    name=PACKAGE_NAME,
    version='0.1',
    description='A Cython wrapper to the ni854x I2C interface',
    author='Amit Aides',
    author_email='amitibo@tx.technion.ac.il',
    url="",
    packages=[PACKAGE_NAME],
    cmdclass = {'build_ext': build_ext},
    ext_modules = [
        Extension(
            PACKAGE_NAME + '.' + 'cyni845x',
            [r'src\cyni845x.pyx'],
            include_dirs=[NI_ICLUDE_DIR, np.get_include()],
            libraries=[NI_LIB],
            library_dirs=[IPOPT_LIB_DIR]
        )
    ],
)
