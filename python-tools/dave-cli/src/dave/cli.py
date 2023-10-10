import argparse
import logging
import os
import sys

from dave import grid, yabai, mfa, pgpass

LOG_LEVELS_MAP = {
    'critical': logging.CRITICAL,
    'error':    logging.ERROR,
    'warn':     logging.WARN,
    'warning':  logging.WARN,
    'info':     logging.INFO,
    'debug':    logging.DEBUG,
}

class CLI(object):

    def __init__(self):
        self.yabai_client = yabai.Yabai()
        self.grid_controller = grid.GridController(self.yabai_client)

    def configure_logging(self, opts):
        log_level = LOG_LEVELS_MAP.get(opts.log_level.lower(), logging.INFO)
        logging.basicConfig(
            filename=opts.log_file,
            level=log_level,
            # encoding='utf-8',
        )

    def build_arg_parser(self):
        parser = argparse.ArgumentParser('dave', description='cli and desktop control helpers')
        parser.add_argument(
            '--log-file',
            type=str,
            default='/tmp/dave.log',
        )
        parser.add_argument(
            '--log-level',
            type=str,
            default='DEBUG',
        )

        def cmd_print_help(opts):
            parser.print_help()
        parser.set_defaults(func=cmd_print_help)

        subparsers = parser.add_subparsers()
        self.add_odc_commands(subparsers)
        self.add_mfa_commands(subparsers)
        self.add_pg_commands(subparsers)
        return parser


    def add_odc_commands(self, subparsers):
        def cmd_move_space(opts):
            logging.info(f'odc-move-space {opts.direction}')
            try:
                self.grid_controller.move(**grid.MOVEMENT_DIRECTION_OFFSETS[opts.direction])
            except Exception as e:
                logging.error(e)

        move_space_cmd = subparsers.add_parser('odc-move-space', help='Move between spaces')
        move_space_cmd.set_defaults(func=cmd_move_space)
        move_space_cmd.add_argument(
            'direction',
            choices=grid.MOVEMENT_DIRECTIONS,
            help='direction to move',
        )


        def cmd_move_window(opts):
            logging.info(f'odc-move-window {opts.direction}')
            direction_args = grid.MOVEMENT_DIRECTION_OFFSETS[opts.direction]
            self.grid_controller.move_window(follow=opts.follow, **direction_args)

        move_window_cmd = subparsers.add_parser('odc-move-window', help='Move focused window')
        move_window_cmd.set_defaults(func=cmd_move_window)
        move_window_cmd.add_argument(
            'direction',
            choices=grid.MOVEMENT_DIRECTIONS,
            help='direction to move',
        )
        move_window_cmd.add_argument(
            '--follow',
            default=False,
            action='store_true',
        )


        def cmd_invert_space(opts):
            logging.info(f'odc-invert-space {opts.direction}')
            space = self.yabai_client.focused_space
            space.mirror({'horizontal': 'x-axis', 'vertical': 'y-axis'}[opts.direction])

        invert_space_cmd = subparsers.add_parser('odc-invert-space', help='Flip the tree in the current space')
        invert_space_cmd.set_defaults(func=cmd_invert_space)
        invert_space_cmd.add_argument(
            'direction',
            choices=grid.INVERT_DIRECTIONS,
            help='direction to invert windows',
        )

        def cmd_set_space_layout(opts):
            logging.info(f'odc-set-space-layout {opts.layout}')
            space.layout = opts.layout

        set_space_layout_cmd = subparsers.add_parser('odc-set-space-layout', help='Set the layout mode for the current space')
        set_space_layout_cmd.set_defaults(func=cmd_set_space_layout)
        set_space_layout_cmd.add_argument(
            'layout',
            choices={'bsp', 'float', 'stack'},
            help='layout for current space',
        )

        def cmd_log(opts):
            message = ' '.join(opts.message_tokens)
            logging.info(message)

        log_cmd = subparsers.add_parser('odc-log', help='Log a message to the odc log')
        log_cmd.set_defaults(func=cmd_log)
        log_cmd.add_argument(
            'message_tokens',
            nargs='+',
        )

    def add_mfa_commands(self, subparsers):
        config_file = os.environ.get('MFA_CONFIG', os.path.expanduser('~/.mfa'))

        # list subcommand
        def cmd_list_logins(opts):
            login_map = mfa.load_login_map(opts.config)
            print('\n'.join(sorted(login_map.keys())))
        list_cmd = subparsers.add_parser('mfa-list', help="List all stored MFA profiles")
        list_cmd.set_defaults(func=cmd_list_logins, config=config_file)

        # token subcommand
        def cmd_generate_login_token(opts):
            print(mfa.generate_login_token(opts.config, opts.login))
        token_cmd = subparsers.add_parser('mfa-token')
        token_cmd.add_argument('login')
        token_cmd.set_defaults(func=cmd_generate_login_token, config=config_file)

        # qrcode subcommand
        token_cmd = subparsers.add_parser('mfa-qrcode', help="Display MFA QR code")
        token_cmd.add_argument('login')
        token_cmd.set_defaults(func=mfa.cmd_display_login_qrcode, config=config_file)

        # add subcommand
        def cmd_add_token(opts):
            mfa.add_token(opts.config, opts.login, opts.key)
        token_cmd = subparsers.add_parser('mfa-add', help="Add MFA token")
        token_cmd.add_argument('login')
        token_cmd.add_argument('key')
        token_cmd.set_defaults(func=cmd_add_token, config=config_file)

        # update subcommand
        def cmd_update_token(opts):
            mfa.update_token(opts.config, opts.login, opts.key)
        token_cmd = subparsers.add_parser('mfa-update')
        token_cmd.add_argument('login')
        token_cmd.add_argument('key')
        token_cmd.set_defaults(func=cmd_update_token, config=config_file)

        # remove subcommand
        def cmd_remove_token(opts):
            mfa.remove_token(opts.config, opts.login)
        token_cmd = subparsers.add_parser('mfa-remove')
        token_cmd.add_argument('login')
        token_cmd.set_defaults(func=cmd_remove_token, config=config_file)

    def add_pg_commands(self, subparsers):
        # pg-list
        def cmd_list_databases(opts):
            pgpass.list_databases()
        list_cmd = subparsers.add_parser('pg-list', help="Print a list of all stored pgpass profiles")
        list_cmd.set_defaults(func=cmd_list_databases)

        # pg-print-psql-connection-command {alias}
        def cmd_print_psql_connection_command(opts):
            print(pgpass.get_connect_command(opts.alias[0], opts.args))
        connect_cmd = subparsers.add_parser('pg-print-psql-connection-command', help="Print the psql command for connecting to the specified profile")
        connect_cmd.add_argument('alias', nargs=1)
        connect_cmd.add_argument('args', nargs='*')
        connect_cmd.set_defaults(func=cmd_print_psql_connection_command)

        # pg-print-dbext-command
        def cmd_print_dbext_command(opts):
            pgpass.dump_dbext(opts.alias)
        connect_cmd = subparsers.add_parser('pg-print-dbext', help="Dump a let statement for defining a default profile in vim's dbext")
        connect_cmd.add_argument('alias', nargs='?')
        connect_cmd.set_defaults(func=cmd_print_dbext_command)

        # pg-print-dadbod-command
        def cmd_print_dadbod_command(opts):
            pgpass.dump_dadbod(opts.alias)
        connect_cmd = subparsers.add_parser('pg-print-dadbod', help="Print a statement to connect to the named profile via dadbod.vim")
        connect_cmd.add_argument('alias', nargs='?')
        connect_cmd.set_defaults(func=cmd_print_dadbod_command)


    @classmethod
    def run(clazz, args=None):
        CLI().parse_and_execute(args=args)

    def parse_and_execute(self, args=None):
        args = args or sys.argv[1:]
        parser = self.build_arg_parser()
        opts = parser.parse_args(args)
        self.configure_logging(opts)
        f = self.print_cli_errors(opts.func)
        sys.exit(f(opts))


    class CLIError(Exception):
        def __init__(self, message):
            self.message = message

        def __unicode__(self):
            return self.message


    def print_cli_errors(self, f):
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
    sys.exit(CLI.run())


if __name__ == '__main__':
    main()
