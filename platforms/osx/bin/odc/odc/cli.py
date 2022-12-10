import argparse
import logging
import sys

import odc.grid
import odc.yabai

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
        self.yabai_client = odc.yabai.Yabai()
        self.grid_controller = odc.grid.GridController(self.yabai_client)

    def configure_logging(self, opts):
        log_level = LOG_LEVELS_MAP.get(opts.log_level.lower(), logging.INFO)
        logging.basicConfig(
            filename=opts.log_file,
            level=log_level,
            # encoding='utf-8',
        )

    def build_arg_parser(self):
        parser = argparse.ArgumentParser('odc', description='OSX desktop control actions')
        subparsers = parser.add_subparsers()
        parser.add_argument(
            '--log-file',
            type=str,
            default='/tmp/odc.log',
        )
        parser.add_argument(
            '--log-level',
            type=str,
            default='DEBUG',
        )

        def cmd_move_space(opts):
            logging.info(f'move-space {opts.direction}')
            try:
                self.grid_controller.move(**odc.grid.MOVEMENT_DIRECTION_OFFSETS[opts.direction])
            except Exception as e:
                logging.error(e)
                import ipdb; ipdb.set_trace();

        move_space_cmd = subparsers.add_parser('move-space', help='Move between spaces')
        move_space_cmd.set_defaults(func=cmd_move_space)
        move_space_cmd.add_argument(
            'direction',
            choices=odc.grid.MOVEMENT_DIRECTIONS,
            help='direction to move',
        )


        def cmd_move_window(opts):
            logging.info(f'move-window {opts.direction}')
            direction_args = odc.grid.MOVEMENT_DIRECTION_OFFSETS[opts.direction]
            self.grid_controller.move_window(follow=opts.follow, **direction_args)
            
        move_window_cmd = subparsers.add_parser('move-window', help='Move focused window')
        move_window_cmd.set_defaults(func=cmd_move_window)
        move_window_cmd.add_argument(
            'direction',
            choices=odc.grid.MOVEMENT_DIRECTIONS,
            help='direction to move',
        )
        move_window_cmd.add_argument(
            '--follow',
            default=False,
            action='store_true',
        )


        def cmd_invert_space(opts):
            logging.info(f'invert-space {opts.direction}')
            space = self.yabai_client.focused_space
            space.mirror({'horizontal': 'x-axis', 'vertical': 'y-axis'}[opts.direction])
            
        invert_space_cmd = subparsers.add_parser('invert-space', help='Flip the tree in the current space')
        invert_space_cmd.set_defaults(func=cmd_invert_space)
        invert_space_cmd.add_argument(
            'direction',
            choices=odc.grid.INVERT_DIRECTIONS,
            help='direction to invert windows',
        )

        def cmd_set_space_layout(opts):
            logging.info(f'set-space-layout {opts.layout}')
            space.layout = opts.layout
            
        set_space_layout_cmd = subparsers.add_parser('set-space-layout', help='Set the layout mode for the current space')
        set_space_layout_cmd.set_defaults(func=cmd_set_space_layout)
        set_space_layout_cmd.add_argument(
            'layout',
            choices={'bsp', 'float', 'stack'},
            help='layout for current space',
        )

        def cmd_log(opts):
            message = ' '.join(opts.message_tokens)
            logging.info(message)

        log_cmd = subparsers.add_parser('log', help='Log a message to the odc log')
        log_cmd.set_defaults(func=cmd_log)
        log_cmd.add_argument(
            'message_tokens',
            nargs='+',
        )

        return parser

    @classmethod
    def run(clazz, args=None):
        CLI().parse_and_execute(args=args)

    def parse_and_execute(self, args=None):
        args = args or sys.argv[1:]
        parser = self.build_arg_parser()
        opts = parser.parse_args(args)
        self.configure_logging(opts)
        opts.func(opts)


if __name__ == '__main__':
    sys.exit(CLI.run())
