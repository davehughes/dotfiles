import argparse
import os
import subprocess
import sys
import urllib
import yaml


def load_login_map(filepath):
    '''
    Load a yaml file of the format:
    |  <login>: <key>
    |  ...
    '''
    if not os.path.isfile(filepath):
        return {}
    return yaml.safe_load(open(filepath))


def save_login_map(filepath, login_map):
    if not login_map and not os.path.isfile(filepath):
        return

    with open(filepath, 'w') as f:
        yaml.dump(login_map, f, default_flow_style=False)
    os.chmod(filepath, 0o600)


def generate_login_token(filepath, login):
    login_map = load_login_map(filepath)
    login_key = login_map.get(login)
    if not login_key:
        raise CLIError("No key found for login '{}'".format(login))

    return generate_token(login_key)


def generate_token(key):
    if not is_oathtool_installed():
        raise CLIError("Couldn't find an installation of oathtool.  You can "
                       "install it with your system package manager.")

    proc = subprocess.Popen(
        ['oathtool', '--totp', '-b', key],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        )
    out, err = proc.communicate()
    if err:
        raise Exception(err)
    return out.strip()


def validate_key(key):
    try:
        generate_token(key)
    except CLIError:
        raise
    except:
        raise CLIError("Invalid key: could not generate a token with the key {}".format(key))


def add_token(filepath, login, key):
    validate_key(key)
    login_map = load_login_map(filepath)
    if login in login_map:
        raise CLIError("Login '{}' already exists.".format(login))

    login_map[login] = key
    save_login_map(filepath, login_map)


def update_token(filepath, login, key):
    validate_key(key)
    login_map = load_login_map(filepath)
    if not login in login_map:
        raise CLIError("Login '{}' doesn't exist.".format(login))

    login_map[login] = key
    save_login_map(filepath, login_map)


def remove_token(filepath, login):
    login_map = load_login_map(filepath)
    if not login in login_map:
        raise CLIError("Login '{}' doesn't exist.".format(login))

    del login_map[login]
    save_login_map(filepath, login_map)


def is_oathtool_installed():
    proc = subprocess.Popen(['sh', '-c', 'which oathtool'], stdout=subprocess.PIPE)
    proc.communicate()
    return proc.returncode == 0


def cmd_display_login_qrcode(opts):
    login_map = load_login_map(opts.config)
    key = login_map.get(opts.login)
    if not key:
        raise CLIError("Login '{}' not found.".format(opts.login))

    otp_url = 'otpauth://totp/{label}?secret={secret}'.format(
        label=urllib.quote(opts.login),
        secret=urllib.quote(key),
    )
    print(generate_qrcode(otp_url))

def generate_qrcode(data, small=True):
    status = subprocess.call(['which', 'qrcode-terminal'])
    if status != 0:
        raise Exception("Couldn't find required command 'qrcode-terminal'")

    proc = subprocess.Popen(
        ['qrcode-terminal', data],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        )
    out, err = proc.communicate()
    if err:
        raise Exception(err)
    return out
