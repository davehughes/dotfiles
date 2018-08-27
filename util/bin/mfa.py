#!/usr/bin/python
from __future__ import print_function
import argparse
import os
import subprocess
import sys
import yaml


def load_login_map(filepath):
    '''
    Load a yaml file of the format:
    |  <login>: <key>
    |  ...
    '''
    if not os.path.isfile(filepath):
        return {}
    return yaml.load(open(filepath))


def save_login_map(filepath, login_map):
    if not login_map and not os.path.isfile(filepath):
        return

    with open(filepath, 'w') as f:
        yaml.dump(login_map, f, default_flow_style=False)
    os.chmod(filepath, 0600)


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


def parse_opts(argv=None):
    argv = argv or sys.argv[1:]
    parser = argparse.ArgumentParser(description="Manage multi-factor auth from the command line")
    subparsers = parser.add_subparsers()
    config_default = os.environ.get('MFA_CONFIG', os.path.expanduser('~/.mfa'))
    parser.add_argument('--config', default=config_default)

    # list subcommand
    def cmd_list_logins(opts):
        login_map = load_login_map(opts.config)
        print('\n'.join(sorted(login_map.keys())))
    list_cmd = subparsers.add_parser('list')
    list_cmd.set_defaults(func=cmd_list_logins)

    # token subcommand
    def cmd_generate_login_token(opts):
        print(generate_login_token(opts.config, opts.login))
    token_cmd = subparsers.add_parser('token')
    token_cmd.add_argument('login')
    token_cmd.set_defaults(func=cmd_generate_login_token)

    # add subcommand
    def cmd_add_token(opts):
        add_token(opts.config, opts.login, opts.key)
    token_cmd = subparsers.add_parser('add')
    token_cmd.add_argument('login')
    token_cmd.add_argument('key')
    token_cmd.set_defaults(func=cmd_add_token)

    # update subcommand
    def cmd_update_token(opts):
        update_token(opts.config, opts.login, opts.key)
    token_cmd = subparsers.add_parser('update')
    token_cmd.add_argument('login')
    token_cmd.add_argument('key')
    token_cmd.set_defaults(func=cmd_update_token)

    # remove subcommand
    def cmd_remove_token(opts):
        remove_token(opts.config, opts.login)
    token_cmd = subparsers.add_parser('remove')
    token_cmd.add_argument('login')
    token_cmd.set_defaults(func=cmd_remove_token)

    return parser.parse_args(argv)


class CLIError(Exception):
    def __init__(self, message):
        self.message = message

    def __unicode__(self):
        return self.message


def print_cli_errors(f):
    def wrapped(*a, **kw):
        try:
            f(*a, **kw)
        except CLIError as e:
            print(e.message)
            return 1
        else:
            return 0

    return wrapped


def main():
    opts = parse_opts()
    f = print_cli_errors(opts.func)
    sys.exit(f(opts))


if __name__ == '__main__':
    main()
