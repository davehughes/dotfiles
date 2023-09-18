#!/usr/bin/env python3
import argparse
import collections
import os
import re
import sys


ConnectionLine = collections.namedtuple('ConnectionLine', ['host', 'port', 'database', 'user', 'password'])


def build_alias_map(filepath=None):
    '''
    Load a file with the format:
    |  # alias:{alias}
    |  host:port:database:user:password
    |  ...
    into a map like {'alias': ConnectionLine(host='host', port='port', database='database', user='user'), ...}
    '''
    filepath = filepath or os.environ.get('PGPASSFILE', '~/.pgpass')  
    alias_comment_pattern = re.compile(r'# alias:(?P<alias>[^\s]+)\s*')
    alias_map = {}
    unaliased_connections = []

    with open(filepath) as f:
        alias = None
        for line in f:
            m = alias_comment_pattern.match(line)
            if m:
                alias = m.group('alias')
                continue
            else:
                fields = line.strip().split(':')
                if len(fields) == 5:
                    connection_line = ConnectionLine(*fields)
                    if alias:
                        alias_map[alias] = connection_line
                    else:
                        unaliased_connections.append(connection_line)

            alias = None

    unaliased_map = {c.database: c for c in reversed(unaliased_connections)}

    merged_map = {}
    merged_map.update(unaliased_map)
    merged_map.update(alias_map)
    return merged_map


def get_connect_command(alias, args):
    alias_map = build_alias_map()
    connection_line = alias_map.get(alias)
    if not connection_line:
        raise KeyError("No connection found for alias: {}".format(alias))

    return 'psql -h {host} -p {port} -U {user} {database} {args}'.format(
        user=connection_line.user,
        host=connection_line.host,
        port=connection_line.port,
        database=connection_line.database,
        args=' '.join(args or []),
        )


def list_databases(filepath=None):
    alias_map = build_alias_map(filepath=filepath)
    aliases = sorted(alias_map.keys())
    for alias in aliases:
        connection_line = alias_map[alias]
        print(f'{alias}: {connection_line.user}:***@{connection_line.host}:{connection_line.port}/{connection_line.database}')


def dump_dbext():
    config_template = "let g:dbext_default_profile_{profile_name} = '{connection_string}'"
    connection_template = 'type={type}:user={user}:passwd={password}:dsnname={database}:host={host}:port={port}'

    alias_map = build_alias_map()
    aliases = sorted(alias_map.keys())
    for alias in aliases:
        connection_line = alias_map[alias]
        dbext_connection_string = connection_template.format(
            type='pgsql',
            user=connection_line.user,
            password=connection_line.password,
            host=connection_line.host,
            port=connection_line.port,
            database=connection_line.database,
            )
        config_line = config_template.format(
            profile_name=alias.lower().replace('-', '_'),
            connection_string=dbext_connection_string,
            )
        print(config_line)

        
def parse_opts(argv=None):
    argv = argv or sys.argv[1:]
    parser = argparse.ArgumentParser(description="Manage psql connections")
    subparsers = parser.add_subparsers()

    # pgpass.py list
    def cmd_list_databases(opts):
        list_databases()
    list_cmd = subparsers.add_parser('list')
    list_cmd.set_defaults(func=cmd_list_databases)

    # pgpass.py print-connection-command {alias}
    def cmd_print_connection_command(opts):
        print(get_connect_command(opts.alias[0], opts.args))
    connect_cmd = subparsers.add_parser('print-connection-command')
    connect_cmd.add_argument('alias', nargs=1)
    connect_cmd.add_argument('args', nargs='*')
    connect_cmd.set_defaults(func=cmd_print_connection_command)

    # pgpass.py dump-dbext
    def cmd_print_connection_command(opts):
        dump_dbext()
    connect_cmd = subparsers.add_parser('dump-dbext')
    connect_cmd.set_defaults(func=cmd_print_connection_command)

    return parser.parse_args(argv)


def main():
    opts = parse_opts()
    opts.func(opts)


if __name__ == '__main__':
    main()
