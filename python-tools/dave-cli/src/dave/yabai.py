import json
import subprocess


class YabaiExecutionError(Exception):
    def __init__(self, return_code, message):
        self.return_code = return_code
        self.message = message


class Yabai(object):
    def __init__(self):
        # TODO: handle custom config
        pass

    @property
    def displays(self):
        cmd = ['yabai', '-m', 'query', '--displays']
        return [Display(self, rec) for rec in self.run_command(cmd)]

    def display(self, selector):
        cmd = ['yabai', '-m', 'query', '--displays', selector]
        return Display(self, self.run_command(cmd))

    @property
    def spaces(self):
        cmd = ['yabai', '-m', 'query', '--spaces']
        return [Space(self, rec) for rec in self.run_command(cmd)]

    def space(self, selector):
        cmd = ['yabai', '-m', 'query', '--space', selector]
        return Space(self, self.run_command(cmd))

    @property
    def windows(self):
        cmd = ['yabai', '-m', 'query', '--windows']
        return [Window(self, rec) for rec in self.run_command(cmd)]

    def window(self, selector):
        cmd = ['yabai', '-m', 'query', '--windows', selector]
        return Window(self, self.run_command(cmd))
    
    @property
    def focused_space(self):
        return [s for s in self.spaces if s.focused][0]

    @property
    def focused_window(self):
        return [w for w in self.windows if w.focused][0]

    def run_command(self, command_args, timeout=5, returns='json'):
        command_args = [str(a) for a in command_args]
        p = subprocess.Popen(command_args, stderr=subprocess.PIPE, stdout=subprocess.PIPE)
        p.wait(timeout=timeout)
        if p.returncode != 0:
            error_output = p.stderr.read()
            raise YabaiExecutionError(p.returncode, error_output)

        try:
            raw_output = p.stdout.read().decode('utf-8')
            if returns == 'void':
                return None
            if returns == 'string':
                return raw_output.strip()
            elif returns == 'json':
                return json.loads(raw_output)
            else: # elif returns == 'raw':
                return raw_output
        except Exception as e:
            if raw_output:
                raise Exception(f'Error processing yabai output: {raw_output}')
            else:
                raise Exception('Error reading yabai output')

    def config_get(self, setting):
        cmd = ['yabai', '-m', 'config', setting]
        return self.run_command(cmd, returns='string')

    def config_set(self, setting, value):
        cmd = ['yabai', '-m', 'config', setting, value]
        return self.run_command(cmd, returns='raw')

    def config_get_all(self):
        return { prop: self.config_get(prop) for prop in self.settings_props }

    settings_props = [
        'debug_output', 'external_bar', 'mouse_follows_focus', 'focus_follows_mouse',
        'window_placement', 'window_topmost', 'window_shadow', 'window_opacity',
        'window_opacity_duration', 'active_window_opacity', 'normal_window_opacity',
        'window_border', 'window_border_width', 'active_window_border_color', 'normal_window_border_color',
        'insert_feedback_color', 'split_ratio', 'auto_balance', 'mouse_modifier',
        'mouse_action1', 'mouse_action2', 'mouse_drop_action',
    ]

    def __getattr__(self, attr):
        if attr in self.settings_props:
            return self.config_get(attr)
        raise AttributeError(f"'{self.__class__.__name__}' object has no attribute '{attr}'")

    def __setattr__(self, attr, value):
        if attr in self.settings_props:
            return self.config_set(attr, value)
        super(Yabai, self).__setattr__(attr, value)


class Display(object):
    def __init__(self, client, data):
        self.client = client
        self.data = data

    def create_space(self):
        res = self.spaces[0].create()
        import ipdb; ipdb.set_trace();

    @property
    def spaces(self):
        return [s for s in self.client.spaces if s.data['display'] == self.data['index']]

    @property
    def windows(self):
        return [w for w in self.client.windows if w.data['display'] == self.data['index']]

    def __repr__(self):
        return f"Display(index: {self.data['index']}, id: {self.data['id']}, {len(self.data['spaces'])} spaces)"

    data_props = ['id', 'uuid', 'index', 'spaces', 'frame']

    def __getattr__(self, attr):
        if attr in self.data_props:
            return self.data[attr]
        raise AttributeError(f"'{self.__class__.__name__}' object has no attribute '{attr}'")


class Space(object):
    def __init__(self, client, data):
        self.client = client
        self.data = data
        self.selector = data.get('label') or data['index']

    @property
    def id(self):
        return self.data['id']

    @property
    def label(self):
        return self.data['label']

    @property
    def index(self):
        return self.data['index']

    @property
    def index0(self):
        return self.data['index'] - 1

    @property
    def type(self):
        return self.data['type']

    @property
    def focused(self):
        return self.data['has-focus']

    @property
    def native_fullscreen(self):
        return self.data['native-fullscreen'] == 1

    def focus(self):
        cmd = ['yabai', '-m', 'space', '--focus', self.selector]
        return self.client.run_command(cmd, returns='raw')

    def destroy(self):
        cmd = ['yabai', '-m', 'space', self.selector, '--destroy']
        return self.client.run_command(cmd)

    def create(self):
        cmd = ['yabai', '-m', 'space', self.selector, '--create']
        return self.client.run_command(cmd, returns='void')

    @property
    def display(self):
        matching_displays = [d for d in self.client.displays if d.data['index'] == self.data['display']]
        return matching_displays[0] if matching_displays else None

    @property
    def windows(self):
        return [w for w in self.client.windows if w.data['space'] == self.data['index']]

    def config_get(self, setting):
        cmd = ['yabai', '-m', 'config', '--space', self.selector, setting]
        return self.client.run_command(cmd, returns='string')

    def config_set(self, setting, value):
        cmd = ['yabai', '-m', 'config', '--space', self.selector, setting, value]
        return self.client.run_command(cmd, returns='raw')

    settings_props = ['layout', 'top_padding', 'bottom_padding', 'left_padding', 'right_padding', 'window_gap']

    def __getattr__(self, attr):
        if attr in self.settings_props:
            return self.config_get(attr)
        raise AttributeError(f"'{self.__class__.__name__}' object has no attribute '{attr}'")

    def __setattr__(self, attr, value):
        if attr in self.settings_props:
            return self.config_set(attr, value)
        super(Space, self).__setattr__(attr, value)

    def mirror(self, axis):
        cmd = ['yabai', '-m', 'space', self.selector, '--mirror', axis]
        return self.client.run_command(cmd, returns='void')

    def __repr__(self):
        return f"Space({self.data['id']}, label: {self.data['label']}, index: {self.data['index']})"


class Window(object):
    def __init__(self, client, data):
        self.client = client
        self.data = data

    @property
    def focused(self):
        return self.data.get('has-focus', False) or self.data.get('focused', 0) == 1

    @property
    def display(self):
        matching_displays = [d for d in self.client.displays if d.data['index'] == self.data['display']]
        return matching_displays[0] if matching_displays else None

    @property
    def space(self):
        matching_spaces = [s for s in self.client.spaces if s.data['index'] == self.data['space']]
        return matching_spaces[0] if matching_spaces else None

    def send_to_space(self, space):
        cmd = ['yabai', '-m', 'window', '--space', space.selector]
        return self.client.run_command(cmd, returns='void')

    def __repr__(self):
        return f"Window(id: {self.data['id']}, pid: {self.data['pid']}, app: {self.data['app']}, title: {self.data['title']})"
