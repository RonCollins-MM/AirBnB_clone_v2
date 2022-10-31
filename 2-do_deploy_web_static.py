#!/usr/bin/python3
"""this fabfile destributes archive to my webservers"""
from fabric.api import *
from datetime import datetime
import os


env.hosts = ['34.232.70.87', '35.153.16.39']


def do_pack():
    """creates an archive of the airbnb clone"""
    filename = ""
    exe = ""
    if not os.path.exists("versions"):
        os.mkdir("versions")
    filename = "versions/web_static_{}.tgz web_static"\
        .format(datetime.now().strftime("%Y%m%d%H%m%S"))
    exe = "tar -cvzf " + filename
    result = local(exe)
    if result.failed:
        return None
    return filename


def do_deploy(archive_path):
    """deploys the archive file in the path provided"""
    folder = archive_path.split("/")[-1].split(".tgz")[0]
    archive = archive_path.split("/")[-1]
    archive_dir = "/data/web_static/releases/{}/".format(folder)
    if not os.path.exists(archive_path):
        return False
    result = put(archive_path, '/tmp/{}'.format(archive))
    if result.failed:
        return False
    result = run("mkdir -p {}".format(archive_dir))
    if result.failed:
        return False
    result = run("tar -xzf /tmp/{} -C {}".format(archive, archive_dir))
    if result.failed:
        return False
    result = run("rm /tmp/{}".format(archive))
    if result.failed:
        return False
    result = run("mv {}web_static/* {}".format(archive_dir, archive_dir))
    if result.failed:
        return False
    result = run("sudo rm -rf /data/web_static/current")
    if result.failed:
        return False
    result = run("rm -rf {}web_static".format(archive_dir))
    if result.failed:
        return False
    result = run("ln -s {} /data/web_static/current".format(archive_dir))
    if result.failed:
        return False
    return True
