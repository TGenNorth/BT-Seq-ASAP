# -*- coding: utf-8 -*-

__author__ = 'Darrin Lemmer'
__email__ = 'dlemmer@tgen.org'

# http://setuptools.readthedocs.io/en/latest/setuptools.html#adding-support-for-revision-control-systems
from pkg_resources import get_distribution, DistributionNotFound
try:
    __version__ = get_distribution(__name__).version
except DistributionNotFound:
    # package is not installed
    __version__ = 'dev'
    pass
