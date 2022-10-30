#!/usr/bin/python3
"""
Fabric script that generates a tgz archive from the contents of the web_static
folder of the AirBnB Clone repo
"""

from datetime import datetime
from fabric.api import local
from os.path import isdir


def do_pack():
    """generates a tgz archive"""
    try:
        date = datetime.now().strftime('%Y%m%d%H%M%')
        if isdir('versions') is False:
            local('mkdir versions')
        file_name = f'versions/web_static_{date}.tgz'
        local(f'tar -cvzf {file_name} web_static')
        return file_name
    except:
        return None
